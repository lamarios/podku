import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_grid_sub_text.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/shape_clipper.dart';

const double _imageSize = 250;

class EpisodeInGrid extends StatelessWidget {
  static const double mainAxisExtent = 450;
  static const double crossAxisExtent = 450;
  static const double crossAxisSpacing = pu6;
  static const double mainAxisSpacing = pu6;

  final Episode episode;
  final bool offline;
  final bool showPodcastImage;

  const EpisodeInGrid({super.key, required this.episode, this.offline = false, this.showPodcastImage = true});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Builder(
      builder: (context) {
        final isPlayerOnEpisode = context.select(
          (PlayerCubit c) =>
              episode.id != null && episode.podcast?.id != unsubbedPodcastUuid && c.state.episode?.id == episode.id,
        );
        final isEpisodePlaying = context.select((PlayerCubit c) => c.state.playing && isPlayerOnEpisode);
        return PodcastColorProvider(
          podcastLight: episode.podcast,
          builder: (context, colors) => SingleMotionBuilder(
            motion: MaterialSpringMotion.expressiveSpatialFast(),
            value: isEpisodePlaying ? 1 : 0,
            builder: (context, value, child) {
              final backgroundColor = Color.lerp(colors.secondaryContainer, colors.primaryContainer, value)!;

              final clipper2 = MorphClipper(
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
              final borderColor = Color.lerp(Colors.transparent, colors.primary, value);

              double pictureSize = lerpDouble(_imageSize * 0.85, _imageSize * 1, value)!;
              final double borderSize = lerpDouble(0, 4, value)!;
              return InkWell(
                onTap: () => EpisodeSheet.open(context, episode, offline),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: .circular(lerpDouble(pu4, pu8, value) ?? pu),
                  ),
                  padding: .all(pu6),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      Text(
                        episode.title ?? '',
                        maxLines: 2,
                        overflow: .ellipsis,
                        textAlign: .start,
                        style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
                      ),
                      Text(episode.podcast?.name ?? ''),
                      Gap(pu4),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: pictureSize,
                            height: pictureSize,
                            child: ClipRRect(
                              borderRadius: .circular(pu2),
                              child: Stack(
                                alignment: .center,
                                children: [
                                  ClipPath(
                                    clipper: clipper2,
                                    child: Stack(
                                      children: [
                                        episode.podcast != null && showPodcastImage
                                            ? PodcastImage(
                                                podcastLight: episode.podcast!,
                                                width: pictureSize,
                                                height: pictureSize,
                                                borderRadius: pu2,
                                              )
                                            : Container(
                                                width: pictureSize,
                                                height: pictureSize,
                                                decoration: BoxDecoration(
                                                  borderRadius: .circular(pu4),
                                                  color: colors.secondaryContainer,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.podcasts,
                                                    size: pictureSize / 3,
                                                    color: colors.onSecondaryContainer.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],

                                              begin: .bottomCenter,
                                              end: .topCenter,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomPaint(
                                    size: Size(pictureSize, pictureSize),
                                    painter: BorderPainter(clipper: clipper2, color: borderColor!, width: borderSize),
                                  ),
                                  Positioned(
                                    bottom: pu2,
                                    right: pu2,
                                    left: 0,
                                    child: Align(
                                      alignment: .bottomRight,
                                      child: EpisodePlayButton(episode: episode, offline: offline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(pu4),
                      EpisodeGridSubText(episode: episode, offline: offline),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
