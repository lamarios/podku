import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/player/states/player.dart';

/// a bar of the logo, in the coordinates of assets/podku-icon-no-background.svg (144x144, centered on 0,0)
class _Bar {
  final double x;
  final double restHeight;

  /// tallest the bar can get while playing
  final double maxHeight;
  final Color color;

  const _Bar(this.x, this.restHeight, this.maxHeight, this.color);
}

const double _viewBox = 144;
const double _barWidth = 8;
const double _minHeight = 12;

const _bars = [
  _Bar(-60, 50, 96, Color(0xff3f8f88)),
  _Bar(-30, 90, 124, Color(0xff5fc9c0)),
  _Bar(0, 120, 140, Color(0xffffb454)),
  _Bar(30, 90, 124, Color(0xff5fc9c0)),
  _Bar(60, 50, 96, Color(0xff3f8f88)),
];

/// The podku logo, its bars bounce like an equalizer while an episode is playing and settle back to the logo when
/// playback is paused or the episode is closed.
///
/// The motion is simulated, just_audio doesn't expose the audio spectrum on most platforms.
class AnimatedPodkuLogo extends StatefulWidget {
  final double size;

  const AnimatedPodkuLogo({super.key, required this.size});

  @override
  State<AnimatedPodkuLogo> createState() => _AnimatedPodkuLogoState();
}

class _AnimatedPodkuLogoState extends State<AnimatedPodkuLogo> with SingleTickerProviderStateMixin {
  final _random = Random();
  late final Ticker _ticker;
  late final List<double> _heights = _bars.map((b) => b.restHeight).toList();
  late final List<double> _targets = _bars.map((b) => b.restHeight).toList();

  // time left before each bar picks a new target
  final List<Duration> _nextTarget = List.filled(_bars.length, Duration.zero);
  Duration _lastTick = Duration.zero;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _setPlaying(bool playing) {
    if (playing == _playing) return;
    _playing = playing;
    if (!playing) {
      for (var i = 0; i < _bars.length; i++) {
        _targets[i] = _bars[i].restHeight;
      }
    }
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;

    var settled = true;
    for (var i = 0; i < _bars.length; i++) {
      if (_playing) {
        _nextTarget[i] -= Duration(microseconds: (dt * Duration.microsecondsPerSecond).round());
        if (_nextTarget[i] <= Duration.zero) {
          // skew towards the lower half so peaks stand out, like speech
          final energy = pow(_random.nextDouble(), 1.6).toDouble();
          _targets[i] = _minHeight + energy * (_bars[i].maxHeight - _minHeight);
          _nextTarget[i] = Duration(milliseconds: 80 + _random.nextInt(140));
        }
      }

      // bars shoot up fast and fall back slower, ease back gently when settling to the logo
      final rising = _targets[i] > _heights[i];
      final speed = !_playing ? 8.0 : (rising ? 22.0 : 10.0);
      _heights[i] += (_targets[i] - _heights[i]) * (1 - exp(-speed * dt));

      if ((_heights[i] - _targets[i]).abs() > 0.1) settled = false;
    }

    if (!_playing && settled) {
      for (var i = 0; i < _bars.length; i++) {
        _heights[i] = _bars[i].restHeight;
      }
      _ticker.stop();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final playing = context.select((PlayerCubit c) => c.state.playing && c.state.episode != null);
    _setPlaying(playing && !MediaQuery.disableAnimationsOf(context));

    return SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(painter: _LogoPainter(List.of(_heights))),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final List<double> heights;

  _LogoPainter(this.heights);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / _viewBox;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);

    final paint = Paint();
    // the dot in the middle of the center bar
    paint.color = _bars[2].color;
    canvas.drawCircle(Offset.zero, 8, paint);

    for (var i = 0; i < _bars.length; i++) {
      paint.color = _bars[i].color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(_bars[i].x, 0), width: _barWidth, height: heights[i]),
          const Radius.circular(_barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => !listEquals(oldDelegate.heights, heights);
}
