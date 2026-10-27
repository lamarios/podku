import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/states/episodes.dart';
import 'package:podku/episodes/views/components/continue_playing.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/home/views/screens/home.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/sliver_grid_delegate_with_min_cross_axis_extent.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku/utils/views/components/swite_action_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  SliverGrid buildSliverGrid(BuildContext context, List<Episode> episodes) {
    final cubit = context.read<EpisodesCubit>();

    final colors = M3ETheme.of(context).colorScheme;

    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithMinCrossAxisExtent(
        minCrossAxisExtent: EpisodeInGrid.minCrossAxisExtent,
        mainAxisExtent: EpisodeInGrid.mainAxisExtent,
        crossAxisSpacing: EpisodeInGrid.crossAxisSpacing,
        mainAxisSpacing: EpisodeInGrid.mainAxisSpacing,
      ),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final e = episodes[index];

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
                  top: pu,
                  right: pu,
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
                        style: ButtonStyle(backgroundColor: .all(colors.surface.withValues(alpha: 0.0))),
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

  SliverList buildSliverList(BuildContext context, List<Episode> episodes) {
    final cubit = context.read<EpisodesCubit>();
    final colors = M3ETheme.of(context).colorScheme;

    return SliverList.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final e = episodes[index];

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
                    (downloadStatus == null || downloadStatus.status == .canceled || downloadStatus.status == .failed))
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
      },
    );
  }

  Widget buildSectionHeader(BuildContext context, EpisodeThresholds threshold, int count) {
    final locals = AppLocalizations.of(context)!;
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;

    final title = switch (threshold) {
      .today => locals.today,
      .pastWeek => locals.pastSevenDays,
      .older => locals.older,
    };

    return Container(
      // pinned header, needs an opaque background so episodes don't show through when scrolling under it
      color: colors.surface,
      padding: .only(top: pu4, bottom: pu2),
      child: Row(
        crossAxisAlignment: .baseline,
        textBaseline: .alphabetic,
        children: [
          Text(title, style: textTheme.titleLarge),
          // older is paginated so the loaded count isn't the real total
          if (threshold != .older) ...[
            Gap(pu2),
            Text(locals.nEpisodes(count), style: textTheme.bodyMedium?.copyWith(color: colors.outline)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.of(context) == .mobile;
    final colors = M3ETheme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => EpisodesCubit(EpisodesState()),
      child: BlocBuilder<EpisodesCubit, EpisodesState>(
        builder: (context, state) {
          final hasMore = !state.loading && state.episodes.isNotEmpty && state.episodeCount % 100 == 0;
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
                  controller: context.read<EpisodesCubit>().scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: ContinuePlaying()),
                    if (state.episodes.isNotEmpty) ...[
                      for (final threshold in EpisodeThresholds.values)
                        if (state.episodes[threshold]?.isNotEmpty ?? false)
                          SliverPadding(
                            padding: .only(bottom: pu6),
                            sliver: SliverMainAxisGroup(
                              slivers: [
                                PinnedHeaderSliver(
                                  child: buildSectionHeader(context, threshold, state.episodes[threshold]!.length),
                                ),
                                isMobile
                                    ? buildSliverList(context, state.episodes[threshold]!)
                                    : buildSliverGrid(context, state.episodes[threshold]!),
                              ],
                            ),
                          ),
                      if (hasMore)
                        SliverToBoxAdapter(
                          child: Center(
                            child: TextButton(
                              child: Text(locals.loadMore),
                              onPressed: () => context.read<EpisodesCubit>().loadMore(),
                            ),
                          ),
                        ),
                    ] else if (!state.loading) ...[
                      SliverFillRemaining(
                        child: Center(
                          child: Icon(Icons.playlist_remove, size: 100, color: colors.onSurface.withValues(alpha: 0.2)),
                        ),
                      ),
                    ],
                    if (state.loading) SliverToBoxAdapter(child: Center(child: LoadingIndicator())),
                    MiniPlayer.miniPlayerPadding(),
                    HomeScreen.mobileNavigationPadding(context),
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
