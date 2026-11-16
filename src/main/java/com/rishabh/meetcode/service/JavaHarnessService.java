package com.rishabh.meetcode.service;
import com.rishabh.meetcode.model.Problem;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class JavaHarnessService {

    private final ProblemService probser;
    private final JavaInputParserService inputParser;

    public String createGenericHarness(String userCode, Long problemId, String input) {

        Problem problem = probser.findById(problemId);

        List<String> arguments = inputParser.parseInput(
                input,
                problem.getParameterDefinitions()
        );

        String methodArguments = String.join(", ", arguments);

        String harness = """
            public class Main {
                public static void main(String[] args) {

                    Solution solution = new Solution();

                    var result = solution.%s(%s);

                    %s
                }
            }
            """.formatted(
                problem.getMethodName(),
                methodArguments,
                generateOutputStatement(problem.getReturnType())
        );
        return userCode + "\n" + harness;
    }

    private String generateOutputStatement(String returnType) {

        return switch (returnType) {

            case "int[]", "long[]", "double[]", "boolean[]", "String[]" ->
                    "System.out.println(java.util.Arrays.toString(result));";

            default ->
                    "System.out.println(result);";
        };
    }

    public String createGenericHarness(
            String userCode,
            Problem problem,
            String input
    ) {

        List<String> arguments = inputParser.parseInput(
                input,
                problem.getParameterDefinitions()
        );

        String methodArguments = String.join(", ", arguments);

        String harness = """
        public class Main {
            public static void main(String[] args) {

                Solution solution = new Solution();

                var result = solution.%s(%s);

                %s
            }
        }
        """.formatted(
                problem.getMethodName(),
                methodArguments,
                generateOutputStatement(problem.getReturnType())
        );

        return userCode + "\n" + harness;
    }
}
