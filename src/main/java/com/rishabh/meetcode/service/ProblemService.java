
package com.rishabh.meetcode.service;

import com.rishabh.meetcode.exception.ProblemNotFoundException;
import com.rishabh.meetcode.exception.ProblemUnavailableException;
import com.rishabh.meetcode.model.Company;
import com.rishabh.meetcode.model.Problem;
import com.rishabh.meetcode.model.Tag;
import com.rishabh.meetcode.model.TestCases;
import com.rishabh.meetcode.repo.*;

import lombok.RequiredArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ProblemService {

    private final ProblemRepository problemRepository;
    private final TagRepository tagRepo;
    private final TestCasesRepository testRepo;
    private final SubmissionRepository submissionRepository;
    private final CompanyRepository companyRepository;




    private Set<Company> resolveCompanies(List<String> companyNames) {

        Set<Company> companies = new HashSet<>();

        if (companyNames == null) {
            return companies;
        }

        for (String name : companyNames) {

            if (name == null || name.trim().isEmpty()) {
                continue;
            }

            String companyName = name.trim();

            Company company = companyRepository
                    .findByNameIgnoreCase(companyName)
                    .orElseGet(() -> {
                        Company newCompany = new Company();
                        newCompany.setName(companyName);
                        return companyRepository.save(newCompany);
                    });

            companies.add(company);
        }

        return companies;
    }

    @Transactional
    public Problem saveProblem(
            Problem problem,
            String tagNames,
            Set<TestCases> testCase,
            List<String> companyNames
    ) {

        Set<Tag> finalTags = new HashSet<>();

        if (tagNames != null && !tagNames.trim().isEmpty()) {

            String[] names = tagNames.split(",");

            for (String name : names) {

                String tagName = name.trim();

                if (tagName.isEmpty()) {
                    continue;
                }

                Tag tag = tagRepo.findByName(tagName)
                        .orElseGet(() -> {
                            Tag newTag = new Tag();
                            newTag.setName(tagName);
                            return tagRepo.save(newTag);
                        });

                finalTags.add(tag);
            }
        }

        problem.setTags(finalTags);

        problem.setCompanies(resolveCompanies(companyNames));

        Problem savedProblem = problemRepository.save(problem);

        for (TestCases cases : testCase) {
            cases.setProblem(savedProblem);
            testRepo.save(cases);
        }

        return savedProblem;
    }


    public Problem findById(long id) {
        return problemRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Problem not found with id: " + id)
                );
    }

    public List<TestCases> getTestCasesByProblemId(Long problemId) {
        return testRepo.findByProblem_id(problemId);
    }

    public String getHarness(Long problemId) {
        Problem problem = findById(problemId);
        return problem.getHarnessTemplate();
    }

    public List<Object[]> getTagCounts() {
        return tagRepo.findTagCounts();
    }

    @Transactional
    public void deleteProblem(Long problemId) {

        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Problem not found with id: " + problemId
                        )
                );

        if (submissionRepository.existsByProblem_Id(problemId)) {

            problem.setActive(false);

            problemRepository.save(problem);

            return;
        }

        problem.getTags().clear();

        testRepo.deleteAllByProblemId(problemId);

        problemRepository.delete(problem);
    }


    @Transactional
    public Problem updateProblem(
            Long problemId,
            Problem updatedProblem,
            String tagNames,
            Set<TestCases> newTestCases,
            List<String> companyNames
    ){
        Problem existingProblem = findById(problemId);

        existingProblem.setTitle(updatedProblem.getTitle());
        existingProblem.setDescription(updatedProblem.getDescription());
        existingProblem.setDifficulty(updatedProblem.getDifficulty());
        existingProblem.setCategory(updatedProblem.getCategory());
        existingProblem.setExamples(updatedProblem.getExamples());
        existingProblem.setMethodName(updatedProblem.getMethodName());
        existingProblem.setReturnType(updatedProblem.getReturnType());
        existingProblem.setParameterDefinitions(
                updatedProblem.getParameterDefinitions()
        );
        existingProblem.setReferenceSolution(
                updatedProblem.getReferenceSolution()
        );

        Set<Tag> finalTags = new HashSet<>();

        if (tagNames != null && !tagNames.trim().isEmpty()) {
            String[] names = tagNames.split(",");

            for (String name : names) {
                String tagName = name.trim();

                if (tagName.isEmpty()) {
                    continue;
                }

                Tag tag = tagRepo.findByName(tagName)
                        .orElseGet(() -> {
                            Tag newTag = new Tag();
                            newTag.setName(tagName);
                            return tagRepo.save(newTag);
                        });

                finalTags.add(tag);
            }
        }

        existingProblem.getTags().clear();
        existingProblem.getTags().addAll(finalTags);
        Set<Company> finalCompanies = resolveCompanies(companyNames);

        existingProblem.getCompanies().clear();
        existingProblem.getCompanies().addAll(finalCompanies);

        testRepo.deleteAllByProblemId(problemId);

        for (TestCases testCase : newTestCases) {
            testCase.setProblem(existingProblem);
            testRepo.save(testCase);
        }

        return problemRepository.save(existingProblem);
    }

    public List<Problem> findAll() {
        return problemRepository.findByActiveTrueAndDeletedFalse();
    }

    public Problem getActiveProblem(Long problemId) {

        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() ->
                        new ProblemNotFoundException(
                                "Problem not found with id: " + problemId
                        )
                );

        if (problem.isDeleted()) {
            throw new ProblemUnavailableException(
                    "This problem has been permanently deleted."
            );
        }

        if (!problem.isActive()) {
            throw new ProblemUnavailableException(
                    "This problem is currently inactive."
            );
        }

        return problem;
    }

    public List<Problem> getInactiveProblems() {
        return problemRepository.findByActiveFalseAndDeletedFalse();
    }

    @Transactional
    public void reactivateProblem(Long problemId) {

        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() ->
                        new RuntimeException("Problem not found")
                );

        if (problem.isDeleted()) {
            throw new IllegalStateException(
                    "This problem has been permanently deleted."
            );
        }

        problem.setActive(true);

        problemRepository.save(problem);
    }

    @Transactional
    public void permanentlyDeleteProblem(Long problemId) {

        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() ->
                        new RuntimeException("Problem not found")
                );

        if (problem.isActive()) {
            throw new IllegalStateException(
                    "Only inactive problems can be permanently deleted."
            );
        }

        if (problem.isDeleted()) {
            throw new IllegalStateException(
                    "Problem has already been permanently deleted."
            );
        }

        boolean hasSubmissions =
                submissionRepository.existsByProblem_Id(problemId);

        problem.getTags().clear();

        testRepo.deleteAllByProblemId(problemId);

        if (hasSubmissions) {

            problem.setDescription(null);
            problem.setExamples(null);
            problem.setConstraints(null);
            problem.setHarnessTemplate(null);
            problem.setReferenceSolution(null);
            problem.setMethodName(null);
            problem.setReturnType(null);
            problem.setParameterDefinitions(null);

            problem.setActive(false);
            problem.setDeleted(true);

            problemRepository.save(problem);

        } else {

            problemRepository.delete(problem);
        }
    }

    public boolean hasSubmissions(Long problemId) {
        return submissionRepository.existsByProblem_Id(problemId);
    }

    public String generateStarterCode(Problem problem) {

        String methodName = problem.getMethodName();
        String returnType = problem.getReturnType();
        String parameters = problem.getParameterDefinitions();

        if (parameters == null) {
            parameters = "";
        }

        return "class Solution {\n" +
                "    public " + returnType + " " + methodName +
                "(" + parameters + ") {\n" +
                "        // Write your code here\n\n" +
                "    }\n" +
                "}";
    }

    public List<Company> getAllCompanies() {
        return companyRepository.findAllByOrderByNameAsc();
    }

    public List<Object[]> getCompanyCounts() {
        return companyRepository.findCompanyProblemCounts();
    }

    public Company getCompanyById(Long companyId) {

        return companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException("Company not found with id: " + companyId)
                );
    }

    public List<Problem> getProblemsByCompanyId(Long companyId) {

        return problemRepository
                .findByCompanies_IdAndActiveTrueAndDeletedFalse(companyId);
    }

    public long getActiveProblemCount() {
        return problemRepository.countByActiveTrue();
    }


}
