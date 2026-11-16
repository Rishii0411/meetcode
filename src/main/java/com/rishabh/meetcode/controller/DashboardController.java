
package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.model.Submission;
import com.rishabh.meetcode.model.User;
import com.rishabh.meetcode.repo.UserRepository;
import com.rishabh.meetcode.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.rishabh.meetcode.dto.StreakSummary;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final UserRepository userRepository;
    private final SubmissionService submissionService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("User not found")
                );

        long totalSolved =
                submissionService.getTotalProblemsSolved(user.getId());

        long totalSubmissions =
                submissionService.getTotalSubmissions(user.getId());

        long acceptedSubmissions =
                submissionService.getAcceptedSubmissions(user.getId());

        long easySolved =
                submissionService.getSolvedByDifficulty(user.getId(), "Easy");

        long mediumSolved =
                submissionService.getSolvedByDifficulty(user.getId(), "Medium");

        long hardSolved =
                submissionService.getSolvedByDifficulty(user.getId(), "Hard");

        double acceptanceRate = (totalSubmissions == 0 ? 0.0 : (acceptedSubmissions * 100.0) / totalSubmissions);

        List<Submission> recentSubmissions =
                submissionService.getRecentSubmissions(user.getId());

        StreakSummary streakSummary =
                submissionService.getStreakSummary(user.getId());

        model.addAttribute("streakSummary", streakSummary);
        model.addAttribute("recentSubmissions", recentSubmissions);
        model.addAttribute("acceptanceRate", acceptanceRate);
        model.addAttribute("user", user);
        model.addAttribute("totalSolved", totalSolved);
        model.addAttribute("totalSubmissions", totalSubmissions);
        model.addAttribute("easySolved", easySolved);
        model.addAttribute("mediumSolved", mediumSolved);
        model.addAttribute("hardSolved", hardSolved);

        return "dashboard";
    }


    @GetMapping("/api/streak")
    @ResponseBody
    public StreakSummary getStreak() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("User not found")
                );

        return submissionService.getStreakSummary(user.getId());
    }
}
