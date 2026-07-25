import 'package:podku_server/src/generated/episodes/episode_transcript.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';

class SrtParser {
  // SRT timestamps use commas instead of dots: 00:00:11,447 --> 00:00:16,131
  static final _timeLineRegex = RegExp(r'^(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})');

  // Some SRT files still include a <v Speaker> tag, even though it's non-standard.
  static final _voiceTagRegex = RegExp(r'^<v\s+([^>]+)>\s*');

  // A line that's just a number (the cue index).
  static final _indexLineRegex = RegExp(r'^\d+$');

  List<EpisodeTranscript> parse(String srtContent, {required Episode episode, String? language}) {
    final cues = <EpisodeTranscript>[];

    final lines = srtContent.replaceAll('\r\n', '\n').split('\n');

    int i = 0;

    while (i < lines.length) {
      final line = lines[i].trim();

      // Skip blank lines and index lines.
      if (line.isEmpty || _indexLineRegex.hasMatch(line)) {
        i++;
        continue;
      }

      final match = _timeLineRegex.firstMatch(line);
      if (match == null) {
        // Unexpected line — skip it rather than throwing, so a malformed
        // block doesn't take down the whole parse.
        i++;
        continue;
      }

      final startTime = match.group(1)!;
      final endTime = match.group(2)!;
      i++;

      // Collect cue text lines until a blank line or EOF.
      final contentLines = <String>[];
      while (i < lines.length && lines[i].trim().isNotEmpty) {
        contentLines.add(lines[i]);
        i++;
      }

      if (contentLines.isEmpty) {
        continue;
      }

      // Speaker is optional — only present if a <v Speaker> tag shows up.
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
