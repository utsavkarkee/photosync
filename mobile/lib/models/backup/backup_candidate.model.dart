import 'package:mediab/entities/asset.entity.dart';

class BackupCandidate {
  BackupCandidate({required this.asset, required this.albumNames});

  Asset asset;
  List<String> albumNames;

  @override
  int get hashCode => asset.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! BackupCandidate) {
      return false;
    }
    return asset == other.asset;
  }
}
