import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';

const double _imagesize = 100;

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cubit = context.read<PlayerCubit>();

    return SizedBox(
      height: _imagesize,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => cubit.showPlayers(false, true),
          child: Stack(
            children: [
              Positioned(
                left: pu6 + _imagesize / 2,
                right: pu6,
                bottom: _imagesize / 8,
                top: _imagesize / 8,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(borderRadius: .circular(pu3), color: colors.primaryContainer),
                  child: Row(
                    children: [
                      Gap(pu6 + _imagesize / 2),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final loading = context.select((PlayerCubit c) => c.state.loading);
                            return loading
                                ? Center(
                                    child: LoadingIndicator(),
                                  )
                                : Column(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .stretch,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final title = context.select((PlayerCubit c) => c.state.episode?.title ?? 'nothing is player');
                                          return Text(
                                            title,
                                            overflow: .ellipsis,
                                            maxLines: 2,
                                          );
                                        },
                                      ),
                                      Gap(pu2),
                                      ProgressBar(height: 5),
                                    ],
                                  );
                          },
                        ),
                      ),
                      Gap(pu2),
                      Builder(
                        builder: (context) {
                          final loading = context.select((PlayerCubit c) => c.state.loading);
                          return loading ? SizedBox.shrink() : PlayPauseButton();
                        },
                      ),
                      Gap(pu6),
                    ],
                  ),
                ),
              ),

              Builder(
                builder: (context) {
                  final episode = context.select((PlayerCubit c) => c.state.episode);
                  final loading = context.select((PlayerCubit c) => c.state.loading);
                  if (episode == null) return SizedBox.shrink();
                  return Positioned(
                    left: pu6,
                    child: AnimatedSwitcher(
                      duration: animationDuration,
                      child: loading
                          ? Container(
                              width: _imagesize,
                              height: _imagesize,
                              decoration: BoxDecoration(borderRadius: .circular(pu3), color: colors.secondaryContainer),
                            )
                          : PodcastImage(
                              key: ValueKey(episode.id),
                              podcast: episode.podcast!,
                              width: _imagesize,
                              height: _imagesize,
                              borderRadius: pu3,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
