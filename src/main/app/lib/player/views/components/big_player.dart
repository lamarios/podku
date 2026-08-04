import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/menus/m3e_menus.dart';
import 'package:material_3_expressive/components/toggle_button_group/m3e_toggle_button_group.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:podku/episodes/models/episode_transcript.dart';
import 'package:podku/episodes/views/components/people_wrap.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/player_speed.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/player/views/components/transcript_follower.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/description.dart';

const double _imageWidth = 200;

class BigPlayer extends StatelessWidget {
  const BigPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final cubit = context.read<PlayerCubit>();
    final isMobile = BreakPoint.of(context) == .mobile || BreakPoint.of(context) == .tablet;

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final podcast = context.select((PlayerCubit c) => c.state.episode?.podcast);
          var tabController = DefaultTabController.of(context);
          return PodcastColorProvider(
            podcastLight: podcast,
            builder: (context, colors) => ListenableBuilder(
              listenable: tabController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  color: tabController.index == 0 ? colors.surface : colors.surface,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: M3EAppBar.top(
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
                        final playing = context.select((PlayerCubit c) => c.state.playing);
                        final loading = context.select((PlayerCubit c) => c.state.loading);
                        final showTranscript = context.select((PlayerCubit c) => c.state.showTranscript);
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
                                            podcastLight: episode.podcast!,
                                            width: _imageWidth,
                                            height: _imageWidth,
                                            borderRadius: pu8,
                                          ),
                                        ),
                                        Gap(pu4),
                                        Padding(
                                          padding: .symmetric(horizontal: pu2),
                                          child: Text(
                                            episode.title ?? '',
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
                                            SingleMotionBuilder(
                                              value: playing ? 1 : 0,
                                              from: 0,
                                              motion: MaterialSpringMotion.expressiveEffectsDefault(),
                                              builder: (context, value, child) => M3EButtonGroup(
                                                size: .xl,
                                                style: .text,
                                                onSelectedIndexChanged: (value) => switch (value) {
                                                  0 => cubit.skip(-10),
                                                  1 => cubit.playPause(),
                                                  2 => cubit.skip(10),
                                                  _ => throw UnimplementedError(),
                                                },
                                                actions: [
                                                  M3EButtonGroupAction(
                                                    icon: Icon(Icons.fast_rewind, color: colors.onSecondaryContainer),
                                                  ),
                                                  M3EButtonGroupAction(
                                                    icon: AnimatedIcon(
                                                      icon: AnimatedIcons.play_pause,
                                                      color: colors.onSecondaryContainer,
                                                      progress: AlwaysStoppedAnimation(value),
                                                    ),
                                                  ),
                                                  M3EButtonGroupAction(
                                                    icon: Icon(Icons.fast_forward, color: colors.onSecondaryContainer),
                                                  ),
                                                ],
                                              ),
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
                                            final chapters = context.select(
                                              (PlayerCubit c) => c.state.episode?.chapters ?? [],
                                            );
                                            final chapter = context.select(
                                              (PlayerCubit c) => c.state.episode?.chapters
                                                  ?.where((ch) => (ch.startTime ?? 0) <= c.state.position.inSeconds)
                                                  .lastOrNull,
                                            );
                                            return Padding(
                                              padding: .symmetric(horizontal: pu16),
                                              child: Row(
                                                mainAxisAlignment: .spaceBetween,
                                                crossAxisAlignment: .start,
                                                children: [
                                                  Text(printDuration(position), style: textTheme.bodySmall),
                                                  if (chapter != null && chapters.isNotEmpty)
                                                    Expanded(
                                                      child: M3EMenu(
                                                        anchorBuilder: (context, open) {
                                                          return InkWell(
                                                            onTap: () => open(),
                                                            child: Padding(
                                                              padding: .only(bottom: pu3),
                                                              child: Text(
                                                                chapter.title ?? '',
                                                                textAlign: .center,
                                                                style: textTheme.bodySmall,
                                                                maxLines: 2,
                                                                overflow: .ellipsis,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        children: chapters
                                                            .map(
                                                              (e) => M3EMenuEntry(
                                                                label: e.title ?? '',
                                                                onPressed: () => cubit.seek(
                                                                  Duration(seconds: (e.startTime ?? 0).toInt()),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                  Text(printDuration(duration), style: textTheme.bodySmall),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Gap(pu4),
                                        Row(
                                          mainAxisAlignment: .center,
                                          children: [
                                            PlayerSpeed(),
                                            if (episode.hasTranscript)
                                              IconButton(
                                                onPressed: () => cubit.showTranscript(!showTranscript),
                                                icon: Icon(Icons.closed_caption),
                                                color: showTranscript ? colors.onSurface : colors.primary,
                                              ),
                                          ],
                                        ),

                                        if (showTranscript) Expanded(child: TranscriptFollower()),
                                      ],
                                    ),
                                    Container(
                                      color: colors.surface,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: .all(pu4),
                                          child: Column(
                                            children: [
                                              PeopleList(episode: episode, wrap: true, size: 50),
                                              Gap(pu2),
                                              HtmlDescription(episode: episode, offline: false),
                                            ],
                                          ),
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
