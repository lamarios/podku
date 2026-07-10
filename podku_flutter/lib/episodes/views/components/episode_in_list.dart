import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/player/states/player.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

class EpisodeInList extends StatelessWidget {
  final Episode episode;

  const EpisodeInList({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    print('episode rebuild');
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: .only(bottom: pu2),
      child: Row(
        children: [
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
                  style: textTheme.titleMedium,
                ),
                Text(
                  printDuration(Duration(seconds: episode.durationSeconds ?? 0)),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              CircularProgressIndicator(
                value: episode.progress,
                backgroundColor: colors.secondaryContainer,
              ),
              IconButton(
                onPressed: () => context.read<PlayerCubit>().playEpisode(episode),
                icon: Icon(
                  Icons.play_arrow,
                  size: 20,
                ),
                visualDensity: .comfortable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
