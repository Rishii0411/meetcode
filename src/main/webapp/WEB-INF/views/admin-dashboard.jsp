<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">
    <title>Admin Dashboard | MeetCode</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/globals.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin-dashboard.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="admin-dashboard">

    <div class="welcome-section">
        <h1>Admin Dashboard</h1>
        <p>Manage inactive problems and restore them when needed.</p>
    </div>

    <div class="inactive-problems">

        <h2>Inactive Problems</h2>

        <c:choose>

            <c:when test="${not empty inactiveProblems}">

                <div class="table-wrap">

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Difficulty</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                        <c:forEach var="problem" items="${inactiveProblems}">

                            <tr>

                                <td class="col-id">${problem.id}</td>

                                <td class="col-title"><c:out value="${problem.title}"/></td>

                                <td class="col-difficulty">
                                    <span class="badge ${fn:toLowerCase(problem.difficulty)}">${problem.difficulty}</span>
                                </td>

                                <td class="col-actions">

                                    <form action="${pageContext.request.contextPath}/admin/problems/${problem.id}/reactivate"
                                          method="post">

                                        <input type="hidden"
                                               name="${_csrf.parameterName}"
                                               value="${_csrf.token}">

                                        <button type="submit" class="btn btn-ghost btn-sm">
                                            Reactivate
                                        </button>

                                    </form>

                                    <form action="${pageContext.request.contextPath}/admin/problems/${problem.id}/delete"
                                          method="post"
                                          onsubmit="return confirm('Permanently delete this problem? Existing submissions will be preserved.');">

                                        <input type="hidden"
                                               name="${_csrf.parameterName}"
                                               value="${_csrf.token}">

                                        <button type="submit" class="btn btn-danger btn-sm">
                                            Permanently Delete
                                        </button>

                                    </form>

                                </td>

                            </tr>

                        </c:forEach>

                    </tbody>

                </table>

                </div>

            </c:when>

            <c:otherwise>

                <p class="empty-note">No inactive problems found. Problems you deactivate will appear here so you can restore them.</p>

            </c:otherwise>

        </c:choose>

    </div>

</div>

<%@ include file="footer.jsp" %>

</body>
</html>
