<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<html>

<head>
    <title>Tilmeez Company Home Page</title>
</head>

<body>
    <p>

    <h2>Welcome to Tilmeez Company Home page</h2>

    </p>

    <hr>
    <%--Display user name and role--%>

    <p>
        User: <security:authentication property="principal.username"/>
        <br><br>
        Role(s): <security:authentication property="principal.authorities"/>
    </p>

    <hr>

    <%--Add a link to point to / leaders ... this is for the manager--%>

    <p>
        <a href="${pageContext.request.contextPath}/leaders">LeaderShip Meeting</a>
        (Only for Manager peoples)
    </p>

    <hr>

    <%--Add a link to point to /systems--%>
    <a href="${pageContext.request.contextPath}/systems">IT Systems Meeting</a>
    (Only for Admin peoples)

    <%--ADD A LOUGOUT BUTTON--%>
    <form:form action="${pageContext.request.contextPath}/logout" method="post">

        <input type="submit" value="Logout">

    </form:form>
</body>

</html>