import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        imageUrl: podcast.artworkUrl ?? '',
        width: width,
        height: height,
        imageRenderMethodForWeb: .HttpGet,
        fit: .cover,
      ),
    );
  }
}
