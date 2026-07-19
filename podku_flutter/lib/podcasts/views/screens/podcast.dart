import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/views/components/episode_in_grid.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/states/podcast.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku_client/podku_client.dart';

class PodcastScreen extends StatelessWidget {
  final String? podcastId;
  final SearchResult? searchResult;

  const PodcastScreen({super.key, this.podcastId, this.searchResult});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isMobile = BreakPoint.get(context) == .mobile;

    return podcastId != null || searchResult != null
        ? BlocProvider(
            create: (context) => PodcastCubit(
              PodcastState(),
              podcastId: podcastId,
              searchResult: searchResult,
              playerCubit: context.read<PlayerCubit>(),
            ),
            child: BlocBuilder<PodcastCubit, PodcastState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(title: Text(state.podcast?.name ?? ''), backgroundColor: colors.secondaryContainer),
                  backgroundColor: colors.secondaryContainer,
                  body: SafeArea(
                    bottom: false,
                    child: state.loading || state.podcast == null
                        ? Center(child: LoadingIndicator())
                        : Column(
                            children: [
                              _PodcastHeader(
                                podcast: state.podcast!,
                                subscribing: state.subscribing,
                                subscribed: state.subscribed,
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

  const _PodcastHeader({required this.podcast, required this.subscribing, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakPoint.get(context) == .mobile;

    if (isMobile) {
      return Column(
        children: [
          Center(
            child: PodcastImage(podcast: podcast, width: 200, height: 200, borderRadius: pu4),
          ),
          if (podcast.description != null) ...[
            Gap(pu2),
            Padding(
              padding: .symmetric(horizontal: pu2),
              child: Text(podcast.description!, maxLines: 5, overflow: .ellipsis),
            ),
          ],
          Gap(pu2),
          _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Gap(pu4),
              Center(
                child: PodcastImage(podcast: podcast, width: 150, height: 150, borderRadius: pu4),
              ),

              Gap(pu4),
              Expanded(
                child: SizedBox(
                  height: 150,
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
              ),
            ],
          ),
          Gap(pu2),
          _SubscribeButton(podcast: podcast, subscribing: subscribing, subscribed: subscribed),
        ],
      );
    }
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
              subscribed ? 'Unsubscribe' : 'Subscribe',
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
