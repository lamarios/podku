import 'package:openapi/openapi.dart';

extension TranscriptTiming on EpisodeTranscript {
  Duration get startDuration => _parseDuration(startTime ?? '00:00:00');
  Duration get endDuration => _parseDuration(endTime ?? '00:00:00');

  bool containsPosition(Duration position) => position >= startDuration && position < endDuration;
}

Duration _parseDuration(String input) {
  final parts = input.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final secondsParts = parts[2].split('.');
  final seconds = int.parse(secondsParts[0]);
  final milliseconds = secondsParts.length > 1 ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3)) : 0;
  return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
}
