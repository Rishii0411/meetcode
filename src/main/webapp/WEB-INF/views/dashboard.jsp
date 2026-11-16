<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | MeetCode</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/globals.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">

</head>

<body>
<%@ include file="navbar.jsp" %>

<div class="dashboard">

    <div class="welcome-section">

        <h1>Welcome, ${user.username}!</h1>

        <p>Here's an overview of your coding progress.</p>

    </div>

    <div class="streak-container">

        <div class="streak-card">

            <div class="streak-icon">
                🔥
            </div>

            <div class="streak-details">
                <h3>Current Streak</h3>
                <h1>${streakSummary.currentStreak}</h1>
                <p>Consecutive active days</p>
            </div>

        </div>

        <div class="streak-card">

            <div class="streak-icon">
                🏆
            </div>

            <div class="streak-details">
                <h3>Longest Streak</h3>
                <h1>${streakSummary.longestStreak}</h1>
                <p>Your personal best</p>
            </div>

        </div>

    </div>

    <div class="activity-calendar-container">

        <div class="activity-calendar-header">
            <div>
                <h2>My Coding Activity</h2>
                <p>Your coding consistency over the last 12 months.</p>
            </div>
        </div>

        <div id="activity-calendar">


        </div>

        <div class="calendar-legend">
            <span>Less</span>
            <span class="legend-box inactive"></span>
            <span class="legend-box active"></span>
            <span>More</span>
        </div>

    </div>

    <div class="stats-container">


        <div class="stat-card">

            <h3>Total Problems Solved</h3>

            <h1>${totalSolved}</h1>

        </div>

        <div class="stat-card">

            <h3>Easy</h3>

            <h1 class="easy">${easySolved}</h1>

        </div>

        <div class="stat-card">

            <h3>Medium</h3>

            <h1 class="medium">${mediumSolved}</h1>

        </div>

        <div class="stat-card">

            <h3>Hard</h3>

            <h1 class="hard">${hardSolved}</h1>

        </div>

        <div class="stat-card">

            <h3>Acceptance Rate</h3>

            <p>${String.format("%.1f", acceptanceRate)}%</p>

        </div>


        <div class="stat-card">

            <h3>Total Submissions</h3>

            <h1>${totalSubmissions}</h1>

        </div>
    </div>

<%
    DateTimeFormatter formatter =
        DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
%>
<div class="recent-submissions">

    <h2>Recent Submissions</h2>

    <table>
        <thead>
            <tr>
                <th>Problem</th>
                <th>Difficulty</th>
                <th>Verdict</th>
                <th>Language</th>
                <th>Submitted At</th>
            </tr>
        </thead>

        <tbody>
            <c:choose>

                <c:when test="${not empty recentSubmissions}">

                    <c:forEach var="submission" items="${recentSubmissions}">
                        <tr class="submission-row"
                            onclick="window.location.href='${pageContext.request.contextPath}/problems/${submission.problem.id}?submissionId=${submission.id}'">
                            <td>
                                <span >
                                    ${submission.problem.title}
                                </span>
                            </td>

                            <td>
                                <span class="difficulty-badge ${submission.problem.difficulty.toLowerCase()}">
                                    ${submission.problem.difficulty}
                                </span>
                            </td>

                            <td>
                                <span class="verdict-badge ${submission.verdict.replace(' ', '-').toLowerCase()}">
                                    ${submission.verdict}
                                </span>
                            </td>

                            <td>${submission.language}</td>

                           <td>
                               <%= ((java.time.LocalDateTime)
                                   ((pageContext.getAttribute("submission") != null)
                                       ? ((com.rishabh.meetcode.model.Submission)
                                           pageContext.getAttribute("submission")).getSubmittedAt()
                                       : null)).format(formatter) %>
                           </td>
                        </tr>
                    </c:forEach>

                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="5">You haven't made any submissions yet.</td>
                    </tr>
                </c:otherwise>

            </c:choose>
        </tbody>
    </table>

</div>


    <div class="profile-card">

        <h2>My Profile</h2>

        <p>
            <strong>Username:</strong>
            ${user.username}
        </p>

        <p>
            <strong>Email:</strong>
            ${user.email}
        </p>

    </div>


    <a class="action-button"
       href="${pageContext.request.contextPath}/">
        Explore Problems
    </a>


</div>



<script>

document.addEventListener("DOMContentLoaded", function () {

    const calendar = document.getElementById("activity-calendar");

    fetch("${pageContext.request.contextPath}/api/streak")
        .then(response => {
            if (!response.ok) {
                throw new Error("Unable to fetch activity data");
            }

            return response.json();
        })
        .then(data => {

            const activeDates = new Set(data.activeDates);

            generateCalendar(activeDates);

        })
        .catch(error => {
            console.error("Calendar error:", error);
            calendar.textContent = "Unable to load coding activity.";
        });


    function generateCalendar(activeDates) {

        const today = new Date();

        const startDate = new Date(today);
        startDate.setDate(today.getDate() - 364);

        startDate.setDate(startDate.getDate() - startDate.getDay());

        const endDate = new Date(today);
        endDate.setDate(endDate.getDate() + (6 - endDate.getDay()));

        const weeks = [];
        let currentWeek = [];

        let currentDate = new Date(startDate);

        while (currentDate <= endDate) {

            currentWeek.push(new Date(currentDate));

            if (currentWeek.length === 7) {
                weeks.push(currentWeek);
                currentWeek = [];
            }

            currentDate.setDate(currentDate.getDate() + 1);
        }



        const calendarColumns = [];

        weeks.forEach(week => {

            let currentSegment = null;

            week.forEach(date => {

                const monthKey =
                    date.getFullYear() + "-" + date.getMonth();

                if (
                    currentSegment === null ||
                    currentSegment.monthKey !== monthKey
                ) {

                    currentSegment = {
                        monthKey: monthKey,
                        month: date.getMonth(),
                        dates: Array(7).fill(null)
                    };

                    calendarColumns.push(currentSegment);
                }

                currentSegment.dates[date.getDay()] = date;

            });

        });

        const monthNames = [
            "Jan", "Feb", "Mar", "Apr",
            "May", "Jun", "Jul", "Aug",
            "Sep", "Oct", "Nov", "Dec"
        ];

        const layout = document.createElement("div");
        layout.className = "calendar-layout";

        const weekdayLabels = document.createElement("div");
        weekdayLabels.className = "weekday-labels";

        ["", "Mon", "", "Wed", "", "Fri", ""].forEach(day => {
            const label = document.createElement("span");
            label.textContent = day;
            weekdayLabels.appendChild(label);
        });

        const calendarContent = document.createElement("div");
        calendarContent.className = "calendar-content";

        const monthLabels = document.createElement("div");
        monthLabels.className = "calendar-months";

       let previousMonthKey = null;
       let extraColumns = 0;

       calendarColumns.forEach((column, index) => {

           const monthLabel = document.createElement("span");

           if (column.monthKey !== previousMonthKey) {

               if (previousMonthKey !== null) {
                   extraColumns++;
               }

               monthLabel.textContent = monthNames[column.month];
           }

           monthLabel.style.gridColumn =
               index + 1 + extraColumns;

           monthLabels.appendChild(monthLabel);

           previousMonthKey = column.monthKey;

       });

        const calendarGrid = document.createElement("div");
        calendarGrid.className = "calendar-grid";




        let previousGridMonthKey = null;

        calendarColumns.forEach(column => {

            if (
                previousGridMonthKey !== null &&
                column.monthKey !== previousGridMonthKey
            ) {

                const spacer = document.createElement("div");

                spacer.className = "calendar-month-spacer";

                calendarGrid.appendChild(spacer);
            }

            column.dates.forEach(date => {

                const day = document.createElement("div");

                if (date === null) {

                    day.className = "calendar-day-placeholder";

                } else {

                    const year = date.getFullYear();

                    const month = String(
                        date.getMonth() + 1
                    ).padStart(2, "0");

                    const dateNumber = String(
                        date.getDate()
                    ).padStart(2, "0");

                    const dateKey =
                        year + "-" + month + "-" + dateNumber;

                    const isActive = activeDates.has(dateKey);

                    day.classList.add("calendar-day");

                    if (isActive) {
                        day.classList.add("active");
                    } else {
                        day.classList.add("inactive");
                    }

                    day.title = dateKey + " - " +
                        (isActive
                            ? "Accepted submission"
                            : "No accepted submission");
                }

                calendarGrid.appendChild(day);

            });

            previousGridMonthKey = column.monthKey;

        });





        calendarContent.appendChild(monthLabels);
        calendarContent.appendChild(calendarGrid);

        layout.appendChild(weekdayLabels);
        layout.appendChild(calendarContent);

        calendar.innerHTML = "";
        calendar.appendChild(layout);

    }

});

</script>
<%@ include file="footer.jsp" %>

</body>
</html>
