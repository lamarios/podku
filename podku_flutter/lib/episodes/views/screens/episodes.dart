import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/states/episodes.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.get(context) == .mobile;
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => EpisodesCubit(EpisodesState()),
      child: BlocBuilder<EpisodesCubit, EpisodesState>(
        builder: (context, state) {
          final cubit = context.read<EpisodesCubit>();

          return MultiBlocListener(
            listeners: [
              BlocListener<HomeCubit, HomeState>(
                listenWhen: (previous, current) => current.selectedIndex == 0,
                listener: (context, state) => context.read<EpisodesCubit>().getEpisodes(refresh: true),
              ),
              BlocListener<PlayerCubit, PlayerState>(
                listenWhen: (previous, current) => previous.episode != current.episode,
                listener: (context, state) => context.read<EpisodesCubit>().getEpisodes(refresh: true),
              ),
            ],
            child: ErrorHandler<EpisodesCubit, EpisodesState>(
              showAsSnack: true,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  if (state.episodes.isNotEmpty)
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => cubit.getEpisodes(refresh: true),
                        child: Padding(
                          padding: .symmetric(horizontal: pu2),
                          child: isMobile
                              ? _EpisodeList(state: state, cubit: cubit)
                              : _EpisodeGrid(state: state, cubit: cubit),
                        ),
                      ),
                    )
                  else if (!state.loading) ...[
                    Expanded(
                      child: Center(
                        child: Icon(Icons.playlist_remove, size: 100, color: colors.onSurface.withValues(alpha: 0.2)),
                      ),
                    ),
                  ],
                  if (state.loading) Center(child: LoadingIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EpisodeGrid extends StatelessWidget {
  final EpisodesState state;
  final EpisodesCubit cubit;

  const _EpisodeGrid({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final colors = Theme.of(context).colorScheme;

    children.addAll(
      state.episodes.map((e) {
        return Builder(
          key: ValueKey(e),
          builder: (context) {
            final downloadStatus = kIsWeb
                ? null
                : context.select((DownloadManagerCubit c) => c.state.downloadStatus[e.id.uuid]);

            final showDownloadButton =
                !kIsWeb &&
                (downloadStatus == null || downloadStatus.status == .canceled || downloadStatus.status == .failed);

            return Stack(
              children: [
                EpisodeInGrid(episode: e),
                Positioned(
                  top: pu2,
                  right: pu8,
                  child: MenuAnchor(
                    animated: true,
                    menuChildren: [
                      if (showDownloadButton)
                        MenuItemButton(
                          onPressed: () async {
                            context.read<DownloadManagerCubit>().download(e, manualDownload: true);
                          },
                          child: Row(children: [Icon(Icons.download), Gap(pu), Text('Download')]),
                        ),
                      MenuItemButton(
                        onPressed: () async {
                          cubit.markEpisodeAsPlayed(e);
                        },
                        child: Row(children: [Icon(Icons.check), Gap(pu), Text('Mark as played')]),
                      ),
                    ],
                    builder: (context, controller, child) {
                      return IconButton(
                        style: ButtonStyle(backgroundColor: .all(colors.surface.withValues(alpha: 0.5))),
                        visualDensity: .compact,
                        icon: Icon(Icons.more_vert, size: 17),
                        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );

    if (state.episodes.isNotEmpty && state.episodes.length % 100 == 0) {
      children.add(
        Center(
          child: TextButton(child: Text('Load more'), onPressed: () => context.read<EpisodesCubit>().loadMore()),
        ),
      );
    }

    return GridView.extent(
      maxCrossAxisExtent: EpisodeInGrid.crossAxisExtent,
      mainAxisExtent: EpisodeInGrid.mainAxisExtent,
      crossAxisSpacing: EpisodeInGrid.crossAxisSpacing,
      mainAxisSpacing: EpisodeInGrid.mainAxisSpacing,
      children: children,
    );
  }
}

class _EpisodeList extends StatelessWidget {
  final EpisodesState state;
  final EpisodesCubit cubit;

  const _EpisodeList({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: state.episodes.length + (state.episodes.isNotEmpty && state.episodes.length % 100 == 0 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.episodes.length) {
          final e = state.episodes[index];

          return Builder(
            builder: (context) {
              final downloadStatus = kIsWeb
                  ? null
                  : context.select((DownloadManagerCubit c) => c.state.downloadStatus[e.id.uuid]);
              return SwipeActionCell(
                key: ValueKey(e),
                trailingActions: [
                  if (!kIsWeb &&
                      (downloadStatus == null ||
                          downloadStatus.status == .canceled ||
                          downloadStatus.status == .failed))
                    SwipeAction(
                      content: SwipeActionButton(color: colors.secondaryContainer, icon: Icon(Icons.download)),
                      color: Colors.transparent,
                      onTap: (handler) async {
                        context.read<DownloadManagerCubit>().download(e, manualDownload: true);
                        await handler(false);
                      },
                    ),
                  SwipeAction(
                    content: SwipeActionButton(color: colors.primaryContainer, icon: Icon(Icons.check)),
                    color: Colors.transparent,
                    onTap: (handler) async {
                      await cubit.markEpisodeAsPlayed(e);
                      await handler(false);
                    },
                  ),
                ],
                child: EpisodeInList(key: ValueKey(e.id.uuid), episode: e),
              );
            },
          );
        } else {
          return TextButton(child: Text('Load more'), onPressed: () => context.read<EpisodesCubit>().loadMore());
        }
      },
    );
  }
}
