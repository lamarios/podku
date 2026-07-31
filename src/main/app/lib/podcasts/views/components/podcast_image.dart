import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/models/podcast.dart';

class PodcastImage extends StatelessWidget {
  final Podcast? podcast;
  final PodcastLight? podcastLight;
  final double? width;
  final double? height;
  final double? borderRadius;

  const PodcastImage({super.key, this.podcast, this.width, this.height, this.borderRadius, this.podcastLight});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        imageUrl: podcast?.artUrl ?? podcastLight!.artUrl,
        width: width,
        height: height,
        fit: .cover,
        imageRenderMethodForWeb: .HttpGet,
      ),
    );
  }
}
