import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/search/states/search.dart';
import 'package:podku/search/views/components/result_transcript.dart';
import 'package:podku/search/views/components/search_result.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';

class SearchScreen extends StatelessWidget {
  final String? query;

  const SearchScreen({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;
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
                      textAlignVertical: .center,
                      decoration: InputDecoration(
                        enabledBorder: .none,
                        focusedBorder: .none,
                        prefixIcon: Icon(M3EIcons.search),
                        fillColor: colors.secondaryContainer,
                        filled: true,
                        isDense: true,
                        floatingLabelBehavior: .never,
                        // label: Text(locals.searchPodcasts),
                        hintText: locals.searchPodcasts,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        // fine-tune if needed
                        suffixIcon: IconButton(
                          visualDensity: .compact,
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
                      child: _SectionTitle(title: locals.discoverNewPodcasts, icon: M3EIcons.travel_explore),
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
                        child: _SearchResultBox(
                          child: M3ECard(
                            child: Padding(
                              padding: .only(left: pu2),
                              child: Builder(
                                builder: (context) {
                                  var rows = state.discoverResults.length < 3 ? state.discoverResults.length : 3;
                                  const rowHeight = 100.0;
                                  return SizedBox(
                                    height: rows * rowHeight,
                                    child: GridView.count(
                                      scrollDirection: .horizontal,
                                      crossAxisCount: rows,
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
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // user podcasts
                  if (state.podcastResults.isNotEmpty || state.loadingPodcasts)
                    SliverToBoxAdapter(
                      child: _SectionTitle(title: locals.yourPodcasts, icon: M3EIcons.podcasts),
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
                        child: _SearchResultBox(
                          child: M3ECard(
                            child: Padding(
                              padding: .only(left: pu2),
                              child: Builder(
                                builder: (context) {
                                  var rows = state.podcastResults.length < 3 ? state.podcastResults.length : 3;
                                  const rowHeight = 100.0;
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: rows * rowHeight),
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      scrollDirection: .horizontal,
                                      crossAxisCount: rows,
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
                                  );
                                },
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
                        child: _SectionTitle(title: locals.yourEpisodes, icon: M3EIcons.playlist_play),
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
                                return Column(
                                  mainAxisSize: .min,
                                  children: [
                                    EpisodeInList(episode: e.episode!, offline: false),
                                    if (e.matchedTranscripts?.isNotEmpty ?? false) ResultTranscript(result: e),
                                  ],
                                );
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final textTheme = M3ETheme.of(context).textTheme;
    return Padding(
      padding: .symmetric(horizontal: pu3),
      child: Row(
        spacing: pu2,
        children: [
          Icon(icon, size: 20, color: colors.primary),
          Text(title, style: textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _SearchResultBox extends StatelessWidget {
  final Widget child;

  const _SearchResultBox({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    return Stack(
      children: [
        ConditionalWrap(
          wrapIf: kIsWeb,
          wrapper: (child) => Scrollbar(thumbVisibility: true, child: child),
          child: child,
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: Container(
            width: 75,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.transparent, colors.surface], stops: [0, 0.75]),
            ),
          ),
        ),
      ],
    );
  }
}
