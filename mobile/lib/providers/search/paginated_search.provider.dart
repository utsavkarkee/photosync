import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/models/search/search_result.model.dart';
import 'package:mediab/providers/asset_viewer/render_list.provider.dart';
import 'package:mediab/widgets/asset_grid/asset_grid_data_structure.dart';
import 'package:mediab/models/search/search_filter.model.dart';
import 'package:mediab/services/search.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paginated_search.provider.g.dart';

final paginatedSearchProvider = StateNotifierProvider<PaginatedSearchNotifier, SearchResult>(
  (ref) => PaginatedSearchNotifier(ref.watch(searchServiceProvider)),
);

class PaginatedSearchNotifier extends StateNotifier<SearchResult> {
  final SearchService _searchService;

  PaginatedSearchNotifier(this._searchService) : super(SearchResult(assets: [], nextPage: 1));

  search(SearchFilter filter) async {
    if (state.nextPage == null) return;

    final result = await _searchService.search(filter, state.nextPage!);

    if (result == null) return;

    state = SearchResult(
      assets: [...state.assets, ...result.assets],
      nextPage: result.nextPage,
    );
  }

  clear() {
    state = SearchResult(assets: [], nextPage: 1);
  }
}

@riverpod
AsyncValue<RenderList> paginatedSearchRenderList(
  PaginatedSearchRenderListRef ref,
) {
  final result = ref.watch(paginatedSearchProvider);

  return ref.watch(
    renderListProviderWithGrouping(
      (result.assets, GroupAssetsBy.none),
    ),
  );
}
