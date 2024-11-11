import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/services/user.service.dart';

final otherUsersProvider = FutureProvider.autoDispose<List<User>>((ref) {
  UserService userService = ref.watch(userServiceProvider);

  return userService.getUsers();
});
