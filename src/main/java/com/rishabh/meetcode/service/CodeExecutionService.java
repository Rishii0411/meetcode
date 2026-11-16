package com.rishabh.meetcode.service;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.Map;

@Service
public class CodeExecutionService {

    private final RestClient restClient;
    public CodeExecutionService() {
        this.restClient = RestClient.builder()
                .baseUrl("https://ce.judge0.com")
                .build();
    }

    public Map<String, Object> executeJavaCode(String sourceCode,String input) {

        Map<String, Object> requestBody = Map.of(
                "source_code", sourceCode,
                "language_id", 62,
                "stdin",input
        );

        return restClient.post()
                .uri("/submissions?wait=true")
                .contentType(MediaType.APPLICATION_JSON)
                .body(requestBody)
                .retrieve()
                .body(new org.springframework.core.ParameterizedTypeReference<
                        Map<String, Object>>() {});
    }
}
