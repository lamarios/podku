import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor/motor.dart';
import 'package:podku_flutter/player/states/player.dart';
import 'package:podku_flutter/player/views/components/play_pause_button.dart';
import 'package:podku_flutter/player/views/components/progress_bar.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

const double _imagesize = 100;

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final cubit = context.read<PlayerCubit>();

    return SizedBox(
      height: _imagesize,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => cubit.setMiniPlayer(false),
          child: Stack(
            children: [
              Positioned(
                left: pu6 + _imagesize / 2,
                right: pu6,
                bottom: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(borderRadius: .circular(pu3), color: colors.primaryContainer),
                  child: Row(
                    children: [
                      Gap(pu6 + _imagesize / 2),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .stretch,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final title = context.select((PlayerCubit c) => c.state.episode?.title ?? 'nothing is player');
                                    return Text(
                                      title,
                                      style: textTheme.titleMedium,
                                      overflow: .ellipsis,
                                      maxLines: 2,
                                    );
                                  },
                                ),
                                ProgressBar(height: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      Gap(pu2),
                      PlayPauseButton(),
                      Gap(pu6),
                    ],
                  ),
                ),
              ),

              Builder(
                builder: (context) {
                  final episode = context.select((PlayerCubit c) => c.state.episode);
                  if (episode == null) return SizedBox.shrink();
                  return Positioned(
                    left: pu6,
                    child: PodcastImage(
                      key: ValueKey(episode!.id),
                      podcast: episode!.podcast!,
                      width: _imagesize,
                      height: _imagesize,
                      borderRadius: pu3,
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
