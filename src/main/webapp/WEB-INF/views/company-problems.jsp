
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rishabh.meetcode.model.Company" %>
<%@ page import="com.rishabh.meetcode.model.Problem" %>
<%@ page import="com.rishabh.meetcode.model.Tag" %>

<%
    Company company = (Company) request.getAttribute("company");

    List<Problem> problems =
            (List<Problem>) request.getAttribute("problems");

    int easyCount = 0;
    int mediumCount = 0;
    int hardCount = 0;

    if (problems != null) {
        for (Problem problem : problems) {

            if ("Easy".equalsIgnoreCase(problem.getDifficulty())) {
                easyCount++;
            }
            else if ("Medium".equalsIgnoreCase(problem.getDifficulty())) {
                mediumCount++;
            }
            else if ("Hard".equalsIgnoreCase(problem.getDifficulty())) {
                hardCount++;
            }
        }
    }

    int totalCount = problems != null ? problems.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">

    <title><%= company.getName() %> Problems | MeetCode</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/globals.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/home.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/company-problems.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<main class="company-page">


    <section class="company-header">

        <div class="company-heading">
            <h1><%= company.getName() %></h1>
            <p>Interview Preparation Problems</p>
        </div>

        <div class="company-total">
            <span>Total Problems</span>
            <h2><%= totalCount %></h2>
        </div>

    </section>



    <section class="company-stats">

        <div class="stat-card easy-stat">
            <span>Easy</span>
            <h2><%= easyCount %></h2>
        </div>

        <div class="stat-card medium-stat">
            <span>Medium</span>
            <h2><%= mediumCount %></h2>
        </div>

        <div class="stat-card hard-stat">
            <span>Hard</span>
            <h2><%= hardCount %></h2>
        </div>

    </section>



    <section class="company-problem-section">

        <div class="company-problem-heading">
            <h2><%= company.getName() %> Problems</h2>
            <span id="visibleProblemCount" aria-live="polite"><%= totalCount %> Problems</span>
        </div>

        <div class="difficulty-filters">

            <button class="difficulty-filter active" data-difficulty="all">
                All
            </button>

            <button class="difficulty-filter" data-difficulty="easy">
                Easy
            </button>

            <button class="difficulty-filter" data-difficulty="medium">
                Medium
            </button>

            <button class="difficulty-filter" data-difficulty="hard">
                Hard
            </button>

        </div>

        <div class="company-problem-search">
            <input
                type="text"
                id="problemSearch"
                class="form-input"
                aria-label="Search problems"
                placeholder="Search problems..."
                autocomplete="off"
            >
        </div>

        <div class="company-problem-sort">
            <label for="problemSort">Sort by:</label>

            <select id="problemSort" class="form-input">
                <option value="default">Default Order</option>
                <option value="easy-hard">Easy to Hard</option>
                <option value="hard-easy">Hard to Easy</option>
                <option value="title-asc">Title: A to Z</option>
                <option value="title-desc">Title: Z to A</option>
            </select>
        </div>

        <div class="problem-list">

            <% if (problems != null && !problems.isEmpty()) { %>

                <% for (Problem problem : problems) { %>

                    <a class="problem-row"
                       data-difficulty="<%= problem.getDifficulty().toLowerCase() %>"
                       href="${pageContext.request.contextPath}/problems/<%= problem.getId() %>">

                        <span class="status-circle"></span>

                        <span class="problem-title">
                            <%= problem.getTitle() %>
                        </span>

                        <span class="difficulty <%= problem.getDifficulty().toLowerCase() %>">
                            <%= problem.getDifficulty() %>
                        </span>

                        <span class="topic">

                            <% if (problem.getTags() != null &&
                                   !problem.getTags().isEmpty()) { %>

                                <%= problem.getTags().iterator().next().getName() %>

                            <% } else { %>

                                No Topic

                            <% } %>

                        </span>

                    </a>

                <% } %>

            <% } else { %>

                <p class="no-company-problems">
                    No problems are currently associated with this company.
                </p>

            <% } %>

        </div>

    </section>

</main>


<script>
const difficultyFilters = document.querySelectorAll(".difficulty-filter");

const companyProblemRows = document.querySelectorAll(".problem-row");

const visibleProblemCount = document.getElementById("visibleProblemCount");
const problemSearch = document.getElementById("problemSearch");
const problemSort = document.getElementById("problemSort");

const originalOrder = Array.from(companyProblemRows);

function applyFilters() {

    const activeFilter = document.querySelector(".difficulty-filter.active");
    const selectedDifficulty = activeFilter.dataset.difficulty;

    const searchValue = problemSearch.value.trim().toLowerCase();
    const sortValue = problemSort.value;

    let rows = [...originalOrder];

    const difficultyOrder = {
        easy: 1,
        medium: 2,
        hard: 3
    };

    if (sortValue === "easy-hard") {
        rows.sort((a, b) =>
            difficultyOrder[a.dataset.difficulty] -
            difficultyOrder[b.dataset.difficulty]
        );
    }
    else if (sortValue === "hard-easy") {
        rows.sort((a, b) =>
            difficultyOrder[b.dataset.difficulty] -
            difficultyOrder[a.dataset.difficulty]
        );
    }
    else if (sortValue === "title-asc") {
        rows.sort((a, b) =>
            a.querySelector(".problem-title").textContent.trim()
                .localeCompare(
                    b.querySelector(".problem-title").textContent.trim()
                )
        );
    }
    else if (sortValue === "title-desc") {
        rows.sort((a, b) =>
            b.querySelector(".problem-title").textContent.trim()
                .localeCompare(
                    a.querySelector(".problem-title").textContent.trim()
                )
        );
    }

    const problemList = document.querySelector(".problem-list");

    rows.forEach(row => problemList.appendChild(row));

    let visibleCount = 0;

    rows.forEach(row => {

        const problemDifficulty = row.dataset.difficulty;

        const problemTitle = row
            .querySelector(".problem-title")
            .textContent
            .trim()
            .toLowerCase();

        const matchesDifficulty =
            selectedDifficulty === "all" ||
            problemDifficulty === selectedDifficulty;

        const matchesSearch =
            problemTitle.includes(searchValue);

        if (matchesDifficulty && matchesSearch) {
            row.style.display = "grid";
            visibleCount++;
        } else {
            row.style.display = "none";
        }
    });

    visibleProblemCount.textContent = visibleCount + " Problems";
}

difficultyFilters.forEach(filter => {

    filter.addEventListener("click", function () {

        difficultyFilters.forEach(button => {
            button.classList.remove("active");
        });

        this.classList.add("active");

        applyFilters();
    });

});

problemSearch.addEventListener("input", applyFilters);

problemSort.addEventListener("change", applyFilters);

</script>

<%@ include file="footer.jsp" %>

</body>
</html>
