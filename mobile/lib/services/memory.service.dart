import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/interfaces/asset.interface.dart';
import 'package:mediab/models/memories/memory.model.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/repositories/asset.repository.dart';
import 'package:mediab/services/api.service.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';

final memoryServiceProvider = StateProvider<MemoryService>((ref) {
  return MemoryService(
    ref.watch(apiServiceProvider),
    ref.watch(assetRepositoryProvider),
  );
});

class MemoryService {
  final log = Logger("MemoryService");

  final ApiService _apiService;
  final IAssetRepository _assetRepository;

  MemoryService(this._apiService, this._assetRepository);

  Future<List<Memory>?> getMemoryLane() async {
    try {
      final now = DateTime.now();
      final data = await _apiService.assetsApi.getMemoryLane(
        now.day,
        now.month,
      );

      if (data == null) {
        return null;
      }

      List<Memory> memories = [];
      for (final MemoryLaneResponseDto(:yearsAgo, :assets) in data) {
        final dbAssets = await _assetRepository.getAllByRemoteId(assets.map((e) => e.id));
        if (dbAssets.isNotEmpty) {
          final String title =
              yearsAgo <= 1 ? 'memories_year_ago'.tr() : 'memories_years_ago'.tr(args: [yearsAgo.toString()]);
          memories.add(
            Memory(
              title: title,
              assets: dbAssets,
            ),
          );
        }
      }

      return memories.isNotEmpty ? memories : null;
    } catch (error, stack) {
      log.severe("Cannot get memories", error, stack);
      return null;
    }
  }
}
