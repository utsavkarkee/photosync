import 'package:auto_route/auto_route.dart';
import 'package:mediab/providers/gallery_permission.provider.dart';
import 'package:mediab/routing/router.dart';

class BackupPermissionGuard extends AutoRouteGuard {
  final GalleryPermissionNotifier _permission;

  BackupPermissionGuard(this._permission);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final p = _permission.hasPermission;
    if (p) {
      resolver.next(true);
    } else {
      router.push(const PermissionOnboardingRoute());
    }
  }
}
