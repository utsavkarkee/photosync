import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/constants/immich_colors.dart';
import 'package:mediab/providers/asset_viewer/show_controls.provider.dart';
import 'package:mediab/providers/asset_viewer/video_player_controls_provider.dart';
import 'package:mediab/widgets/asset_viewer/video_position.dart';

/// The video controls for the [videoPlayerControlsProvider]
class VideoControls extends ConsumerWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    return AnimatedOpacity(
      opacity: ref.watch(showControlsProvider) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 100),
      child: isPortrait
          ? const ColoredBox(
              color: blackOpacity40,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: VideoPosition(),
              ),
            )
          : const ColoredBox(
              color: blackOpacity40,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 128.0),
                child: VideoPosition(),
              ),
            ),
    );
  }
}
