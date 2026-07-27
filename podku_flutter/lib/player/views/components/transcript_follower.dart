import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/transcript.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

class TranscriptFollower extends StatelessWidget {
  const TranscriptFollower({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranscriptCubit(TranscriptState(), playerCubit: context.read<PlayerCubit>()),
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          final transcript = context.select((TranscriptCubit c) => c.state.transcript);
          return BlocListener<PlayerCubit, PlayerState>(
            listenWhen: (previous, current) => previous.episode != current.episode,
            listener: (context, state) => context.read<TranscriptCubit>().setEpisode(state.episode),
            child: transcript.isNotEmpty && state.index != -1
                ? state.loading
                      ? Center(child: LoadingIndicator())
                      : Padding(
                          padding: .symmetric(horizontal: pu2),
                          child: Column(
                            crossAxisAlignment: .stretch,
                            mainAxisAlignment: .center,
                            spacing: pu2,
                            children: [
                              if (state.index > 0)
                                _TranscriptLine(
                                  line: state.transcript[state.index - 1],
                                  lineIndex: state.index - 1,
                                  currentIndex: state.index,
                                ),
                              _TranscriptLine(
                                line: state.transcript[state.index],
                                lineIndex: state.index,
                                currentIndex: state.index,
                              ),
                              if (state.index < state.transcript.length + 1)
                                _TranscriptLine(
                                  line: state.transcript[state.index + 1],
                                  lineIndex: state.index + 1,
                                  currentIndex: state.index,
                                ),
                            ],
                          ),
                        )
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _TranscriptLine extends StatelessWidget {
  final int lineIndex;
  final int currentIndex;
  final EpisodeTranscript line;

  const _TranscriptLine({required this.line, required this.lineIndex, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Text(
      '${line.speaker != null ? '${line.speaker}: ' : ''}${line.content}',
      style: textTheme.bodyMedium?.copyWith(
        color: currentIndex < lineIndex
            ? colors.onSurface.withValues(alpha: 0.7)
            : currentIndex > lineIndex
            ? colors.onSurface.withValues(alpha: 0.2)
            : colors.primary,
      ),
    );
  }
}
