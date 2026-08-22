Duration parseDuration(String input) {
  final parts = input.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final secondsParts = parts[2].split('.');
  final seconds = int.parse(secondsParts[0]);
  final milliseconds = secondsParts.length > 1 ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3)) : 0;

  return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

/// expected parameter format: 00:00:00.000
String roundTranscriptDuration(String duration) {
  return duration.split('.')[0];
}
