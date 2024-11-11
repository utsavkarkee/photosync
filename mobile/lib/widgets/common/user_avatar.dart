import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediab/extensions/build_context_extensions.dart';
import 'package:mediab/entities/store.entity.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/services/api.service.dart';

Widget userAvatar(BuildContext context, User u, {double? radius}) {
  final url = "${Store.get(StoreKey.serverEndpoint)}/users/${u.id}/profile-image";
  final nameFirstLetter = u.name.isNotEmpty ? u.name[0] : "";
  return CircleAvatar(
    radius: radius,
    backgroundColor: context.primaryColor.withAlpha(50),
    foregroundImage: CachedNetworkImageProvider(
      url,
      headers: ApiService.getRequestHeaders(),
      cacheKey: "user-${u.id}-profile",
    ),
    // silence errors if user has no profile image, use initials as fallback
    onForegroundImageError: (exception, stackTrace) {},
    child: Text(nameFirstLetter.toUpperCase()),
  );
}
