import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/services/api.service.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';

final trashServiceProvider = Provider<TrashService>((ref) {
  return TrashService(
    ref.watch(apiServiceProvider),
  );
});

class TrashService {
  final _log = Logger("TrashService");

  final ApiService _apiService;

  TrashService(this._apiService);

  Future<bool> restoreAssets(Iterable<Asset> assetList) async {
    try {
      List<String> remoteIds = assetList.where((a) => a.isRemote).map((e) => e.remoteId!).toList();
      await _apiService.trashApi.restoreAssets(BulkIdsDto(ids: remoteIds));
      return true;
    } catch (error, stack) {
      _log.severe("Cannot restore assets", error, stack);
      return false;
    }
  }

  Future<bool> restoreAsset(Asset asset) async {
    try {
      if (asset.isRemote) {
        List<String> remoteId = [asset.remoteId!];

        await _apiService.trashApi.restoreAssets(BulkIdsDto(ids: remoteId));
      }
      return true;
    } catch (error, stack) {
      _log.severe("Cannot restore assets", error, stack);
      return false;
    }
  }

  Future<void> emptyTrash() async {
    try {
      await _apiService.trashApi.emptyTrash();
    } catch (error, stack) {
      _log.severe("Cannot empty trash", error, stack);
    }
  }

  Future<void> restoreTrash() async {
    try {
      await _apiService.trashApi.restoreTrash();
    } catch (error, stack) {
      _log.severe("Cannot restore trash", error, stack);
    }
  }
}
