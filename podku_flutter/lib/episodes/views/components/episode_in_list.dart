import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/episodes/views/components/episode_sub_title.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

class EpisodeInList extends StatelessWidget {
  final Episode episode;
  final bool offline;
  final bool showPodcastImage;

  const EpisodeInList({super.key, required this.episode, this.offline = false, this.showPodcastImage = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(bottom: pu, top: pu),
      child: InkWell(
        onTap: () => EpisodeSheet.open(context, episode, offline),
        child: Row(
          children: [
            if (showPodcastImage && episode.podcast != null)
              PodcastImage(podcast: episode.podcast!, width: 75, height: 75, borderRadius: pu),
            Gap(pu2),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(episode.title, maxLines: 2, overflow: .ellipsis),
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
    );
  }
}
