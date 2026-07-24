import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/states/podcast.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/description.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku_client/podku_client.dart';

class PodcastScreen extends StatelessWidget {
  final String? podcastId;
  final SearchResult? searchResult;

  const PodcastScreen({super.key, this.podcastId, this.searchResult});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isMobile = BreakPoint.get(context) == .mobile;

    var podcastCubit = PodcastCubit(
      PodcastState(),
      podcastId: podcastId,
      searchResult: searchResult,
      playerCubit: context.read<PlayerCubit>(),
    );

    var brightnessOf = Theme.brightnessOf(context);
    return podcastId != null || searchResult != null
        ? MultiBlocProvider(
            key: ValueKey(brightnessOf),
            providers: [
              BlocProvider(
                create: (context) {
                  return podcastCubit;
                },
              ),
              BlocProvider(
                create: (context) => PodcastImageColorCubit(
                  PodcastImageColorState(scaffoldColor: colors.secondaryContainer, colorScheme: colors),
                  podcast: podcastCubit.state.podcast,
                  brightness: brightnessOf,
                  fallBackColorScheme: colors,
                ),
              ),
            ],
            child: BlocConsumer<PodcastCubit, PodcastState>(
              listener: (context, state) => context.read<PodcastImageColorCubit>().setPodcast(state.podcast),
              listenWhen: (previous, current) => previous.podcast != current.podcast,
              builder: (context, state) {
                final scaffoldColor = context.select((PodcastImageColorCubit c) => c.state.scaffoldColor);
                final colorScheme = context.select((PodcastImageColorCubit c) => c.state.colorScheme);
                final colorInitialized = context.select((PodcastImageColorCubit c) => c.state.initialized);
                final podcastColorCubit = context.read<PodcastImageColorCubit>();

                var isLoading = state.loading || state.podcast == null || !colorInitialized;
                return ErrorHandler<PodcastCubit, PodcastState>(
                  showAsSnack: true,
                  child: AnimatedTheme(
                    duration: animationDuration,
                    data: Theme.of(context).copyWith(colorScheme: colorScheme),
                    child: Container(
                      color: isLoading ? colorScheme.surface : scaffoldColor,
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(state.podcast?.name ?? ''),
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.red,
                        ),
                        backgroundColor: Colors.transparent,
                        body: SafeArea(
                          bottom: false,
                          child: CustomScrollView(
                            controller: podcastColorCubit.scrollController,
                            shrinkWrap: isLoading,
                            physics: isLoading ? NeverScrollableScrollPhysics() : null,
                            slivers: [
                              if (isLoading)
                                SliverFillRemaining(hasScrollBody: false, child: Center(child: LoadingIndicator())),
                              if (state.podcast != null) ...[
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _PodcastHeader(
                                    podcast: state.podcast!,
                                    subscribing: state.subscribing,
                                    subscribed: state.subscribed,
                                    maxExtent: isMobile ? 450 : 225,
                                  ),
                                ),
                                if (state.podcast?.episodes != null)
                                  DecoratedSliver(
                                    decoration: BoxDecoration(color: colorScheme.surface),
                                    sliver: isMobile
                                        ? SliverList.builder(
                                            itemCount: state.podcast!.episodes!.length,
                                            itemBuilder: (context, index) => ConditionalWrap(
                                              wrapIf: index == state.podcast!.episodes!.length - 1,
                                              wrapper: (child) => Padding(padding: .only(bottom: 200), child: child),
                                              child: EpisodeInList(
                                                episode: state.podcast!.episodes![index],
                                                offline: !state.subscribed,
                                                // we set that as we're not going to track progress on unsubbed podcast episodes
                                                showPodcastImage: false,
                                              ),
                                            ),
                                          )
                                        : SliverPadding(
                                            padding: .only(top: pu4),
                                            sliver: SliverGrid.extent(
                                              maxCrossAxisExtent: EpisodeInGrid.crossAxisExtent,
                                              childAspectRatio:
                                                  (EpisodeInGrid.crossAxisExtent * 0.8) / EpisodeInGrid.crossAxisExtent,
                                              // mainAxisExtent: EpisodeInGrid.mainAxisExtent,
                                              crossAxisSpacing: EpisodeInGrid.crossAxisSpacing,
                                              mainAxisSpacing: EpisodeInGrid.mainAxisSpacing,
                                              children:
                                                  state.podcast?.episodes
                                                      ?.map((e) => EpisodeInGrid(episode: e, showPodcastImage: false))
                                                      .toList() ??
                                                  [],
                                            ),
                                          ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : SizedBox.shrink();
  }
}

class _PodcastHeader extends SliverPersistentHeaderDelegate {
  final Podcast podcast;
  final bool subscribing;
  final bool subscribed;
  @override
  final double maxExtent;
  static const double _minImageSize = 0;

  const _PodcastHeader({
    required this.podcast,
    required this.subscribing,
    required this.subscribed,
    required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // t goes 0 -> 1 as the header collapses
    final isMobile = BreakPoint.get(context) == .mobile;
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final imageSize = lerpDouble(isMobile ? 200 : 150, _minImageSize, (t * 1).clamp(0, 1))!;
    final opacity = (1 - t * 1.25).clamp(0.0, 1.0); // fades out in the first half
    if (isMobile) {
      return Opacity(
        opacity: opacity,
        child: Column(
          children: [
            Center(
              child: PodcastImage(podcast: podcast, width: imageSize, height: imageSize, borderRadius: pu4),
            ),
            if (podcast.description != null) ...[
              Gap(pu2),
              Expanded(
                child: Padding(
                  padding: .symmetric(horizontal: pu2),
                  child: SingleChildScrollView(child: HtmlDescription(podcast: podcast, offline: false)),
                ),
              ),
            ],
            if (t < 0.05) ...[
              Gap(pu2),
              _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
            ],
          ],
        ),
      );
    } else {
      return Opacity(
        opacity: opacity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Gap(pu4),
                Center(
                  child: PodcastImage(podcast: podcast, width: imageSize, height: imageSize, borderRadius: pu4),
                ),
                Gap(pu4),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        if (podcast.description != null) ...[
                          Gap(pu2),
                          Padding(
                            padding: .symmetric(horizontal: pu2),
                            child: HtmlWidget(podcast.description!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (t < 0.05) ...[
              Gap(pu2),
              _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
            ],
          ],
        ),
      );
    }
  }

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant _PodcastHeader oldDelegate) {
    return oldDelegate.podcast != podcast;
  }
}

class _SubscribeButton extends StatelessWidget {
  final Podcast podcast;
  final bool subscribing;
  final bool subscribed;

  const _SubscribeButton({required this.podcast, required this.subscribing, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;

    final cubit = context.read<PodcastCubit>();
    return Padding(
      padding: .symmetric(horizontal: pu2),
      child: Row(
        mainAxisAlignment: .end,
        children: [
          TextButton.icon(
            onPressed: subscribing
                ? null
                : () async {
                    if (subscribed) {
                      cubit.unsubscribe();
                    } else {
                      cubit.subscribe();
                    }
                  },
            label: Text(
              subscribed ? locals.unsubscribe : locals.subscribe,
              style: textTheme.bodyMedium!.copyWith(color: subscribed ? colors.error : colors.primary),
            ),
            icon: Icon(
              subscribed ? Icons.block : Icons.check_box_outline_blank_outlined,
              color: subscribed ? colors.error : colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
