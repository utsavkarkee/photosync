import 'package:mediab/providers/asset_viewer/current_asset.provider.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrentAssetProvider extends CurrentAssetInternal with Mock implements CurrentAsset {
  Asset? initAsset;
  MockCurrentAssetProvider([this.initAsset]);

  @override
  Asset? build() {
    return initAsset;
  }
}
