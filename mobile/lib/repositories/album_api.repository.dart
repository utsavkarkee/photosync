import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/album.entity.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/interfaces/album_api.interface.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/repositories/api.repository.dart';
import 'package:openapi/api.dart';

final albumApiRepositoryProvider = Provider(
  (ref) => AlbumApiRepository(ref.watch(apiServiceProvider).albumsApi),
);

class AlbumApiRepository extends ApiRepository implements IAlbumApiRepository {
  final AlbumsApi _api;

  AlbumApiRepository(this._api);

  @override
  Future<Album> get(String id) async {
    final dto = await checkNull(_api.getAlbumInfo(id));
    return _toAlbum(dto);
  }

  @override
  Future<List<Album>> getAll({bool? shared}) async {
    final dtos = await checkNull(_api.getAllAlbums(shared: shared));
    return dtos.map(_toAlbum).toList();
  }

  @override
  Future<Album> create(
    String name, {
    required Iterable<String> assetIds,
    Iterable<String> sharedUserIds = const [],
  }) async {
    final users = sharedUserIds.map(
      (id) => AlbumUserCreateDto(userId: id, role: AlbumUserRole.editor),
    );
    final responseDto = await checkNull(
      _api.createAlbum(
        CreateAlbumDto(
          albumName: name,
          assetIds: assetIds.toList(),
          albumUsers: users.toList(),
        ),
      ),
    );
    return _toAlbum(responseDto);
  }

  @override
  Future<Album> update(
    String albumId, {
    String? name,
    String? thumbnailAssetId,
    String? description,
    bool? activityEnabled,
  }) async {
    final response = await checkNull(
      _api.updateAlbumInfo(
        albumId,
        UpdateAlbumDto(
          albumName: name,
          albumThumbnailAssetId: thumbnailAssetId,
          description: description,
          isActivityEnabled: activityEnabled,
        ),
      ),
    );
    return _toAlbum(response);
  }

  @override
  Future<void> delete(String albumId) {
    return _api.deleteAlbum(albumId);
  }

  @override
  Future<({List<String> added, List<String> duplicates})> addAssets(
    String albumId,
    Iterable<String> assetIds,
  ) async {
    final response = await checkNull(
      _api.addAssetsToAlbum(
        albumId,
        BulkIdsDto(ids: assetIds.toList()),
      ),
    );

    final List<String> added = [];
    final List<String> duplicates = [];

    for (final result in response) {
      if (result.success) {
        added.add(result.id);
      } else if (result.error == BulkIdResponseDtoErrorEnum.duplicate) {
        duplicates.add(result.id);
      }
    }
    return (added: added, duplicates: duplicates);
  }

  @override
  Future<({List<String> removed, List<String> failed})> removeAssets(
    String albumId,
    Iterable<String> assetIds,
  ) async {
    final response = await checkNull(
      _api.removeAssetFromAlbum(
        albumId,
        BulkIdsDto(ids: assetIds.toList()),
      ),
    );
    final List<String> removed = [], failed = [];
    for (final dto in response) {
      if (dto.success) {
        removed.add(dto.id);
      } else {
        failed.add(dto.id);
      }
    }
    return (removed: removed, failed: failed);
  }

  @override
  Future<Album> addUsers(String albumId, Iterable<String> userIds) async {
    final albumUsers = userIds.map((userId) => AlbumUserAddDto(userId: userId)).toList();
    final response = await checkNull(
      _api.addUsersToAlbum(
        albumId,
        AddUsersDto(albumUsers: albumUsers),
      ),
    );
    return _toAlbum(response);
  }

  @override
  Future<void> removeUser(String albumId, {required String userId}) {
    return _api.removeUserFromAlbum(albumId, userId);
  }

  static Album _toAlbum(AlbumResponseDto dto) {
    final Album album = Album(
      remoteId: dto.id,
      name: dto.albumName,
      createdAt: dto.createdAt,
      modifiedAt: dto.updatedAt,
      lastModifiedAssetTimestamp: dto.lastModifiedAssetTimestamp,
      shared: dto.shared,
      startDate: dto.startDate,
      endDate: dto.endDate,
      activityEnabled: dto.isActivityEnabled,
    );
    album.remoteAssetCount = dto.assetCount;
    album.owner.value = User.fromSimpleUserDto(dto.owner);
    album.remoteThumbnailAssetId = dto.albumThumbnailAssetId;
    final users = dto.albumUsers.map((albumUser) => User.fromSimpleUserDto(albumUser.user));
    album.sharedUsers.addAll(users);
    final assets = dto.assets.map(Asset.remote).toList();
    album.assets.addAll(assets);
    return album;
  }
}
