import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/widgets/asset_grid/asset_grid_data_structure.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/providers/db.provider.dart';
import 'package:mediab/providers/user.provider.dart';
import 'package:mediab/utils/renderlist_generator.dart';
import 'package:isar/isar.dart';

final archiveProvider = StreamProvider<RenderList>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  final query = ref
      .watch(dbProvider)
      .assets
      .where()
      .ownerIdEqualToAnyChecksum(user.isarId)
      .filter()
      .isArchivedEqualTo(true)
      .isTrashedEqualTo(false)
      .sortByFileCreatedAtDesc();
  return renderListGenerator(query, ref);
});
