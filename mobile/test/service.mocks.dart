import 'package:mediab/services/api.service.dart';
import 'package:mediab/services/entity.service.dart';
import 'package:mediab/services/hash.service.dart';
import 'package:mediab/services/sync.service.dart';
import 'package:mediab/services/user.service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockUserService extends Mock implements UserService {}

class MockSyncService extends Mock implements SyncService {}

class MockHashService extends Mock implements HashService {}

class MockEntityService extends Mock implements EntityService {}
