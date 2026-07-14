import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:podku/episodes/views/components/download_status.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

class EpisodeInList extends StatelessWidget {
  final Episode episode;
  final bool offline;

  const EpisodeInList({super.key, required this.episode, this.offline = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: .only(bottom: pu, top: pu),
      child: Row(
        children: [
          if (episode.podcast != null)
            PodcastImage(
              podcast: episode.podcast!,
              width: 75,
              height: 75,
              borderRadius: pu,
            ),
          Gap(pu2),
          Expanded(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  episode.title,
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          episode.pubDateMillis ?? 0,
                        ),
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.outline,
                      ),
                    ),
                    if (episode.durationSeconds != null) ...[
                      Gap(pu2),
                      Icon(
                        Icons.timer_outlined,
                        size: 12,
                        color: colors.outline,
                      ),
                      Text(
                        printDuration(
                          Duration(seconds: episode.durationSeconds ?? 0),
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.outline,
                        ),
                      ),
                    ],
                    Gap(pu),
                    if (!kIsWeb && !offline) EpisodeDownloadStatus(episode: episode),
                  ],
                ),
              ],
            ),
          ),
          Gap(pu),
          EpisodePlayButton(episode: episode, offline: offline),
        ],
      ),
    );
  }
}
