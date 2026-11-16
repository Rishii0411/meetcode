 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">
    <title>${errorTitle} | MeetCode</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/globals.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/problem-unavailable.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="unavailable-wrapper">

    <div class="unavailable-card">

        <div class="unavailable-icon" aria-hidden="true">
            <span>!</span>
        </div>

        <div class="unavailable-content">

            <span class="unavailable-label">Problem status</span>

            <h1>${errorTitle}</h1>

            <p class="unavailable-message">
                ${errorMessage}
            </p>

            <p class="unavailable-description">
                The problem may have been deactivated by an administrator
                or permanently removed from the platform.
                You can continue exploring other available problems.
            </p>

            <div class="unavailable-actions">

                <a href="${pageContext.request.contextPath}/"
                   class="primary-button btn btn-primary">
                    Explore Problems
                </a>

                <a href="${pageContext.request.contextPath}/dashboard"
                   class="secondary-button btn btn-ghost">
                    Back to Dashboard
                </a>

            </div>

            <div class="unavailable-footer">
                <span>MeetCode</span>
                <span>Keep learning. Keep coding.</span>
            </div>

        </div>

    </div>

</div>

<%@ include file="footer.jsp" %>

</body>
</html>
