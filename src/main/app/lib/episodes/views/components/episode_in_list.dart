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
    final colors = M3ETheme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final playerEpisode = context.select((PlayerCubit c) => c.state.episode);
        final isEpisodePlaying =
            episode.id != null && episode.podcast?.id != unsubbedPodcastUuid && playerEpisode?.id == episode.id;

        return SingleMotionBuilder(
          motion: MaterialSpringMotion.expressiveEffectsDefault(),
          value: isEpisodePlaying ? 1 : 0,
          builder: (context, value, child) {
            final padding = lerpDouble(0, pu2, value)!;
            return Padding(
              padding: .only(bottom: pu, top: pu),
              child: Container(
                decoration: BoxDecoration(
                  // color: isEpisodePlaying ? colors.primaryContainer : Colors.transparent,
                  color: Color.lerp(Colors.transparent, colors.primaryContainer, value),
                  borderRadius: .circular(pu8),
                ),
                padding: .all(padding),
                child: InkWell(
                  onTap: () => EpisodeSheet.open(context, episode, offline),
                  child: Row(
                    children: [
                      if (showPodcastImage && episode.podcast != null)
                        ClipPath(
                          clipper: MorphClipper(
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
                          ),
                          child: PodcastImage(
                            podcastLight: episode.podcast!,
                            width: lerpDouble(75, 100, value),
                            height: lerpDouble(75, 100, value),
                            borderRadius: pu,
                          ),
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
                      Gap(pu),
                    ],
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
