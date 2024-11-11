import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/backup_album.entity.dart';
import 'package:mediab/entities/duplicated_asset.entity.dart';
import 'package:mediab/entities/album.entity.dart';
import 'package:mediab/entities/android_device_asset.entity.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/entities/etag.entity.dart';
import 'package:mediab/entities/exif_info.entity.dart';
import 'package:mediab/entities/ios_device_asset.entity.dart';
import 'package:mediab/entities/logger_message.entity.dart';
import 'package:mediab/entities/store.entity.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_http_override.dart';

// Listener Mock to test when a provider notifies its listeners
class ListenerMock<T> extends Mock {
  void call(T? previous, T next);
}

final class TestUtils {
  const TestUtils._();

  /// Downloads Isar binaries (if required) and initializes a new Isar db
  static Future<Isar> initIsar() async {
    await Isar.initializeIsarCore(download: true);

    final instance = Isar.getInstance();
    if (instance != null) {
      return instance;
    }

    final db = await Isar.open(
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
        AndroidDeviceAssetSchema,
        IOSDeviceAssetSchema,
      ],
      maxSizeMiB: 1024,
      directory: "test/",
    );

    // Clear and close db on test end
    addTearDown(() async {
      await db.writeTxn(() => db.clear());
      await db.close();
    });
    return db;
  }

  /// Creates a new ProviderContainer to test Riverpod providers
  static ProviderContainer createContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );

    // Dispose on test end
    addTearDown(container.dispose);

    return container;
  }

  static void init() {
    // Turn off easy localization logging
    EasyLocalization.logger.enableBuildModes = [];
    WidgetController.hitTestWarningShouldBeFatal = true;
    HttpOverrides.global = MockHttpOverrides();
  }
}
