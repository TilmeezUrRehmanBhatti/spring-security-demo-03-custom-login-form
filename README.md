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

**Adding Login Error Message - Overview**

+ Spring Security's default login page had built-in support for error messages
+ For our custom login page, we need logic to handle for login error messages


**Failed Login**

+ When login fails, by default Spring Security will ...
+ Send user back to your login page
+ Append an error parameter: **?error**

**Development Process**

1. Modify custom login form 
   1. Check the **error** parameter 
   2. If **error** exists, show an error message 

_Step 1:Modify form - check for error_

File:WEB_INF/view/plain-login.jsp
```JSP
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
...
<form:form action="..." mehod="...">
  
  <c:if test="${param.error != null}">
    
    <i>Sorry! You entered invalid username/password.</i>
    
  </c:if>
  
</form:form>
...
```

+ `<c:if test="${param.error != null}">` if error param then show message


**Question:**

What would be required to link a CSS file for Spring Security login form? For example, I'd like to have a CSS file (from src/main/webapp/css/style.css) for the style of the error message when using Spring Security login form. I suspect that it block the request to the CSS if i am not authenticated.

By default, Spring Security will block all requests to the web app if the user is not authenticated. However, if you'd like to use a local CSS file on your login form then these are the basic steps:

1. Create a separate CSS file

2. Reference the CSS file in your login page

3. Configure Spring Security to allow unauthenticated requests (permit all) to the "/css" directory

4. Configure the all Java configuration to serve content from the "/css" directory

**3.Configure Spring Security to allow unauthenticated requests (permit all)to the "/css" directory**

Make note of this snippet. It permits all requests to CSS. No need for authentication. Here's the snippet

```JAVA
 http.authorizeRequests()
                .antMatchers("/css/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .formLogin()
                .loginPage("/showMyLoginPage")
                .loginProcessingUrl("/authenticateTheUser")
                .permitAll();        
```
**4. Configure the all Java configuration to serve content from the "/css" directory**
```JAVA
 @Override
 public void addResourceHandlers(ResourceHandlerRegistry registry) {
     registry.addResourceHandler("/css/**").addResourceLocations("/css/");
 }
 ```

## Spring Security - Adding Custom Logout Support



**Development Process**
1. Add logout support to Spring Security Configuration
2. Add logout button to JSP page
3. Update login form to display "logged out" message

_Step 1:Add logout support to Spring Security Configuration_
```JAVA
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    
    http.authorizeRequest()
      .anyRequest ().authenticated()
      .and()
      .formLogin()
        .loginPage("/showMyLoginPage")
        .loginProcessingURL("/authenticateTheUser")
        .permitAll()
      .and()
      .logout().permitAll();
  }
```

_Step 2:Add logout button_

+ Send data to default logout URL:/logout
    + By default, must use POST method
+ Logout URL will be handled by Spring Security Filters
    + no coding required

```JSP
<form:form action="${pageContext.request.contextPath}/logout"
           method="POST" >
  
  <input type="submit" value="Logout" />
  
</form:form>
```

**Logout Process**
+ When a logout is processed, by default Spring Security will ...
+ Invalidate user's HTTP session and remove session cookies, etc
+ Send user back to your login page
+ Append a logout parameter: **?logout**

_Step 3:Update login form to display "logged out" message

1. Update login form
2. Check **logout** parameter
3. If **logout** parameter exists, show "logged out" message


**Modify Login form - check for "logout"**

File:WEB_INF/view/plain-login.jsp
```JSP
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
...
<form:form action="..." mehod="...">
  
  <c:if test="${param.error != null}">
    
    <i>Sorry! You entered invalid username/password.</i>
    
  </c:if>
  
  User name: <input type="text" name="username" />
  Password: <input type="password" name="password" />
  
</form:form>
...
```

