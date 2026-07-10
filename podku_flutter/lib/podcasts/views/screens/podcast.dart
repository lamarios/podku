import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku_flutter/episodes/views/components/episode_in_list.dart';
import 'package:podku_flutter/podcasts/states/podcast.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

class PodcastScreen extends StatelessWidget {
  final String? podcastId;

  const PodcastScreen({super.key, this.podcastId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return podcastId != null
        ? BlocProvider(
            create: (context) => PodcastCubit(PodcastState(), podcastId: podcastId!),
            child: BlocBuilder<PodcastCubit, PodcastState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(state.podcast?.name ?? ''),
                  ),
                  body: SafeArea(
                    child: state.loading
                        ? Center(child: LoadingIndicator())
                        : Padding(
                            padding: const EdgeInsets.all(pu2),
                            child: Column(
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
                                  Text(
                                    state.podcast!.description!,
                                    maxLines: 5,
                                    overflow: .ellipsis,
                                  ),
                                ],
                                Gap(pu2),
                                Text(
                                  'Episodes',
                                  style: textTheme.titleMedium,
                                ),
                                Gap(pu2),
                                if (state.podcast?.episodes != null)
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.podcast!.episodes!.length,
                                      itemBuilder: (context, index) => EpisodeInList(episode: state.podcast!.episodes![index]),
                                    ),
                                  ),
                              ],
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
