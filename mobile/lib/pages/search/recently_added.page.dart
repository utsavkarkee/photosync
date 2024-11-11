import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/asyncvalue_extensions.dart';
import 'package:mediab/widgets/asset_grid/immich_asset_grid.dart';
import 'package:mediab/providers/search/recently_added_asset.provider.dart';

@RoutePage()
class RecentlyAddedPage extends HookConsumerWidget {
  const RecentlyAddedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recents = ref.watch(recentlyAddedAssetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('recently_added_page_title').tr(),
        leading: IconButton(
          onPressed: () => context.maybePop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: recents.widgetWhen(
        onData: (searchResponse) => ImmichAssetGrid(
          assets: searchResponse,
        ),
      ),
    );
  }
}
