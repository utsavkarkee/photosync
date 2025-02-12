import 'package:mediab/interfaces/album.interface.dart';
import 'package:mediab/interfaces/album_api.interface.dart';
import 'package:mediab/interfaces/album_media.interface.dart';
import 'package:mediab/interfaces/asset.interface.dart';
import 'package:mediab/interfaces/asset_media.interface.dart';
import 'package:mediab/interfaces/backup.interface.dart';
import 'package:mediab/interfaces/etag.interface.dart';
import 'package:mediab/interfaces/exif_info.interface.dart';
import 'package:mediab/interfaces/file_media.interface.dart';
import 'package:mediab/interfaces/user.interface.dart';
import 'package:mocktail/mocktail.dart';

class MockAlbumRepository extends Mock implements IAlbumRepository {}

class MockAssetRepository extends Mock implements IAssetRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockBackupRepository extends Mock implements IBackupRepository {}

class MockExifInfoRepository extends Mock implements IExifInfoRepository {}

class MockETagRepository extends Mock implements IETagRepository {}

class MockAlbumMediaRepository extends Mock implements IAlbumMediaRepository {}

class MockAssetMediaRepository extends Mock implements IAssetMediaRepository {}

class MockFileMediaRepository extends Mock implements IFileMediaRepository {}

class MockAlbumApiRepository extends Mock implements IAlbumApiRepository {}
