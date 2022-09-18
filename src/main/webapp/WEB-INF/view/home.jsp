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


<%--ADD A LOUGOUT BUTTON--%>
<form:form action="${pageContext.request.contextPath}/logout" method="post">

<input type="submit" value="Logout">

</form:form>
</body>

</html>