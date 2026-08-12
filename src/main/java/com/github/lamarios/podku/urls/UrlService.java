/* (C)2026 */
package com.github.lamarios.podku.urls;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UrlService {
    private final UrlRepository urlRepository;

    public UrlService(UrlRepository urlRepository) {
        this.urlRepository = urlRepository;
    }

    @Transactional
    public void storeUrls(List<String> urls) {
        var hashed = urls
            .stream()
            .filter(Objects::nonNull)
            .filter(s -> !s.isBlank())
            .map(UrlHash::new)
            .toList();

        urlRepository.saveAll(hashed);
    }

    @Transactional(readOnly = true)
    public Optional<String> getUrl(String hash) {
        return urlRepository.findById(hash).map(UrlHash::getUrl);
    }
}
