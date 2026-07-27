import 'package:podku_client/podku_client.dart';

extension EpisodeProgress on Episode {
  double get progressPercent {
    return (progress / (durationSeconds ?? 1).toDouble()).clamp(0, 1);
  }
}
