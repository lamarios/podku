import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/scrobbling.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';

class ProgressBar extends StatelessWidget {
  final double height;
  final bool scrobblingDot;

  const ProgressBar({super.key, required this.height, this.scrobblingDot = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scrobbleSize = height * 1.5;

    return BlocProvider(
      create: (context) => ScrobblingCubit(ScrobblingState()),
      child: BlocBuilder<ScrobblingCubit, ScrobblingState>(
        builder: (context, scrobblingState) {
          final playerCubit = context.read<PlayerCubit>();
          final scrobblingCubit = context.read<ScrobblingCubit>();

          final Duration position = context.select((PlayerCubit c) => c.state.position);
          final Duration bufferPosition = context.select((PlayerCubit c) => c.state.bufferPosition);
          final Duration totalDuration = context.select((PlayerCubit c) => c.state.duration);

          final totalDurationAdjusted = totalDuration.inSeconds == 0 ? 1 : totalDuration.inSeconds;
          totalDuration.inSeconds;

          var progress = position.inSeconds / totalDurationAdjusted;
          return ClipRRect(
            clipBehavior: .none,
            borderRadius: .circular(height),
            child: Container(
              height: height,
              clipBehavior: .none,
              decoration: BoxDecoration(color: colors.surfaceDim, borderRadius: .circular(height)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConditionalWrap(
                    wrapIf: scrobblingDot,
                    wrapper: (child) => GestureDetector(
                      onHorizontalDragStart: (details) =>
                          scrobblingCubit.startDragging(playerCubit, details, constraints),
                      onHorizontalDragUpdate: (details) =>
                          scrobblingCubit.dragUpdate(playerCubit, details, constraints),
                      onHorizontalDragEnd: (details) =>
                          scrobblingCubit.dragEnd(playerCubit, details.localPosition, constraints),
                      onTapUp: (details) => scrobblingCubit.dragEnd(playerCubit, details.localPosition, constraints),
                      dragStartBehavior: .down,
                      behavior: .translucent,
                      child: child,
                    ),
                    child: Stack(
                      alignment: .centerLeft,
                      clipBehavior: .none,
                      children: [
                        AnimatedFractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: bufferPosition.inSeconds / totalDurationAdjusted,
                          duration: animationDuration,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: .circular(height),
                              color: colors.secondaryContainer.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        AnimatedFractionallySizedBox(
                          widthFactor: progress,
                          heightFactor: 1,
                          duration: animationDuration,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: .circular(height),
                              color: colors.onSecondaryContainer,
                            ),
                          ),
                        ),
                        if (scrobblingDot)
                          Positioned(
                            left:
                                (scrobblingState.holdingPosition ?? (constraints.maxWidth * progress)) -
                                (scrobbleSize / 2),
                            child: GestureDetector(
                              child: Container(
                                height: scrobbleSize,
                                width: scrobbleSize,

                                decoration: BoxDecoration(color: colors.primary, borderRadius: .circular(scrobbleSize)),
                              ),
                            ),
                          ),
                        if (scrobblingDot)
                          Positioned(
                            left: (scrobblingState.holdingPosition ?? 0) - 35,
                            bottom: height + 20,
                            child: SingleMotionBuilder(
                              from: 0,
                              motion: MaterialSpringMotion.expressiveSpatialDefault(),
                              value: scrobblingState.holdingPosition != null ? 1 : 0,
                              builder: (context, value, child) => Opacity(
                                opacity: value.clamp(0, 1),
                                child: Transform.translate(
                                  offset: Offset(0, lerpDouble(20, 0, value) ?? 1),
                                  child: child,
                                ),
                              ),
                              child: scrobblingState.holdingPosition == null
                                  ? SizedBox.shrink()
                                  : Container(
                                      width: 70,
                                      height: 20,
                                      alignment: .center,
                                      decoration: BoxDecoration(color: colors.surface, borderRadius: .circular(pu)),
                                      child: Text(
                                        printDuration(
                                          Duration(
                                            seconds:
                                                (((scrobblingState.holdingPosition ?? 0) / constraints.maxWidth) *
                                                        totalDuration.inSeconds)
                                                    .round(),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
