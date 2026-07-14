import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/states/episodes.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => EpisodeCubit(EpisodeState()),
      child: BlocBuilder<EpisodeCubit, EpisodeState>(
        builder: (context, state) {
          final cubit = context.read<EpisodeCubit>();

          return MultiBlocListener(
            listeners: [
              BlocListener<HomeCubit, HomeState>(
                listenWhen: (previous, current) => current.selectedIndex == 0,
                listener: (context, state) =>
                    context.read<EpisodeCubit>().getEpisodes(refresh: true),
              ),
              BlocListener<PlayerCubit, PlayerState>(
                listenWhen: (previous, current) =>
                    previous.episode != current.episode,
                listener: (context, state) =>
                    context.read<EpisodeCubit>().getEpisodes(refresh: true),
              ),
            ],
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                if (state.episodes.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => cubit.getEpisodes(refresh: true),
                      child: Padding(
                        padding: .symmetric(horizontal: pu2),
                        child: ListView.builder(
                          itemCount:
                              state.episodes.length +
                              (state.episodes.isNotEmpty &&
                                      state.episodes.length % 100 == 0
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            final hasMore = state.episodes.length % 100 == 0;
                            final isLast = index >= state.episodes.length - 1;

                            if (index < state.episodes.length) {
                              final e = state.episodes[index];

                              return Builder(
                                builder: (context) {
                                  final downloadStatus = kIsWeb
                                      ? null
                                      : context.select(
                                          (DownloadManagerCubit c) =>
                                              c.state.downloadStatus[e.id.uuid],
                                        );
                                  return SwipeActionCell(
                                    key: Key(e.id.uuid),
                                    trailingActions:
                                        !kIsWeb &&
                                            (downloadStatus == null || downloadStatus.status == .canceled  || downloadStatus.status == .failed)
                                        ? [
                                            SwipeAction(
                                              content: SwipeActionButton(
                                                color:
                                                    colors.secondaryContainer,
                                                icon: Icon(Icons.download),
                                              ),
                                              color: Colors.transparent,
                                              onTap: (handler) async {
                                                context
                                                    .read<
                                                      DownloadManagerCubit
                                                    >()
                                                    .download(
                                                      e,
                                                      manualDownload: true,
                                                    );
                                                await handler(false);
                                              },
                                            ),
                                          ]
                                        : null,
                                    child: ConditionalWrap(
                                      wrapIf: isLast && !hasMore,
                                      wrapper: (child) => Padding(
                                        padding: .only(bottom: 200),
                                        child: child,
                                      ),
                                      child: EpisodeInList(
                                        key: ValueKey(e.id.uuid),
                                        episode: e,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Padding(
                                padding: .only(bottom: 200),
                                child: TextButton(
                                  child: Text('Load more'),
                                  onPressed: () =>
                                      context.read<EpisodeCubit>().loadMore(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  )
                else if (!state.loading) ...[
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.playlist_remove,
                        size: 100,
                        color: colors.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ],
                if (state.loading) Center(child: LoadingIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
