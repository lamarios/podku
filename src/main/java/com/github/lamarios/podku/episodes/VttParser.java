/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VttParser {
    // Matches lines like: 00:00:11.447 --> 00:00:16.131 (optional cue settings after)
    // Matches lines like: 00:00:11.447 --> 00:00:16.131 (optional cue settings after)
    private static final Pattern TIME_LINE_PATTERN = Pattern.compile(
            "^(\\\\d{2}:\\\\d{2}:\\\\d{2}\\\\.\\\\d{3}|\\\\d{2}:\\\\d{2}\\\\.\\\\d{3})\\\\s*--"
            + ">\\\\s*(\\\\d{2}:\\\\d{2}:\\\\d{2}\\\\.\\\\d{3}|\\\\d{2}:\\\\d{2}\\\\.\\\\d{3})"
    );
    // Matches a leading <v Speaker> tag, capturing the speaker name.
    private static final Pattern VOICE_TAG_PATTERN = Pattern.compile("^<v\\s+([^>]+)>\\s*");

    public List<EpisodeTranscript> parse(String vttContent, Episode episode, String language) {
        List<EpisodeTranscript> cues = new ArrayList<>();
        // Normalize line endings and split into lines.
        String[] lines = vttContent.replace("\r\n", "\n").split("\n", -1);

        int i = 0;
        // Skip the WEBVTT header (and any metadata lines before the first blank line).
        while (i < lines.length && !TIME_LINE_PATTERN.matcher(lines[i].trim()).find()) {
            i++;
        }

        while (i < lines.length) {
            String line = lines[i].trim();
            Matcher timeMatcher = TIME_LINE_PATTERN.matcher(line);
            if (!timeMatcher.find()) {
                // Not a timestamp line (blank line, cue identifier, etc.) — skip it.
                i++;
                continue;
            }

            String startTime = timeMatcher.group(1);
            String endTime = timeMatcher.group(2);
            i++;
            // Collect all following lines until a blank line or EOF — this is the cue text,
            // which may span multiple lines.
            List<String> contentLines = new ArrayList<>();
            while (i < lines.length && !lines[i].trim().isEmpty()) {
                contentLines.add(lines[i]);
                i++;
            }

            if (contentLines.isEmpty()) {
                continue;
            }
            // Extract speaker from a leading <v Speaker> tag on the first content line.
            String speaker = null;
            String firstLine = contentLines.get(0);
            Matcher voiceMatcher = VOICE_TAG_PATTERN.matcher(firstLine);
            String bodyFirstLine = firstLine;
            if (voiceMatcher.find()) {
                speaker = voiceMatcher.group(1).trim();
                bodyFirstLine = firstLine.substring(voiceMatcher.end());
            }

            List<String> bodyLines = new ArrayList<>();
            bodyLines.add(bodyFirstLine);
            bodyLines.addAll(contentLines.subList(1, contentLines.size()));
            String content = String.join("\n", bodyLines).trim();

            EpisodeTranscript transcript = new EpisodeTranscript();
            transcript.setStartTime(startTime);
            transcript.setEndTime(endTime);
            transcript.setSpeaker(speaker);
            transcript.setContent(content);
            transcript.setEpisode(episode);
            transcript.setLanguage(language);

            cues.add(transcript);
        }

        return cues;
    }

    public List<EpisodeTranscript> parse(String vttContent, Episode episode) {
        return parse(vttContent, episode, null);
    }
}
