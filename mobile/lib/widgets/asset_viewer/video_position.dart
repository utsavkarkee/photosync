import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/constants/immich_colors.dart';
import 'package:mediab/providers/asset_viewer/video_player_controls_provider.dart';
import 'package:mediab/providers/asset_viewer/video_player_value_provider.dart';
import 'package:mediab/widgets/asset_viewer/formatted_duration.dart';
import 'package:mediab/widgets/asset_viewer/video_mute_button.dart';

class VideoPosition extends HookConsumerWidget {
  const VideoPosition({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (position, duration) = ref.watch(
      videoPlaybackValueProvider.select((v) => (v.position, v.duration)),
    );
    final wasPlaying = useRef<bool>(true);
    return duration == Duration.zero
        ? const _VideoPositionPlaceholder()
        : Row(
            children: [
              FormattedDuration(position),
              Expanded(
                child: Slider(
                  value: min(
                    position.inMicroseconds / duration.inMicroseconds * 100,
                    100,
                  ),
                  min: 0,
                  max: 100,
                  thumbColor: Colors.white,
                  activeColor: Colors.white,
                  inactiveColor: whiteOpacity75,
                  onChangeStart: (value) {
                    final state = ref.read(videoPlaybackValueProvider).state;
                    wasPlaying.value = state != VideoPlaybackState.paused;
                    ref.read(videoPlayerControlsProvider.notifier).pause();
                  },
                  onChangeEnd: (value) {
                    if (wasPlaying.value) {
                      ref.read(videoPlayerControlsProvider.notifier).play();
                    }
                  },
                  onChanged: (position) {
                    ref.read(videoPlayerControlsProvider.notifier).position =
                        position;
                  },
                ),
              ),
              FormattedDuration(duration),
              const VideoMuteButton(),
            ],
          );
  }
}

class _VideoPositionPlaceholder extends StatelessWidget {
  const _VideoPositionPlaceholder();

  static void _onChangedDummy(_) {}

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FormattedDuration(Duration.zero),
        Expanded(
          child: Slider(
            value: 0.0,
            min: 0,
            max: 100,
            thumbColor: Colors.white,
            activeColor: Colors.white,
            inactiveColor: whiteOpacity75,
            onChanged: _onChangedDummy,
          ),
        ),
        FormattedDuration(Duration.zero),
        VideoMuteButton(),
      ],
    );
  }
}