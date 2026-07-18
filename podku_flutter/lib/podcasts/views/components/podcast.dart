import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';

const double _imageSize = 200;

class PodcastInGrid extends StatelessWidget {
  final Podcast podcast;

  const PodcastInGrid({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/podcast/${podcast.id.toString()}').then((value) {
        if (context.mounted) {
          context.read<PodcastsCubit>().getPodcasts();
        }
      }),
      child: Column(
        children: [
          PodcastImage(podcast: podcast, width: _imageSize, height: _imageSize, borderRadius: pu4),
          Text(podcast.name),
        ],
      ),
    );
  }
}
