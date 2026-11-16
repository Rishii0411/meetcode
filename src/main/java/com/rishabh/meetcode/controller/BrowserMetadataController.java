package com.rishabh.meetcode.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class BrowserMetadataController {

    @GetMapping("/.well-known/appspecific/com.chrome.devtools.json")
    public Map<String, Object> chromeDevToolsMetadata() {
        return Map.of();
    }
}
