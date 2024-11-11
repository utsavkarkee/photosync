import 'package:mediab/entities/etag.entity.dart';
import 'package:mediab/interfaces/database.interface.dart';

abstract interface class IETagRepository implements IDatabaseRepository {
  Future<ETag?> get(int id);

  Future<ETag?> getById(String id);

  Future<List<String>> getAllIds();

  Future<void> upsertAll(List<ETag> etags);

  Future<void> deleteByIds(List<String> ids);
}
