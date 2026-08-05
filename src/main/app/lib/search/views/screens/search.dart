import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/cards/m3e_cards.dart';
import 'package:material_3_expressive/components/icon_buttons/m3e_icon_buttons.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/search/states/search.dart';
import 'package:podku/search/views/components/search_result.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';

class SearchScreen extends StatelessWidget {
  final String? query;

  const SearchScreen({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;
    final textTheme = M3ETheme.of(context).textTheme;
    final cardTheme = M3ETheme.of(context).cardTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PodcastsCubit(PodcastState())),
        BlocProvider(create: (context) => SearchCubit(SearchState(), query)),
      ],
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();
          var sizeOf = MediaQuery.sizeOf(context);
          print('sizeOf ${sizeOf.width}');
          return Scaffold(
            appBar: M3EAppBar.top(
              title: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: ClipRRect(
                    borderRadius: .circular(500),
                    child: TextField(
                      controller: cubit.searchController,
                      textInputAction: .search,
                      decoration: InputDecoration(
                        enabledBorder: .none,
                        focusedBorder: .none,
                        prefixIcon: Icon(M3EIcons.search),
                        fillColor: colors.secondaryContainer,
                        filled: true,

                        label: Text(locals.searchPodcasts),
                        suffix: M3EIconButton(
                          onPressed: () => cubit.searchController.text = '',
                          icon: Icon(M3EIcons.close),
                        ),
                      ),
                      // label: locals.searchPodcasts,
                      // variant: .filled,
                    ),
                  ),
                ),
              ),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // discover
                  if (state.discoverResults.isNotEmpty || state.loadingDiscover)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: .symmetric(horizontal: pu2, vertical: pu),
                        child: Row(
                          spacing: pu2,
                          children: [
                            Icon(M3EIcons.travel_explore),
                            Text(locals.discoverNewPodcasts, style: textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),
                  if (state.loadingDiscover)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(padding: const EdgeInsets.all(8.0), child: LoadingIndicator()),
                      ),
                    ),
                  if (!state.loadingDiscover && state.discoverResults.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: .all(pu3),
                        child: M3ECard(
                          child: Padding(
                            padding: .only(left: pu2),
                            child: SizedBox(
                              height: 300,
                              child: GridView.count(
                                scrollDirection: .horizontal,
                                crossAxisCount: 3,
                                mainAxisExtent: min(375, sizeOf.width * 0.6),
                                children: state.discoverResults
                                    .map(
                                      (r) => Padding(
                                        key: ValueKey(r),
                                        padding: .only(bottom: pu2),
                                        child: SearchResultView(result: r),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // user podcasts
                  if (state.podcastResults.isNotEmpty || state.loadingPodcasts)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: .symmetric(horizontal: pu2, vertical: pu),
                        child: Row(
                          spacing: pu2,
                          children: [
                            Icon(M3EIcons.podcasts),
                            Text(locals.yourPodcasts, style: textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),
                  if (state.loadingPodcasts)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(padding: .all(pu4), child: LoadingIndicator()),
                      ),
                    ),
                  if (!state.loadingPodcasts && state.podcastResults.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: .all(pu3),
                        child: M3ECard(
                          child: Padding(
                            padding: .only(left: pu2),
                            child: SizedBox(
                              height: 300,
                              child: GridView.count(
                                scrollDirection: .horizontal,
                                crossAxisCount: 3,
                                mainAxisExtent: min(375, sizeOf.width * 0.6),
                                children: state.podcastResults
                                    .map(
                                      (r) => Padding(
                                        key: ValueKey(r),
                                        padding: .only(bottom: pu2),
                                        child: SearchResultView(podcast: r),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // user podcasts
                  if (state.episodeResults.isNotEmpty || state.loadingEpisodes)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: .symmetric(horizontal: pu2, vertical: pu),
                        child: Row(
                          spacing: pu2,
                          children: [
                            Icon(M3EIcons.playlist_play),
                            Text(locals.yourEpisodes, style: textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),
                  if (state.loadingEpisodes)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(padding: .all(pu4), child: LoadingIndicator()),
                      ),
                    ),
                  if (!state.loadingEpisodes && state.episodeResults.isNotEmpty)
                    SliverConstrainedCrossAxis(
                      maxExtent: BreakPoint.tablet.maxWidth,
                      sliver: SliverPadding(
                        padding: .all(pu3),
                        sliver: DecoratedSliver(
                          decoration: BoxDecoration(
                            color: cardTheme.backgroundColor(colors, .elevated),
                            borderRadius: cardTheme.borderRadius,
                          ),
                          sliver: SliverPadding(
                            padding: .all(pu3),
                            sliver: SliverList.builder(
                              itemCount: state.episodeResults.length,
                              itemBuilder: (context, index) {
                                final e = state.episodeResults[index];
                                return EpisodeInList(episode: e, offline: false);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (state.discoverResults.isEmpty && state.episodeResults.isEmpty && state.podcastResults.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Icon(Icons.search, size: 100, color: colors.onSurface.withValues(alpha: 0.1)),
                      ),
                    )
                  else
                    MiniPlayer.miniPlayerPadding(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
