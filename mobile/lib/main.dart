import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/build_context_extensions.dart';
import 'package:mediab/utils/download.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart';
import 'package:mediab/constants/locales.dart';
import 'package:mediab/services/background.service.dart';
import 'package:mediab/entities/backup_album.entity.dart';
import 'package:mediab/entities/duplicated_asset.entity.dart';
import 'package:mediab/routing/router.dart';
import 'package:mediab/routing/tab_navigation_observer.dart';
import 'package:mediab/utils/cache/widgets_binding.dart';
import 'package:mediab/entities/album.entity.dart';
import 'package:mediab/entities/android_device_asset.entity.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/entities/etag.entity.dart';
import 'package:mediab/entities/exif_info.entity.dart';
import 'package:mediab/entities/ios_device_asset.entity.dart';
import 'package:mediab/entities/logger_message.entity.dart';
import 'package:mediab/entities/store.entity.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/providers/app_life_cycle.provider.dart';
import 'package:mediab/providers/db.provider.dart';
import 'package:mediab/services/immich_logger.service.dart';
import 'package:mediab/services/local_notification.service.dart';
import 'package:mediab/utils/http_ssl_cert_override.dart';
import 'package:mediab/utils/immich_app_theme.dart';
import 'package:mediab/utils/migration.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  ImmichWidgetsBinding();
  final db = await loadDb();
  await initApp();
  await migrateDatabaseIfNeeded(db);
  HttpOverrides.global = HttpSSLCertOverride();

  runApp(
    ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MainWidget(),
    ),
  );
}

Future<void> initApp() async {
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();

  if (kReleaseMode && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
      debugPrint("Enabled high refresh mode");
    } catch (e) {
      debugPrint("Error setting high refresh rate: $e");
    }
  }

  await fetchSystemPalette();

  // Initialize  Photosync  Logger Service
  ImmichLogger();

  var log = Logger("ImmichErrorLogger");

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(
      'FlutterError - Catch all',
      "${details.toString()}\nException: ${details.exception}\nLibrary: ${details.library}\nContext: ${details.context}",
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("FlutterError - Catch all: $error \n $stack");
    log.severe('PlatformDispatcher - Catch all', error, stack);
    return true;
  };

  initializeTimeZones();

  FileDownloader().configureNotification(
    running: TaskNotification(
      'downloading_media'.tr(),
      'file: {filename}',
    ),
    complete: TaskNotification(
      'download_finished'.tr(),
      'file: {filename}',
    ),
    progressBar: true,
  );

  FileDownloader().trackTasksInGroup(
    downloadGroupLivePhoto,
    markDownloadedComplete: false,
  );
}

Future<Isar> loadDb() async {
  final dir = await getApplicationDocumentsDirectory();
  Isar db = await Isar.open(
    [
      StoreValueSchema,
      ExifInfoSchema,
      AssetSchema,
      AlbumSchema,
      UserSchema,
      BackupAlbumSchema,
      DuplicatedAssetSchema,
      LoggerMessageSchema,
      ETagSchema,
      if (Platform.isAndroid) AndroidDeviceAssetSchema,
      if (Platform.isIOS) IOSDeviceAssetSchema,
    ],
    directory: dir.path,
    maxSizeMiB: 1024,
  );
  Store.init(db);
  return db;
}

class ImmichApp extends ConsumerStatefulWidget {
  const ImmichApp({super.key});

  @override
  ImmichAppState createState() => ImmichAppState();
}

class ImmichAppState extends ConsumerState<ImmichApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("[APP STATE] resumed");
        ref.read(appStateProvider.notifier).handleAppResume();
        break;
      case AppLifecycleState.inactive:
        debugPrint("[APP STATE] inactive");
        ref.read(appStateProvider.notifier).handleAppInactivity();
        break;
      case AppLifecycleState.paused:
        debugPrint("[APP STATE] paused");
        ref.read(appStateProvider.notifier).handleAppPause();
        break;
      case AppLifecycleState.detached:
        debugPrint("[APP STATE] detached");
        ref.read(appStateProvider.notifier).handleAppDetached();
        break;
      case AppLifecycleState.hidden:
        debugPrint("[APP STATE] hidden");
        ref.read(appStateProvider.notifier).handleAppHidden();
        break;
    }
  }

  Future<void> initApp() async {
    WidgetsBinding.instance.addObserver(this);

    // Draw the app from edge to edge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Sets the navigation bar color
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    );
    if (Platform.isAndroid) {
      // Android 8 does not support transparent app bars
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt <= 26) {
        overlayStyle = context.isDarkTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
      }
    }
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    await ref.read(localNotificationService).setup();
  }

  @override
  initState() {
    super.initState();
    initApp().then((_) => debugPrint("App Init Completed"));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // needs to be delayed so that EasyLocalization is working
      ref.read(backgroundServiceProvider).resumeServiceIfEnabled();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final immichTheme = ref.watch(immichThemeProvider);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: true,
      home: MaterialApp.router(
        title: 'Immich',
        debugShowCheckedModeBanner: false,
        themeMode: ref.watch(immichThemeModeProvider),
        darkTheme: getThemeData(colorScheme: immichTheme.dark),
        theme: getThemeData(colorScheme: immichTheme.light),
        routeInformationParser: router.defaultRouteParser(),
        routerDelegate: router.delegate(
          navigatorObservers: () => [TabNavigationObserver(ref: ref)],
        ),
      ),
    );
  }
}

// ignore: prefer-single-widget-per-file
class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: locales.values.toList(),
      path: translationsPath,
      useFallbackTranslations: true,
      fallbackLocale: locales.values.first,
      child: const ImmichApp(),
    );
  }
}
