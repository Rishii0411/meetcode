<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rishabh.meetcode.model.Problem" %>


<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Problems | MeetCode</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/globals.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
   <%@ include file="navbar.jsp" %>
    <main>
        <div class="outer">
            <div class="left-fix">
                <div class="upper1">
                    <div class="topics">
                        <div class="slider1">
                            <div class="topic-filter active">
                                <img class="scr_img all" src="all_topics2.png" alt="all topics">
                                <p>All Topics</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img" src="algo1.png" alt="">
                                <p>Algorithms</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img db" src="database1.png" alt="">
                                <p>Database</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img shell" src="shell1.png" alt="">
                                <p>Shell</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img con" src="concurrency1.png" alt="">
                                <p>Concurrency</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img js1" src="js1.png" alt="">
                                <p>JavaScript</p>
                            </div>

                            <div class="topic-filter">
                                <img class="scr_img panda" src="panda1.png" alt="">
                                <p>pandas</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="lower"></div>
            </div>
            <div class="left-bar"></div>
           <div class="center-large">
                <div class="center-small">
                    <div class="first-slide">
                        <div class="slider" id="bannerSlider">
                            <div class="mission-slide sld">
                                <div class="mission-grid" aria-hidden="true"></div>
                                <div class="mission-orbit mission-orbit-one" aria-hidden="true"></div>
                                <div class="mission-orbit mission-orbit-two" aria-hidden="true"></div>
                                <div class="mission-content">
                                    <span class="mission-eyebrow">MEETCODE / DAILY MISSION</span>
                                    <h2>Build your interview streak.</h2>
                                    <p>One focused problem today is one step closer to interview-ready.</p>
                                    <div class="mission-footer">
                                        <div class="mission-stat">
                                            <strong>${SolvedProblemCount}</strong>
                                            <span>solved so far</span>
                                        </div>
                                        <a class="mission-cta" href="#problem-list">Start solving <span aria-hidden="true">→</span></a>
                                    </div>
                                </div>
                                <div class="mission-code-card" aria-hidden="true">
                                    <span>today.java</span>
                                    <code>solve();</code>
                                    <i></i><i></i><i></i>
                                </div>
                            </div>
                            <div class="first sld"><a href="#"><img class="slid" src="first.png" alt="OFFER"></a></div>
                            <div class="second sld"><a href="#"><img class="slid" src="second.png" alt="JAVA SCRIPT"></a></div>
                            <div class="third sld"><a href="#"><img class="slid" src="third.png" alt="TOP INTERVIEW QUESTIONS"></a></div>
                            <div class="fourth sld"><a href="#"><img class="slid" src="fourth.png" alt="CRASH COURSE DSA"></a></div>
                            <div class="fifth sld"><a href="#"><img class="slid" src="fifth.jpeg" alt="CRASH COURSE SYSTEM DESIGN"></a></div>
                        </div>
                    </div>

                    <div class="center-lower">
                    <%
                       List<Object[]> tagCounts =
                           (List<Object[]>) request.getAttribute("tagCounts");
                    %>
                        <div class="algo-list">
                            <div class="algo-cont">
                              <%
                                  if (tagCounts != null) {
                                      for (Object[] tag : tagCounts) {
                              %>

                                  <div class="tag tag-filter"
                                       data-tag="<%= tag[0] %>">

                                      <p class="name"><%= tag[0] %></p>

                                      <span class="count"><%= tag[1] %></span>
                                  </div>

                              <%
                                      }
                                  }
                              %>

                            </div>
                        </div>
                        <div class="search-bar">
                                <div class="left-search">
                                    <div class="inp">
                                        <span class="icon"><img src="magnifying-glass-11-svgrepo-com.png" alt="search icon"></span>
                                        <input style="color: rgb(169, 169, 169);" class="search srch-ques" type="text" placeholder="Search questions">
                                    </div>
                                   <div class="cont filter-wrapper">

                                       <div class="filter" id="difficultyFilterButton">
                                           <img class="scr_img" src="filter.png" alt="Filter">
                                       </div>

                                       <div class="difficulty-dropdown" id="difficultyDropdown">

                                           <p class="filter-heading">Difficulty</p>

                                           <label>
                                               <input type="radio" name="difficulty" value="all" checked>
                                               All
                                           </label>

                                           <label>
                                               <input type="radio" name="difficulty" value="easy">
                                               Easy
                                           </label>

                                           <label>
                                               <input type="radio" name="difficulty" value="medium">
                                               Medium
                                           </label>

                                           <label>
                                               <input type="radio" name="difficulty" value="hard">
                                               Hard
                                           </label>

                                       </div>

                                   </div>
                                </div>
                                <div class="right-search">
                                    <div class="solved flx">
                                        <div class="comp-bar"></div>
                                        <%
                                           long problemCount = (long) request.getAttribute("problemCount");
                                           long SolvedProblemCount = (long) request.getAttribute("SolvedProblemCount");
                                        %>
                                        <p><%=SolvedProblemCount%>/<%=problemCount%> SOLVED</p> </div>

                                </div>
                                </div>
                        </div>
                       <div class="problem-list" id="problem-list">




                           <%
                               List<Problem> problems = (List<Problem>) request.getAttribute("problems");
                               Set<Long> acceptedProblemIds =
                                       (Set<Long>) request.getAttribute("acceptedProblemIds");

                               if (problems != null) {
                                   for (Problem problem : problems) {
                           %>
                                      <a class="problem-row"
                                         data-category="<%= problem.getCategory() != null ? problem.getCategory() : "" %>"
                                         href="${pageContext.request.contextPath}/problems/<%= problem.getId() %>">
                                           <span class="status-circle <%= acceptedProblemIds != null && acceptedProblemIds.contains(problem.getId()) ? "solved" : "" %>"
                                                 aria-label="<%= acceptedProblemIds != null && acceptedProblemIds.contains(problem.getId()) ? "Solved" : "Not solved" %>"></span>

                                           <span class="problem-title">
                                               <%= problem.getTitle() %>
                                           </span>

                                           <span class="difficulty <%= problem.getDifficulty().toLowerCase() %>">
                                               <%= problem.getDifficulty() %>
                                           </span>

                                           <span class="topic"
                                                 data-topic="<%= problem.getTags() != null && !problem.getTags().isEmpty()
                                                     ? problem.getTags().iterator().next().getName()
                                                     : "" %>">

                                               <% if (problem.getTags() != null && !problem.getTags().isEmpty()) { %>
                                                   <%= problem.getTags().iterator().next().getName() %>
                                               <% } else { %>
                                                   No Topic
                                               <% } %>

                                           </span>
                                       </a>
                           <%
                                   }
                               }
                           %>

                       </div>
                       <div class="empty-state" id="emptyState" style="display: none;">

                           <div class="empty-state-icon">
                               <img src="magnifying-glass-11-svgrepo-com.png" alt="No results">
                           </div>

                           <h3 id="emptyStateTitle">No problems found</h3>

                           <p id="emptyStateMessage">
                               Try changing your search or filters.
                           </p>

                           <button type="button" id="clearProblemFilters">
                               Clear all filters
                           </button>

                       </div>
                </div>
           </div>
            <div class="right-fix">
                <div class="right-margin">
                    <div class="streak-cont">
                        <div class="streak">

                            <div class="streak-header">
                                <h3>Monthly Activity</h3>
                                <p id="calendar-month"></p>
                            </div>

                            <div class="monthly-calendar">

                                <div class="calendar-weekdays">
                                    <span>Sun</span>
                                    <span>Mon</span>
                                    <span>Tue</span>
                                    <span>Wed</span>
                                    <span>Thu</span>
                                    <span>Fri</span>
                                    <span>Sat</span>
                                </div>

                                <div id="monthly-calendar-grid">
                                </div>

                            </div>

                            <div class="monthly-legend">
                                <span>Less</span>
                                <span class="legend-box inactive"></span>
                                <span class="legend-box active"></span>
                                <span>More</span>
                            </div>

                        </div>
                    </div>
                    <div class="companies-cont">
                        <div class="trending-companies">
                            <div class="com"><p>Trending Companies</p></div>
                            <div class="rl-scroll">
                                <div class="left-scroll flx">
                                    <img class="scr_img" src="left-arrow.png" alt="right list">
                                </div>
                                <div class="right-scroll flx">
                                    <img class="scr_img" src="right-arrow.png" alt="left list">
                                </div>
                            </div>
                        </div>
                        <div class="srch-com-name">
                            <div class="inp src-com">
                                <span class="icon"><img src="magnifying-glass-11-svgrepo-com.png" alt="search icon"></span>
                                <input style="font-size: 14px;" class="search com-srch" type="text" placeholder="Search for a company...">
                            </div>
                            <div class="comname">
                                <div class="com-tag-cont">
                                    <%
                                        List<Object[]> companyCounts =
                                            (List<Object[]>) request.getAttribute("companyCounts");

                                        if (companyCounts != null && !companyCounts.isEmpty()) {
                                            for (Object[] company : companyCounts) {
                                    %>

                                        <a class="company-tag"
                                           href="${pageContext.request.contextPath}/companies/<%= company[0] %>"
                                           data-company-name="<%= company[1] %>">

                                            <%= company[1] %>

                                            <div class="com-cnt">
                                                <%= company[2] %>
                                            </div>

                                        </a>

                                    <%
                                            }
                                        }
                                    %>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>


<script>

const topicFilters = document.querySelectorAll(".topic-filter");
const tagFilters = document.querySelectorAll(".tag-filter");
const problemRows = document.querySelectorAll(".problem-row");
const problemSearch = document.querySelector(".srch-ques");
const difficultyFilterButton =
    document.getElementById("difficultyFilterButton");

const difficultyDropdown =
    document.getElementById("difficultyDropdown");

const difficultyOptions =
    document.querySelectorAll('input[name="difficulty"]');

const emptyState = document.getElementById("emptyState");
const emptyStateTitle = document.getElementById("emptyStateTitle");
const emptyStateMessage = document.getElementById("emptyStateMessage");
const clearProblemFilters = document.getElementById("clearProblemFilters");

let selectedDifficulty = "all";

let selectedCategory = "all";
let selectedTag = "";


function applyProblemFilters() {

    const searchValue = problemSearch.value.trim().toLowerCase();
    let visibleCount = 0;

    problemRows.forEach(row => {

        const problemTitle = row
            .querySelector(".problem-title")
            .textContent
            .trim()
            .toLowerCase();

        const problemCategory =
            row.dataset.category.trim().toLowerCase();

        const topicElement = row.querySelector(".topic");

        const problemTopic =
            topicElement.dataset.topic.trim().toLowerCase();

        const matchesSearch =
            problemTitle.includes(searchValue);

        const matchesCategory =
            selectedCategory === "all" ||
            problemCategory === selectedCategory;

        const matchesTag =
            selectedTag === "" ||
            problemTopic === selectedTag;

        const problemDifficulty =
            row.querySelector(".difficulty").textContent.trim().toLowerCase();

        const matchesDifficulty =
            selectedDifficulty === "all" ||
            problemDifficulty === selectedDifficulty;

        if (
            matchesSearch &&
            matchesCategory &&
            matchesTag &&
            matchesDifficulty
        ) {
            row.style.display = "grid";
            visibleCount++;
        } else {
            row.style.display = "none";
        }


    });

    if (visibleCount === 0) {

        emptyState.style.display = "flex";

        if (problemRows.length === 0) {

            emptyStateTitle.textContent = "No problems available yet";

            emptyStateMessage.textContent =
                "We're working on adding problems. Please check back later.";

            clearProblemFilters.style.display = "none";

        } else if (searchValue !== "") {

            emptyStateTitle.textContent = "No problems found";

            emptyStateMessage.textContent =
                "We couldn't find any problems matching your search.";

            clearProblemFilters.style.display = "inline-block";

        } else {

            emptyStateTitle.textContent = "No matching problems";

            emptyStateMessage.textContent =
                "Try changing your topic, tag, or difficulty filters.";

            clearProblemFilters.style.display = "inline-block";
        }

    } else {

        emptyState.style.display = "none";

    }
}

topicFilters.forEach(filter => {

    filter.addEventListener("click", function () {

        selectedCategory =
            this.querySelector("p").textContent.trim().toLowerCase();

        if (selectedCategory === "all topics") {
            selectedCategory = "all";
        }

        topicFilters.forEach(item => {
            item.classList.remove("active");
        });

        this.classList.add("active");

        applyProblemFilters();
    });
});

tagFilters.forEach(filter => {

    filter.addEventListener("click", function () {

        const clickedTag = this.dataset.tag.trim().toLowerCase();

        selectedTag = selectedTag === clickedTag ? "" : clickedTag;

        applyProblemFilters();
    });
});

problemSearch.addEventListener("input", applyProblemFilters);

difficultyFilterButton.addEventListener("click", function (event) {

    event.stopPropagation();

    difficultyDropdown.classList.toggle("show");

});


difficultyOptions.forEach(option => {

    option.addEventListener("change", function () {

        selectedDifficulty = this.value;

        applyProblemFilters();

        difficultyDropdown.classList.remove("show");

    });

});


document.addEventListener("click", function (event) {

    if (
        !difficultyDropdown.contains(event.target) &&
        !difficultyFilterButton.contains(event.target)
    ) {
        difficultyDropdown.classList.remove("show");
    }

});


clearProblemFilters.addEventListener("click", function () {

    problemSearch.value = "";

    selectedCategory = "all";

    topicFilters.forEach(item => {
        item.classList.remove("active");
    });

    document.querySelector(".topic-filter").classList.add("active");

    selectedTag = "";

    selectedDifficulty = "all";

    document.querySelector(
        'input[name="difficulty"][value="all"]'
    ).checked = true;

    difficultyDropdown.classList.remove("show");

    applyProblemFilters();

});



applyProblemFilters();


const companySearch = document.querySelector(".com-srch");
const companyTags = Array.from(
    document.querySelectorAll(".company-tag")
);

const leftCompanyArrow = document.querySelector(".left-scroll");
const rightCompanyArrow = document.querySelector(".right-scroll");

const companiesPerPage = 20;
let currentCompanyPage = 0;

function displayCompanies() {

    const searchValue = companySearch.value.trim().toLowerCase();

    const filteredCompanies = companyTags.filter(company => {

        const countElement = company.querySelector(".com-cnt");

        const companyName = company.textContent
            .replace(countElement ? countElement.textContent : "", "")
            .trim()
            .toLowerCase();

        return companyName.includes(searchValue);
    });

    const totalPages = Math.ceil(
        filteredCompanies.length / companiesPerPage
    );

    if (totalPages === 0) {
        currentCompanyPage = 0;
    } else if (currentCompanyPage >= totalPages) {
        currentCompanyPage = totalPages - 1;
    }

    const startIndex = currentCompanyPage * companiesPerPage;
    const endIndex = startIndex + companiesPerPage;

    companyTags.forEach(company => {
        company.style.display = "none";
    });

    filteredCompanies.slice(startIndex, endIndex).forEach(company => {
        company.style.display = "flex";
    });
}

companySearch.addEventListener("input", function () {

    currentCompanyPage = 0;

    displayCompanies();

});

rightCompanyArrow.addEventListener("click", function () {

    const searchValue = companySearch.value.trim().toLowerCase();

    const filteredCompanies = companyTags.filter(company => {

        const countElement = company.querySelector(".com-cnt");

        const companyName = company.textContent
            .replace(countElement ? countElement.textContent : "", "")
            .trim()
            .toLowerCase();

        return companyName.includes(searchValue);
    });

    const totalPages = Math.ceil(
        filteredCompanies.length / companiesPerPage
    );

    if (currentCompanyPage < totalPages - 1) {
        currentCompanyPage++;
        displayCompanies();
    }

});

leftCompanyArrow.addEventListener("click", function () {

    if (currentCompanyPage > 0) {
        currentCompanyPage--;
        displayCompanies();
    }

});

displayCompanies();

</script>


<script>
document.addEventListener("DOMContentLoaded", function () {

    const calendarGrid =
        document.getElementById("monthly-calendar-grid");

    const monthLabel =
        document.getElementById("calendar-month");

    const activeDates = new Set([
        <c:if test="${not empty streakSummary}">
            <c:forEach var="date" items="${streakSummary.activeDates}">
                "${date}",
            </c:forEach>
        </c:if>
    ]);

    generateMonthlyCalendar(activeDates);

    function generateMonthlyCalendar(activeDates) {

        const today = new Date();

        const year = today.getFullYear();
        const month = today.getMonth();

        monthLabel.textContent =
            today.toLocaleString("en-US", {
                month: "long",
                year: "numeric"
            });

        const firstDay = new Date(year, month, 1).getDay();

        const totalDays = new Date(year, month + 1, 0).getDate();

        calendarGrid.innerHTML = "";

        for (let i = 0; i < firstDay; i++) {

            const emptyCell = document.createElement("div");

            emptyCell.className = "calendar-empty";

            calendarGrid.appendChild(emptyCell);
        }

        for (let day = 1; day <= totalDays; day++) {

            const date = new Date(year, month, day);

            const monthNumber = String(month + 1).padStart(2, "0");

            const dayNumber = String(day).padStart(2, "0");

            const dateKey =
                year + "-" + monthNumber + "-" + dayNumber;

            const isActive = activeDates.has(dateKey);

            const dayElement = document.createElement("div");

            dayElement.classList.add("calendar-date");

            if (isActive) {
                dayElement.classList.add("active");
            } else {
                dayElement.classList.add("inactive");
            }

            if (day === today.getDate()) {
                dayElement.classList.add("today");
            }

            dayElement.textContent = day;

            dayElement.title = dateKey + (
                isActive
                    ? " - Accepted submission"
                    : " - No accepted submission"
            );

            calendarGrid.appendChild(dayElement);
        }
    }

});
</script>

<script>
const bannerSlider = document.getElementById("bannerSlider");

if (bannerSlider) {
    const bannerSlides = Array.from(bannerSlider.querySelectorAll(".sld"));

    if (bannerSlides.length > 1) {
        const firstClone = bannerSlides[0].cloneNode(true);
        const lastClone = bannerSlides[bannerSlides.length - 1].cloneNode(true);

        firstClone.setAttribute("aria-hidden", "true");
        lastClone.setAttribute("aria-hidden", "true");
        bannerSlider.appendChild(firstClone);
        bannerSlider.insertBefore(lastClone, bannerSlider.firstChild);

        const getSlideWidth = () => bannerSlider.clientWidth;
        const moveToRealFirstSlide = () => {
            bannerSlider.scrollLeft = getSlideWidth();
        };

        requestAnimationFrame(moveToRealFirstSlide);

        let isResetting = false;
        bannerSlider.addEventListener("scroll", () => {
            if (isResetting) return;

            const slideWidth = getSlideWidth();
            if (!slideWidth) return;

            if (bannerSlider.scrollLeft <= slideWidth * 0.25) {
                isResetting = true;
                bannerSlider.scrollLeft = slideWidth * bannerSlides.length;
                requestAnimationFrame(() => { isResetting = false; });
            } else if (bannerSlider.scrollLeft >= slideWidth * (bannerSlides.length + 0.75)) {
                isResetting = true;
                bannerSlider.scrollLeft = slideWidth;
                requestAnimationFrame(() => { isResetting = false; });
            }
        });

        window.addEventListener("resize", moveToRealFirstSlide);
    }
}
</script>


<%@ include file="footer.jsp" %>

</body>
</html>
