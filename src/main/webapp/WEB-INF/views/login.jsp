
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | MeetCode</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/globals.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body class="auth-page">

    <div class="auth-card">

        <div class="auth-brand">
            <img class="auth-brand-logo" src="/logo.png" alt="MeetCode">
        </div>

        <h1 class="auth-heading">Welcome back</h1>
        <p class="auth-subheading">Sign in to continue solving problems</p>

        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <div class="auth-error">
            Incorrect username or password — please try again.
        </div>
        <%
            }
        %>

        <form class="auth-form"
              action="${pageContext.request.contextPath}/login"
              method="post">

            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">

            <div class="auth-field">
                <label class="auth-label" for="username">Username</label>
                <input class="auth-input"
                       id="username"
                       type="text"
                       name="username"
                       placeholder="Enter your username"
                       autocomplete="username"
                       required>
            </div>

            <div class="auth-field">
                <label class="auth-label" for="password">Password</label>
                <input class="auth-input"
                       id="password"
                       type="password"
                       name="password"
                       placeholder="Enter your password"
                       autocomplete="current-password"
                       required>
            </div>

            <button class="auth-submit" type="submit">Sign in</button>

        </form>

        <p class="auth-footer">
            No account?
            <a href="${pageContext.request.contextPath}/register">Create one</a>
        </p>

    </div>

    <div class="auth-motivation-quote" aria-live="polite">
        <span aria-hidden="true"></span>
        <span id="dailyMotivationQuote">Small progress is still progress.</span>
    </div>

    <script src="${pageContext.request.contextPath}/js/motivation-quotes.js"></script>

</body>
</html>
