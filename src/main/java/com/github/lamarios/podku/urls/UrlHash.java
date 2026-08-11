/* (C)2026 */
package com.github.lamarios.podku.urls;

import com.google.common.hash.Hashing;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.nio.charset.StandardCharsets;

@Entity
@Table(name = "url_hashes")
public class UrlHash {
    @Id
    private String hash;
    private String url;

    public UrlHash() {
    }

    public UrlHash(String url) {
        this.url = url;
        this.hash = Hashing.sha256().hashString(url, StandardCharsets.UTF_8).toString();
    }

    public String getHash() {
        return hash;
    }

    public void setHash(String hash) {
        this.hash = hash;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
