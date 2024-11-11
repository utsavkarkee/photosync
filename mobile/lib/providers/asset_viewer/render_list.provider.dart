import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/widgets/asset_grid/asset_grid_data_structure.dart';
import 'package:mediab/providers/app_settings.provider.dart';
import 'package:mediab/services/app_settings.service.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/utils/renderlist_generator.dart';
import 'package:isar/isar.dart';

final renderListProvider = FutureProvider.family<RenderList, List<Asset>>((ref, assets) {
  final settings = ref.watch(appSettingsServiceProvider);

  return RenderList.fromAssets(
    assets,
    GroupAssetsBy.values[settings.getSetting(AppSettingsEnum.groupAssetsBy)],
  );
});

final renderListProviderWithGrouping = FutureProvider.family<RenderList, (List<Asset>, GroupAssetsBy?)>((ref, args) {
  final settings = ref.watch(appSettingsServiceProvider);
  final grouping = args.$2 ?? GroupAssetsBy.values[settings.getSetting(AppSettingsEnum.groupAssetsBy)];
  return RenderList.fromAssets(args.$1, grouping);
});

final renderListQueryProvider = StreamProvider.family<RenderList, QueryBuilder<Asset, Asset, QAfterSortBy>?>(
  (ref, query) => query == null ? const Stream.empty() : renderListGenerator(query, ref),
);
