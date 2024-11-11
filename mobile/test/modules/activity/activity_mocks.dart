import 'package:mediab/models/activities/activity.model.dart';
import 'package:mediab/providers/activity.provider.dart';
import 'package:mediab/providers/activity_statistics.provider.dart';
import 'package:mediab/services/activity.service.dart';
import 'package:mocktail/mocktail.dart';

class ActivityServiceMock extends Mock implements ActivityService {}

class MockAlbumActivity extends AlbumActivityInternal with Mock implements AlbumActivity {
  List<Activity>? initActivities;
  MockAlbumActivity([this.initActivities]);

  @override
  Future<List<Activity>> build(String albumId, [String? assetId]) async {
    return initActivities ?? [];
  }
}

class ActivityStatisticsMock extends ActivityStatisticsInternal with Mock implements ActivityStatistics {}
