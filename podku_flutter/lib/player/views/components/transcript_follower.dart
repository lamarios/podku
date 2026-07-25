import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/transcript.dart';

class TranscriptFollower extends StatelessWidget {
  const TranscriptFollower({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranscriptCubit(TranscriptState(), playerCubit: context.read<PlayerCubit>()),
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          return BlocListener<PlayerCubit, PlayerState>(
            listenWhen: (previous, current) => previous.episode != current.episode,
            listener: (context, state) => context.read<TranscriptCubit>().setEpisode(state.episode),
            child: state.transcript.isNotEmpty && state.index != -1
                ? Text(state.transcript[state.index].content)
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
