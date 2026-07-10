import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_flutter/player/states/player.dart';
import 'package:podku_flutter/utils.dart';

class ProgressBar extends StatelessWidget {
  final double height;

  const ProgressBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Builder(
      builder: (context) {



        final Duration position = context.select((PlayerCubit c) => c.state.position);
        final Duration bufferPosition = context.select((PlayerCubit c) => c.state.bufferPosition);
        final Duration totalDuration = context.select((PlayerCubit c) => c.player.duration ?? Duration(milliseconds: 1));


        final totalDurationAdjusted = totalDuration.inSeconds == 0 ? 1 : totalDuration.inSeconds;
        totalDuration.inSeconds;

        return ClipRRect(
          borderRadius: .circular(height),
          child: Container(
            height: height,
            decoration: BoxDecoration(color: colors.surfaceDim),
            child: Stack(
              children: [
                AnimatedFractionallySizedBox(
                  heightFactor: 1,
                  widthFactor: bufferPosition.inSeconds / totalDurationAdjusted,
                  duration: animationDuration,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: .circular(height), color: colors.secondaryContainer),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  widthFactor: position.inSeconds / totalDurationAdjusted,
                  heightFactor: 1,
                  duration: animationDuration,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: .circular(height), color: colors.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
