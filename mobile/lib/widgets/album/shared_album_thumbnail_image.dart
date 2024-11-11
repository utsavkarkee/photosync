import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/widgets/common/immich_thumbnail.dart';

class SharedAlbumThumbnailImage extends HookConsumerWidget {
  final Asset asset;

  const SharedAlbumThumbnailImage({super.key, required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // debugPrint("View ${asset.id}");
      },
      child: Stack(
        children: [
          ImmichThumbnail(
            asset: asset,
            width: 500,
            height: 500,
          ),
        ],
      ),
    );
  }
}
