import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/search/states/search_result.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku_client/podku_client.dart';

class UnsubbedPodcastScreen extends StatelessWidget {
  final SearchResult result;

  const UnsubbedPodcastScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isMobile = BreakPoint.get(context) == .mobile;

    return Scaffold(
      backgroundColor: colors.secondaryContainer,
      appBar: AppBar(title: Text(result.trackName ?? ''), backgroundColor: colors.secondaryContainer),
      body: SafeArea(
        bottom: false,
        child: BlocProvider(
          create: (context) =>
              SearchResultCubit(SearchResultState(), result: result, playerCubit: context.read<PlayerCubit>()),
          child: BlocBuilder<SearchResultCubit, SearchResultState>(
            builder: (context, state) {
              final cubit = context.read<SearchResultCubit>();

              if (state.loading || state.podcast == null) {
                return Center(child: LoadingIndicator());
              } else {
                return Column(
                  children: [
                    Center(
                      child: PodcastImage(podcast: state.podcast!, width: 200, height: 200, borderRadius: pu4),
                    ),
                    if (state.podcast?.description != null) ...[
                      Gap(pu2),
                      Padding(
                        padding: .symmetric(horizontal: pu2),
                        child: Text(state.podcast!.description!, maxLines: 5, overflow: .ellipsis),
                      ),
                    ],
                    Gap(pu2),
                    Padding(
                      padding: .symmetric(horizontal: pu2),
                      child: Row(
                        mainAxisAlignment: .end,
                        children: [
                          TextButton.icon(
                            onPressed: state.subscribing
                                ? null
                                : () async {
                                    if (state.podcast != null) {
                                      if (state.subscribed) {
                                        cubit.unsubscribe();
                                      } else {
                                        cubit.subscribe();
                                      }
                                    }
                                  },
                            label: Text(
                              state.subscribed ? 'Unsubscribe' : 'Subscribe',
                              style: textTheme.bodyMedium!.copyWith(
                                color: state.subscribed ? colors.error : colors.primary,
                              ),
                            ),
                            icon: Icon(
                              state.subscribed ? Icons.block : Icons.check_box_outline_blank_outlined,
                              color: state.subscribed ? colors.error : colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(pu2),
                    if (state.podcast?.episodes != null)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: colors.surface),
                          padding: .only(left: pu4, right: pu4, top: pu4),
                          child: isMobile
                              ? ListView.builder(
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
                              : GridView.extent(
                                  maxCrossAxisExtent: EpisodeInGrid.crossAxisExtent,
                                  mainAxisExtent: EpisodeInGrid.mainAxisExtent,
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
