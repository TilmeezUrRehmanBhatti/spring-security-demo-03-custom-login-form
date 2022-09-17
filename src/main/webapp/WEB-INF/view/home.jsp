<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>

<head>
    <title>Tilmeez Company Home Page</title>
</head>

<body>
<p>

<h2>Tilmeez Company Home page</h2>

</p>


<%--ADD A LOUGOUT BUTTON--%>
<form:form action="${pageContext.request.contextPath}/logout" method="post">

<input type="submit" value="Logout">

</form:form>
</body>

</html>