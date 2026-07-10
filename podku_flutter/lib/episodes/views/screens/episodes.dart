import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_flutter/episodes/states/episodes.dart';
import 'package:podku_flutter/episodes/views/components/episode_in_list.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpisodeCubit(EpisodeState()),
      child: BlocBuilder<EpisodeCubit, EpisodeState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.episodes.length,
            itemBuilder: (context, index) {
              final e = state.episodes[index];

              return EpisodeInList(key: ValueKey(e.id.uuid), episode: e);
            },
          );
        },
      ),
    );
  }
}
