import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/shape_clipper.dart';

const double _imageSize = 70;

class EpisodeInContinuePlaying extends StatelessWidget {
  final double height;

  final Episode episode;
  final bool offline;
  final bool showPodcastImage;

  const EpisodeInContinuePlaying({
    super.key,
    required this.episode,
    this.offline = false,
    this.showPodcastImage = true,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.of(context) == .mobile;

    final baseColors = Theme.of(context).colorScheme;
    return SizedBox(
      width: isMobile ? MediaQuery.sizeOf(context).width * 0.75 : 400,
      height: height,
      child: Builder(
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
                final backgroundColor = Color.lerp(
                  isMobile ? colors.primaryContainer.withValues(alpha: 0) : baseColors.surfaceContainer,
                  colors.primaryContainer,
                  value,
                )!;

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
                      borderRadius: .circular(lerpDouble(pu4, height, value) ?? pu),
                    ),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      mainAxisAlignment: .center,
                      children: [
                        Padding(
                          padding: .symmetric(horizontal: pu2),
                          child: Row(
                            spacing: pu2,
                            children: [
                              SizedBox(
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
                                        painter: BorderPainter(
                                          clipper: clipper2,
                                          color: borderColor!,
                                          width: borderSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(episode.title ?? '', maxLines: 2, overflow: .ellipsis, textAlign: .start),
                              ),
                              EpisodePlayButton(episode: episode, offline: offline),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
