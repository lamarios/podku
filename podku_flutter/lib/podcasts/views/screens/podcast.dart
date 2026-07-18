import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/main.dart';
import 'package:podku/podcasts/states/podcast.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';

class PodcastScreen extends StatelessWidget {
  final String? podcastId;

  const PodcastScreen({super.key, this.podcastId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final isMobile = BreakPoint.get(context) == .mobile;

    return podcastId != null
        ? BlocProvider(
            create: (context) =>
                PodcastCubit(PodcastState(), podcastId: podcastId!),
            child: BlocBuilder<PodcastCubit, PodcastState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(state.podcast?.name ?? ''),
                    backgroundColor: colors.secondaryContainer,
                  ),
                  backgroundColor: colors.secondaryContainer,
                  body: SafeArea(
                    bottom: false,
                    child: state.loading
                        ? Center(child: LoadingIndicator())
                        : Column(
                            crossAxisAlignment: .stretch,
                            children: [
                              Center(
                                child: PodcastImage(
                                  podcast: state.podcast!,
                                  width: 200,
                                  height: 200,
                                  borderRadius: pu4,
                                ),
                              ),
                              if (state.podcast?.description != null) ...[
                                Gap(pu2),
                                Padding(
                                  padding: .symmetric(horizontal: pu2),
                                  child: Text(
                                    state.podcast!.description!,
                                    maxLines: 5,
                                    overflow: .ellipsis,
                                  ),
                                ),
                              ],
                              Gap(pu2),
                              Padding(
                                padding: .symmetric(horizontal: pu2),
                                child: Row(
                                  mainAxisAlignment: .end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        if (state.podcast != null) {
                                          final unsubscribed = await client
                                              .podcast
                                              .unsubscribe(
                                                state.podcast!.copyWith(
                                                  episodes: [],
                                                ),
                                              );
                                          if (unsubscribed && context.mounted) {
                                            context.pop();
                                          }
                                        }
                                      },
                                      label: Text(
                                        'Unsubscribe',
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: colors.error,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.block,
                                        color: colors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(pu2),
                              Padding(
                                padding: .symmetric(horizontal: pu2),
                                child: Text(
                                  'Episodes',
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              Gap(pu2),
                              if (state.podcast?.episodes != null)
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                    ),
                                    padding: .only(
                                      left: pu4,
                                      right: pu4,
                                      top: pu4,
                                    ),
                                    child: isMobile
                                        ? ListView.builder(
                                            itemCount:
                                                state.podcast!.episodes!.length,
                                            itemBuilder: (context, index) =>
                                                ConditionalWrap(
                                                  wrapIf:
                                                      index ==
                                                      state
                                                              .podcast!
                                                              .episodes!
                                                              .length -
                                                          1,
                                                  wrapper: (child) => Padding(
                                                    padding: .only(bottom: 200),
                                                    child: child,
                                                  ),
                                                  child: EpisodeInList(
                                                    episode: state
                                                        .podcast!
                                                        .episodes![index],
                                                  ),
                                                ),
                                          )
                                        : GridView.extent(
                                            maxCrossAxisExtent:
                                                EpisodeInGrid.crossAxisExtent,
                                            mainAxisExtent:
                                                EpisodeInGrid.mainAxisExtent,
                                            crossAxisSpacing:
                                                EpisodeInGrid.crossAxisSpacing,
                                            mainAxisSpacing:
                                                EpisodeInGrid.mainAxisSpacing,
                                            children:
                                                state.podcast?.episodes
                                                    ?.map(
                                                      (e) => EpisodeInGrid(
                                                        episode: e,
                                                      ),
                                                    )
                                                    .toList() ??
                                                [],
                                          ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                );
              },
            ),
          )
        : SizedBox.shrink();
  }
}
