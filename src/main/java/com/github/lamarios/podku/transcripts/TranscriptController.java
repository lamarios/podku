package com.github.lamarios.podku.transcripts;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/transcripts")
@Tag(name = "Transcripts")
public class TranscriptController {

    private final TranscriptService transcriptService;

    @Autowired
    public TranscriptController(TranscriptService transcriptService) {
        this.transcriptService = transcriptService;
    }

    @GetMapping("{id}/languages")
    public List<String> getEpisodeLanguages(@PathVariable String id) {
       return transcriptService.getLanguages(id);
    }

    @GetMapping("{id}/{language}")
    public List<EpisodeTranscript> getTranscript(@PathVariable String id, @PathVariable String language) {
        return transcriptService.getTranscript(id, language);
    }
}
