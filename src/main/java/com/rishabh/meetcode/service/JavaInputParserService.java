package com.rishabh.meetcode.service;

import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class JavaInputParserService {

    public List<String> parseInput(String input, String parameterDefinitions) {

        if (input == null || input.isBlank()) {
            throw new IllegalArgumentException("Input cannot be empty.");
        }

        List<String> types = extractParameterTypes(parameterDefinitions);
        List<String> arguments = new ArrayList<>();

        String[] lines = input.split("\\R", -1);
        int lineIndex = 0;

        for (String type : types) {

            if (lineIndex >= lines.length) {
                throw new IllegalArgumentException(
                        "Insufficient input. Missing value for parameter type: " + type
                );
            }

            switch (type) {

                case "int": {
                    String value = lines[lineIndex++].trim();
                    validateInt(value);
                    arguments.add(value);
                    break;
                }

                case "long": {
                    String value = lines[lineIndex++].trim();
                    validateLong(value);
                    arguments.add(value + "L");
                    break;
                }

                case "double": {
                    String value = lines[lineIndex++].trim();
                    validateDouble(value);
                    arguments.add(value);
                    break;
                }

                case "float": {
                    String value = lines[lineIndex++].trim();
                    validateFloat(value);
                    arguments.add(value + "f");
                    break;
                }

                case "boolean": {
                    String value = lines[lineIndex++].trim();
                    validateBoolean(value);
                    arguments.add(value);
                    break;
                }

                case "String": {
                    String value = lines[lineIndex++];
                    arguments.add("\"" + escapeJavaString(value) + "\"");
                    break;
                }

                case "int[]": {
                    arguments.add(parseNumericArray(lines, type, lineIndex));
                    lineIndex = updateLineIndex(lines, lineIndex);
                    break;
                }

                case "long[]": {
                    arguments.add(parseNumericArray(lines, type, lineIndex));
                    lineIndex = updateLineIndex(lines, lineIndex);
                    break;
                }

                case "double[]": {
                    arguments.add(parseNumericArray(lines, type, lineIndex));
                    lineIndex = updateLineIndex(lines, lineIndex);
                    break;
                }

                case "float[]": {
                    arguments.add(parseNumericArray(lines, type, lineIndex));
                    lineIndex = updateLineIndex(lines, lineIndex);
                    break;
                }

                case "boolean[]": {
                    arguments.add(parseBooleanArray(lines, lineIndex));
                    lineIndex = updateLineIndex(lines, lineIndex);
                    break;
                }

                case "String[]": {
                    int size = parseArraySize(lines[lineIndex++]);

                    if (size == 0) {
                        arguments.add("new String[]{}");
                        break;
                    }

                    List<String> stringValues = new ArrayList<>();

                    for (int i = 0; i < size; i++) {

                        if (lineIndex >= lines.length) {
                            throw new IllegalArgumentException(
                                    "Missing String array element."
                            );
                        }

                        String value = lines[lineIndex++];

                        if (value.contains("\n") || value.contains("\r")) {
                            throw new IllegalArgumentException(
                                    "String array elements cannot contain line breaks."
                            );
                        }

                        stringValues.add(
                                "\"" + escapeJavaString(value) + "\""
                        );
                    }

                    arguments.add(
                            "new String[]{" + String.join(",", stringValues) + "}"
                    );

                    break;
                }

                default:
                    throw new IllegalArgumentException(
                            "Unsupported parameter type: " + type
                    );
            }
        }

        if (lineIndex < lines.length) {
            throw new IllegalArgumentException(
                    "Unexpected extra input: " + lines[lineIndex]
            );
        }

        return arguments;
    }

    private String parseNumericArray(
            String[] lines,
            String type,
            int lineIndex
    ) {

        int size = parseArraySize(lines[lineIndex]);

        if (size == 0) {
            return "new " + type + "{}";
        }

        if (lineIndex + 1 >= lines.length) {
            throw new IllegalArgumentException(
                    "Missing array elements for parameter: " + type
            );
        }

        String[] values = lines[lineIndex + 1].trim().split("\\s+");

        if (values.length != size) {
            throw new IllegalArgumentException(
                    "Array size does not match the provided input."
            );
        }

        List<String> javaValues = new ArrayList<>();

        for (String value : values) {

            switch (type) {

                case "int[]":
                    validateInt(value);
                    javaValues.add(value);
                    break;

                case "long[]":
                    validateLong(value);
                    javaValues.add(value + "L");
                    break;

                case "double[]":
                    validateDouble(value);
                    javaValues.add(value);
                    break;

                case "float[]":
                    validateFloat(value);
                    javaValues.add(value + "f");
                    break;
            }
        }

        return "new " + type + "{"
                + String.join(",", javaValues) + "}";
    }

    private String parseBooleanArray(String[] lines, int lineIndex) {

        int size = parseArraySize(lines[lineIndex]);

        if (size == 0) {
            return "new boolean[]{}";
        }

        if (lineIndex + 1 >= lines.length) {
            throw new IllegalArgumentException(
                    "Missing boolean array elements."
            );
        }

        String[] values = lines[lineIndex + 1].trim().split("\\s+");

        if (values.length != size) {
            throw new IllegalArgumentException(
                    "Array size does not match the provided input."
            );
        }

        for (String value : values) {
            validateBoolean(value);
        }

        return "new boolean[]{" + String.join(",", values) + "}";
    }

    private int updateLineIndex(String[] lines, int lineIndex) {

        int size = parseArraySize(lines[lineIndex]);

        if (size == 0) {
            return lineIndex + 1;
        }

        return lineIndex + 2;
    }

    private List<String> extractParameterTypes(String parameterDefinitions) {

        if (parameterDefinitions == null || parameterDefinitions.isBlank()) {
            throw new IllegalArgumentException(
                    "Parameter definitions cannot be empty."
            );
        }

        List<String> types = new ArrayList<>();

        String[] parameters = parameterDefinitions.split(",");

        for (String parameter : parameters) {

            if (parameter.isBlank()) {
                throw new IllegalArgumentException(
                        "Invalid parameter definition: empty parameter found."
                );
            }

            String[] parts = parameter.trim().split("\\s+");

            if (parts.length != 2) {
                throw new IllegalArgumentException(
                        "Invalid parameter definition: " + parameter
                );
            }

            types.add(parts[0]);
        }

        return types;
    }

    private int parseArraySize(String value) {

        try {
            int size = Integer.parseInt(value.trim());

            if (size < 0) {
                throw new IllegalArgumentException(
                        "Array size cannot be negative."
                );
            }

            return size;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Array size must be a valid integer."
            );
        }
    }

    private void validateInt(String value) {

        try {
            Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid integer value: " + value
            );
        }
    }

    private void validateLong(String value) {

        try {
            Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid long value: " + value
            );
        }
    }

    private void validateDouble(String value) {

        try {
            double number = Double.parseDouble(value);

            if (!Double.isFinite(number)) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid double value: " + value
            );
        }
    }

    private void validateFloat(String value) {

        try {
            float number = Float.parseFloat(value);

            if (!Float.isFinite(number)) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid float value: " + value
            );
        }
    }

    private void validateBoolean(String value) {

        if (!value.equals("true") && !value.equals("false")) {
            throw new IllegalArgumentException(
                    "Boolean value must be true or false."
            );
        }
    }

    private String escapeJavaString(String value) {

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\t", "\\t")
                .replace("\r", "\\r");
    }
}
