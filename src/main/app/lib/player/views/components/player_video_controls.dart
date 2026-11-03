import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';

/// Controls shown over the episode video: a full screen button in the big player, basic playback controls when the
/// video is full screen.
class PlayerVideoControls extends StatelessWidget {
  const PlayerVideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    // the full screen video is a separate route reusing these controls
    return isFullscreen(context) ? const FullscreenVideoControls() : const _FullscreenButton();
  }
}

class _FullscreenButton extends StatelessWidget {
  const _FullscreenButton();

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return Align(
      alignment: .bottomRight,
      child: Padding(
        padding: .all(pu),
        child: IconButton(
          onPressed: () => enterFullscreen(context),
          tooltip: locals.fullscreen,
          visualDensity: .compact,
          style: IconButton.styleFrom(backgroundColor: Colors.black54, foregroundColor: Colors.white),
          icon: Icon(Icons.fullscreen),
        ),
      ),
    );
  }
}

/// Playback controls over the full screen video, hidden after a few seconds while the episode plays.
class FullscreenVideoControls extends StatefulWidget {
  static const hideDelay = Duration(seconds: 3);

  const FullscreenVideoControls({super.key});

  @override
  State<FullscreenVideoControls> createState() => _FullscreenVideoControlsState();
}

class _FullscreenVideoControlsState extends State<FullscreenVideoControls> {
  late final PlayerCubit _cubit;
  Timer? _hideTimer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PlayerCubit>();
    // the cubit state can't change while the widget tree is being built or disposed
    Future.microtask(() => _cubit.setFullscreen(true));
    _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    Future.microtask(() => _cubit.setFullscreen(false));
    super.dispose();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_cubit.state.playing) {
      _hideTimer = Timer(FullscreenVideoControls.hideDelay, () {
        if (mounted) setState(() => _visible = false);
      });
    }
  }

  void _show() {
    if (!_visible) {
      setState(() => _visible = true);
    }
    _scheduleHide();
  }

  void _toggle() {
    if (_visible) {
      _hideTimer?.cancel();
      setState(() => _visible = false);
    } else {
      _show();
    }
  }

  void _run(VoidCallback action) {
    action();
    _show();
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final playing = context.select((PlayerCubit c) => c.state.playing);

    return MultiBlocListener(
      listeners: [
        // controls stay visible while paused
        BlocListener<PlayerCubit, PlayerState>(
          listenWhen: (previous, current) => previous.playing != current.playing,
          listener: (context, state) => _show(),
        ),
        // e.g. the playback stopped or moved to another device
        BlocListener<PlayerCubit, PlayerState>(
          listenWhen: (previous, current) => previous.showingVideo && !current.showingVideo,
          listener: (context, state) => exitFullscreen(context),
        ),
      ],
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () => exitFullscreen(context),
          const SingleActivator(LogicalKeyboardKey.space): () => _run(_cubit.playPause),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _run(() => _cubit.skip(-10)),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _run(() => _cubit.skip(10)),
        },
        child: Focus(
          autofocus: true,
          child: MouseRegion(
            onHover: (_) => _show(),
            child: GestureDetector(
              behavior: .opaque,
              onTap: _toggle,
              child: AnimatedOpacity(
                opacity: _visible ? 1 : 0,
                duration: animationDuration,
                child: IgnorePointer(
                  ignoring: !_visible,
                  child: Container(
                    color: Colors.black38,
                    child: IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: .min,
                              children: [
                                IconButton(
                                  onPressed: () => _run(() => _cubit.skip(-10)),
                                  tooltip: locals.rewind,
                                  iconSize: 48,
                                  color: Colors.white,
                                  icon: Icon(Icons.replay_10),
                                ),
                                Gap(pu8),
                                IconButton(
                                  onPressed: () => _run(_cubit.playPause),
                                  tooltip: playing ? locals.pause : locals.play,
                                  iconSize: 72,
                                  color: Colors.white,
                                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                                ),
                                Gap(pu8),
                                IconButton(
                                  onPressed: () => _run(() => _cubit.skip(10)),
                                  tooltip: locals.skipForward,
                                  iconSize: 48,
                                  color: Colors.white,
                                  icon: Icon(Icons.forward_10),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SafeArea(
                              child: Padding(
                                padding: .all(pu2),
                                child: IconButton(
                                  onPressed: () => exitFullscreen(context),
                                  tooltip: locals.exitFullscreen,
                                  color: Colors.white,
                                  icon: Icon(Icons.fullscreen_exit),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
