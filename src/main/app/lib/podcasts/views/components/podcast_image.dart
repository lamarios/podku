import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
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
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: .circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        imageUrl: podcast?.artUrl ?? podcastLight!.artUrl,
        cacheKey: podcast?.artworkUrl ?? podcastLight!.artworkUrl,
        width: width,
        height: height,
        fadeInDuration: Duration(milliseconds: 150),
        fadeOutDuration: Duration(milliseconds: 150),
        fit: .cover,
        imageRenderMethodForWeb: .HttpGet,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: colors.secondaryContainer,
          child: Center(child: Icon(M3EIcons.podcasts, color: colors.secondary.withValues(alpha: 0.5), size: 20)),
        ),
      ),
    );
  }
}
