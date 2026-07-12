import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';

class PlayPauseButton extends StatelessWidget {
  final double? size;

  const PlayPauseButton({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final cubit = context.read<PlayerCubit>();
        final playing = context.select((PlayerCubit c) => c.state.playing);
        return InkWell(
          onTap: () => cubit.playPause(),
          child: SingleMotionBuilder(
            value: playing ? 1 : 0,
            from: 0,
            motion: MaterialSpringMotion.expressiveEffectsDefault(),
            builder: (context, value, child) => AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              color: colors.onSecondaryContainer,
              progress: AlwaysStoppedAnimation(value),
              size: size,
            ),
          ),
        );
      },
    );
  }
}
