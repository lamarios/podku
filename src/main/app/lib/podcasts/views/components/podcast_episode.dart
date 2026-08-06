import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/components/lists/components/m3e_card_list_item.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/episodes/views/components/episode_sub_title.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';

class PodcastEpisode extends StatelessWidget {
  final Episode episode;
  final bool offline;
  final bool showPodcastImage;
  final int index;
  final int itemCount;

  const PodcastEpisode({
    super.key,
    required this.episode,
    this.offline = false,
    this.showPodcastImage = true,
    required this.index,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final isPlayerOnEpisode = context.select(
          (PlayerCubit c) =>
              episode.id != null && episode.podcast?.id != unsubbedPodcastUuid && c.state.episode?.id == episode.id,
        );
        final isEpisodePlaying = context.select((PlayerCubit c) => c.state.playing && isPlayerOnEpisode);

        return SingleMotionBuilder(
          motion: Motion.bouncySpring(),
          value: isEpisodePlaying ? 1 : 0,
          builder: (context, value, child) => M3ECardListItem(
            index: index,
            position: index == itemCount - 1
                ? .last
                : index == 0
                ? .first
                : .middle,
            outerRadius: lerpDouble(pu4, pu8 * 2, value)!,
            innerRadius: lerpDouble(pu2, pu8 * 2, value)!,
            gap: pu,
            color: Color.lerp(
              isPlayerOnEpisode ? colors.secondaryContainer : colors.surfaceContainer,
              colors.primaryContainer,
              value,
            ),
            child: child!,
          ),
          child: Padding(
            padding: .only(bottom: pu, top: pu),
            child: InkWell(
              onTap: () => EpisodeSheet.open(context, episode, offline),
              child: Row(
                children: [
                  EpisodePlayButton(episode: episode, offline: offline),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
