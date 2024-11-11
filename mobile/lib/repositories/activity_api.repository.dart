import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/interfaces/activity_api.interface.dart';
import 'package:mediab/models/activities/activity.model.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/repositories/api.repository.dart';
import 'package:openapi/api.dart';

final activityApiRepositoryProvider = Provider(
  (ref) => ActivityApiRepository(ref.watch(apiServiceProvider).activitiesApi),
);

class ActivityApiRepository extends ApiRepository implements IActivityApiRepository {
  final ActivitiesApi _api;

  ActivityApiRepository(this._api);

  @override
  Future<List<Activity>> getAll(String albumId, {String? assetId}) async {
    final response = await checkNull(_api.getActivities(albumId, assetId: assetId));
    return response.map(_toActivity).toList();
  }

  @override
  Future<Activity> create(
    String albumId,
    ActivityType type, {
    String? assetId,
    String? comment,
  }) async {
    final dto = ActivityCreateDto(
      albumId: albumId,
      type: type == ActivityType.comment ? ReactionType.comment : ReactionType.like,
      assetId: assetId,
      comment: comment,
    );
    final response = await checkNull(_api.createActivity(dto));
    return _toActivity(response);
  }

  @override
  Future<void> delete(String id) {
    return checkNull(_api.deleteActivity(id));
  }

  @override
  Future<ActivityStats> getStats(String albumId, {String? assetId}) async {
    final response = await checkNull(_api.getActivityStatistics(albumId, assetId: assetId));
    return ActivityStats(comments: response.comments);
  }

  static Activity _toActivity(ActivityResponseDto dto) => Activity(
        id: dto.id,
        createdAt: dto.createdAt,
        type: dto.type == ReactionType.comment ? ActivityType.comment : ActivityType.like,
        user: User.fromSimpleUserDto(dto.user),
        assetId: dto.assetId,
        comment: dto.comment,
      );
}
