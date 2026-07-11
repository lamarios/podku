import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku_client/podku_client.dart';

class PodcastImage extends StatelessWidget {
  final Podcast podcast;
  final double? width;
  final double? height;
  final double? borderRadius;

  const PodcastImage({super.key, required this.podcast, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        imageUrl: podcast.artUrl,
        width: width,
        height: height,
        fit: .cover,
        imageRenderMethodForWeb: .HttpGet,
      ),
    );
  }
}
