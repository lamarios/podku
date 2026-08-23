import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/cards/m3e_cards.dart';
import 'package:material_3_expressive/components/icon_buttons/m3e_icon_buttons.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/colors.dart';
import 'package:podku/utils/duration_utils.dart';
import 'package:podku/utils/states/simple_cubit.dart';
import 'package:podku/utils/views/components/simple_cubit.dart';

class ResultTranscript extends StatelessWidget {
  final EpisodeSearchResult result;

  const ResultTranscript({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.matchedTranscripts?.isEmpty ?? true) {
      return SizedBox.shrink();
    }

    final colors = M3ETheme.of(context).colorScheme;

    var cardColor = Theme.brightnessOf(context) == .dark
        ? darken(colors.secondaryContainer, 0.5)
        : lighten(colors.secondaryContainer, 0.5);
    final textTheme = Theme.of(context).textTheme;
    final locals = AppLocalizations.of(context)!;

    return SimpleCubitView<bool>(
      initialValue: false,
      builder: (context, expanded) {
        return SingleMotionBuilder(
          motion: MaterialSpringMotion.expressiveSpatialFast(),
          value: (expanded ?? false) ? 1 : 0,
          builder: (context, value, child) {
            return Row(
              spacing: pu,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: .all(pu2),
                  child: Column(
                    spacing: pu2,
                    children: [
                      Icon(M3EIcons.comment_outlined, size: 20, color: colors.secondary),
                      SizedBox(
                        height: lerpDouble(0, 200, max(0, value)),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            locals.fromTranscript,
                            maxLines: 1,
                            overflow: .fade,
                            textAlign: .end,
                            style: textTheme.labelMedium?.copyWith(
                              color: Color.lerp(colors.secondary.withValues(alpha: 0), colors.secondary, max(0, value)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: M3ECard(
                    padding: .zero,
                    color: cardColor,
                    elevation: lerpDouble(1, 4, max(0, value)),
                    child: SizedBox(
                      height: lerpDouble(60, 300, value),
                      child: Stack(
                        clipBehavior: .none,
                        children: [
                          Padding(
                            padding: .symmetric(horizontal: pu),
                            child: ListView.builder(
                              itemCount: result.matchedTranscripts?.length ?? 0,
                              physics: !expanded! ? NeverScrollableScrollPhysics() : null,
                              itemBuilder: (context, index) => Padding(
                                padding: .only(bottom: index == result.matchedTranscripts!.length - 1 ? 50 : 0),
                                child: _TranscriptLine(
                                  line: result.matchedTranscripts![index],
                                  episode: result.episode!,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [cardColor, cardColor.withValues(alpha: 0)],
                                  stops: [0.1, 1],
                                  begin: .bottomCenter,
                                  end: .topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: lerpDouble(0, pi, value)!,
                              child: M3EIconButton(
                                icon: Icon(M3EIcons.expand_more),
                                size: .xs,
                                variant: .tonal,
                                onPressed: () => context.read<SimpleCubit<bool>>().set(!expanded),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _TranscriptLine extends StatelessWidget {
  final Episode episode;
  final EpisodeTranscript line;

  const _TranscriptLine({required this.line, required this.episode});

  RichText buildHighlightedText(BuildContext context, {TextStyle? baseStyle, TextStyle? highlightStyle}) {
    final parts = line.highlightedContent?.split('§') ?? [];
    return RichText(
      text: TextSpan(
        style: baseStyle ?? DefaultTextStyle.of(context).style,
        children: [
          for (var i = 0; i < parts.length; i++) TextSpan(text: parts[i], style: i.isOdd ? highlightStyle : null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = parseDuration(line.startTime ?? '00:00:00.000');
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: .start,
      children: [
        M3EButton.icon(
          onPressed: () => context.read<PlayerCubit>().playEpisode(episode, initialPosition: duration - 5.seconds),
          icon: Icon(M3EIcons.play_arrow),
          label: Text(roundTranscriptDuration(line.startTime ?? '')),
          style: .text,
          size: .xs,
          decoration: M3EButtonDecoration(padding: .only(right: pu2)),
        ),
        Expanded(
          child: Padding(
            padding: .only(top: pu3),
            child: buildHighlightedText(
              context,
              highlightStyle: textTheme.bodyMedium?.copyWith(color: colors.tertiary),
              baseStyle: textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
