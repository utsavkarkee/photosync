import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/services/oauth.service.dart';
import 'package:mediab/providers/api.provider.dart';

final oAuthServiceProvider = Provider((ref) => OAuthService(ref.watch(apiServiceProvider)));
