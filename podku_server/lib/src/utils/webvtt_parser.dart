import 'package:podku_server/src/generated/episodes/episode_transcript.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';

class VttParser {
  // Matches lines like: 00:00:11.447 --> 00:00:16.131 (optional cue settings after)
  static final _timeLineRegex = RegExp(
    r'^(\d{2}:\d{2}:\d{2}\.\d{3}|\d{2}:\d{2}\.\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2}\.\d{3}|\d{2}:\d{2}\.\d{3})',
  );

  // Matches a leading <v Speaker> tag, capturing the speaker name.
  static final _voiceTagRegex = RegExp(r'^<v\s+([^>]+)>\s*');

  List<EpisodeTranscript> parse(String vttContent, {required Episode episode, String? language}) {
    final cues = <EpisodeTranscript>[];

    // Normalize line endings and split into lines.
    final lines = vttContent.replaceAll('\r\n', '\n').split('\n');

    int i = 0;

    // Skip the WEBVTT header (and any metadata lines before the first blank line).
    while (i < lines.length && !_timeLineRegex.hasMatch(lines[i].trim())) {
      i++;
    }

    while (i < lines.length) {
      final line = lines[i].trim();

      final match = _timeLineRegex.firstMatch(line);
      if (match == null) {
        // Not a timestamp line (blank line, cue identifier, etc.) — skip it.
        i++;
        continue;
      }

      final startTime = match.group(1)!;
      final endTime = match.group(2)!;
      i++;

      // Collect all following lines until a blank line or EOF — this is the cue text,
      // which may span multiple lines.
      final contentLines = <String>[];
      while (i < lines.length && lines[i].trim().isNotEmpty) {
        contentLines.add(lines[i]);
        i++;
      }

      if (contentLines.isEmpty) {
        continue;
      }

      // Extract speaker from a leading <v Speaker> tag on the first content line.
      String? speaker;
      final firstLine = contentLines.first;
      final voiceMatch = _voiceTagRegex.firstMatch(firstLine);

      String bodyFirstLine = firstLine;
      if (voiceMatch != null) {
        speaker = voiceMatch.group(1)!.trim();
        bodyFirstLine = firstLine.substring(voiceMatch.end);
      }

      final content = ([bodyFirstLine, ...contentLines.skip(1)]).join('\n').trim();

      cues.add(
        EpisodeTranscript(
          startTime: startTime,
          endTime: endTime,
          speaker: speaker,
          content: content,
          episodeId: episode.id,
          episode: episode,
          language: language,
        ),
      );
    }

    return cues;
  }
}
