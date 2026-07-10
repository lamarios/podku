import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_flutter/main.dart';
import 'package:podku_flutter/podcasts/states/podcasts.dart';
import 'package:podku_flutter/podcasts/views/components/podcast.dart';
import 'package:podku_flutter/utils.dart';
import 'package:podku_flutter/utils/views/components/page_title.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  Future<void> getPodcasts() async {
    final podcasts = await client.podcast.getPodcasts();
    print(podcasts);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PodcastsCubit, PodcastState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: .stretch,
          children: [
            PageTitle(title: 'Podcasts'),
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 250,
                crossAxisSpacing: pu2,
                mainAxisSpacing: pu2,
                children: state.subscriptions.map((p) => PodcastInGrid(key: ValueKey(p), podcast: p)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
