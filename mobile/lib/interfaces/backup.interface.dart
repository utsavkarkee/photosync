import 'package:mediab/entities/backup_album.entity.dart';
import 'package:mediab/interfaces/database.interface.dart';

abstract interface class IBackupRepository implements IDatabaseRepository {
  Future<List<BackupAlbum>> getAll({BackupAlbumSort? sort});

  Future<List<String>> getIdsBySelection(BackupSelection backup);

  Future<List<BackupAlbum>> getAllBySelection(BackupSelection backup);

  Future<void> updateAll(List<BackupAlbum> backupAlbums);

  Future<void> deleteAll(List<int> ids);
}

enum BackupAlbumSort { id }
