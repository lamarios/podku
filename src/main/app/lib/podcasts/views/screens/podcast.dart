import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/states/podcast.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';
import 'package:podku/podcasts/views/components/podcast_episode.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/description.dart';
import 'package:podku/utils/views/components/error_listener.dart';

class PodcastScreen extends StatelessWidget {
  final String? podcastId;
  final SearchResult? searchResult;

  const PodcastScreen({super.key, this.podcastId, this.searchResult});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;

    var breakPoint = BreakPoint.of(context);
    final isDesktop = breakPoint == .desktop || breakPoint == .bigDesktop;

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
              listener: (context, state) => context.read<PodcastImageColorCubit>().setPodcast(podcast: state.podcast),
              listenWhen: (previous, current) => previous.podcast != current.podcast,
              builder: (context, state) {
                final scaffoldColor = context.select((PodcastImageColorCubit c) => c.state.scaffoldColor);
                final colorScheme = context.select((PodcastImageColorCubit c) => c.state.colorScheme);
                final colorInitialized = context.select((PodcastImageColorCubit c) => c.state.initialized);
                final podcastColorCubit = context.read<PodcastImageColorCubit>();

                var isLoading = state.loading || state.podcast == null || !colorInitialized;
                return ErrorHandler<PodcastCubit, PodcastState>(
                  showAsSnack: true,
                  child: M3ETheme(
                    data: M3ETheme.of(context).copyWith(colorScheme: colorScheme),
                    child: Container(
                      color: isLoading || isDesktop ? colorScheme.surface : scaffoldColor,
                      child: Scaffold(
                        appBar: M3EAppBar.top(
                          title: Text(state.podcast?.name ?? ''),
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: true,
                        ),
                        backgroundColor: Colors.transparent,
                        body: SafeArea(
                          bottom: false,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ConditionalWrap(
                                wrapIf: isDesktop,
                                wrapper: (child) => Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 1100),
                                    child: Row(
                                      crossAxisAlignment: .start,
                                      mainAxisAlignment: .center,
                                      children: [
                                        if (!state.loading)
                                          Align(
                                            alignment: .topCenter,
                                            child: _VerticalPodcastHeader(
                                              podcast: state.podcast!,
                                              subscribing: state.subscribing,
                                              subscribed: state.subscribed,
                                            ),
                                          ),
                                        Expanded(child: child),
                                      ],
                                    ),
                                  ),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double maxContentWidth = min(constraints.maxWidth, switch (breakPoint) {
                                      .desktop => 800,
                                      .bigDesktop => 1000,
                                      _ => 640,
                                    });

                                    return Align(
                                      alignment: isDesktop ? .topLeft : .topCenter,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                                        child: CustomScrollView(
                                          controller: podcastColorCubit.scrollController,
                                          shrinkWrap: isLoading,
                                          physics: isLoading ? NeverScrollableScrollPhysics() : null,
                                          slivers: [
                                            if (isLoading)
                                              SliverFillRemaining(
                                                hasScrollBody: false,
                                                child: Center(child: LoadingIndicator()),
                                              ),
                                            if (state.podcast != null) ...[
                                              if (!isDesktop)
                                                SliverToBoxAdapter(
                                                  child: _PodcastHeader(
                                                    podcast: state.podcast!,
                                                    subscribing: state.subscribing,
                                                    subscribed: state.subscribed,
                                                    // maxExtent: isMobile ? 450 : 255,
                                                  ),
                                                ),
                                              /*
                                                SliverPersistentHeader(
                                                  pinned: true,
                                                  delegate: _PodcastHeader(
                                                    podcast: state.podcast!,
                                                    subscribing: state.subscribing,
                                                    subscribed: state.subscribed,
                                                    maxExtent: isMobile ? 450 : 255,
                                                  ),
                                                ),
*/
                                              if (state.podcast?.episodes != null)
                                                DecoratedSliver(
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.surface,
                                                    borderRadius: .only(
                                                      topLeft: .circular(pu4),
                                                      topRight: .circular(pu4),
                                                    ),
                                                  ),
                                                  sliver: SliverList.separated(
                                                    separatorBuilder: (context, index) => Padding(
                                                      padding: .symmetric(horizontal: pu6),
                                                      child: Divider(),
                                                    ),
                                                    itemCount: state.podcast!.episodes!.length,
                                                    itemBuilder: (context, index) => ConditionalWrap(
                                                      wrapIf: index == state.podcast!.episodes!.length - 1,
                                                      wrapper: (child) =>
                                                          Padding(padding: .only(bottom: 200), child: child),
                                                      child: Padding(
                                                        padding: .symmetric(vertical: pu2, horizontal: pu6),
                                                        child: PodcastEpisode(
                                                          episode: state.podcast!.episodes![index],
                                                          // offline: !state.subscribed,
                                                          // we set that as we're not going to track progress on unsubbed podcast episodes
                                                          showPodcastImage: false,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                            SliverFillRemaining(child: Container(color: colorScheme.surface)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
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

class _PodcastHeader extends StatelessWidget {
  final Podcast podcast;
  final bool subscribing;
  final bool subscribed;
  static const double _imageSize = 200;

  const _PodcastHeader({
    required this.podcast,
    required this.subscribing,
    required this.subscribed,
    // required this.maxExtent,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.of(context) == .mobile;
    final double opacity = 1; // fades out in the first half
    if (isMobile) {
      return Opacity(
        opacity: opacity,
        child: Column(
          children: [
            Center(
              child: PodcastImage(podcast: podcast, width: _imageSize, height: _imageSize, borderRadius: pu4),
            ),
            if (podcast.description != null) ...[
              Gap(pu2),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: Padding(
                  padding: .symmetric(horizontal: pu2),
                  child: SingleChildScrollView(child: HtmlDescription(podcast: podcast, offline: false)),
                ),
              ),
            ],
            Gap(pu2),
            Align(
              alignment: .centerRight,
              child: _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
            ),
            Gap(pu2),
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
                  child: PodcastImage(podcast: podcast, width: _imageSize, height: _imageSize, borderRadius: pu4),
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
            Gap(pu2),
            Align(
              alignment: .centerRight,
              child: _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
            ),
            Gap(pu2),
          ],
        ),
      );
    }
  }

  // @override
  // double get minExtent => 0;
  //
  // @override
  // bool shouldRebuild(covariant _PodcastHeader oldDelegate) {
  //   return oldDelegate.podcast != podcast;
  // }
}

class _SubscribeButton extends StatelessWidget {
  final Podcast podcast;
  final bool subscribing;
  final bool subscribed;

  const _SubscribeButton({required this.podcast, required this.subscribing, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;

    final cubit = context.read<PodcastCubit>();
    return Padding(
      padding: .symmetric(horizontal: pu2),
      child: M3EButton.icon(
        onPressed: subscribing
            ? null
            : () async {
                if (subscribed) {
                  cubit.unsubscribe();
                } else {
                  cubit.subscribe();
                }
              },

        label: subscribing
            ? SizedBox(width: 25, height: 25, child: Center(child: LoadingIndicator()))
            : Text(subscribed ? locals.unsubscribe : locals.subscribe),
        icon: Icon(subscribed ? Icons.block : Icons.check_box_outline_blank_outlined),
      ),
    );
  }
}

class _VerticalPodcastHeader extends StatelessWidget {
  final bool subscribing;
  final bool subscribed;
  final Podcast podcast;

  const _VerticalPodcastHeader({required this.podcast, required this.subscribing, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(color: colors.secondaryContainer, borderRadius: .circular(pu4)),
      padding: .all(pu4),
      margin: .all(pu4),
      width: 300,
      child: Column(
        mainAxisSize: .min,
        children: [
          PodcastImage(podcast: podcast, width: 200, height: 200, borderRadius: pu2),
          Gap(pu2),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(child: HtmlDescription(podcast: podcast, offline: false)),
          ),
          Gap(pu4),
          _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
        ],
      ),
    );
  }
}
