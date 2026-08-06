import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/states/episodes.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  SliverGrid buildSliverGrid(BuildContext context) {
    final cubit = context.read<EpisodesCubit>();
    final state = cubit.state;

    final colors = M3ETheme.of(context).colorScheme;

    var hasMore = !state.loading && state.episodes.isNotEmpty && state.episodes.length % 100 == 0;

    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: EpisodeInGrid.crossAxisExtent,
        mainAxisExtent: EpisodeInGrid.mainAxisExtent,
        crossAxisSpacing: EpisodeInGrid.crossAxisSpacing,
        mainAxisSpacing: EpisodeInGrid.mainAxisSpacing,
      ),
      itemCount: state.episodes.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasMore && index == state.episodes.length) {
          return Center(
            child: TextButton(child: Text('Load more'), onPressed: () => context.read<EpisodesCubit>().loadMore()),
          );
        }

        final e = state.episodes[index];

        return Builder(
          key: ValueKey(e),
          builder: (context) {
            final downloadStatus = kIsWeb
                ? null
                : context.select((DownloadManagerCubit c) => c.state.downloadStatus[e.id]);

            final showDownloadButton =
                kIsWeb ||
                (!kIsWeb &&
                    (downloadStatus == null || downloadStatus.status == .canceled || downloadStatus.status == .failed));
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
                            if (kIsWeb) {
                              launchUrl(Uri.parse(e.audioUrl ?? ''));
                            } else {
                              context.read<DownloadManagerCubit>().download(e, manualDownload: true);
                            }
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
      },
    );
  }

  SliverList buildSliverList(BuildContext context) {
    final cubit = context.read<EpisodesCubit>();
    final state = cubit.state;
    final colors = M3ETheme.of(context).colorScheme;

    var hasMore = !state.loading && state.episodes.isNotEmpty && state.episodes.length % 100 == 0;

    return SliverList.builder(
      itemCount: state.episodes.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.episodes.length) {
          final e = state.episodes[index];

          return Builder(
            builder: (context) {
              final downloadStatus = kIsWeb
                  ? null
                  : context.select((DownloadManagerCubit c) => c.state.downloadStatus[e.id]);
              return SwipeActionCell(
                key: ValueKey(e),
                trailingActions: [
                  if (kIsWeb)
                    SwipeAction(
                      content: SwipeActionButton(color: colors.secondaryContainer, icon: Icon(Icons.download)),
                      color: Colors.transparent,
                      onTap: (handler) async {
                        launchUrl(Uri.parse(e.audioUrl ?? ''));
                        await handler(false);
                      },
                    ),
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
                child: EpisodeInList(key: ValueKey(e.id), episode: e),
              );
            },
          );
        } else {
          return TextButton(child: Text('Load more'), onPressed: () => context.read<EpisodesCubit>().loadMore());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.of(context) == .mobile;
    final colors = M3ETheme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => EpisodesCubit(EpisodesState()),
      child: BlocBuilder<EpisodesCubit, EpisodesState>(
        builder: (context, state) {
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
              child: RefreshIndicator(
                onRefresh: () => context.read<EpisodesCubit>().getEpisodes(refresh: true),
                child: CustomScrollView(
                  slivers: [
                    if (state.episodes.isNotEmpty)
                      isMobile ? buildSliverList(context) : buildSliverGrid(context)
                    else if (!state.loading) ...[
                      SliverFillRemaining(
                        child: Center(
                          child: Icon(Icons.playlist_remove, size: 100, color: colors.onSurface.withValues(alpha: 0.2)),
                        ),
                      ),
                    ],
                    if (state.loading) SliverToBoxAdapter(child: Center(child: LoadingIndicator())),
                    MiniPlayer.miniPlayerPadding(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
