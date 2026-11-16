package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.model.*;
import com.rishabh.meetcode.service.ProblemService;
import com.rishabh.meetcode.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.rishabh.meetcode.dto.StreakSummary;
import com.rishabh.meetcode.model.User;
import com.rishabh.meetcode.repo.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class MainPageController {

    private final ProblemService problemSer;
    private final SubmissionService submissionSer;
    private final UserRepository userRepository;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("problems", problemSer.findAll());
        model.addAttribute("tagCounts", problemSer.getTagCounts());
        model.addAttribute("companyCounts", problemSer.getCompanyCounts());
        model.addAttribute("problemCount",problemSer.getActiveProblemCount());
        model.addAttribute("SolvedProblemCount",submissionSer.getSolvedActiveProblemCount());
        model.addAttribute("acceptedProblemIds", submissionSer.getAcceptedProblemIdsForCurrentUser());


        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null &&
                authentication.isAuthenticated() &&
                !"anonymousUser".equals(authentication.getPrincipal())) {

            String username = authentication.getName();

            User user = userRepository.findByUsername(username)
                    .orElseThrow(() ->
                            new RuntimeException("User not found")
                    );

            StreakSummary streakSummary =
                    submissionSer.getStreakSummary(user.getId());

            model.addAttribute("streakSummary", streakSummary);

        }
        else
        {
            model.addAttribute("streakSummary", null);
        }
        return "index";
    }

    @GetMapping("/addproblem")
    public String createProblem(Model model) {

        model.addAttribute("isEdit", false);

        model.addAttribute(
                "companies",
                problemSer.getAllCompanies()
        );

        return "AddProblem";
    }


    @PostMapping("/addproblem")
    public String createProblem(
            @ModelAttribute Problem problem,
            @RequestParam String tagNames,
            @ModelAttribute TestCaseFormList testCaseFormList,
            @RequestParam(required = false) List<String> companyNames
    ) {
        Set<TestCases> testCases = new HashSet<>();

        if (testCaseFormList.getTestCaseForms() != null) {

            for (TestCaseForm form : testCaseFormList.getTestCaseForms()) {
                TestCases testCase = new TestCases();
                testCase.setInput(form.getInput());
                testCase.setExpectedOutput(form.getExpectedOutput());
                testCase.setPublic(form.isPublicTestCase());
                testCases.add(testCase);
            }
        }
        Problem savedProblem = problemSer.saveProblem(
                problem, tagNames, testCases, companyNames
        );

        return "redirect:/";
    }

    @GetMapping("/editproblem/{id}")
    public String editProblem(@PathVariable Long id, Model model) {

        Problem problem = problemSer.findById(id);

        List<TestCases> testCases =
                problemSer.getTestCasesByProblemId(id);

        String tagNames = problem.getTags()
                .stream()
                .map(Tag::getName)
                .collect(Collectors.joining(", "));

        model.addAttribute(
                "companies",
                problemSer.getAllCompanies()
        );

        model.addAttribute(
                "selectedCompanyIds",
                problem.getCompanies()
                        .stream()
                        .map(Company::getId)
                        .collect(Collectors.toSet())
        );
        model.addAttribute("problem", problem);
        model.addAttribute("testCases", testCases);
        model.addAttribute("tagNames", tagNames);
        model.addAttribute("isEdit", true);

        return "AddProblem";
    }


    @PostMapping("/editproblem/{id}")
    public String updateProblem(
            @PathVariable Long id,
            @ModelAttribute Problem problem,
            @RequestParam String tagNames,
            @ModelAttribute TestCaseFormList testCaseFormList,
            @RequestParam(required = false) List<String> companyNames
    ) {

        Set<TestCases> testCases = new HashSet<>();

        if (testCaseFormList.getTestCaseForms() != null) {

            for (TestCaseForm form : testCaseFormList.getTestCaseForms()) {

                TestCases testCase = new TestCases();

                testCase.setInput(form.getInput());
                testCase.setExpectedOutput(form.getExpectedOutput());
                testCase.setPublic(form.isPublicTestCase());

                testCases.add(testCase);
            }
        }

        problemSer.updateProblem(id, problem, tagNames, testCases, companyNames);

        return "redirect:/problems/" + id;
    }

    @PostMapping("/deleteproblem/{id}")
    public String deleteProblem(@PathVariable Long id) {

        try {
            problemSer.deleteProblem(id);
            return "redirect:/?deleted";

        } catch (IllegalStateException e) {

            return "redirect:/?error=" +
                    java.net.URLEncoder.encode(
                            e.getMessage(),
                            java.nio.charset.StandardCharsets.UTF_8
                    );
        }
    }


    @GetMapping("/companies/{id}")
    public String companyProblems(
            @PathVariable Long id,
            Model model
    ) {

        Company company = problemSer.getCompanyById(id);

        List<Problem> problems =
                problemSer.getProblemsByCompanyId(id);

        model.addAttribute("company", company);
        model.addAttribute("problems", problems);

        return "company-problems";
    }

}
