import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/providers/db.provider.dart';
import 'package:isar/isar.dart';

final allMotionPhotosProvider = FutureProvider<List<Asset>>((ref) async {
  return ref.watch(dbProvider).assets.filter().livePhotoVideoIdIsNotNull().findAll();
});
