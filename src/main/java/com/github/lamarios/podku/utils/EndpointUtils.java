/* (C)2026 */
package com.github.lamarios.podku.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

public class EndpointUtils {
  public static ResponseEntity<StreamingResponseBody> serveFile(Path filePath) throws IOException {
    String contentType = Files.probeContentType(filePath);
    if (contentType == null) {
      contentType = "application/octet-stream";
    }

    long fileSize = Files.size(filePath);

    StreamingResponseBody responseBody =
        outputStream -> {
          try (InputStream inputStream = new FileInputStream(filePath.toFile())) {
            // 8KB buffer
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
              outputStream.write(buffer, 0, bytesRead);
            }
            outputStream.flush();
          }
        };

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_TYPE, contentType)
        .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(fileSize))
        .body(responseBody);
  }
}
