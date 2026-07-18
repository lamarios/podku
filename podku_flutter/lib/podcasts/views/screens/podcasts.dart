import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast.dart';
import 'package:podku/utils.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<PodcastsCubit, PodcastState>(
      builder: (context, state) {
        return BlocListener<HomeCubit, HomeState>(
          listener: (context, state) => context.read<PodcastsCubit>().getPodcasts(),
          listenWhen: (previous, current) => current.selectedIndex == 1,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(
                child: state.subscriptions.isNotEmpty
                    ? GridView.extent(
                        maxCrossAxisExtent: 250,
                        mainAxisExtent: 250,
                        crossAxisSpacing: pu2,
                        mainAxisSpacing: pu2,
                        children: state.subscriptions.map((p) => PodcastInGrid(key: ValueKey(p), podcast: p)).toList(),
                      )
                    : Center(
                        child: Icon(Icons.podcasts_outlined, size: 100, color: colors.onSurface.withValues(alpha: 0.1)),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
