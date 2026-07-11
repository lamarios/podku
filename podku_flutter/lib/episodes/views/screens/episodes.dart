import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/states/episodes.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => EpisodeCubit(EpisodeState()),
      child: BlocBuilder<EpisodeCubit, EpisodeState>(
        builder: (context, state) {
          return BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) => current.selectedIndex == 0,
            listener: (context, state) => context.read<EpisodeCubit>().getEpisodes(fromScratch: true),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [

                if (state.episodes.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.episodes.length + (state.episodes.isNotEmpty && state.episodes.length % 100 == 0 ? 1 : 0),
                      itemBuilder: (context, index) {
                        final hasMore = state.episodes.length % 100 == 0;
                        final isLast = index >= state.episodes.length - 1;

                        if (index < state.episodes.length) {
                          final e = state.episodes[index];

                          return ConditionalWrap(
                            wrapIf: isLast && !hasMore,
                            wrapper: (child) => Padding(
                              padding: .only(bottom: 200),
                              child: child,
                            ),
                            child: EpisodeInList(key: ValueKey(e.id.uuid), episode: e),
                          );
                        } else {
                          return Padding(
                            padding: .only(bottom: 200),
                            child: TextButton(
                              child: Text('Load more'),
                              onPressed: () => context.read<EpisodeCubit>().loadMore(),
                            ),
                          );
                        }
                      },
                    ),
                  ) else if (!state.loading)
                   ...[Expanded(child: Center(child: Icon(Icons.playlist_remove, size: 100, color: colors.onSurface.withValues(alpha: 0.2),),))]
                ,
                if (state.loading) Center(child: LoadingIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
