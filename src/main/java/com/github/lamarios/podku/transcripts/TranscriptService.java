/* (C)2026 */
package com.github.lamarios.podku.transcripts;

import com.github.lamarios.podku.episodes.EpisodeService;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TranscriptService {
    private final EpisodeService episodeService;
    private final EpisodeTranscriptRepository episodeTranscriptRepository;

    @Autowired
    public TranscriptService(EpisodeService episodeService, EpisodeTranscriptRepository episodeTranscriptRepository) {
        this.episodeService = episodeService;
        this.episodeTranscriptRepository = episodeTranscriptRepository;
    }

    @Transactional(readOnly = true)
    public List<String> getLanguages(String id) {
        var episode = episodeService.getEpisode(id);
        if (episode == null) {
            return Collections.emptyList();
        } else {
            return episodeTranscriptRepository.findDistinctLanguagesForEpisode(episode);
        }
    }

    @Transactional(readOnly = true)
    public List<EpisodeTranscript> getTranscript(String id, String language) {
        var episode = episodeService.getEpisode(id);
        if (episode == null) {
            return Collections.emptyList();
        } else {
            return episodeTranscriptRepository.findAllByEpisodeAndLanguage(
                    episode,
                    language,
                    Sort.by(Sort.Direction.ASC, "startTime")
            );
        }
    }
}
