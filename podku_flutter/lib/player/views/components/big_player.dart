import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku_flutter/player/states/player.dart';
import 'package:podku_flutter/player/views/components/play_pause_button.dart';
import 'package:podku_flutter/player/views/components/progress_bar.dart';
import 'package:podku_flutter/podcasts/views/components/podcast_image.dart';
import 'package:podku_flutter/utils.dart';

const double _imageWidth = 300;

class BigPlayer extends StatelessWidget {
  const BigPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final cubit = context.read<PlayerCubit>();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () => context.read<PlayerCubit>().setMiniPlayer(true), icon: Icon(Icons.arrow_drop_down))],
      ),
      body: Builder(
        builder: (context) {
          final episode = context.select((PlayerCubit c) => c.state.episode);
          final loading = context.select((PlayerCubit c) => c.state.loading);
          return episode == null
              ? Center(
                  child: Text('nothing is playing'),
                )
              : loading
              ? Center(
                  child: LoadingIndicator(),
                )
              : Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Center(
                      child: PodcastImage(
                        podcast: episode!.podcast!,
                        width: _imageWidth,
                        height: _imageWidth,
                        borderRadius: pu8,
                      ),
                    ),
                    Gap(pu4),
                    Text(
                      episode!.title,
                      style: textTheme.titleLarge,
                      overflow: .ellipsis,
                      maxLines: 3,
                      textAlign: .center,
                    ),
                    Gap(pu4),
                    Row(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        IconButton(iconSize: 60, onPressed: () => cubit.skip(-10), icon: Icon(Icons.fast_rewind)),
                        Gap(pu4),
                        PlayPauseButton(
                          size: 75,
                        ),
                        Gap(pu4),
                        IconButton(iconSize: 60, onPressed: () => cubit.skip(30), icon: Icon(Icons.fast_forward)),
                      ],
                    ),
                    Gap(pu4),
                    Padding(
                      padding: .symmetric(horizontal: pu6),
                      child: ProgressBar(height: 10),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: .all(pu4),
                          child: Text(episode?.description ?? ''),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
