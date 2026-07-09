import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/podcasts/states/podcasts.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

const double _imageSize = 100;

class SearchResultView extends StatelessWidget {
  final SearchResult result;
  final bool subscribed;

  const SearchResultView({super.key, required this.result, required this.subscribed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PodcastImage(podcast: Podcast(artworkUrl: result.artworkUrl600, url: '', name: ''
            ''), width: _imageSize, height: _imageSize, borderRadius: pu4,),
        Expanded(child: Text(result.collectionName ?? result.trackName ?? '')),
        if (!subscribed)
          TextButton.icon(
            onPressed: () => context.read<PodcastsCubit>().subscribe(result),
            label: Text('Subscribe'),
            icon: Icon(Icons.check_box_outline_blank),
          )
        else
          TextButton.icon(
            onPressed: null,
            label: Text('Subscribed'),
            icon: Icon(Icons.check_box_outlined),
          ),
      ],
    );
  }
}
