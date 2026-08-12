/* (C)2026 */
package com.github.lamarios.podku.staticContent;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StaticContentController {
    @RequestMapping(value = "/")
    public String serveIndex() {
        return "index.html";
    }
}
