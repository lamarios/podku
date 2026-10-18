import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FadeInText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration fade;

  const FadeInText(this.text, {super.key, this.style, this.fade = const Duration(milliseconds: 500)});

  @override
  State<FadeInText> createState() => _FadeInTextState();
}

class _Chunk {
  _Chunk(this.text, this.born);
  final String text;
  final Duration born;
}

class _FadeInTextState extends State<FadeInText> with SingleTickerProviderStateMixin {
  final _clock = Stopwatch()..start();
  final _fading = <_Chunk>[];
  late String _settled = widget.text; // fully visible prefix
  late String _prev = widget.text;
  late final Ticker _ticker = createTicker(_onTick);

  void _onTick(Duration _) {
    final now = _clock.elapsed;
    while (_fading.isNotEmpty && now - _fading.first.born >= widget.fade) {
      _settled += _fading.removeAt(0).text;
    }
    if (_fading.isEmpty) _ticker.stop();
    setState(() {});
  }

  @override
  void didUpdateWidget(FadeInText old) {
    super.didUpdateWidget(old);
    final text = widget.text;
    if (text.length > _prev.length && text.startsWith(_prev)) {
      _fading.add(_Chunk(text.substring(_prev.length), _clock.elapsed));
      if (!_ticker.isActive) _ticker.start();
    } else if (text != _prev) {
      // text was replaced, not appended: reset
      _settled = text;
      _fading.clear();
    }
    _prev = text;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(widget.style);
    final color = base.color ?? Theme.of(context).colorScheme.onSurface;
    final now = _clock.elapsed;

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: _settled),
          for (final c in _fading)
            TextSpan(
              text: c.text,
              style: TextStyle(
                color: color.withValues(
                  alpha:
                      color.a *
                      Curves.easeOut.transform(
                        ((now - c.born).inMicroseconds / widget.fade.inMicroseconds).clamp(0.0, 1.0),
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
