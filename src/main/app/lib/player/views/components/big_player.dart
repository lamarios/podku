import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/cards/m3e_cards.dart';
import 'package:material_3_expressive/components/menus/m3e_menus.dart';
import 'package:material_3_expressive/components/sliders/m3e_sliders.dart';
import 'package:material_3_expressive/components/snackbar/m3e_snackbar.dart';
import 'package:material_3_expressive/components/toggle_button_group/m3e_toggle_button_group.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/episode_transcript.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/episodes/views/components/people_wrap.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/player_speed.dart';
import 'package:podku/player/views/components/player_video.dart';
import 'package:podku/player/views/components/playing_podcast_image.dart';
import 'package:podku/player/views/components/progress_bar.dart';
import 'package:podku/player/views/components/remote_players.dart';
import 'package:podku/player/views/components/transcript_follower.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/app_action.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/description.dart';
import 'package:podku/utils/views/components/progressive_blur.dart';

const double _imageWidth = 170;

class BigPlayer extends StatelessWidget {
  /// Key of the podcast image slot, used to measure where the image is when expanding from the mini player.
  final GlobalKey? imageKey;

  /// Hides the podcast image while keeping its slot, when the image is drawn elsewhere (during the expansion).
  final bool hideImage;

  const BigPlayer({super.key, this.imageKey, this.hideImage = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final cubit = context.read<PlayerCubit>();
    final isMobile = BreakPoint.of(context) == .mobile || BreakPoint.of(context) == .tablet;
    final locals = AppLocalizations.of(context)!;
    final podcast = context.select((PlayerCubit c) => c.state.episode?.podcast);
    final showVolume = context.select((PlayerCubit c) => c.state.showVolume);
    final volume = context.select((PlayerCubit c) => c.state.volume);
    final showTranscript = context.select((PlayerCubit c) => c.state.showTranscript);

    return PodcastColorProvider(
      podcastLight: podcast,
      builder: (context, colors) => AnimatedContainer(
        decoration: BoxDecoration(
          color: colors.surface,
          border: isMobile
              ? null
              : Border(
                  left: BorderSide(color: colors.outlineVariant, width: pu),
                ),
        ),
        duration: Duration(milliseconds: 500),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // the content scrolls under the blurred app bar
          extendBodyBehindAppBar: true,
          appBar: _BlurredAppBar(
            color: colors.surface,
            // the transcript overlay already blurs and tints what's under the app bar
            tinted: !showTranscript,
            appBar: M3EAppBar.top(
              leading: isMobile
                  ? IconButton(
                      onPressed: () => context.read<PlayerCubit>().showPlayers(true, false),
                      icon: Icon(Icons.keyboard_arrow_down),
                    )
                  : SizedBox.shrink(),
              backgroundColor: Colors.transparent,
              actions: [IconButton(onPressed: () => context.read<PlayerCubit>().stop(), icon: Icon(Icons.close))],
            ),
          ),
          body: Builder(
            builder: (context) {
              final episode = context.select((PlayerCubit c) => c.state.episode);
              final playing = context.select((PlayerCubit c) => c.state.playing);
              final loading = context.select((PlayerCubit c) => c.state.loading);
              final showTranscript = context.select((PlayerCubit c) => c.state.showTranscript);
              final showingVideo = context.select((PlayerCubit c) => c.state.showingVideo);
              final videoEnabled = context.select((PlayerCubit c) => c.state.videoEnabled);
              final playingLocally = context.select((PlayerCubit c) => c.isPlayingLocally);
              // with the body extended behind the app bar, the scaffold reports the app bar (and status bar) as padding
              final topPadding = MediaQuery.paddingOf(context).top;
              return AnimatedSwitcher(
                switchOutCurve: Curves.easeInOutQuad,
                switchInCurve: Curves.easeInOutQuad,
                duration: animationDuration,
                child: episode == null || loading
                    ? Center(child: LoadingIndicator())
                    : Stack(
                        fit: .expand,
                        children: [
                          SingleChildScrollView(
                            padding: .only(top: topPadding),
                            child: Column(
                              crossAxisAlignment: .stretch,
                              children: [
                                Padding(
                                  padding: .only(top: pu8),
                                  child: Column(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .stretch,
                                    children: [
                                      Center(
                                        child: Builder(
                                          builder: (context) {
                                            // the video of the episode replaces the podcast image
                                            if (showingVideo) {
                                              return PlayerVideo(scale: 1, borderRadius: pu4);
                                            }
                                            return SizedBox(
                                              key: imageKey,
                                              width: _imageWidth,
                                              height: _imageWidth,
                                              child: Opacity(
                                                opacity: hideImage ? 0 : 1,
                                                // same spring and shape as the mini player so expanding /
                                                // collapsing only changes the image size
                                                child: SingleMotionBuilder(
                                                  motion: MaterialSpringMotion.expressiveSpatialFast(),
                                                  value: playing ? 1 : 0,
                                                  builder: (context, playingValue, child) => PlayingPodcastImage(
                                                    podcast: episode.podcast!,
                                                    size: _imageWidth,
                                                    playingValue: playingValue,
                                                    borderColor: colors.primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
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
                                          IconButton(
                                            onPressed: () => cubit.setShowVolume(!showVolume),
                                            icon: Icon(
                                              volume == 0
                                                  ? Icons.volume_mute
                                                  : volume < 30
                                                  ? Icons.volume_down
                                                  : Icons.volume_up,
                                              color: showVolume ? colors.onSurface : colors.primary,
                                            ),
                                          ),
                                          PlayerSpeed(),
                                          InkWell(
                                            onTap: () async {
                                              var playerCubit = context.read<PlayerCubit>();
                                              if (playerCubit.state.episode != null) {
                                                await client.bookmarks.saveBookmark(
                                                  bookmark: Bookmark(
                                                    time: playerCubit.state.position.inSeconds,
                                                    episode: playerCubit.state.episode,
                                                  ),
                                                );

                                                actionStream.add(.refreshBookmarks);

                                                if (context.mounted) {
                                                  M3ESnackbar.show(context, message: locals.bookmarkAdded);
                                                }
                                              }
                                            },
                                            child: Row(
                                              crossAxisAlignment: .center,
                                              mainAxisSize: .min,
                                              children: [
                                                Icon(M3EIcons.bookmark, color: colors.primary),
                                                Icon(M3EIcons.add, size: 12, color: colors.primary),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder<bool>(
                                            future: episode.hasTranscript,
                                            builder: (context, snapshot) {
                                              if (!(snapshot.data ?? false)) {
                                                return SizedBox.shrink();
                                              }
                                              return IconButton(
                                                onPressed: () => cubit.showTranscript(!showTranscript),
                                                icon: Icon(Icons.closed_caption),
                                                color: showTranscript ? colors.onSurface : colors.primary,
                                              );
                                            },
                                          ),
                                          if (playingLocally && episode.canSwitchVideo)
                                            IconButton(
                                              onPressed: cubit.toggleVideo,
                                              tooltip: videoEnabled ? locals.listenToAudio : locals.watchVideo,
                                              icon: Icon(
                                                videoEnabled ? Icons.headphones : Icons.videocam,
                                                color: colors.primary,
                                              ),
                                            ),
                                          RemotePlayers(),
                                        ],
                                      ),
                                      SingleMotionBuilder(
                                        motion: MaterialSpringMotion.expressiveSpatialFast(),
                                        value: showVolume ? 1 : 0,
                                        builder: (context, value, child) {
                                          var sliderTheme = M3ETheme.of(context).sliderTheme;
                                          return value < 0.1
                                              ? SizedBox.shrink()
                                              : SizedBox(
                                                  height: lerpDouble(0, 45, value),
                                                  child: Padding(
                                                    padding: .symmetric(horizontal: pu16),
                                                    child: M3ESlider(
                                                      value: volume.clamp(0, 100),
                                                      min: 0,
                                                      max: 100,
                                                      trackThickness: lerpDouble(0, sliderTheme.trackHeight, value),
                                                      thumbLength: lerpDouble(0, sliderTheme.handleHeight, value),

                                                      onChangeEnd: (value) => cubit.setVolume(value, onChangeEnd: true),
                                                      onChanged: (value) => cubit.setVolume(value, onChangeEnd: false),
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: .fromLTRB(pu4, pu4, pu4, pu4 + MediaQuery.paddingOf(context).bottom),
                                  child: M3ECard(
                                    color: colors.surfaceContainerHigh,
                                    child: Column(
                                      crossAxisAlignment: .stretch,
                                      children: [
                                        PeopleList(episode: episode, wrap: true, size: 50),
                                        Gap(pu2),
                                        HtmlDescription(episode: episode, offline: false),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // the overlay's blurred background goes under the app bar, only its content is pushed below it
                          _TranscriptOverlay(show: showTranscript, contentTopPadding: topPadding),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Full size transcript follower shown on top of the big player, with a blurred translucent background and a
/// small set of playback controls at the bottom. Slides / fades in from the bottom when [show] becomes true.
class _TranscriptOverlay extends StatelessWidget {
  final bool show;

  /// Space at the top of the overlay covered by the app bar, the transcript starts below it.
  final double contentTopPadding;

  const _TranscriptOverlay({required this.show, required this.contentTopPadding});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;

    return SingleMotionBuilder(
      motion: MaterialSpringMotion.expressiveSpatialDefault(),
      value: show ? 1 : 0,
      builder: (context, value, child) {
        // keep the transcript (and its cubit) unmounted while hidden
        if (!show && value < 0.02) {
          return const SizedBox.shrink();
        }
        final progress = value.clamp(0.0, 1.0);
        return IgnorePointer(
          ignoring: !show,
          child: FractionalTranslation(
            translation: Offset(0, (1 - value) * 0.3),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24 * progress, sigmaY: 24 * progress),
                child: ColoredBox(
                  color: colors.surface.withValues(alpha: 0.65 * progress),
                  child: Opacity(opacity: progress, child: child),
                ),
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: Padding(
              padding: .only(top: contentTopPadding + pu4),
              child: TranscriptFollower(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: .symmetric(horizontal: pu4, vertical: pu2),
              child: _TranscriptPlaybackControls(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptPlaybackControls extends StatelessWidget {
  const _TranscriptPlaybackControls();

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final cubit = context.read<PlayerCubit>();
    final playing = context.select((PlayerCubit c) => c.state.playing);

    return Stack(
      alignment: .center,
      children: [
        SingleMotionBuilder(
          value: playing ? 1 : 0,
          from: 0,
          motion: MaterialSpringMotion.expressiveEffectsDefault(),
          builder: (context, value, child) => M3EButtonGroup(
            size: .sm,
            style: .tonal,
            onSelectedIndexChanged: (value) => switch (value) {
              0 => cubit.skip(-10),
              1 => cubit.playPause(),
              2 => cubit.skip(10),
              _ => throw UnimplementedError(),
            },
            actions: [
              M3EButtonGroupAction(icon: Icon(Icons.fast_rewind, color: colors.onSecondaryContainer)),
              M3EButtonGroupAction(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  color: colors.onSecondaryContainer,
                  progress: AlwaysStoppedAnimation(value),
                ),
              ),
              M3EButtonGroupAction(icon: Icon(Icons.fast_forward, color: colors.onSecondaryContainer)),
            ],
          ),
        ),
        Align(
          alignment: .centerRight,
          child: IconButton(
            onPressed: () => cubit.showTranscript(false),
            icon: Icon(Icons.closed_caption_disabled),
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}

/// Transparent app bar blurring the content scrolling under it, with a progressive blur and tint fading out from the
/// top of the screen and slightly overflowing below the app bar, so the content smoothly transitions into it.
class _BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// How far below the app bar the blur extends.
  static const double _fadeOverflow = pu8;

  final PreferredSizeWidget appBar;

  /// Tint applied on top of the blur, so the app bar's content stays readable.
  final Color color;

  /// Whether to apply the tint, faded out when something else already tints the area (the transcript overlay).
  final bool tinted;

  const _BlurredAppBar({required this.appBar, required this.color, required this.tinted});

  @override
  Size get preferredSize => appBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: -_fadeOverflow,
          child: ProgressiveBlur(
            sigma: 16,
            child: SingleMotionBuilder(
              motion: MaterialSpringMotion.expressiveEffectsDefault(),
              value: tinted ? 1 : 0,
              builder: (context, tint, _) => SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topCenter,
                      end: .bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.7 * tint.clamp(0.0, 1.0)),
                        color.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        appBar,
      ],
    );
  }
}
