package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
@RequiredArgsConstructor
public class NavigationModelAdvice {

    private final SubmissionService submissionService;

    @ModelAttribute("hasSubmissionToday")
    public boolean hasSubmissionToday() {
        return submissionService.hasSubmissionTodayForCurrentUser();
    }
}
