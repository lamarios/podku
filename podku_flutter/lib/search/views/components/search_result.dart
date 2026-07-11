import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';

const double _imageSize = 75;

class SearchResultView extends StatelessWidget {
  final SearchResult result;
  final bool subscribed;

  const SearchResultView({super.key, required this.result, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        bool isBeingSubscribedTo = context.select((PodcastsCubit c) => c.state.subscribingTo == result);

        return Row(
          children: [
            PodcastImage(
              podcast: Podcast(
                artworkUrl: result.artworkUrl600,
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
              child: Text(
                result.collectionName ?? result.trackName ?? '',
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ),
            isBeingSubscribedTo
                ? SizedBox(width: 20, height: 20, child: LoadingIndicator())
                : !subscribed
                ? TextButton.icon(
                    onPressed: () => context.read<PodcastsCubit>().subscribe(result),
                    label: Text('Subscribe'),
                    icon: Icon(Icons.check_box_outline_blank),
                  )
                : TextButton.icon(
                    onPressed: null,
                    label: Text('Subscribed'),
                    icon: Icon(Icons.check_box_outlined),
                  ),
          ],
        );
      },
    );
  }
}
