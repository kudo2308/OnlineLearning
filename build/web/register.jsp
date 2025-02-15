
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/style_1.css">
    </head>
    <body>
        <div class="video-background">
            <video autoplay loop muted playsinline>
                <source src="assets/images/5818973-hd_1920_1080_24fps.mp4" type="video/mp4">
            </video>
        </div>
        <div class="wrapper">
            <form action="login" method="post">
                <h1>Login</h1>
                <div class="input-box">
                    <input type="text" placeholder="Username" name="user" value="${cookie.user.value}">
                    <i class='bx bxs-user'></i>
                </div>
                <div class="input-box">
                    <input type="password" placeholder="Password" name="pass" value="${cookie.pass.value}">
                    <i class='bx bxs-lock-alt' ></i>
                </div>
                <div class="remember-forgot">
                    <label><input type="checkbox" name="remember" ${cookie['remember'] != null ? 'checked' : ''}>Remember Me</label>
                    <!--  <a href="#">Forgot Password</a>-->
                </div>
                <c:set var="login" value="${requestScope.errorlogin}" />
                <c:if test="${not empty login }">
                    <div id="error-message" class="error-message">
                        <i class="bx bxs-error"></i> Incorrect username or password.
                    </div>
                </c:if>
                <button type="submit" class="btn">Login</button>
                <div class="register-link">
                    <p>Don't have an account? <a href="dk.jsp">Register</a></p>
                </div>
            </form>
        </div>
    </body>
    <script>
        function showError() {
            var errorMessage = document.getElementById("error-message");
            errorMessage.style.display = "block";
            setTimeout(function () {
                errorMessage.style.display = "none";
            }, 3000);
        }
        window.onload = function () {
            showError();
        };
    </script>
</html>
