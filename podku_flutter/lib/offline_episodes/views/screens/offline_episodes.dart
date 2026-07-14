import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/utils.dart';

class OfflineEpisodesScreen extends StatelessWidget {
  const OfflineEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Downloads'),),
      body: SafeArea(
          child: BlocBuilder<DownloadManagerCubit, DownloadManagerState>(
            builder: (context, state) {
              return Padding(
                padding: .symmetric(horizontal: pu2),
                child: Column(
                  children: [
                    Expanded(child: ListView.builder(
                      itemCount: state.offlineEpisodes.length,
                      itemBuilder: (context, index) {
                        final episode = state.offlineEpisodes[index];

                        return EpisodeInList(episode: episode, offline: true,);
                      },))
                  ],
                ),
              );
            },)),
    );
  }
}
