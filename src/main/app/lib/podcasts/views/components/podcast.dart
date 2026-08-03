import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';

const double _imageSize = 200;

class PodcastInGrid extends StatelessWidget {
  final double? size;
  final PodcastLight podcast;

  const PodcastInGrid({super.key, required this.podcast, this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/podcast/${podcast.id.toString()}').then((value) {
        if (context.mounted) {
          context.read<PodcastsCubit>().getPodcasts();
        }
      }),
      child: Padding(
        padding: .all(pu),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Center(
              child: PodcastImage(
                podcastLight: podcast,
                width: size ?? _imageSize,
                height: size ?? _imageSize,
                borderRadius: pu4,
              ),
            ),
            Text(podcast.name ?? '', maxLines: 2, overflow: .ellipsis),
          ],
        ),
      ),
    );
  }
}
