import 'package:openapi/openapi.dart';

extension EpisodeProgress on Episode {
  double get progressPercent {
    return ((progress ?? 0) / (durationSeconds ?? 1).toDouble()).clamp(0, 1);
  }
}
