import 'package:mediab/mixins/error_logger.mixin.dart';
import 'package:mediab/models/map/map_marker.model.dart';
import 'package:mediab/services/api.service.dart';
import 'package:logging/logging.dart';

class MapSerivce with ErrorLoggerMixin {
  final ApiService _apiService;
  @override
  final logger = Logger("MapService");

  MapSerivce(this._apiService);

  Future<Iterable<MapMarker>> getMapMarkers({
    bool? isFavorite,
    bool? withArchived,
    bool? withPartners,
    DateTime? fileCreatedAfter,
    DateTime? fileCreatedBefore,
  }) async {
    return logError(
      () async {
        final markers = await _apiService.mapApi.getMapMarkers(
          isFavorite: isFavorite,
          isArchived: withArchived,
          withPartners: withPartners,
          fileCreatedAfter: fileCreatedAfter,
          fileCreatedBefore: fileCreatedBefore,
        );

        return markers?.map(MapMarker.fromDto) ?? [];
      },
      defaultValue: [],
      errorMessage: "Failed to get map markers",
    );
  }
}
