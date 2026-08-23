package com.github.lamarios.podku.bookmarks;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.List;
import java.util.Map;

public record BookmarkWithTranscript(
    Bookmark bookmark, Map<String, List<EpisodeTranscript>> transcripts) {}
