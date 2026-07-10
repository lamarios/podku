import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/main.dart';
import 'package:podku_flutter/utils/views/components/simple_cubit.dart';

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
        imageUrl: '$serverUrl/podcasts/${podcast.id.uuid}/image',
        width: width,
        height: height,
        fit: .cover,
        imageRenderMethodForWeb: .HttpGet,
      ),
    );
  }
}
