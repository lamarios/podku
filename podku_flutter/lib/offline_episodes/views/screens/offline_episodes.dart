import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';

class OfflineEpisodesScreen extends StatelessWidget {
  const OfflineEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: SafeArea(
        child: BlocBuilder<DownloadManagerCubit, DownloadManagerState>(
          builder: (context, state) {
            final cubit = context.read<DownloadManagerCubit>();
            return Padding(
              padding: .symmetric(horizontal: pu2),
              child: Column(
                children: [
                state.offlineEpisodes.isEmpty ?
                    Expanded(
                      child: Center(
                        child: Icon(
                          Icons.download,
                          size: 100,
                          color: colors.onSurface.withValues(alpha: 0.2),
                        ),
                      ),
                    )
                    :  Expanded(
                    child: ListView.builder(
                      itemCount: state.offlineEpisodes.length,
                      itemBuilder: (context, index) {
                        final episode = state.offlineEpisodes[index];

                        return SwipeActionCell(
                          key: Key(episode.id.uuid),
                          trailingActions: [
                            SwipeAction(
                              content: SwipeActionButton(color: colors.errorContainer, icon: Icon(Icons.delete)),
                              color: Colors.transparent,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (handler) async {
                                cubit.delete(episode);
                                await handler(true);
                              },
                            ),
                          ],
                          child: EpisodeInList(
                            episode: episode,
                            offline: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
