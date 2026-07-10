import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

const double _imageSize = 200;

class PodcastInGrid extends StatelessWidget {
  final Podcast podcast;

  const PodcastInGrid({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/podcast/${podcast.id.toString()}'),
      child: Column(
        children: [
          PodcastImage(
            podcast: podcast,
            width: _imageSize,
            height: _imageSize,
            borderRadius: pu4,
          ),
          Text(podcast.name),
        ],
      ),
    );
  }
}
