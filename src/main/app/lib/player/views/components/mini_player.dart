import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/playing_podcast_image.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/utils.dart';

/// Content of the collapsed player. The card behind it (color, shape, shadow) is drawn by the expandable player panel.
/// Scale of the mini player podcast image, which pops out of the card while playing.
double miniPlayerImageScale(double playingValue) => lerpDouble(1, 1.2, playingValue)!;

class MiniPlayer extends StatelessWidget {
  static const double playerSize = 75;

  /// Key of the podcast image slot, used to measure where the image is when expanding to the big player.
  final GlobalKey? imageKey;

  /// Hides the podcast image while keeping its slot, when the image is drawn elsewhere (during the expansion).
  final bool hideImage;

  const MiniPlayer({super.key, this.imageKey, this.hideImage = false});

  static SliverPadding miniPlayerPadding() {
    return SliverPadding(padding: .only(bottom: playerSize * 2));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final cubit = context.read<PlayerCubit>();

    return Builder(
      builder: (context) {
        final podcast = context.select((PlayerCubit c) => c.state.episode?.podcast);
        final isPlaying = context.select((PlayerCubit c) => c.state.playing);
        final playingLocally = context.select((PlayerCubit c) => c.isPlayingLocally);
        final currentPlayer = context.select((PlayerCubit c) => c.state.currentPlayer);

        return PodcastColorProvider(
          podcastLight: podcast,
          builder: (context, colors) {
            return SizedBox(
              height: playerSize,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: .opaque,
                  onTap: () => cubit.showPlayers(false, true),
                  child: SingleMotionBuilder(
                    motion: MaterialSpringMotion.expressiveSpatialFast(),
                    value: isPlaying ? 1 : 0,
                    builder: (context, value, child) {
                      return SizedBox(
                        height: 70,
                        child: Builder(
                          builder: (context) {
                            final episode = context.select((PlayerCubit c) => c.state.episode);
                            final loading = context.select((PlayerCubit c) => c.state.loading);

                            if (episode == null) {
                              return SizedBox.shrink();
                            }
                            if (loading) {
                              return Center(child: LoadingIndicator());
                            }

                            return Row(
                              children: [
                                // the key is outside the scale: the expandable player measures the slot's layout box
                                // and applies the playing scale itself, as it changes while the mini player is hidden
                                SizedBox(
                                  key: imageKey,
                                  width: playerSize,
                                  height: playerSize,
                                  child: Transform.scale(
                                    scale: miniPlayerImageScale(value),
                                    child: SizedBox(
                                      width: playerSize,
                                      height: playerSize,
                                      child: Opacity(
                                        opacity: hideImage ? 0 : 1,
                                        child: PlayingPodcastImage(
                                          podcast: episode.podcast!,
                                          size: playerSize,
                                          playingValue: value,
                                          borderColor: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Gap(pu6),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .stretch,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final title = context.select(
                                            (PlayerCubit c) => c.state.episode?.title ?? 'nothing is playing',
                                          );
                                          return Text(title, overflow: .ellipsis, maxLines: playingLocally ? 2 : 1);
                                        },
                                      ),
                                      if (!playingLocally)
                                        Row(
                                          spacing: pu,
                                          children: [
                                            Icon(M3EIcons.devices_other, size: 15),
                                            Text(currentPlayer?.name ?? '', style: textTheme.labelSmall),
                                          ],
                                        ),
                                      Gap(pu2),
                                      ProgressBar(height: 5),
                                    ],
                                  ),
                                ),
                                Gap(pu2),
                                PlayPauseButton(),
                                Gap(pu2),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
