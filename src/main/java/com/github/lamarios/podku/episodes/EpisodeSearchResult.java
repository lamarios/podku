package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.List;

public record EpisodeSearchResult(Episode episode, List<EpisodeTranscript> matchedTranscripts) {}
