import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/repositories/activity_api.repository.dart';
import 'package:mediab/repositories/album_api.repository.dart';
import 'package:mediab/repositories/asset_api.repository.dart';
import 'package:mediab/repositories/partner_api.repository.dart';
import 'package:mediab/repositories/person_api.repository.dart';
import 'package:mediab/repositories/user_api.repository.dart';

void invalidateAllApiRepositoryProviders(WidgetRef ref) {
  ref.invalidate(userApiRepositoryProvider);
  ref.invalidate(activityApiRepositoryProvider);
  ref.invalidate(partnerApiRepositoryProvider);
  ref.invalidate(albumApiRepositoryProvider);
  ref.invalidate(personApiRepositoryProvider);
  ref.invalidate(assetApiRepositoryProvider);
}
