import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/player/states/player.dart';

const double _playedThreshold = 0.95;
class EpisodePlayButton extends StatelessWidget {
  final Episode episode;

  const EpisodePlayButton({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        var cubit = context.read<PlayerCubit>();

        final playerEpisode = context.select((PlayerCubit c) => c.state.episode);
        final isEpisodePlaying = playerEpisode?.id == episode.id;
        final playerProgress = context.select(
          (PlayerCubit c) => isEpisodePlaying && c.state.loading == false ? (c.state.position.inSeconds) / (c.state.duration.inSeconds) : episode.progress,
        );

        return Stack(
          alignment: .center,
          children: [
            CircularProgressIndicator(
              value: playerProgress,
              backgroundColor: colors.secondaryContainer,
            ),
            IconButton(
              onPressed: () {
                cubit.playEpisode(episode);
              },
              color: isEpisodePlaying ? colors.primary : playerProgress > _playedThreshold ?  Colors.green : null,
              icon: Icon(
                !isEpisodePlaying && playerProgress > _playedThreshold ? Icons.check : Icons.play_arrow,
                size: 20,
              ),
              visualDensity: .compact,
            ),
          ],
        );
      },
    );
  }
}
