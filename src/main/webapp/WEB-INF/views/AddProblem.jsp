<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rishabh.meetcode.model.Problem" %>
<%@ page import="com.rishabh.meetcode.model.TestCases" %>
<%@ page import="com.rishabh.meetcode.model.Company" %>
<%@ page import="java.util.Set" %>

<%!
    private String esc(Object value) {
        return org.springframework.web.util.HtmlUtils.htmlEscape(
            value == null ? "" : value.toString()
        );
    }
%>

<%
    boolean isEdit = Boolean.TRUE.equals(request.getAttribute("isEdit"));

    Problem problem = (Problem) request.getAttribute("problem");

    List<TestCases> existingTestCases =
        (List<TestCases>) request.getAttribute("testCases");

    String tagNames = (String) request.getAttribute("tagNames");

    if (tagNames == null) {
        tagNames = "";
    }

    int testCaseCount = 0;
    List<Company> companies =
        (List<Company>) request.getAttribute("companies");

    Set<Long> selectedCompanyIds =
        (Set<Long>) request.getAttribute("selectedCompanyIds");

    if (companies == null) {
        companies = new java.util.ArrayList<>();
    }

    if (selectedCompanyIds == null) {
        selectedCompanyIds = new java.util.HashSet<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">

    <title><%= isEdit ? "Edit Problem" : "Add Problem" %> | MeetCode</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/globals.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/add-problem.css">
</head>

<body class="add-problem-page">

<%@ include file="navbar.jsp" %>

<main class="admin-page">

    <div class="admin-page-header">
        <h1><%= isEdit ? "Edit Problem" : "Create New Problem" %></h1>

        <p>
            <%= isEdit
                ? "Update the problem details, method configuration and test cases."
                : "Configure the problem details, Java method and test cases for your coding platform." %>
        </p>
    </div>

    <form id="problemForm"
      action="<%= isEdit
       ? request.getContextPath() + "/editproblem/" + problem.getId()
       : request.getContextPath() + "/addproblem" %>"
      method="post">

    <input type="hidden"
           name="${_csrf.parameterName}"
           value="${_csrf.token}">



    <section class="form-section">

        <h3>Problem Details</h3>

        <div class="field">
            <label for="fieldTitle">Title</label>

            <input type="text"
                   id="fieldTitle"
                   class="form-input"
                   name="title"
                   placeholder="Problem title"
                   value="<%= isEdit ? esc(problem.getTitle()) : "" %>"
                   required>
        </div>


        <div class="field">
            <label for="fieldDescription">Description</label>

            <textarea id="fieldDescription"
                      class="form-input"
                      name="description"
                      placeholder="Problem Description"
                      rows="8"
                      required><%= isEdit ? esc(problem.getDescription()) : "" %></textarea>
        </div>


        <div class="field-row">


            <div class="field">
                <label for="fieldDifficulty">Difficulty</label>

                <select id="fieldDifficulty" class="form-input" name="difficulty" required>

                    <option value="Easy"
                        <%= isEdit && "Easy".equals(problem.getDifficulty())
                            ? "selected" : "" %>>
                        Easy
                    </option>

                    <option value="Medium"
                        <%= isEdit && "Medium".equals(problem.getDifficulty())
                            ? "selected" : "" %>>
                        Medium
                    </option>

                    <option value="Hard"
                        <%= isEdit && "Hard".equals(problem.getDifficulty())
                            ? "selected" : "" %>>
                        Hard
                    </option>

                </select>
            </div>



            <div class="field">
                <label for="fieldCategory">Problem Category</label>

                <select id="fieldCategory" class="form-input" name="category" required>

                    <option value="">Select Category</option>

                    <option value="Algorithms"
                        <%= isEdit && "Algorithms".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        Algorithms
                    </option>

                    <option value="Database"
                        <%= isEdit && "Database".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        Database
                    </option>

                    <option value="Shell"
                        <%= isEdit && "Shell".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        Shell
                    </option>

                    <option value="Concurrency"
                        <%= isEdit && "Concurrency".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        Concurrency
                    </option>

                    <option value="JavaScript"
                        <%= isEdit && "JavaScript".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        JavaScript
                    </option>

                    <option value="pandas"
                        <%= isEdit && "pandas".equals(problem.getCategory())
                            ? "selected" : "" %>>
                        pandas
                    </option>

                </select>
            </div>

        </div>



        <div class="field">
            <label for="fieldExamples">Examples</label>

            <textarea id="fieldExamples"
                      class="form-input"
                      name="examples"
                      placeholder="Examples"
                      rows="5"><%= isEdit ? esc(problem.getExamples()) : "" %></textarea>
        </div>



        <div class="field">
            <label for="fieldTags">Tags</label>

            <input type="text"
                   id="fieldTags"
                   class="form-input"
                   name="tagNames"
                   placeholder="Tags (comma separated)"
                   value="<%= esc(tagNames) %>">
        </div>

    </section>



    <section class="form-section">

        <h3>Method Configuration</h3>

        <div class="field-row">

            <div class="field">
                <label for="fieldMethodName">Method Name</label>

                <input type="text"
                       id="fieldMethodName"
                       class="form-input code-input"
                       name="methodName"
                       placeholder="e.g. twoSum"
                       value="<%= isEdit ? esc(problem.getMethodName()) : "" %>"
                       required>
            </div>

            <div class="field">
                <label for="fieldReturnType">Return Type</label>

                <input type="text"
                       id="fieldReturnType"
                       class="form-input code-input"
                       name="returnType"
                       placeholder="e.g. int[]"
                       value="<%= isEdit ? esc(problem.getReturnType()) : "" %>"
                       required>
            </div>

        </div>


        <div class="field">
            <label for="parameterDefinitions">Parameter Definitions</label>

            <textarea id="parameterDefinitions"
                      class="form-input code-input"
                      name="parameterDefinitions"
                      placeholder="e.g. int[] nums, int target"
                      rows="3"
                      required><%= isEdit ? esc(problem.getParameterDefinitions()) : "" %></textarea>
        </div>

    </section>



    <section class="form-section">

        <h3>Reference Solution (Admin Only)</h3>

        <div class="field">
            <label for="fieldReferenceSolution">Java Reference Solution</label>

            <textarea id="fieldReferenceSolution"
                      class="form-input code-input"
                      name="referenceSolution"
                      placeholder="Enter the correct Java solution here..."
                      rows="15"
                      spellcheck="false"
                      required><%= isEdit ? esc(problem.getReferenceSolution()) : "" %></textarea>
        </div>

    </section>



<section class="company-section form-section">

    <h3>Company Information</h3>

    <p class="company-description">
        Was this problem asked in a company interview?
    </p>

    <div class="company-interview-options">

        <label>
            <input type="radio"
                   name="companyInterview"
                   value="yes"
                   id="companyInterviewYes"
                   <%= !selectedCompanyIds.isEmpty() ? "checked" : "" %>>
            Yes
        </label>

        <label>
            <input type="radio"
                   name="companyInterview"
                   value="no"
                   id="companyInterviewNo"
                   <%= selectedCompanyIds.isEmpty() ? "checked" : "" %>>
            No
        </label>

    </div>

    <div id="companySelector"
         class="company-selector"
         <%= selectedCompanyIds.isEmpty() ? "hidden" : "" %>>

        <label for="companySearch">Select companies</label>

        <input type="text"
               id="companySearch"
               class="form-input"
               placeholder="Search companies...">

        <div id="companyList" class="company-list">

            <% for (Company company : companies) { %>

                <label class="company-option"
                       data-company-name="<%= esc(company.getName()).toLowerCase() %>">

                    <input type="checkbox"
                           name="companyNames"
                           value="<%= esc(company.getName()) %>"
                           <%= selectedCompanyIds.contains(company.getId())
                               ? "checked" : "" %>>

                    <span><%= esc(company.getName()) %></span>

                </label>

            <% } %>

        </div>

        <div class="add-company-row">

            <input type="text"
                   id="newCompanyName"
                   class="form-input"
                   aria-label="New company name"
                   placeholder="Company not listed? Enter its name">

            <button type="button" id="addCompanyButton" class="btn btn-ghost">
                + Add Company
            </button>

        </div>

        <div id="selectedCompanies"
             class="selected-companies"></div>

    </div>

</section>



   <section class="form-section">

   <h3>Test Cases</h3>

   <div id="testCasesContainer">

       <%
           if (isEdit && existingTestCases != null) {
               for (TestCases testCase : existingTestCases) {
       %>

           <div class="test-case">

               <div class="test-case-header">
                   <h4>Test Case <%= testCaseCount + 1 %></h4>

                   <button type="button"
                           class="remove-test-case">
                       &times;
                   </button>
               </div>

               <div class="test-case-inputs">
               </div>

               <textarea class="serialized-input"
                         name="testCaseForms[<%= testCaseCount %>].input"
                         hidden><%= esc(testCase.getInput()) %></textarea>

               <input type="text"
                      class="expected-output"
                      name="testCaseForms[<%= testCaseCount %>].expectedOutput"
                      placeholder="Expected output"
                      value="<%= esc(testCase.getExpectedOutput()) %>"
                      required>

               <div class="visibility-options">

                   <label>
                       <input type="radio"
                              class="public-radio"
                              name="testCaseForms[<%= testCaseCount %>].publicTestCase"
                              value="true"
                              <%= testCase.getIsPublic() ? "checked" : "" %>>
                       Public
                   </label>

                   <label>
                       <input type="radio"
                              class="hidden-radio"
                              name="testCaseForms[<%= testCaseCount %>].publicTestCase"
                              value="false"
                              <%= !testCase.getIsPublic() ? "checked" : "" %>>
                       Hidden
                   </label>

               </div>

           </div>

       <%
                   testCaseCount++;
               }
           }
       %>

   </div>

   <button type="button" id="addTestCase" class="btn btn-ghost">
       + Add Test Case
   </button>

   </section>

   <div class="form-actions">

       <button type="submit" id="saveProblem" class="btn btn-primary">
           <%= isEdit ? "Update Problem" : "Save Problem" %>
       </button>

   </div>


 <script>

     const parameterDefinitionsElement =
         document.getElementById("parameterDefinitions");

     const testCasesContainer =
         document.getElementById("testCasesContainer");

     let testCaseCount =
         testCasesContainer.querySelectorAll(".test-case").length;



     function getParameterDefinitions() {

         const definitions =
             parameterDefinitionsElement.value.trim();

         if (!definitions) {
             throw new Error("Enter parameter definitions first.");
         }

         return definitions.split(",").map(parameter => {

             const parts = parameter.trim().split(/\s+/);

             if (parts.length !== 2) {
                 throw new Error("Invalid parameter definition: " + parameter);
             }

             const type = parts[0];
             const name = parts[1];

             const supportedTypes = [
                 "int",
                 "long",
                 "double",
                 "float",
                 "boolean",
                 "String",
                 "int[]",
                 "long[]",
                 "double[]",
                 "float[]",
                 "boolean[]",
                 "String[]"
             ];

             if (!supportedTypes.includes(type)) {
                 throw new Error("Unsupported parameter type: " + type);
             }

             if (!/^[A-Za-z_$][A-Za-z0-9_$]*$/.test(name)) {
                 throw new Error("Invalid parameter name: " + name);
             }

             return { type, name };

         });

     }



     function createParameterField(parameter, value = "") {

         const group = document.createElement("div");
         group.className = "parameter-input-group";

         const label = document.createElement("label");

         label.textContent =
             parameter.name + " (" + parameter.type + ")";

         const input = document.createElement("input");

         input.type = "text";
         input.className = "parameter-input";

         input.dataset.name = parameter.name;
         input.dataset.type = parameter.type;

         input.value = value;

         input.required = true;

         if (parameter.type === "String[]") {

             input.placeholder =
                 '["apple", "hello world", "mango"]';

         } else if (
             parameter.type === "int[]" ||
             parameter.type === "long[]" ||
             parameter.type === "double[]" ||
             parameter.type === "float[]"
         ) {

             input.placeholder = "[1, 2, 3]";

         } else if (parameter.type === "boolean[]") {

             input.placeholder = "[true, false, true]";

         } else if (parameter.type === "boolean") {

             input.placeholder = "true or false";

         } else if (
             parameter.type === "double" ||
             parameter.type === "float"
         ) {

             input.placeholder = "Enter decimal number";

         } else {

             input.placeholder = "Enter " + parameter.name;

         }

         group.appendChild(label);
         group.appendChild(input);

         return group;
     }



     function collectParameterValues(testCase) {

         const values = {};

         testCase.querySelectorAll(".parameter-input").forEach(input => {

             values[input.dataset.name] = {
                 type: input.dataset.type,
                 value: input.value
             };

         });

         return values;
     }



     function renderTestCaseInputs(testCase, parameters, oldValues = {}) {

         const container =
             testCase.querySelector(".test-case-inputs");

         container.innerHTML = "";

         parameters.forEach(parameter => {

             let preservedValue = "";

             const oldValue = oldValues[parameter.name];

             if (oldValue && oldValue.type === parameter.type) {

                 preservedValue = oldValue.value;

             }

             const field = createParameterField(
                 parameter,
                 preservedValue
             );

             container.appendChild(field);

         });

     }



     function decodeStoredInput(input, parameters) {

         const lines = input.split(/\r?\n/);
         const values = {};

         let lineIndex = 0;

         parameters.forEach(parameter => {

             const type = parameter.type;
             const name = parameter.name;

             if (lineIndex >= lines.length) {
                 throw new Error("Missing stored input");
             }

             if (type === "String[]") {

                 const size = Number(lines[lineIndex++]);

                 if (!Number.isInteger(size) || size < 0) {
                     throw new Error("Invalid stored array size");
                 }

                 const elements = lines.slice(
                     lineIndex,
                     lineIndex + size
                 );

                 if (elements.length !== size) {
                     throw new Error("Incomplete stored String array");
                 }

                 lineIndex += size;

                 values[name] = {
                     type,
                     value: JSON.stringify(elements)
                 };

             }

             else if (type.endsWith("[]")) {

                 const size = Number(lines[lineIndex++]);

                 if (!Number.isInteger(size) || size < 0) {
                     throw new Error("Invalid stored array size");
                 }

                 let elements = [];

                 if (size > 0) {

                     if (lineIndex >= lines.length) {
                         throw new Error("Missing stored array elements");
                     }

                     elements = lines[lineIndex++]
                         .trim()
                         .split(/\s+/);

                     if (elements.length !== size) {
                         throw new Error("Invalid stored array elements");
                     }

                 }

                 values[name] = {
                     type,
                     value: "[" + elements.join(", ") + "]"
                 };

             }

             else {

                 values[name] = {
                     type,
                     value: lines[lineIndex++]
                 };

             }

         });

         if (lineIndex !== lines.length) {
             throw new Error("Unexpected extra stored input");
         }

         return values;
     }



     function initializeExistingTestCases() {

         let parameters;

         try {

             parameters = getParameterDefinitions();

         } catch (error) {

             console.error(error);
             return;

         }

         testCasesContainer.querySelectorAll(".test-case")
             .forEach(testCase => {

                 const serializedInput =
                     testCase.querySelector(".serialized-input").value;

                 let oldValues = {};

                 try {

                     oldValues = decodeStoredInput(
                         serializedInput,
                         parameters
                     );

                 } catch (error) {

                     console.error(
                         "Could not restore existing test case:",
                         error
                     );

                 }

                 renderTestCaseInputs(
                     testCase,
                     parameters,
                     oldValues
                 );

             });

     }



     parameterDefinitionsElement.addEventListener(
         "change",
         function () {

             let parameters;

             try {

                 parameters = getParameterDefinitions();

             } catch (error) {

                 alert(error.message);
                 return;

             }

             testCasesContainer.querySelectorAll(".test-case")
                 .forEach(testCase => {

                     const oldValues =
                         collectParameterValues(testCase);

                     renderTestCaseInputs(
                         testCase,
                         parameters,
                         oldValues
                     );

                 });

         }
     );



     document.getElementById("addTestCase")
         .addEventListener("click", function () {

             let parameters;

             try {

                 parameters = getParameterDefinitions();

             } catch (error) {

                 alert(error.message);
                 return;

             }

             const testCase = document.createElement("div");

             testCase.className = "test-case";

             testCase.innerHTML = `
                 <div class="test-case-header">

                     <h4></h4>

                     <button type="button"
                             class="remove-test-case">
                         &times;
                     </button>

                 </div>

                 <div class="test-case-inputs"></div>

                 <textarea class="serialized-input" hidden></textarea>

                 <input type="text"
                        class="expected-output"
                        placeholder="Expected output"
                        required>

                 <div class="visibility-options">

                     <label>
                         <input type="radio"
                                class="public-radio"
                                value="true"
                                checked>
                         Public
                     </label>

                     <label>
                         <input type="radio"
                                class="hidden-radio"
                                value="false">
                         Hidden
                     </label>

                 </div>
             `;

             renderTestCaseInputs(
                 testCase,
                 parameters
             );

             testCasesContainer.appendChild(testCase);

             reindexTestCases();

         });



     function removeTestCase(button) {

         const testCase = button.closest(".test-case");

         if (!testCase) {
             return;
         }

         testCase.remove();

         reindexTestCases();

     }

     testCasesContainer.addEventListener("click", function(event) {

         const removeButton = event.target.closest(".remove-test-case");

         if (!removeButton) {
             return;
         }

         removeTestCase(removeButton);

     });



     function reindexTestCases() {

         const testCases =
             testCasesContainer.querySelectorAll(".test-case");

         testCases.forEach((testCase, index) => {

             testCase.querySelector("h4").textContent =
                 "Test Case " + (index + 1);

             testCase.querySelector(".serialized-input").name =
                 "testCaseForms[" + index + "].input";

             testCase.querySelector(".expected-output").name =
                 "testCaseForms[" + index + "].expectedOutput";

             testCase.querySelector(".public-radio").name =
                 "testCaseForms[" + index + "].publicTestCase";

             testCase.querySelector(".hidden-radio").name =
                 "testCaseForms[" + index + "].publicTestCase";

         });

         testCaseCount = testCases.length;

     }



     function serializeTestCaseInput(testCase) {

         const inputs =
             testCase.querySelectorAll(".parameter-input");

         const values = [];

         inputs.forEach(input => {

             const value = input.value.trim();

             const type = input.dataset.type;
             const name = input.dataset.name;

             if (value === "") {
                 throw new Error("Please enter a value for " + name);
             }

             if (type === "String[]") {

                 let elements;

                 try {

                     elements = JSON.parse(value);

                 } catch (error) {

                     throw new Error(
                         name + " must be a valid JSON array."
                     );

                 }

                 if (
                     !Array.isArray(elements) ||
                     !elements.every(item => typeof item === "string")
                 ) {

                     throw new Error(
                         name + " must contain only strings."
                     );

                 }

                 if (elements.some(item =>
                     item.includes("\n") || item.includes("\r")
                 )) {

                     throw new Error(
                         "String array elements cannot contain line breaks."
                     );

                 }

                 values.push(String(elements.length));
                 values.push(...elements);

             }

             else if (type.endsWith("[]")) {

                 let arrayText = value;

                 if (
                     arrayText.startsWith("[") &&
                     arrayText.endsWith("]")
                 ) {

                     arrayText =
                         arrayText.slice(1, -1).trim();

                 } else if (
                     arrayText.includes("[") ||
                     arrayText.includes("]")
                 ) {

                     throw new Error("Invalid array format for " + name);

                 }

                 const elements = arrayText === ""
                     ? []
                     : arrayText.split(",").map(item => item.trim());

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

                         throw new Error(
                             name + " must contain valid decimal numbers."
                         );

                     }

                     if (
                         type === "boolean[]" &&
                         item !== "true" &&
                         item !== "false"
                     ) {

                         throw new Error(
                             name + " must contain only true or false."
                         );

                     }

                 });

                 values.push(String(elements.length));

                 if (elements.length > 0) {
                     values.push(elements.join(" "));
                 }

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

                     throw new Error(
                         name + " must be a valid decimal number."
                     );

                 }

                 if (
                     type === "boolean" &&
                     value !== "true" &&
                     value !== "false"
                 ) {

                     throw new Error(name + " must be true or false.");

                 }

                 if (type === "String" && /[\r\n]/.test(input.value)) {
                     throw new Error(
                         name + " cannot contain line breaks."
                     );
                 }

                 values.push(value);

             }

         });

         return values.join("\n");

     }



     const problemForm =
         document.getElementById("problemForm");

     problemForm.addEventListener("submit", function (event) {

         try {

             reindexTestCases();

             const testCases =
                 testCasesContainer.querySelectorAll(".test-case");

             testCases.forEach(testCase => {

                 const serializedInput =
                     serializeTestCaseInput(testCase);

                 testCase.querySelector(".serialized-input").value =
                     serializedInput;

             });

         } catch (error) {

             event.preventDefault();

             alert(error.message);

         }

     });



        const companyYes = document.getElementById("companyInterviewYes");
        const companyNo = document.getElementById("companyInterviewNo");

        const companySelector = document.getElementById("companySelector");
        const companySearch = document.getElementById("companySearch");
        const companyList = document.getElementById("companyList");

        const newCompanyName = document.getElementById("newCompanyName");
        const addCompanyButton = document.getElementById("addCompanyButton");

        const selectedCompanies =
            document.getElementById("selectedCompanies");


        function updateCompanySelector() {

            const enabled = companyYes.checked;

            companySelector.hidden = !enabled;

            companyList.querySelectorAll(
                'input[name="companyNames"]'
            ).forEach(checkbox => {
                checkbox.disabled = !enabled;
            });
        }


        function renderSelectedCompanies() {

            selectedCompanies.innerHTML = "";

            const checkedCompanies = companyList.querySelectorAll(
                'input[name="companyNames"]:checked'
            );

            checkedCompanies.forEach(checkbox => {

                const chip = document.createElement("div");
                chip.className = "company-chip";

                const name = document.createElement("span");
                name.textContent = checkbox.value;

                const removeButton = document.createElement("button");
                removeButton.type = "button";
                removeButton.textContent = "×";
                removeButton.title = "Remove " + checkbox.value;

                removeButton.addEventListener("click", function () {

                    checkbox.checked = false;

                    renderSelectedCompanies();

                });

                chip.appendChild(name);
                chip.appendChild(removeButton);

                selectedCompanies.appendChild(chip);

            });

        }


        companySearch.addEventListener("input", function () {

            const searchValue = this.value.trim().toLowerCase();

            companyList.querySelectorAll(".company-option")
                .forEach(option => {

                    const companyName =
                        option.dataset.companyName;

                    option.style.display =
                        companyName.includes(searchValue)
                            ? "flex"
                            : "none";

                });

        });


        companyList.addEventListener("change", function (event) {

            if (event.target.matches('input[name="companyNames"]')) {
                renderSelectedCompanies();
            }

        });


        addCompanyButton.addEventListener("click", function () {

            const name = newCompanyName.value.trim();

            if (!name) {
                alert("Please enter a company name.");
                return;
            }

            const existingCompanies = Array.from(
                companyList.querySelectorAll(
                    'input[name="companyNames"]'
                )
            );

            const existing = existingCompanies.find(checkbox =>
                checkbox.value.toLowerCase() === name.toLowerCase()
            );

            if (existing) {

                existing.checked = true;

                renderSelectedCompanies();

                newCompanyName.value = "";

                alert("This company already exists. It has been selected.");

                return;
            }

            const option = document.createElement("label");

            option.className = "company-option";
            option.dataset.companyName = name.toLowerCase();

            const checkbox = document.createElement("input");

            checkbox.type = "checkbox";
            checkbox.name = "companyNames";
            checkbox.value = name;
            checkbox.checked = true;

            const companyText = document.createElement("span");
            companyText.textContent = name;

            option.appendChild(checkbox);
            option.appendChild(companyText);

            companyList.appendChild(option);

            newCompanyName.value = "";
            companySearch.value = "";

            companyList.querySelectorAll(".company-option")
                .forEach(item => {
                    item.style.display = "flex";
                });

            renderSelectedCompanies();

        });


        newCompanyName.addEventListener("keydown", function (event) {

            if (event.key === "Enter") {

                event.preventDefault();

                addCompanyButton.click();

            }

        });


        companyYes.addEventListener("change", function () {

            updateCompanySelector();

        });

        companyNo.addEventListener("change", function () {

            updateCompanySelector();

        });


        updateCompanySelector();

        renderSelectedCompanies();


     initializeExistingTestCases();

     reindexTestCases();

    </script>

    </form>
</main>

<%@ include file="footer.jsp" %>

</body>
</html>
