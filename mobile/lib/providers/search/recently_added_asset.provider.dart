import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/providers/db.provider.dart';
import 'package:mediab/providers/user.provider.dart';
import 'package:isar/isar.dart';

final recentlyAddedAssetProvider = FutureProvider<List<Asset>>((ref) async {
  final user = ref.read(currentUserProvider);
  if (user == null) return [];

  return ref
      .watch(dbProvider)
      .assets
      .where()
      .ownerIdEqualToAnyChecksum(user.isarId)
      .sortByFileCreatedAtDesc()
      .findAll();
});
