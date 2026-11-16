<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.rishabh.meetcode.model.Problem" %>
<%@ page import="com.rishabh.meetcode.model.Tag" %>
<%@ page import="com.rishabh.meetcode.model.TestCases" %>
<%@ page import="java.util.List" %>

<%
    Problem problem = (Problem) request.getAttribute("problem");

    List<TestCases> publicTestCases =
            (List<TestCases>) request.getAttribute("publicTestCases");

    Long problemId = problem.getId();
    String contextPath = request.getContextPath();

    Authentication problemPageAuthentication =
            SecurityContextHolder.getContext().getAuthentication();

    boolean isAdmin = problemPageAuthentication != null
            && problemPageAuthentication.isAuthenticated()
            && problemPageAuthentication.getAuthorities().stream()
                .anyMatch(authority ->
                    "ROLE_ADMIN".equals(authority.getAuthority())
                );
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title><%= problem.getTitle() %> | MeetCode</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/globals.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/problem-details.css">

</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="lc-problem-page">

    <section class="problem-panel">

        <div class="lc-problem-header">
            <span class="problem-kicker">Problem</span>
            <h1><%= problem.getTitle() %></h1>

            <span class="badge <%= problem.getDifficulty().toLowerCase() %>">
                <%= problem.getDifficulty() %>
            </span>
        </div>

<% if (isAdmin) { %>

    <div class="lc-admin-actions">

        <a href="<%= contextPath %>/editproblem/<%= problemId %>"
           class="lc-edit-problem-btn btn btn-ghost btn-sm">
            Edit Problem
        </a>

        <form action="<%= contextPath %>/deleteproblem/<%= problemId %>"
              method="post"
              style="display: inline;"
              onsubmit="return confirm('<%= Boolean.TRUE.equals(request.getAttribute("hasSubmissions"))
                      ? "This problem has submissions. It will be deactivated and existing submissions will be preserved. Continue?"
                      : "This problem has no submissions. It will be permanently deleted. Continue?" %>');">

            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">

            <% if (Boolean.TRUE.equals(request.getAttribute("hasSubmissions"))) { %>

                <button type="submit" class="deactivate-btn btn btn-ghost btn-sm">
                    Deactivate Problem
                </button>

            <% } else { %>

                <button type="submit" class="delete-problem-btn btn btn-danger btn-sm">
                    Delete Problem
                </button>

            <% } %>

        </form>

    </div>

<% } %>

        <div class="lc-problem-description">
            <%= problem.getDescription() %>
        </div>

        <div class="lc-problem-examples">
            <%= problem.getExamples() %>
        </div>

        <div class="lc-problem-constraints">
            <%= problem.getConstraints() %>
        </div>

        <div class="lc-problem-tags">
            <% for (Tag tag : problem.getTags()) { %>
                <span class="tag-chip"><%= tag.getName() %></span>
            <% } %>
        </div>

        <div class="lc-problem-test-cases">

            <h2>Examples</h2>

            <% if (publicTestCases != null && !publicTestCases.isEmpty()) { %>

                <% for (TestCases testCase : publicTestCases) { %>

                    <div class="lc-test-case">

                        <h3>Input</h3>
                        <pre><%= testCase.getInput() %></pre>

                        <h3>Expected Output</h3>
                        <pre><%= testCase.getExpectedOutput() %></pre>

                    </div>

                <% } %>

            <% } else { %>

                <p>No public examples available for this problem yet.</p>

            <% } %>

        </div>

        <div class="lc-submission-section">
            <div id="submissionsPanel" style="display: none;">

                <div id="submissionList">
                </div>

                <div id="submissionDetails" style="display: none;">

                    <h3>Submission Details</h3>

                    <p id="submissionVerdict"></p>

                    <p id="submissionLanguage"></p>

                    <p id="submissionDate"></p>

                    <h4>Submitted Code</h4>

                    <pre id="submissionCode"></pre>

                    <button id="loadCodeBtn" class="btn btn-ghost btn-sm" type="button">
                        Load this code in Editor
                    </button>

                </div>

            </div>

        </div>

    </section>

    <div class="lc-workspace">

    <div class="lc-editor-container">

        <div class="lc-editor-header">
            <span class="editor-language">Java</span>
            <span class="editor-hint">Write your solution</span>
        </div>

        <textarea id="starterCode" hidden><c:out value="${starterCode}"/></textarea>

        <div id="editor"></div>

        <div class="lc-output-panel">

           <div class="lc-input-section">

               <h3>Custom Input</h3>

               <div id="parameterInputs"></div>


           </div>

            <div class="lc-result-section">

                <h3>Output</h3>

                <pre id="output">Click Run to see results.</pre>

            </div>

        </div>

    </div>

    <div class="lc-action-bar">

        <button id="submissionsTab"
                class="btn btn-ghost"
                type="button"
                onclick="loadSubmissions()">
            Submissions
        </button>

        <button id="runBtn" class="btn btn-ghost" type="button"
                title="Run with custom input (⌘ + ')">Run</button>

        <button id="submitBtn" class="btn btn-primary" type="button"
                title="Submit against all test cases (⌘ + Enter)">Submit</button>

    </div>

    </div>

</div>



<script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs/loader.min.js"></script>

<script>


    const problemId = <%= problemId %>;
    const contextPath = "<%= contextPath %>";
    const parameterDefinitions ="<%= problem.getParameterDefinitions() %>";


function generateParameterInputs() {

    const container = document.getElementById("parameterInputs");

    container.innerHTML = "";

    const parameters = parameterDefinitions.split(",");

    parameters.forEach(parameter => {

        const parts = parameter.trim().split(/\s+/);

        const type = parts[0];
        const name = parts[1];

        const inputGroup = document.createElement("div");
        inputGroup.classList.add("parameter-input-group");

        const label = document.createElement("label");
        label.textContent = name;


        const input = document.createElement("input");

        input.type = "text";
        input.classList.add("parameter-input");

        input.dataset.name = name;
        input.dataset.type = type;

        if (
            type === "int[]" ||
            type === "long[]" ||
            type === "double[]" ||
            type === "float[]"
        ) {
            input.placeholder = "[1, 2, 3]";
        }
        else if (type === "boolean[]") {
            input.placeholder = "[true, false, true]";
        }
        else if (type === "String[]") {
            input.placeholder = '["apple", "hello world", "mango"]';
        }
        else if (type === "boolean") {
            input.placeholder = "true or false";
        }
        else if (type === "double" || type === "float") {
            input.placeholder = "Enter decimal number";
        }
        else {
            input.placeholder = "Enter " + name;
        }


        inputGroup.appendChild(label);
        inputGroup.appendChild(input);

        container.appendChild(inputGroup);

    });
}
        generateParameterInputs();


    require.config({
        paths: {
            vs: "https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs"
        }
    });

    require(["vs/editor/editor.main"], function () {

        window.codeEditor = monaco.editor.create(
            document.getElementById("editor"),
            {
                value: document.getElementById("starterCode").value,

                language: "java",
                theme: "vs-dark",
                automaticLayout: true,

                minimap: {
                    enabled: false
                },

                fontSize: 14,
                tabSize: 4,
                scrollBeyondLastLine: false
            }
        );


        const urlParams = new URLSearchParams(window.location.search);

        const submissionId = urlParams.get("submissionId");


        if (submissionId) {
            loadSelectedSubmission(submissionId);
        }

    });




    function getCsrfHeaders() {

        const csrfToken = document.querySelector(
            'meta[name="_csrf"]'
        ).getAttribute("content");

        const csrfHeader = document.querySelector(
            'meta[name="_csrf_header"]'
        ).getAttribute("content");

        return {
            "Content-Type": "application/json",
            [csrfHeader]: csrfToken
        };
    }




    document.getElementById("runBtn").addEventListener("click", async function () {

        const code = window.codeEditor.getValue();

        let input;

        try {
            input = buildCustomInput();
        } catch (error) {
            document.getElementById("output").textContent = error.message;
            return;
        }

        const outputElement = document.getElementById("output");

        const runButton = document.getElementById("runBtn");

        runButton.disabled = true;

        outputElement.textContent = "Compiling and running your code...";

        try {

            const response = await fetch(
                contextPath + "/problems/" + problemId + "/run",
                {
                    method: "POST",

                    headers: getCsrfHeaders(),

                    body: JSON.stringify({
                        code: code,
                        input: input
                    })
                }
            );

            if (!response.ok) {
                throw new Error("Server returned status " + response.status);
            }

           const result = await response.json();

           if (result.verdict === "Execution Error") {

               outputElement.textContent =
                   "Execution Error\n\n" +
                   "Actual Output:\n" +
                   result.actualOutput +
                   "\n\nExpected Output:\n" +
                   result.expectedOutput;

           } else if (result.verdict === "Reference Solution Error" ||
                      result.verdict === "Configuration Error") {

               outputElement.textContent =
                   result.verdict + "\n\n" + result.message;

           } else {

               outputElement.textContent =
                   "Verdict: " + result.verdict +
                   "\n\nActual Output:\n" +
                   result.actualOutput +
                   "\n\nExpected Output:\n" +
                   result.expectedOutput;

           }

        } catch (error) {

            console.error("Execution failed:", error);

            outputElement.textContent = "Error: " + error.message;

        } finally {

            runButton.disabled = false;

        }

    });




    document.getElementById("submitBtn").addEventListener("click", async function () {

        const code = window.codeEditor.getValue();

        const outputElement = document.getElementById("output");

        const submitButton = document.getElementById("submitBtn");

        submitButton.disabled = true;

        outputElement.textContent = "Running all test cases...";

        try {

            const response = await fetch(
                contextPath + "/problems/" + problemId + "/submit",
                {
                    method: "POST",

                    headers: getCsrfHeaders(),

                    body: JSON.stringify({
                        code: code
                    })
                }
            );

            if (!response.ok) {
                throw new Error("Server returned status " + response.status);
            }

            const result = await response.json();

            outputElement.textContent =
                "Verdict: " + result.verdict +

                "\nPassed Test Cases: " +
                (result.passedTestCase ?? 0) +
                "/" +
                (result.totalTestCases ?? 0) +

                (result.input !== undefined
                    ? "\nFor input: " + result.input
                    : "") +

                (result.message
                    ? "\n" + result.message
                    : "") +

                (result.expectedOutput !== undefined
                    ? "\nExpected: " + result.expectedOutput
                    : "") +

                (result.actualOutput !== undefined
                    ? "\nActual: " + result.actualOutput
                    : "");

        } catch (error) {

            console.error("Submission failed:", error);

            outputElement.textContent = "Submission error: " + error.message;

        } finally {

            submitButton.disabled = false;

        }

    });




    document.addEventListener("keydown", function (event) {


        if (event.repeat) {
            return;
        }


        if (event.metaKey && event.key === "'") {

            event.preventDefault();

            document.getElementById("runBtn").click();

        }


        else if (event.metaKey && event.key === "Enter") {

            event.preventDefault();

            document.getElementById("submitBtn").click();

        }

    });




    async function loadSelectedSubmission(submissionId) {

        try {

            const response = await fetch(
                contextPath + "/problems/" + problemId +
                "/submissions/" + submissionId
            );

            if (!response.ok) {
                throw new Error("Unable to fetch selected submission");
            }

            const submission = await response.json();


            window.codeEditor.setValue(submission.code);

            console.log("Previous submission code loaded successfully.");

        } catch (error) {

            console.error("Error loading selected submission:", error);

        }

    }




    async function loadSubmissions() {

        const panel = document.getElementById("submissionsPanel");

        const submissionList = document.getElementById("submissionList");


        if (panel.style.display === "block") {

            panel.style.display = "none";

            return;

        }

        panel.style.display = "block";

        submissionList.textContent = "Loading submissions...";

        try {


            const response = await fetch(
                contextPath + "/problems/" + problemId + "/submissions"
            );

            if (!response.ok) {
                throw new Error("Failed to fetch submissions. Status: " + response.status);
            }

            const submissions = await response.json();

            if (submissions.length === 0) {

                submissionList.textContent = "No submissions yet.";

                return;

            }

            submissionList.innerHTML = "";

            submissions.forEach(submission => {

                const submissionItem = document.createElement("div");

                submissionItem.classList.add("lc-submission-item");

                const verdictClass =
                    submission.verdict === "Accepted" ? "verdict-accepted" :
                    submission.verdict === "Wrong Answer" ? "verdict-wrong" :
                    "verdict-error";



                const paragraph = document.createElement("p");

                const verdictElement = document.createElement("strong");

                verdictElement.classList.add(
                    "submission-verdict",
                    verdictClass
                );

                verdictElement.textContent = submission.verdict;

                paragraph.appendChild(verdictElement);

                paragraph.appendChild(
                    document.createTextNode(
                        " | " +
                        submission.language +
                        " | " +
                        new Date(submission.submittedAt).toLocaleString()
                    )
                );

                submissionItem.appendChild(paragraph);

                submissionItem.style.cursor = "pointer";



                submissionItem.addEventListener("click", function () {

                    const detailsPanel = document.getElementById("submissionDetails");

                    detailsPanel.style.display = "block";

                    document.getElementById("submissionVerdict").textContent =
                        "Verdict: " + submission.verdict;

                    document.getElementById("submissionLanguage").textContent =
                        "Language: " + submission.language;

                    document.getElementById("submissionDate").textContent =
                        "Submitted At: " +
                        new Date(submission.submittedAt).toLocaleString();

                    document.getElementById("submissionCode").textContent =
                        submission.code;


                    window.selectedSubmission = submission;

                });


                submissionList.appendChild(submissionItem);

            });

        } catch (error) {

            submissionList.textContent = "Unable to load submissions.";

            console.error("Submission history error:", error);

        }

    }




    document.getElementById("loadCodeBtn").addEventListener("click", function () {

        if (!window.selectedSubmission) {
            return;
        }

        window.codeEditor.setValue(window.selectedSubmission.code);

        document.getElementById("submissionDetails").style.display = "none";

        document.getElementById("editor").scrollIntoView({
            behavior: "smooth"
        });

    });



function buildCustomInput() {

    const inputs = document.querySelectorAll(".parameter-input");
    const values = [];

    inputs.forEach(input => {

        const value = input.value.trim();
        const type = input.dataset.type;
        const name = input.dataset.name;

        if (value === "") {
            throw new Error("Please enter a value for " + name + ".");
        }

        if (type === "String[]") {

            let stringValues;

            try {
                stringValues = JSON.parse(value);
            } catch (error) {
                throw new Error(
                    name + " must be a valid JSON array, e.g. [\"apple\", \"hello world\"]"
                );
            }

            if (
                !Array.isArray(stringValues) ||
                !stringValues.every(item => typeof item === "string")
            ) {
                throw new Error(
                    name + " must contain only strings."
                );
            }

            if (stringValues.some(item => item.includes("\n") || item.includes("\r"))) {
                throw new Error(
                    "String array elements cannot contain line breaks."
                );
            }

            values.push(String(stringValues.length));
            values.push(...stringValues);

        }

        else if (
            type === "int[]" ||
            type === "long[]" ||
            type === "double[]" ||
            type === "float[]" ||
            type === "boolean[]"
        ) {

            let arrayText = value;

            if (arrayText.startsWith("[") && arrayText.endsWith("]")) {
                arrayText = arrayText.slice(1, -1).trim();
            }
            else if (arrayText.includes("[") || arrayText.includes("]")) {
                throw new Error("Invalid array format for " + name);
            }

            if (arrayText === "") {
                values.push("0");
                return;
            }

            const elements = arrayText.split(",").map(item => item.trim());

            if (elements.some(item => item === "")) {
                throw new Error("Invalid array elements for " + name);
            }

            elements.forEach(item => {

                if (type === "int[]" && !/^-?\d+$/.test(item)) {
                    throw new Error(name + " must contain valid integers.");
                }

                if (type === "long[]" && !/^-?\d+$/.test(item)) {
                    throw new Error(name + " must contain valid long values.");
                }

                if (
                    (type === "double[]" || type === "float[]") &&
                    !/^-?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(item)
                ) {
                    throw new Error(name + " must contain valid decimal numbers.");
                }

                if (
                    type === "boolean[]" &&
                    item !== "true" &&
                    item !== "false"
                ) {
                    throw new Error(name + " must contain only true or false.");
                }
            });

            values.push(String(elements.length));
            values.push(elements.join(" "));

        }

        else {

            if (type === "int" && !/^-?\d+$/.test(value)) {
                throw new Error(name + " must be a valid integer.");
            }

            if (type === "long" && !/^-?\d+$/.test(value)) {
                throw new Error(name + " must be a valid long value.");
            }

            if (
                (type === "double" || type === "float") &&
                !/^-?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(value)
            ) {
                throw new Error(name + " must be a valid decimal number.");
            }

            if (
                type === "boolean" &&
                value !== "true" &&
                value !== "false"
            ) {
                throw new Error(name + " must be true or false.");
            }

            values.push(value);
        }

    });

    return values.join("\n");
}


</script>


<%@ include file="footer.jsp" %>

</body>
</html>
