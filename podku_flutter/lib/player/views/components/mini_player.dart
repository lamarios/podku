import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';

class MiniPlayer extends StatelessWidget {
  static const double playerSize = 75;

  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    return Builder(
      builder: (context) {
        final colorScheme = context.select((PodcastImageColorCubit c) => c.state.colorScheme);
        return SizedBox(
          height: playerSize,
          child: Material(
            color: Colors.transparent,
            child: AnimatedTheme(
              duration: animationDuration,
              data: Theme.of(context).copyWith(colorScheme: colorScheme),
              child: Builder(
                builder: (context) {
                  final colors = Theme.of(context).colorScheme;
                  return GestureDetector(
                    onTap: () => cubit.showPlayers(false, true),
                    child: Builder(
                      builder: (context) {
                        return Container(
                          height: 70,
                          decoration: BoxDecoration(color: colors.secondaryContainer),
                          child: Builder(
                            builder: (context) {
                              final episode = context.select((PlayerCubit c) => c.state.episode);
                              final loading = context.select((PlayerCubit c) => c.state.loading);

                              if (episode == null) {
                                return SizedBox.shrink();
                              }
                              if (loading) {
                                return Center(child: LoadingIndicator());
                              }

                              return Row(
                                children: [
                                  PodcastImage(
                                    key: ValueKey(episode.id),
                                    podcast: episode.podcast!,
                                    width: playerSize,
                                    height: playerSize,
                                  ),
                                  Gap(pu6),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: .center,
                                      crossAxisAlignment: .stretch,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final title = context.select(
                                              (PlayerCubit c) => c.state.episode?.title ?? 'nothing is player',
                                            );
                                            return Text(title, overflow: .ellipsis, maxLines: 2);
                                          },
                                        ),
                                        Gap(pu2),
                                        ProgressBar(height: 5),
                                      ],
                                    ),
                                  ),
                                  Gap(pu2),
                                  PlayPauseButton(),
                                  Gap(pu2),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
