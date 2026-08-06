import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/progress_indicators/m3e_progress_indicators.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/episode_progress.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';

const double _playedThreshold = 0.95;

class EpisodePlayButton extends StatelessWidget {
  final Episode episode;
  final bool offline;

  const EpisodePlayButton({super.key, required this.episode, required this.offline});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final isMobile = BreakPoint.of(context) == .mobile;
    return Builder(
      builder: (context) {
        var cubit = context.read<PlayerCubit>();

        final playerEpisode = context.select((PlayerCubit c) => c.state.episode);
        final isEpisodePlaying =
            episode.id != null && episode.podcast?.id != unsubbedPodcastUuid && playerEpisode?.id == episode.id;
        final playerPlaying = context.select((PlayerCubit c) => c.state.playing);

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
                decoration: BoxDecoration(
                  color: isMobile ? Colors.transparent : colors.surface,
                  borderRadius: .circular(100),
                ),
              ),
            ),
            if (!offline)
              Positioned.fill(
                child: isEpisodePlaying
                    ? SingleMotionBuilder(
                        motion: MaterialSpringMotion.expressiveSpatialFast(),
                        value: playerPlaying ? 1 : 0,
                        builder: (context, value, child) {
                          return M3EProgressIndicator.circularWavy(
                            value: playerProgress,
                            trackColor: Color.lerp(colors.surfaceContainer, colors.surfaceContainerHigh, value),
                            amplitude: value.clamp(0, 1),
                          );
                        },
                      )
                    : StreamBuilder<double>(
                        stream: context
                            .read<ServerCubit>()
                            .playbackStream
                            .stream
                            .where((e) => e.episodeId == episode.id && !(e.newPlayback ?? false))
                            .map((event) {
                              return (event.progress ?? 0) / episodeDuration;
                            }),
                        initialData: episode.progressPercent,
                        builder: (context, snapshot) {
                          return M3EProgressIndicator.circular(
                            value: snapshot.data ?? episode.progressPercent,
                            trackColor: colors.secondaryContainer,
                          );
                        },
                      ),
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
              icon: SingleMotionBuilder(
                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                value: isEpisodePlaying && playerPlaying ? 1 : 0,

                builder: (context, value, child) =>
                    AnimatedIcon(icon: AnimatedIcons.play_pause, progress: AlwaysStoppedAnimation(value), size: 20),
              ),
              visualDensity: .compact,
            ),
          ],
        );
      },
    );
  }
}
