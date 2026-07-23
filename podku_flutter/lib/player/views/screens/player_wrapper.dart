import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/big_player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/server/views/components/offline_indicator.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';

class PlayerWrapper extends StatelessWidget {
  static final double _bigPlayerWidth = BreakPoint.mobile.maxWidth * 0.7;
  final Widget child;

  const PlayerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = BreakPoint.get(context) == .mobile;
    final colors = Theme.of(context).colorScheme;
    final brightness = Theme.brightnessOf(context);
    return Builder(
      builder: (context) {
        final connectionStatus = context.select((ServerCubit c) => c.state.status);
        final isOnline = connectionStatus == .connected;
        return BlocProvider(
          create: (context) => PodcastImageColorCubit(
            PodcastImageColorState(colorScheme: colors, scaffoldColor: colors.secondaryContainer),
            brightness: brightness,
            fallBackColorScheme: colors,
          ),
          child: ErrorHandler<PlayerCubit, PlayerState>(
            showAsSnack: true,
            child: BlocListener<PlayerCubit, PlayerState>(
              listener: (context, state) {
                context.read<PodcastImageColorCubit>().setPodcast(state.episode?.podcast);
              },
              listenWhen: (previous, current) => previous.episode?.podcast != current.episode?.podcast,
              child: Container(
                color: colors.surface,
                child: Stack(
                  children: [
                    ConditionalWrap(
                      wrapIf: !isMobile,
                      wrapper: (child) => Builder(
                        builder: (context) {
                          final showBigPlayer = context.select((PlayerCubit c) => c.state.showBigPlayer);
                          return SingleMotionBuilder(
                            motion: MaterialSpringMotion.expressiveSpatialDefault(),
                            value: showBigPlayer ? 1 : 0,
                            from: 0,
                            builder: (context, value, child) {
                              return Positioned(
                                top: 0,
                                bottom: isOnline ? 0 : OfflineIndicator.height,
                                left: 0,
                                right: lerpDouble(0, _bigPlayerWidth, value),
                                child: child!,
                              );
                            },
                            child: child,
                          );
                        },
                      ),
                      wrapElse: (child) => Builder(
                        builder: (context) {
                          final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
                          return SingleMotionBuilder(
                            motion: MaterialSpringMotion.expressiveSpatialDefault(),
                            value:
                                (showMiniPlayer ? MiniPlayer.playerSize : 0) + (isOnline ? 0 : OfflineIndicator.height),
                            from: 0,
                            builder: (context, value, child) => Container(
                              padding: .only(bottom: value.clamp(0, MiniPlayer.playerSize * 2)),
                              child: child,
                            ),
                            child: child,
                          );
                        },
                      ),
                      child: child,
                    ),
                    if (isMobile)
                      Builder(
                        builder: (context) {
                          final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
                          final double offlinePadding = isOnline ? 0 : OfflineIndicator.height;

                          return SingleMotionBuilder(
                            motion: MaterialSpringMotion.expressiveSpatialDefault(),
                            value: showMiniPlayer ? offlinePadding : -MiniPlayer.playerSize - offlinePadding,
                            from: 0,
                            builder: (context, value, child) {
                              return value <= -MiniPlayer.playerSize - offlinePadding
                                  ? SizedBox.shrink()
                                  : Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: value,
                                      child: SafeArea(child: MiniPlayer()),
                                    );
                            },
                          );
                        },
                      ),
                    SingleMotionBuilder(
                      value: isOnline ? -OfflineIndicator.height * 10 : 0,
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      builder: (BuildContext context, double value, Widget? child) =>
                          Positioned(left: 0, bottom: value, right: 0, child: child!),
                      child: OfflineIndicator(),
                    ),
                    Builder(
                      builder: (context) {
                        final showBigPlayer = context.select((PlayerCubit c) => c.state.showBigPlayer);
                        return SingleMotionBuilder(
                          motion: MaterialSpringMotion.expressiveSpatialDefault(),
                          value: showBigPlayer ? 1 : 0,
                          from: 0,
                          builder: (context, value, child) {
                            return value <= 0.1
                                ? SizedBox.shrink()
                                : Positioned(
                                    left: isMobile ? 0 : null,
                                    right: isMobile ? 0 : lerpDouble(-_bigPlayerWidth, 0, value),
                                    bottom: 0,
                                    top: isMobile ? lerpDouble(screenHeight, 0, value) : 0,
                                    child: ConditionalWrap(
                                      wrapIf: !isMobile,
                                      wrapper: (child) => SizedBox(width: _bigPlayerWidth, child: child),
                                      child: BigPlayer(),
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
