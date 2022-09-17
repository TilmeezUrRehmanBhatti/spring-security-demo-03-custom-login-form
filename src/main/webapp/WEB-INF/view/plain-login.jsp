<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Custom Login Page</title>
</head>
<body>

<h3>My Custom Login Page</h3>

<form:form action="${pageContext.request.contextPath}/authenticateTheUser" method="post">

    <p>
        User name: <input type="text" name="username"/>
    </p>

    <p>
        Password: <input type="text" name="password"/>
    </p>

    <input type="submit" value="Login"/>

</form:form>

</body>
</html>















