import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/views/components/player_video_controls.dart';
import 'package:podku/utils.dart';

/// The video of the episode being watched, shown in place of the podcast image in the big player.
class PlayerVideo extends StatelessWidget {
  /// Size of the video relative to the available width, from 0 to 1.
  final double scale;
  final double borderRadius;

  const PlayerVideo({super.key, this.scale = 1, this.borderRadius = pu2});

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<PodkuAudioHandler>().videoController;
    if (controller == null) {
      return SizedBox.shrink();
    }
    final maxHeight = MediaQuery.sizeOf(context).height * 0.4;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = min(constraints.maxWidth - pu4 * 2, maxHeight * 16 / 9) * scale;
        return ClipRRect(
          borderRadius: .circular(borderRadius),
          child: SizedBox(
            width: width,
            height: width * 9 / 16,
            child: Video(
              controller: controller,
              controls: (state) => const PlayerVideoControls(),
              // the player cubit switches to the audio player when the app goes to the background
              pauseUponEnteringBackgroundMode: false,
            ),
          ),
        );
      },
    );
  }
}
