import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/search/states/search.dart';
import 'package:podku/utils.dart';

const double _imageSize = 75;

class SearchResultView extends StatelessWidget {
  final SearchResult? result;
  final PodcastLight? podcast;

  const SearchResultView({super.key, this.result, this.podcast}) : assert(podcast == null || result == null);

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        var push = result != null
            ? context.push('/search/result', extra: result)
            : context.push('/podcast/${podcast!.id}');
        push.then((value) async {
          if (context.mounted) {
            await context.read<PodcastsCubit>().getPodcasts();
            if (context.mounted) {
              await context.read<SearchCubit>().search(force: true);
            }
          }
        });
      },
      child: Row(
        mainAxisSize: .min,
        children: [
          PodcastImage(
            podcastLight:
                podcast ??
                PodcastLight(
                  artworkUrl: result!.artworkUrl600,
                  url: '',
                  name:
                      ''
                      '',
                ),
            width: _imageSize,
            height: _imageSize,
            borderRadius: pu4,
          ),
          Gap(pu2),
          Expanded(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .stretch,
              children: [
                Text(result?.collectionName ?? podcast?.name ?? '', maxLines: 2, overflow: .ellipsis),
                if (result?.genres?.isNotEmpty ?? podcast?.people?.isNotEmpty ?? false)
                  Text(
                    result?.genres?.join(' ') ?? podcast?.people?.map((p) => p.name).join(' ') ?? '',
                    style: textTheme.labelSmall?.copyWith(color: colors.outline),
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
