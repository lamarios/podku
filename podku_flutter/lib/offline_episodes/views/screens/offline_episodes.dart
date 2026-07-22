import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';

class OfflineEpisodesScreen extends StatelessWidget {
  const OfflineEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isMobile = BreakPoint.get(context) == .mobile;
    final locals = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.downloads),
        actions: [IconButton(onPressed: () => context.push('/offline/settings'), icon: Icon(Icons.settings))],
      ),
      body: SafeArea(
        child: BlocBuilder<DownloadManagerCubit, DownloadManagerState>(
          builder: (context, state) {
            final cubit = context.read<DownloadManagerCubit>();
            return Padding(
              padding: .symmetric(horizontal: pu2),
              child: Column(
                children: [
                  state.offlineEpisodes.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Icon(Icons.download, size: 100, color: colors.onSurface.withValues(alpha: 0.2)),
                          ),
                        )
                      : Expanded(
                          child: isMobile
                              ? ListView.builder(
                                  itemCount: state.offlineEpisodes.length,
                                  itemBuilder: (context, index) {
                                    final episode = state.offlineEpisodes[index];

                                    return SwipeActionCell(
                                      key: Key('offline-episode-${episode.id.uuid}'),
                                      trailingActions: [
                                        SwipeAction(
                                          content: SwipeActionButton(
                                            color: colors.errorContainer,
                                            icon: Icon(Icons.delete),
                                          ),
                                          color: Colors.transparent,
                                          performsFirstActionWithFullSwipe: true,
                                          onTap: (handler) async {
                                            cubit.delete(episode);
                                            await handler(false);
                                          },
                                        ),
                                      ],
                                      child: EpisodeInList(episode: episode, offline: true),
                                    );
                                  },
                                )
                              : GridView.extent(
                                  maxCrossAxisExtent: EpisodeInGrid.crossAxisExtent,
                                  mainAxisExtent: EpisodeInGrid.mainAxisExtent,
                                  crossAxisSpacing: EpisodeInGrid.crossAxisSpacing,
                                  mainAxisSpacing: EpisodeInGrid.mainAxisSpacing,
                                  children: state.offlineEpisodes
                                      .map(
                                        (e) => Stack(
                                          children: [
                                            EpisodeInGrid(episode: e, offline: true),

                                            Positioned(
                                              top: pu2,
                                              right: pu8,
                                              child: MenuAnchor(
                                                animated: true,
                                                menuChildren: [
                                                  MenuItemButton(
                                                    onPressed: () async {
                                                      context.read<DownloadManagerCubit>().delete(e);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.delete),
                                                        Gap(pu),
                                                        Text('Delete downloaded file'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                builder: (context, controller, child) {
                                                  return IconButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: .all(colors.surface.withValues(alpha: 0.5)),
                                                    ),
                                                    visualDensity: .compact,
                                                    icon: Icon(Icons.more_vert, size: 17),
                                                    onPressed: () =>
                                                        controller.isOpen ? controller.close() : controller.open(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
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
