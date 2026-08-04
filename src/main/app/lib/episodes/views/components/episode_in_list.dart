import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/episodes/views/components/episode_sub_title.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/shape_clipper.dart';

class EpisodeInList extends StatelessWidget {
  final Episode episode;
  final bool offline;
  final bool showPodcastImage;

  const EpisodeInList({super.key, required this.episode, this.offline = false, this.showPodcastImage = true});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isPlayerOnEpisode = context.select(
          (PlayerCubit c) =>
              episode.id != null && episode.podcast?.id != unsubbedPodcastUuid && c.state.episode?.id == episode.id,
        );
        final isEpisodePlaying = context.select((PlayerCubit c) => c.state.playing && isPlayerOnEpisode);

        return PodcastColorProvider(
          podcastLight: isPlayerOnEpisode ? episode.podcast : null,
          builder: (context, colors) {
            return SingleMotionBuilder(
              motion: MaterialSpringMotion.expressiveSpatialFast(),
              value: isEpisodePlaying ? 1 : 0,
              builder: (context, value, child) {
                final padding = lerpDouble(0, pu2, value)!;
                var clipper2 = MorphClipper(
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
                double pictureSize = lerpDouble(75, 100, value)!;
                double borderSize = lerpDouble(0, 4, value)!;
                final borderColor = Color.lerp(Colors.transparent, colors.primary, value);
                return Padding(
                  padding: .only(bottom: pu, top: pu),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        isPlayerOnEpisode ? colors.secondaryContainer : Colors.transparent,
                        colors.primaryContainer,
                        value,
                      ),
                      borderRadius: .circular(lerpDouble(pu4, pu8 * 2, value) ?? pu),
                    ),
                    padding: .all(max(padding, 0)),
                    child: InkWell(
                      onTap: () => EpisodeSheet.open(context, episode, offline),
                      child: Row(
                        children: [
                          if (showPodcastImage && episode.podcast != null)
                            Stack(
                              children: [
                                ClipPath(
                                  clipper: clipper2,
                                  child: PodcastImage(
                                    podcastLight: episode.podcast!,
                                    width: pictureSize,
                                    height: pictureSize,
                                    borderRadius: pu,
                                  ),
                                ),
                                CustomPaint(
                                  size: Size(pictureSize, pictureSize),
                                  painter: BorderPainter(clipper: clipper2, color: borderColor!, width: borderSize),
                                ),
                              ],
                            ),
                          Gap(pu2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .stretch,
                              children: [
                                Text(episode.title ?? '', maxLines: 2, overflow: .ellipsis),
                                EpisodeSubTitle(episode: episode, offline: offline),
                              ],
                            ),
                          ),
                          Gap(pu),
                          EpisodePlayButton(episode: episode, offline: offline),
                          Gap(pu2),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
