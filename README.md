## Spring Security - Adding Custom Login Form


**Development Process**
1. Modify Spring Security Configuration to reference custom login form
2. Development a Controller to show the custom login form
3. Create custom login form
    + HTML(CSS optional)
    + Spring MVC form tag \<form:form>

_Step 1:Modify Spring Security Configuration_

File:DemoSecurityConfig.java
```JAVA
@Configuration
@EnableWebSecurity
public class DemoSecurityConfig extends WebSecurityConfigurerAdapter {
  
  // override mehod to configure users for in-memory authentication ...
  
}
```

| Method                                      | Description                                                       |
| ------------------------------------------- | ----------------------------------------------------------------- |
| **configure(AuthenticationManagerBuilder)** | Configure users ( in memory, database, ldap, etc)                 |
| **Configure(HttpSecurity)**                 | Configure security of web paths in application, login, logout etc |


File:DemoSecurityConfig.java
```JAVA
@Configuration
@EnableWebSecurity
public class DemoSecurityConfig extends WebSecurityConfigurerAdapter {
  
 @override
  protected void configure(AuthenticationManagerBuilder auth) throes Excepton {
    
    // add our users for in memory authentication
   ... 
  }
  
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    
    http.authorizeRequest()
      .anyRequest ().authenticated()
      .and()
      .formLogin()
        .loginPage("/showMyLoginPage")
        .loginProcessingURL("/authenticateTheUser")
        .permitAll();
  }
}
```

+ `protected void configure(HttpSecurity http)` Configure security of web paths in application, login, logout etc
+ `http.authorizeRequest()` Restrict access based on the HttpServletRequest
+ `.anyRequest ().authenticated()` Any request to the app must be authenticated(ie logged in)
+ `.formLogin()` We are customizing the form login process
    + `.loginPage("/showMyLoginPage")` Show our custom form at the request mapping "/showMyLoginPage"
        + Need to create a controller for this request mapping
    + `.loginProcessingURL("/authenticateTheUser")` Login form should POST data to this URL for processing (check user id and password)
        + No Controller Request Mapping required for this.
    + `.permitAll()` Allow everyone to see login page. No need to be logged in.






_Step 2:Develop a Controller to show the customer login form_

File:LoginController.java
```JAVA
@Controller
public class LoginController {
  
  @GetMapping("/showMyLoginPage")
  public String showMyLoginPage() {
    
    return "plain-login";
  }
}
```
+ `@GetMapping("/showMyLoginPage")` is based on configuration `.loginPage("/showMyLoginPage")` from step 1

_Step 3:Create custom login form_
+ Send data to login processing URL:/authenticateTheUser

<img src="https://user-images.githubusercontent.com/80107049/190868932-bbd9ce8e-9c14-416d-aecf-7608aec5a97b.png" width="500" />


+ Login process URL will be handled by Spring Security Filters
    + no coding required

```JSP
<form:form action="${pageContext.request.contextPath}/authenticateTheUser" mehtod="POST">
  ...
</form:form>
```
+ Must **POST** the data
+ **Best practice** is to use the Spring MVC Form tag \<form:form>
    + Provides automatic support for security defenses

<br>

+ Spring Security defines default names for login form fields
    + User name field: username
    + Password field: password

```JSP
User name: <input type="text" name="username" />
Password: <input type="password" name="password" />
```
+ Spring Security Filters will read the form data and authenticate the user


File:WEB-INF/view/plain-login.jsp
```JSP
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
...
<form:form action="${pageContext.request.contextPath}/authenticateTheUser" mehtod="POST">
  
  <p>
    User name: <input type="text" name="username" />
  </p>
  
  <p>
    Password: <input type="password" name="password" />
  </p>
  
  <input type="submit" value="Login" />
  
</form:form>
...
```

+ `"${pageContext.request.contextPath}/authenticateTheUser"` Gives us access to context path dynamically

**Why use Context Path?**
+ Allows us to dynamically reference context path of application
+ Helps to keep links relative to application context path
+ If you change context path of app then link will work
+ Much better than hard-coding context path ...

