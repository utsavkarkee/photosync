import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/providers/memory.provider.dart';

import 'package:mediab/entities/store.entity.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/providers/asset.provider.dart';
import 'package:mediab/providers/server_info.provider.dart';

class TabNavigationObserver extends AutoRouterObserver {
  /// Riverpod Instance
  final WidgetRef ref;

  TabNavigationObserver({
    required this.ref,
  });

  @override
  Future<void> didChangeTabRoute(
    TabPageRoute route,
    TabPageRoute previousRoute,
  ) async {
    if (route.name == 'HomeRoute') {
      ref.invalidate(memoryFutureProvider);
      Future(() => ref.read(assetProvider.notifier).getAllAsset());

      // Update user info
      try {
        final userResponseDto = await ref.read(apiServiceProvider).usersApi.getMyUser();
        final userPreferences = await ref.read(apiServiceProvider).usersApi.getMyPreferences();

        if (userResponseDto == null) {
          return;
        }

        Store.put(
          StoreKey.currentUser,
          User.fromUserDto(userResponseDto, userPreferences),
        );
        ref.read(serverInfoProvider.notifier).getServerVersion();
      } catch (e) {
        debugPrint("Error refreshing user info $e");
      }
    }
  }
}
