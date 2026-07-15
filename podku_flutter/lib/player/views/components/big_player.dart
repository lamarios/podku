import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';

const double _imageWidth = 200;

class BigPlayer extends StatelessWidget {
  const BigPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final cubit = context.read<PlayerCubit>();
    final isMobile = BreakPoint.get(context) == .mobile;
    return Scaffold(
      backgroundColor: colors.secondaryContainer,
      appBar: AppBar(
        leading: isMobile ? IconButton(
          onPressed: () => context.read<PlayerCubit>().showPlayers(true, false),
          icon: Icon(Icons.arrow_drop_down),
        ) : null,
        backgroundColor: colors.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () => context.read<PlayerCubit>().stop(),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final episode = context.select((PlayerCubit c) => c.state.episode);
          final loading = context.select((PlayerCubit c) => c.state.loading);
          return AnimatedSwitcher(
            switchOutCurve: Curves.easeInOutQuad,
            switchInCurve: Curves.easeInOutQuad,
            duration: animationDuration,
            child: episode == null
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
                          podcast: episode.podcast!,
                          width: _imageWidth,
                          height: _imageWidth,
                          borderRadius: pu8,
                        ),
                      ),
                      Gap(pu4),
                      Padding(
                        padding: .symmetric(horizontal: pu2),
                        child: Text(
                          episode.title,
                          style: textTheme.titleLarge,
                          overflow: .ellipsis,
                          maxLines: 3,
                          textAlign: .center,
                        ),
                      ),
                      Gap(pu4),
                      Row(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        children: [
                          IconButton(
                            iconSize: 60,
                            onPressed: () => cubit.skip(-10),
                            icon: Icon(
                              Icons.fast_rewind,
                              color: colors.onSecondaryContainer,
                            ),
                          ),
                          Gap(pu4),
                          PlayPauseButton(
                            size: 75,
                          ),
                          Gap(pu4),
                          IconButton(
                            iconSize: 60,
                            onPressed: () => cubit.skip(30),
                            icon: Icon(
                              Icons.fast_forward,
                              color: colors.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Gap(pu4),
                      Padding(
                        padding: .symmetric(horizontal: pu6),
                        child: ProgressBar(
                          height: 10,
                          scrobblingDot: true,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final position = context.select(
                            (PlayerCubit c) => c.state.position,
                          );
                          final duration = context.select(
                            (PlayerCubit c) => c.state.duration,
                          );
                          return Padding(
                            padding: .symmetric(horizontal: pu6),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  printDuration(position),
                                  style: textTheme.bodySmall,
                                ),
                                Text(
                                  printDuration(duration),
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Gap(pu4),
                      Expanded(
                        child: Container(
                          color: colors.surface,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: .all(pu4),
                              child: HtmlWidget(episode.description ?? ''),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
