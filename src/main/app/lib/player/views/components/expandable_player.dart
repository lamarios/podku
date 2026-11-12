import 'dart:math';
import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/big_player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/player/views/components/playing_podcast_image.dart';
import 'package:podku/podcasts/views/components/podcast_color_provider.dart';
import 'package:podku/utils.dart';

/// Mobile / tablet player: a single panel that morphs between the mini player docked at the bottom of the screen
/// and the full screen big player.
///
/// Everything is driven by one expansion spring (0 = mini, 1 = big):
/// - the panel's bounds, color, corner radius and shadow are interpolated between the mini card and the full screen,
/// - the big player is laid out at full screen size and revealed by the growing panel while fading in, so its layout
///   (and the position of its podcast image) doesn't move during the transition,
/// - the mini player content fades out,
/// - while the panel is moving, the podcast image is drawn once on top of everything, flying from the mini player's
///   image slot to the big player's one (both measured from their actual layout).
class ExpandablePlayer extends StatefulWidget {
  /// Distance between the bottom of the screen (safe area excluded) and the mini player.
  final double miniBottom;

  /// Horizontal space on each side of the mini player.
  final double miniHorizontalPadding;

  const ExpandablePlayer({super.key, required this.miniBottom, required this.miniHorizontalPadding});

  @override
  State<ExpandablePlayer> createState() => _ExpandablePlayerState();
}

class _ExpandablePlayerState extends State<ExpandablePlayer> {
  final _stackKey = GlobalKey();
  final _miniImageKey = GlobalKey();
  final _bigImageKey = GlobalKey();

  /// Layout box of the podcast image slot in the docked mini player, relative to the docked card: the starting /
  /// ending point of the flying image (the playing scale is applied on top of it).
  ///
  /// Not measured while flying: the mini player content follows the top of the growing panel, so measuring it during
  /// the transition would make the image's path move (and reverse the spring's overshoot near the end).
  Rect? _miniImageSlot;

  /// Whether the image flies during the current transition, decided when it starts: when a new episode starts playing
  /// it's still loading, neither player shows an image yet, so the panel just expands and the big player's image
  /// appears with its content once loaded.
  bool _flyImage = false;
  double? _transitionTarget;

  /// Bounds of the widget holding [key], in this widget's coordinates, as laid out during the last frame.
  Rect? _measure(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    final stack = _stackKey.currentContext?.findRenderObject();
    if (box is! RenderBox || stack is! RenderBox || !box.attached || !box.hasSize || !stack.hasSize) {
      return null;
    }
    // uses the full transform so that scaled widgets (the mini player image grows when playing) are measured properly
    return MatrixUtils.transformRect(box.getTransformTo(stack), Offset.zero & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final hidePlayer = context.select((PlayerCubit c) => c.state.hidePlayer);
    final showMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
    final showBigPlayer = context.select((PlayerCubit c) => c.state.showBigPlayer);
    final podcast = context.select((PlayerCubit c) => c.state.episode?.podcast);
    final playing = context.select((PlayerCubit c) => c.state.playing);
    final loading = context.select((PlayerCubit c) => c.state.loading);
    // in video mode the big player shows the video instead of the podcast image, so the image fades out on its way
    final videoEnabled = context.select((PlayerCubit c) => c.state.videoEnabled);
    final visible = !hidePlayer && (showMiniPlayer || showBigPlayer);
    final double target = showBigPlayer ? 1 : 0;
    if (target != _transitionTarget) {
      _transitionTarget = target;
      _flyImage = !loading && podcast != null;
    }

    final screen = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SingleMotionBuilder(
      motion: MaterialSpringMotion.expressiveSpatialFast(snapToEnd: true),
      value: visible ? 1 : 0,
      from: 0,
      builder: (context, appear, _) {
        if (!visible && appear < 0.01) {
          return const SizedBox.shrink();
        }
        return SingleMotionBuilder(
          motion: MaterialSpringMotion.expressiveSpatialSlow(snapToEnd: true),
          value: target,
          from: 0,
          builder: (context, t, _) => SingleMotionBuilder(
            motion: MaterialSpringMotion.expressiveSpatialFast(),
            value: playing ? 1 : 0,
            builder: (context, playingValue, _) => PodcastColorProvider(
              podcastLight: podcast,
              builder: (context, colors) {
                final expansion = t.clamp(0.0, 1.0);
                final playingProgress = playingValue.clamp(0.0, 1.0);

                // the panel
                const miniHeight = MiniPlayer.playerSize;
                final miniBottom = lerpDouble(500, widget.miniBottom, appear)! + bottomInset;
                final miniRect = Rect.fromLTRB(
                  widget.miniHorizontalPadding,
                  screen.height - miniBottom - miniHeight,
                  screen.width - widget.miniHorizontalPadding,
                  screen.height - miniBottom,
                );
                final panelRect = Rect.lerp(miniRect, Offset.zero & screen, t)!;
                final miniRadius = lerpDouble(pu3, pu8, playingValue)!;
                final radius = BorderRadius.circular(max(0, lerpDouble(miniRadius, 0, t)!));
                final miniColor = Color.lerp(colors.secondaryContainer, colors.primaryContainer, playingProgress)!;

                // the podcast image only flies while the panel is moving, once settled each layout shows its own
                final settled = (t - target).abs() <= 0.001;
                final flying = _flyImage && !settled;
                if (settled && target == 0) {
                  _miniImageSlot = _measure(_miniImageKey)?.shift(-miniRect.topLeft) ?? _miniImageSlot;
                }
                // the playing state can change while expanded, so the image scale is applied from the current state
                final miniImageSlot = (_miniImageSlot ?? Rect.fromLTWH(0, 0, miniHeight, miniHeight)).shift(
                  miniRect.topLeft,
                );
                final miniImageScale = miniPlayerImageScale(playingValue);
                final miniImageRect = Rect.fromCenter(
                  center: miniImageSlot.center,
                  width: miniImageSlot.width * miniImageScale,
                  height: miniImageSlot.height * miniImageScale,
                );
                final bigImageRect =
                    _measure(_bigImageKey) ??
                    Rect.fromCenter(center: Offset(screen.width / 2, screen.height * 0.35), width: 170, height: 170);

                final mountMini = target == 0 || t < 0.999;
                final mountBig = target == 1 || t > 0.001;

                return Stack(
                  key: _stackKey,
                  children: [
                    Positioned.fromRect(
                      rect: panelRect,
                      child: Opacity(
                        opacity: appear.clamp(0.0, 1.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.lerp(miniColor, colors.surface, expansion),
                            borderRadius: radius,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: pu4,
                                color: Colors.black.withValues(alpha: 0.5 * (1 - expansion)),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: radius,
                            child: Stack(
                              children: [
                                if (mountBig)
                                  // laid out at full screen size whatever the panel's size, the panel just reveals it
                                  Positioned(
                                    left: -panelRect.left,
                                    top: -panelRect.top,
                                    width: screen.width,
                                    height: screen.height,
                                    child: IgnorePointer(
                                      ignoring: target == 0,
                                      child: Opacity(
                                        opacity: ((t - 0.25) / 0.75).clamp(0.0, 1.0),
                                        child: BigPlayer(imageKey: _bigImageKey, hideImage: flying || target == 0),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (mountMini)
                      // not inside the panel's clip: the mini player image pops out of the card when playing
                      Positioned(
                        left: panelRect.left,
                        top: panelRect.top,
                        width: miniRect.width,
                        height: miniHeight,
                        child: IgnorePointer(
                          ignoring: target == 1,
                          child: Opacity(
                            opacity: (appear * (1 - t / 0.3)).clamp(0.0, 1.0),
                            child: MiniPlayer(imageKey: _miniImageKey, hideImage: flying || target == 1),
                          ),
                        ),
                      ),
                    if (flying && podcast != null)
                      Positioned.fromRect(
                        rect: Rect.lerp(miniImageRect, bigImageRect, t)!,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: (appear * (videoEnabled ? 1 - t / 0.5 : 1)).clamp(0.0, 1.0),
                            // same look as the mini and big player images, only the size changes while flying
                            child: LayoutBuilder(
                              builder: (context, constraints) => PlayingPodcastImage(
                                podcast: podcast,
                                size: constraints.biggest.shortestSide,
                                playingValue: playingValue,
                                borderColor: colors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
