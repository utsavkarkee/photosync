import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/interfaces/user_api.interface.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/repositories/api.repository.dart';
import 'package:openapi/api.dart';

final userApiRepositoryProvider = Provider(
  (ref) => UserApiRepository(
    ref.watch(apiServiceProvider).usersApi,
  ),
);

class UserApiRepository extends ApiRepository implements IUserApiRepository {
  final UsersApi _api;

  UserApiRepository(this._api);

  @override
  Future<List<User>> getAll() async {
    final dto = await checkNull(_api.searchUsers());
    return dto.map(User.fromSimpleUserDto).toList();
  }

  @override
  Future<({String profileImagePath})> createProfileImage({
    required String name,
    required Uint8List data,
  }) async {
    final response = await checkNull(
      _api.createProfileImage(
        MultipartFile.fromBytes('file', data, filename: name),
      ),
    );
    return (profileImagePath: response.profileImagePath);
  }
}
