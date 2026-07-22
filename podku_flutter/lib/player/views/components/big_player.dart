import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/play_pause_button.dart';
import 'package:podku/player/views/components/player_speed.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';

const double _imageWidth = 200;

class BigPlayer extends StatelessWidget {
  const BigPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<PlayerCubit>();
    final isMobile = BreakPoint.get(context) == .mobile;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final colorScheme = context.select((PodcastImageColorCubit c) => c.state.colorScheme);
          var tabController = DefaultTabController.of(context);
          return AnimatedTheme(
            duration: animationDuration,
            data: Theme.of(context).copyWith(colorScheme: colorScheme),
            child: ListenableBuilder(
              listenable: tabController,
              builder: (context, child) {
                final colors = Theme.of(context).colorScheme;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  color: tabController.index == 0 ? colors.secondaryContainer : colors.surface,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      leading: isMobile
                          ? IconButton(
                              onPressed: () => context.read<PlayerCubit>().showPlayers(true, false),
                              icon: Icon(Icons.keyboard_arrow_down),
                            )
                          : SizedBox.shrink(),
                      backgroundColor: Colors.transparent,
                      actions: [
                        IconButton(onPressed: () => context.read<PlayerCubit>().stop(), icon: Icon(Icons.close)),
                      ],
                      title: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.play_arrow)),
                          Tab(icon: Icon(Icons.info_outline)),
                        ],
                      ),
                    ),
                    body: Builder(
                      builder: (context) {
                        final episode = context.select((PlayerCubit c) => c.state.episode);
                        final loading = context.select((PlayerCubit c) => c.state.loading);
                        return AnimatedSwitcher(
                          switchOutCurve: Curves.easeInOutQuad,
                          switchInCurve: Curves.easeInOutQuad,
                          duration: animationDuration,
                          child: episode == null || loading
                              ? Center(child: LoadingIndicator())
                              : TabBarView(
                                  children: [
                                    Column(
                                      mainAxisAlignment: .center,
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
                                              icon: Icon(Icons.fast_rewind, color: colors.onSecondaryContainer),
                                            ),
                                            Gap(pu4),
                                            PlayPauseButton(size: 75),
                                            Gap(pu4),
                                            IconButton(
                                              iconSize: 60,
                                              onPressed: () => cubit.skip(30),
                                              icon: Icon(Icons.fast_forward, color: colors.onSecondaryContainer),
                                            ),
                                          ],
                                        ),
                                        Gap(pu4),
                                        Padding(
                                          padding: .symmetric(horizontal: pu16),
                                          child: ProgressBar(height: pu3, scrobblingDot: true),
                                        ),
                                        Gap(pu),
                                        Builder(
                                          builder: (context) {
                                            final position = context.select((PlayerCubit c) => c.state.position);
                                            final duration = context.select((PlayerCubit c) => c.state.duration);
                                            return Padding(
                                              padding: .symmetric(horizontal: pu16),
                                              child: Row(
                                                mainAxisAlignment: .spaceBetween,
                                                children: [
                                                  Text(printDuration(position), style: textTheme.bodySmall),
                                                  Text(printDuration(duration), style: textTheme.bodySmall),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Gap(pu4),
                                        Row(mainAxisAlignment: .center, children: [PlayerSpeed()]),
                                      ],
                                    ),
                                    Container(
                                      color: colors.surface,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: .all(pu4),
                                          child: HtmlWidget(episode.description ?? ''),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
