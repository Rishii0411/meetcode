
<!DOCTYPE html>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>


<%
    Authentication authentication =
        SecurityContextHolder.getContext().getAuthentication();

    boolean isLoggedIn =
        authentication != null &&
        authentication.isAuthenticated() &&
        !"anonymousUser".equals(authentication.getPrincipal());

    boolean navbarisAdmin =
        isLoggedIn &&
        authentication.getAuthorities().stream()
            .anyMatch(authority ->
                authority.getAuthority().equals("ROLE_ADMIN")
            );

    String username = isLoggedIn
        ? authentication.getName()
        : "";
%>
<html lang="en">
<head>
    <title>navbar</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/globals.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
</head>
<body>
    <div class="mc-nav-wrapper">
        <div class="mc-nav-container">
            <div class="mc-nav-content">

                <div class="mc-nav-left">
                    <div class="mc-nav-links">

                        <% if (navbarisAdmin) { %>

                            <a href="${pageContext.request.contextPath}/addproblem"
                               class="mc-nav-option">
                                ADD PROBLEM
                            </a>

                        <% } %>
                    </div>


                </div>

                <div class="mc-nav-logo">
                    <a class="mc-nav-logo-link" href="${pageContext.request.contextPath}/">
                        <img class="mc-nav-logo-image" src="/logo.png" alt="meetcode home page">
                    </a>
                </div>


                <div class="mc-nav-right">

                    <div class="mc-nav-streak <%= Boolean.TRUE.equals(request.getAttribute("hasSubmissionToday")) ? "is-active" : "" %>"
                         title="<%= Boolean.TRUE.equals(request.getAttribute("hasSubmissionToday")) ? "Active today" : "No submission today" %>">
                        <img class="mc-nav-streak-icon" src="/fire.png" alt="">
                    </div>

                    <% if (isLoggedIn) { %>

                         <% if (navbarisAdmin) { %>
                         <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <div class="mc-nav-profile">
                                <%= username %>
                            </div>
                            </a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <div class="mc-nav-profile">
                                <%= username %>
                            </div>
                            </a>
                        <% } %>


                    <% } else { %>

                        <div class="mc-nav-auth-options">

                            <a class="mc-nav-login-link"
                               href="${pageContext.request.contextPath}/login">Login</a>

                            <a class="mc-nav-register-link"
                               href="${pageContext.request.contextPath}/register">Register</a>

                        </div>

                    <% } %>

                    <form class="mc-nav-logout-form"
                          action="${pageContext.request.contextPath}/logout"
                          method="post">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <button class="mc-nav-logout-button" type="submit">Logout</button>

                    </form>

                </div>

            </div>
        </div>

        <div class="mc-nav-quote" aria-live="polite">
            <span class="mc-nav-quote-mark" aria-hidden="true"></span>
            <span id="dailyMotivationQuote">Keep going—your next breakthrough may be one problem away.</span>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/motivation-quotes.js"></script>

</body>
</html>
