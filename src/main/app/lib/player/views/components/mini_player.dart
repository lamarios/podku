import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/shape_clipper.dart';

class MiniPlayer extends StatelessWidget {
  static const double playerSize = 75;

  const MiniPlayer({super.key});

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
                  onTap: () => cubit.showPlayers(false, true),
                  child: SingleMotionBuilder(
                    motion: MaterialSpringMotion.expressiveSpatialFast(),
                    value: isPlaying ? 1 : 0,
                    builder: (context, value, child) {
                      double borderSize = lerpDouble(0, 2, value)!;
                      final borderColor = Color.lerp(Colors.transparent, colors.primary, value);
                      var clipper = MorphClipper(
                        Morph(
                          RoundedPolygon.rectangle(
                            width: 1,
                            height: 1,
                            rounding: CornerRounding(radius: 0.15),
                            centerX: 0.5,
                            centerY: 0.5,
                          ),
                          M3EMaterialNewShapes.cookie9Sided,
                        ),
                        value,
                      );

                      return Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color.lerp(colors.secondaryContainer, colors.primaryContainer, value),
                          borderRadius: .circular(lerpDouble(pu3, pu8, value)!),
                          boxShadow: [BoxShadow(blurRadius: pu4, color: Colors.black.withValues(alpha: 0.5))],
                        ),
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
                                Transform.scale(
                                  scale: lerpDouble(1, 1.2, value),
                                  child: Stack(
                                    children: [
                                      ClipPath(
                                        clipper: clipper,
                                        child: PodcastImage(
                                          podcastLight: episode.podcast!,
                                          width: playerSize,
                                          height: playerSize,
                                          borderRadius: pu,
                                        ),
                                      ),
                                      CustomPaint(
                                        size: Size(playerSize, playerSize),
                                        painter: BorderPainter(
                                          clipper: clipper,
                                          color: borderColor!,
                                          width: borderSize,
                                        ),
                                      ),
                                    ],
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
