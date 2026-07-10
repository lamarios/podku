import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku_flutter/player/states/player.dart';
import 'package:podku_flutter/player/views/components/big_player.dart';
import 'package:podku_flutter/player/views/components/mini_player.dart';

class PlayerWrapper extends StatelessWidget {
  final Widget child;

  const PlayerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    print('rebuild');
    return Stack(
      children: [
        child,
        Builder(
          builder: (context) {
            final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
            final hasEpisode = context.select((PlayerCubit c) => c.state.episode != null);
            return SingleMotionBuilder(
              motion: MaterialSpringMotion.expressiveSpatialDefault(),
              value: showMiniPlayer ? 1 : 0,
              from: 0,
              builder: (context, value, child) {
                double miniPlayerEffectiveValue = hasEpisode ? value : 0;
                print('value: ${value}');
                return value <= 0.1
                    ? SizedBox.shrink()
                    : Positioned(
                        left: 0,
                        right: 0,
                        bottom: lerpDouble(-300, 100, miniPlayerEffectiveValue),
                        child: Opacity(opacity: value.clamp(0, 1), child: MiniPlayer()),
                      );
              },
            );
          },
        ),
        Builder(
          builder: (context) {
            final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
            final hasEpisode = context.select((PlayerCubit c) => c.state.episode != null);
            return SingleMotionBuilder(
              motion: MaterialSpringMotion.expressiveSpatialDefault(),
              value: showMiniPlayer ? 1 : 0,
              from: 0,
              builder: (context, value, child) {
                double bigPlayerEffectiveValue = hasEpisode ? value : 1;
                return value >= 0.9
                    ? SizedBox.shrink()
                    : Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: lerpDouble(0, screenHeight, bigPlayerEffectiveValue),
                        child: Opacity(opacity: (1 - value).clamp(0, 1), child: BigPlayer()),
                      );
              },
            );
          },
        ),
      ],
    );
  }
}
