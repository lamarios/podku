/* (C)2026 */
package com.github.lamarios.podku.ping;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ping")
@Tag(name = "Ping")
public class PingController {
    @GetMapping
    public String ping() {
        return "pong";
    }
}
