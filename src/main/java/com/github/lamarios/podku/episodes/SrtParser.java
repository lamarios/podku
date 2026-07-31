package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SrtParser {

    // SRT timestamps use commas instead of dots: 00:00:11,447 --> 00:00:16,131
    private static final Pattern TIME_LINE_PATTERN =
            Pattern.compile("^(\\d{2}:\\d{2}:\\d{2},\\d{3})\\s*-->\\s*(\\d{2}:\\d{2}:\\d{2},\\d{3})");

    // Some SRT files still include a <v Speaker> tag, even though it's non-standard.
    private static final Pattern VOICE_TAG_PATTERN =
            Pattern.compile("^<v\\s+([^>]+)>\\s*");

    // A line that's just a number (the cue index).
    private static final Pattern INDEX_LINE_PATTERN = Pattern.compile("^\\d+$");

    public List<EpisodeTranscript> parse(String srtContent, Episode episode, String language) {
        List<EpisodeTranscript> cues = new ArrayList<>();
        String[] lines = srtContent.replace("\r\n", "\n").split("\n", -1);

        int i = 0;
        while (i < lines.length) {
            String line = lines[i].trim();

            // Skip blank lines and index lines.
            if (line.isEmpty() || INDEX_LINE_PATTERN.matcher(line).matches()) {
                i++;
                continue;
            }

            Matcher timeMatcher = TIME_LINE_PATTERN.matcher(line);
            if (!timeMatcher.find()) {
                // Unexpected line — skip it rather than throwing, so a malformed
                // block doesn't take down the whole parse.
                i++;
                continue;
            }

            String startTime = timeMatcher.group(1);
            String endTime = timeMatcher.group(2);
            i++;

            // Collect cue text lines until a blank line or EOF.
            List<String> contentLines = new ArrayList<>();
            while (i < lines.length && !lines[i].trim().isEmpty()) {
                contentLines.add(lines[i]);
                i++;
            }

            if (contentLines.isEmpty()) {
                continue;
            }

            // Speaker is optional — only present if a <v Speaker> tag shows up.
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
}
