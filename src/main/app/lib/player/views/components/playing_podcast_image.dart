import 'package:material_ui/material_ui.dart' hide CornerRounding, RoundedPolygon;
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils/views/components/shape_clipper.dart';

/// Podcast image of the player: a rounded square that morphs into a cookie with a border while playing.
///
/// Shared by the mini player, the big player and the image flying between them while the player expands, so the
/// image keeps the exact same look during the transition and only its size changes.
class PlayingPodcastImage extends StatelessWidget {
  /// Border width relative to the image size, so the border scales with the image.
  static const double _borderRatio = 2 / 75;

  final PodcastLight podcast;
  final double size;

  /// 0 = paused (rounded square), 1 = playing (cookie with border).
  final double playingValue;
  final Color borderColor;

  const PlayingPodcastImage({
    super.key,
    required this.podcast,
    required this.size,
    required this.playingValue,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final value = playingValue.clamp(0.0, 1.0);
    final clipper = MorphClipper(
      Morph(
        RoundedPolygon.rectangle(
          width: 1,
          height: 1,
          rounding: CornerRounding(radius: 0.15),
          centerX: 0.5,
          centerY: 0.5,
        ),
        M3EMaterialNewShapes.cookie9Sided,
      ),
      value,
    );

    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          ClipPath(
            clipper: clipper,
            child: PodcastImage(podcastLight: podcast, width: size, height: size, borderRadius: 0),
          ),
          CustomPaint(
            size: Size.square(size),
            painter: BorderPainter(
              clipper: clipper,
              color: Color.lerp(Colors.transparent, borderColor, value)!,
              width: size * _borderRatio * value,
            ),
          ),
        ],
      ),
    );
  }
}
