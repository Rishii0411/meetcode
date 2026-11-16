package com.rishabh.meetcode.service;

import com.rishabh.meetcode.model.Submission;
import com.rishabh.meetcode.model.TestCases;
import com.rishabh.meetcode.repo.SubmissionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.rishabh.meetcode.model.User;
import com.rishabh.meetcode.repo.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import com.rishabh.meetcode.dto.StreakSummary;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class SubmissionService {
    private final CodeExecutionService codeExecSer;
    private final JavaHarnessService javaHarnessSer;
    private final ProblemService probSer;
    private final SubmissionRepository submissionRepository;
    private final UserRepository userRepository;


    public Map<String, Object> Submit(Long id,String UserCode)
    {
        int passed = 0;
        String verdict = "";
        List<TestCases> testCases = probSer.getTestCasesByProblemId(id);

        for(TestCases testCase :testCases)
        {
            String input = testCase.getInput();

                String completeCode =
                javaHarnessSer.createGenericHarness(UserCode, id, input);

            Map<String, Object> result = codeExecSer.executeJavaCode(completeCode,"");


            Object statusObject = result.get("status");

            if (statusObject instanceof Map<?, ?> status) {
                Object descriptionObject = status.get("description");
                String description = (descriptionObject == null
                        ? ""
                        : descriptionObject.toString());

                if (!description.equals("Accepted")) {


                    if (description.contains("Compilation Error")) {
                        verdict = "Compilation Error";
                    } else if (description.contains("Time Limit")) {
                        verdict = "Time Limit Exceeded";
                    } else {
                        verdict = "Runtime Error";
                    }

                    saveSubmission(id, UserCode,verdict);
                    return Map.of(
                            "verdict", verdict,
                            "passedTestCase", passed,
                            "totalTestCases", testCases.size(),
                            "message", description
                    );
                }
            }

            Object stdout = result.get("stdout");

            String actualOutput = (stdout == null ? "": stdout.toString().trim());

            String expectedOutput =
                    testCase.getExpectedOutput().trim();
            String normalizedActual = actualOutput.replaceAll("\\s+", "");
            String normalizedExpected = expectedOutput.replaceAll("\\s+", "");

            if (!normalizedActual.equals(normalizedExpected)) {
                int testCaseSize  = testCases.size();
                verdict = "Wrong Answer";
                saveSubmission(id, UserCode, verdict);
                return Map.of(
                        "verdict", "Wrong Answer",
                        "passedTestCase",passed,
                        "totalTestCases", testCaseSize,
                        "input",input,
                        "expectedOutput", expectedOutput,
                        "actualOutput", actualOutput
                             );
            }
            passed++;
        }
        verdict = "Accepted";
        saveSubmission(id, UserCode, verdict);

        return Map.of(
                "verdict", verdict,
                "passedTestCase", passed,
                "totalTestCases", testCases.size()
        );
    }


    private void saveSubmission(Long problemId, String userCode, String verdict) {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("Logged-in user not found")
                );

        Submission submission = new Submission();

        submission.setCode(userCode);
        submission.setVerdict(verdict);
        submission.setLanguage("Java");
        submission.setSubmittedAt(LocalDateTime.now());
        submission.setProblem(probSer.findById(problemId));
        submission.setUser(user);

        submissionRepository.save(submission);
    }


    public List<Submission> getSubmissionsByProblemId(Long problemId) {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("Logged-in user not found")
                );
        return submissionRepository
                .findByProblem_IdAndUser_IdOrderBySubmittedAtDesc(problemId,user.getId());
    }


    public long getTotalProblemsSolved(Long userId) {
        return submissionRepository.countSolvedProblems(
                userId,
                "Accepted"
        );
    }

    public long getSolvedByDifficulty(Long userId, String difficulty) {
        return submissionRepository.countSolvedByDifficulty(
                userId,
                difficulty
        );
    }


    public long getTotalSubmissions(Long userId) {
        return submissionRepository.countByUser_Id(userId);
    }

    public long getAcceptedSubmissions(Long userId) {

        return submissionRepository.countByUser_IdAndVerdict(
                userId,
                "Accepted"
        );
    }

    public List<Submission> getRecentSubmissions(Long userId) {
        return submissionRepository.findByUser_IdOrderBySubmittedAtDesc(userId);
    }

    public Submission getSubmissionById(Long submissionId, Long problemId, Long userId) {

        return submissionRepository
                .findByIdAndProblem_IdAndUser_Id(submissionId, problemId, userId)
                .orElseThrow(() -> new RuntimeException("Submission not found"));
    }

    public long getSolvedActiveProblemCount() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null ||
                !authentication.isAuthenticated() ||
                "anonymousUser".equals(authentication.getPrincipal())) {

            return 0;
        }

        String username = authentication.getName();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("User not found")
                );

        return submissionRepository.countBySolvedActiveTrue(user.getId());
    }

    public Set<Long> getAcceptedProblemIdsForCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null ||
                !authentication.isAuthenticated() ||
                "anonymousUser".equals(authentication.getPrincipal())) {

            return Set.of();
        }

        User user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));

        return new HashSet<>(
                submissionRepository.findAcceptedProblemIdsByUserId(user.getId())
        );
    }

    public boolean hasSubmissionTodayForCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null ||
                !authentication.isAuthenticated() ||
                "anonymousUser".equals(authentication.getPrincipal())) {

            return false;
        }

        User user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));

        LocalDate today = LocalDate.now();

        return submissionRepository.existsSubmissionBetween(
                user.getId(),
                today.atStartOfDay(),
                today.plusDays(1).atStartOfDay()
        );
    }


    public Set<LocalDate> getUserActiveDates(Long userId) {

        List<LocalDateTime> acceptedTimestamps =
                submissionRepository.findAcceptedSubmissionTimestamps(userId);

        return acceptedTimestamps.stream()
                .map(LocalDateTime::toLocalDate)
                .collect(Collectors.toCollection(TreeSet::new));
    }


    public int getCurrentStreak(Set<LocalDate> activeDates) {

        LocalDate today = LocalDate.now();

        LocalDate currentDate;

        if (activeDates.contains(today)) {
            currentDate = today;
        } else if (activeDates.contains(today.minusDays(1))) {
            currentDate = today.minusDays(1);
        } else {
            return 0;
        }

        int streak = 0;

        while (activeDates.contains(currentDate)) {
            streak++;
            currentDate = currentDate.minusDays(1);
        }

        return streak;
    }

    public int getLongestStreak(Set<LocalDate> activeDates) {

        if (activeDates.isEmpty()) {
            return 0;
        }

        int currentStreak = 1;
        int longestStreak = 1;

        LocalDate previousDate = null;

        for (LocalDate date : activeDates) {

            if (previousDate != null) {

                long difference =
                        ChronoUnit.DAYS.between(previousDate, date);

                if (difference == 1) {
                    currentStreak++;
                } else {
                    currentStreak = 1;
                }
            }

            longestStreak = Math.max(longestStreak, currentStreak);

            previousDate = date;
        }

        return longestStreak;
    }

    public StreakSummary getStreakSummary(Long userId) {

        Set<LocalDate> activeDates = getUserActiveDates(userId);

        int currentStreak = getCurrentStreak(activeDates);

        int longestStreak = getLongestStreak(activeDates);

        return new StreakSummary(
                currentStreak,
                longestStreak,
                activeDates
        );
    }
}
