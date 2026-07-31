import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/episode_progress.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/states/server.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

const double _playedThreshold = 0.95;

class EpisodePlayButton extends StatelessWidget {
  final Episode episode;
  final bool offline;

  const EpisodePlayButton({super.key, required this.episode, required this.offline});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        var cubit = context.read<PlayerCubit>();

        final playerEpisode = context.select((PlayerCubit c) => c.state.episode);
        final isEpisodePlaying = playerEpisode?.id == episode.id;
        final episodeDuration = context.select(
          (PlayerCubit c) => isEpisodePlaying ? c.state.duration.inSeconds.toDouble() : episode.progress ?? 1,
        );
        final playerProgress = context.select(
          (PlayerCubit c) => isEpisodePlaying && c.state.loading == false
              ? (c.state.position.inSeconds) / (c.state.duration.inSeconds)
              : episode.progressPercent,
        );

        return Stack(
          alignment: .center,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(color: colors.surface, borderRadius: .circular(100)),
              ),
            ),
            if (!offline)
              isEpisodePlaying
                  ? CircularProgressIndicator(value: playerProgress, backgroundColor: colors.secondaryContainer)
                  : StreamBuilder<double>(
                      stream: context
                          .read<ServerCubit>()
                          .playbackStream
                          .stream
                          .where((e) => e.episodeId == episode.id && !(e.newPlayback ?? false))
                          .map((event) {
                            return (event.progress ?? 0) / episodeDuration;
                          })
                ,
                      initialData: episode.progressPercent,
                      builder: (context, snapshot) {
                        return CircularProgressIndicator(
                        value: snapshot.data ?? episode.progressPercent,
                        backgroundColor: colors.secondaryContainer,
                      );
                      },
                    ),
            IconButton(
              onPressed: () {
                cubit.playEpisode(episode, offline: offline);
              },
              color: isEpisodePlaying
                  ? colors.primary
                  : playerProgress > _playedThreshold
                  ? Colors.green
                  : null,
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
