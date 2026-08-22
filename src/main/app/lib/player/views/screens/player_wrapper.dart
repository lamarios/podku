import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/src/state.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/big_player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/server/views/components/offline_indicator.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';

class PlayerWrapper extends StatelessWidget {
  static final double _bigPlayerWidth = BreakPoint.mobile.maxWidth * 0.7;
  final Widget child;
  final GoRouterState routerState;

  const PlayerWrapper({super.key, required this.child, required this.routerState});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    var breakPoint = BreakPoint.of(context);
    final isMobile = breakPoint == .mobile || breakPoint == .tablet;
    final colors = M3ETheme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final connectionStatus = context.select((ServerCubit c) => c.state.status);
        final isOnline = connectionStatus == .connected;
        final hidePlayer = context.select((PlayerCubit c) => c.state.hidePlayer);
        return ErrorHandler<PlayerCubit, PlayerState>(
          showAsSnack: true,
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
                        value: !hidePlayer && showBigPlayer ? 1 : 0,
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
                      // final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
                      return SingleMotionBuilder(
                        motion: MaterialSpringMotion.expressiveSpatialDefault(),
                        value: (isOnline ? 0 : OfflineIndicator.height),
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
                        value: !hidePlayer && showMiniPlayer ? 1 : 0,
                        from: 0,
                        builder: (context, value, child) {
                          var isHome = routerState.fullPath?.startsWith("/home") ?? false;
                          return value < 0.1
                              ? SizedBox.shrink()
                              : SingleMotionBuilder(
                                  motion: MaterialSpringMotion.expressiveSpatialDefault(),
                                  value: isHome && breakPoint == .mobile ? 100 : pu2,
                                  builder: (context, bottomValue, child) {
                                    final isTablet = breakPoint == .tablet;
                                    return Positioned(
                                      left: isTablet ? 100 : pu4,
                                      right: isTablet ? 100 : pu4,
                                      bottom: lerpDouble(500, bottomValue + offlinePadding, value),
                                      child: SafeArea(
                                        child: Opacity(opacity: value.clamp(0, 1), child: MiniPlayer()),
                                      ),
                                    );
                                  },
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
        );
      },
    );
  }
}
