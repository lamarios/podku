import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/progress_indicators/m3e_progress_indicators.dart';
import 'package:material_3_expressive/components/sliders/m3e_sliders.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/scrobbling.dart';
import 'package:podku/utils.dart';

class ProgressBar extends StatelessWidget {
  final double height;
  final bool scrobblingDot;

  const ProgressBar({super.key, required this.height, this.scrobblingDot = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScrobblingCubit(ScrobblingState()),
      child: BlocBuilder<ScrobblingCubit, ScrobblingState>(
        builder: (context, scrobblingState) {
          final playerCubit = context.read<PlayerCubit>();
          final scrobblingCubit = context.read<ScrobblingCubit>();
          final playing = context.select((PlayerCubit c) => c.state.playing);
          final Duration position = context.select((PlayerCubit c) => c.state.position);
          final Duration totalDuration = context.select((PlayerCubit c) => c.state.duration);

          final totalDurationAdjusted = totalDuration.inSeconds == 0 ? 1 : totalDuration.inSeconds;
          totalDuration.inSeconds;

          var progress = position.inSeconds / totalDurationAdjusted;
          var sliderValue = scrobblingState.holding
              ? scrobblingState.holdingPosition ?? 0
              : position.inSeconds.toDouble();

          final scrobblingChapter = context.select(
            (PlayerCubit c) => c.state.episode?.chapters?.where((c) => (c.startTime ?? 0) <= (sliderValue)).lastOrNull,
          );

          return SingleMotionBuilder(
            motion: MaterialSpringMotion.expressiveEffectsDefault(),
            value: playing ? 1 : 0,
            builder: (context, value, child) {
              return scrobblingDot
                  ? M3ESlider.wavy(
                      onChangeEnd: (value) {
                        scrobblingCubit.setHolding(false);
                        playerCubit.seek(Duration(seconds: (value).toInt()));
                      },
                      value: sliderValue,
                      amplitude: value,
                      label:
                          '${printDuration(Duration(seconds: sliderValue.toInt()))}${scrobblingChapter != null ? '\n${scrobblingChapter.title}' : ''}',
                      onChanged: (double value) {
                        scrobblingCubit.setPosition(value);
                        EasyDebounce.debounce('progress-debounce', Duration(milliseconds: 500), () {
                          scrobblingCubit.setHolding(false);
                          playerCubit.seek(Duration(seconds: (value).toInt()));
                        });
                      },

                      divisions: 0,
                      dotSize: 0,
                      min: 0,
                      max: totalDuration.inSeconds.toDouble(),
                      trackThickness: pu,
                      thumbLength: pu8,
                    )
                  : M3EProgressIndicator.linearWavy(
                      value: progress.clamp(0, 1),
                      stopSize: 0,
                      strokeWidth: 3,
                      amplitude: value,
                    );
            },
          );

          /*
          return ClipRRect(
            clipBehavior: .none,
            borderRadius: .circular(height),
            child: Container(
              height: height,
              clipBehavior: .none,
              decoration: BoxDecoration(color: colors.surfaceDim, borderRadius: .circular(height)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final scrobblingPositionSeconds =
                      (((scrobblingState.holdingPosition ?? 0) / constraints.maxWidth) * totalDuration.inSeconds)
                          .round();

                  final scrobblingChapter = context.select(
                    (PlayerCubit c) => c.state.episode?.chapters
                        ?.where((c) => (c.startTime ?? 0) <= (scrobblingPositionSeconds))
                        .lastOrNull,
                  );
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
                      alignment: .center,
                      clipBehavior: .none,
                      children: [
                        Align(
                          alignment: .centerLeft,
                          child: AnimatedFractionallySizedBox(
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
                        ),
                        Align(
                          alignment: .centerLeft,
                          child: AnimatedFractionallySizedBox(
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

                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: .circular(scrobbleSize),
                                ),
                              ),
                            ),
                          ),
                        if (scrobblingDot)
                          Positioned(
                            bottom: height + 20,
                            child: SingleMotionBuilder(
                              from: 0,
                              motion: MaterialSpringMotion.expressiveSpatialDefault(),
                              value: scrobblingState.holdingPosition != null ? 1 : 0,
                              builder: (context, value, child) => Opacity(
                                opacity: value.clamp(0, 1),
                                child: Transform.translate(
                                  offset: Offset(0, lerpDouble(20, 0, value) ?? 1),
                                  child: value < 0.1 ? SizedBox.shrink() : child,
                                ),
                              ),
                              child: Container(
                                padding: .symmetric(horizontal: pu2, vertical: pu),
                                */
          /*
                                      constraints: BoxConstraints(
                                        minWidth: 70,
                                        minHeight: 20,
                                        // maxWidth: 300,
                                        // maxHeight: 50,
                                      ),
                            */ /*

                                alignment: .center,
                                decoration: BoxDecoration(color: colors.surface, borderRadius: .circular(pu)),
                                child: scrobblingState.holdingPosition == null
                                    ? SizedBox(width: 50, height: 20)
                                    : Column(
                                        mainAxisSize: .min,
                                        crossAxisAlignment: .center,
                                        children: [
                                          Text(printDuration(Duration(seconds: scrobblingPositionSeconds))),
                                          if (scrobblingChapter != null) Text(scrobblingChapter.title ?? ''),
                                        ],
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
    */
        },
      ),
    );
  }
}
