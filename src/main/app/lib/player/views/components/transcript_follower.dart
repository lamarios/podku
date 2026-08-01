import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/transcript.dart';
import 'package:podku/utils.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class TranscriptFollower extends StatelessWidget {
  const TranscriptFollower({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranscriptCubit(TranscriptState(), playerCubit: context.read<PlayerCubit>()),
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          final cubit = context.read<TranscriptCubit>();
          final transcript = context.select((TranscriptCubit c) => c.state.transcript);
          return BlocListener<PlayerCubit, PlayerState>(
            listenWhen: (previous, current) => previous.episode != current.episode,
            listener: (context, state) => context.read<TranscriptCubit>().setEpisode(state.episode),
            child: transcript.isEmpty || state.index == -1 || state.loading
                ? Center(child: LoadingIndicator())
                : Padding(
                    padding: .symmetric(horizontal: pu8),
                    child: ListViewObserver(
                      controller: cubit.observerController,
                      child: ListView.builder(
                        controller: cubit.scrollController,
                        itemCount: state.transcript.length,
                        itemBuilder: (context, index) =>
                            _TranscriptLine(line: state.transcript[index], lineIndex: index, currentIndex: state.index),
                      ),
                    ),
                  ),
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
    final textTheme = M3ETheme.of(context).textTheme;
    return Padding(
      padding: .symmetric(vertical: pu2),
      child: SingleMotionBuilder(
        motion: MaterialSpringMotion.expressiveEffectsDefault(),
        from: 0,
        value: currentIndex == lineIndex
            ? 1
            : currentIndex > lineIndex
            ? 0
            : 0.5,
        builder: (context, value, child) => Opacity(
          opacity: value.clamp(0.2, 1),
          child: Text('${line.speaker != null ? '${line.speaker}: ' : ''}${line.content}', style: textTheme.bodyLarge),
        ),
      ),
    );
  }
}
