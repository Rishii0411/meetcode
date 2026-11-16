package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.exception.ProblemNotFoundException;
import com.rishabh.meetcode.exception.ProblemUnavailableException;
import com.rishabh.meetcode.model.*;
import com.rishabh.meetcode.repo.UserRepository;
import com.rishabh.meetcode.service.CodeExecutionService;
import com.rishabh.meetcode.service.JavaHarnessService;
import com.rishabh.meetcode.service.ProblemService;
import com.rishabh.meetcode.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/problems")
public class ProblemController {

    private final ProblemService problemService;
    private final CodeExecutionService codeExecSer;
    private final JavaHarnessService harnessService;
    private final SubmissionService submissionService;
    private final UserRepository userRepository;


    @GetMapping("/{id}")
    public String showProblem(@PathVariable long id, Model model) {

        try {

            Problem problem = problemService.getActiveProblem(id);

            model.addAttribute("problem", problem);

            String starterCode =
                    problemService.generateStarterCode(problem);

            model.addAttribute("starterCode", starterCode);

            boolean hasSubmissions =
                    problemService.hasSubmissions(id);

            model.addAttribute("hasSubmissions", hasSubmissions);

            model.addAttribute(
                    "publicTestCases",
                    problem.getTestCases()
                            .stream()
                            .filter(TestCases::getIsPublic)
                            .toList()
            );

            return "problem";

        } catch (ProblemUnavailableException ex) {

            model.addAttribute(
                    "errorTitle",
                    "Problem Unavailable"
            );

            model.addAttribute(
                    "errorMessage",
                    ex.getMessage()
            );

            return "problem-unavailable";

        } catch (ProblemNotFoundException ex) {

            model.addAttribute(
                    "errorTitle",
                    "Problem Not Found"
            );

            model.addAttribute(
                    "errorMessage",
                    "This problem could not be found. It may have been permanently removed."
            );

            return "problem-unavailable";
        }
    }


    @PostMapping("/{id}/run")
    @ResponseBody
    public Map<String, Object> runSolution(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {

        Problem problem = problemService.getActiveProblem(id);

        String userCode = request.get("code");
        String input = request.getOrDefault("input", "");

        String referenceSolution = problem.getReferenceSolution();

        if (referenceSolution == null || referenceSolution.isBlank()) {
            return Map.of(
                    "verdict", "Configuration Error",
                    "message", "Reference solution is not configured for this problem."
            );
        }

        String userHarness = harnessService.createGenericHarness(
                userCode,
                problem,
                input
        );

        String referenceHarness = harnessService.createGenericHarness(
                referenceSolution,
                problem,
                input
        );

        Map<String, Object> actualResult =
                codeExecSer.executeJavaCode(userHarness, "");

        Map<String, Object> expectedResult =
                codeExecSer.executeJavaCode(referenceHarness, "");

        if (hasExecutionError(actualResult)) {
            return Map.of(
                    "verdict", "Execution Error",
                    "actualOutput", getExecutionMessage(actualResult),
                    "expectedOutput", getExecutionMessage(expectedResult)
            );
        }

        if (hasExecutionError(expectedResult)) {
            return Map.of(
                    "verdict", "Reference Solution Error",
                    "actualOutput", getOutput(actualResult),
                    "message", "Admin reference solution could not execute correctly."
            );
        }

        String actualOutput = getOutput(actualResult);
        String expectedOutput = getOutput(expectedResult);

        String verdict = actualOutput.trim().equals(expectedOutput.trim())
                ? "Accepted"
                : "Wrong Answer";

        return Map.of(
                "actualOutput", actualOutput,
                "expectedOutput", expectedOutput,
                "verdict", verdict
        );
    }


    @PostMapping("/{id}/submit")
    @ResponseBody
    public Map<String, Object> submitSolution(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {

        problemService.getActiveProblem(id);

        String code = request.get("code");

        return submissionService.Submit(id, code);
    }
    @GetMapping("/{id}/submissions")
    @ResponseBody
    public List<Submission> getSubmissions(@PathVariable Long id) {

        return submissionService.getSubmissionsByProblemId(id);
    }

    @GetMapping("/{problemId}/submissions/{submissionId}")
    @ResponseBody
    public Submission getSubmission(
            @PathVariable Long problemId,
            @PathVariable Long submissionId) {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        User user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));

        return submissionService.getSubmissionById(
                submissionId,
                problemId,
                user.getId()
        );
    }

    private boolean hasExecutionError(Map<String, Object> result) {

        if (result.get("compile_output") != null) {
            return true;
        }

        if (result.get("stderr") != null) {
            return true;
        }

        Object status = result.get("status");

        if (status instanceof Map<?, ?> statusMap) {
            Object statusId = statusMap.get("id");

            return statusId instanceof Number number
                    && number.intValue() != 3;
        }

        return true;
    }

    private String getOutput(Map<String, Object> result) {

        Object stdout = result.get("stdout");

        return stdout == null ? "" : stdout.toString();
    }

    private String getExecutionMessage(Map<String, Object> result) {

        if (result.get("compile_output") != null) {
            return result.get("compile_output").toString();
        }

        if (result.get("stderr") != null) {
            return result.get("stderr").toString();
        }

        Object status = result.get("status");

        if (status instanceof Map<?, ?> statusMap) {
            return String.valueOf(statusMap.get("description"));
        }

        return "Execution failed.";
    }

}
