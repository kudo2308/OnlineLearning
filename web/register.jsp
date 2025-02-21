<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/register.css">
    </head>
    <body>
        <div class="wrapper">
            <form action="register" method="post">
                <h1>Register</h1>
                <div class="input-box">
                    <input type="text" placeholder="Email" name="email" id="email" value="${requestScope.email}">
                    <i class='bx bxs-envelope'></i>
                </div>
                <div class="input-box">
                    <input type="text" placeholder="Fullname" name="fullname" id="fullname" value="${requestScope.fullname}">
                    <i class='bx bxs-user'></i>
                </div>         
                <div class="input-box">
                    <input type="password" placeholder="Password" name="pass" id="pass">
                    <i class='bx bxs-lock-alt'></i>
                </div>
                <div class="input-option" id="input-option">
                    <label>
                        <input type="radio" name="role" value="student" />Student
                    </label>
                    <label style="margin-left: 6%;">
                        <input type="radio" name="role" value="expert" />Expert
                    </label>
                </div>
                <div style="text-align: center;"><button type="submit" class="btn">Register</button></div>
                <hr style="border: 1px solid lightgray;">             
                <div class="google-btn-container">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/SWP_OLSver1/Logingooglehandler&response_type=code&client_id=847733471444-6gh1cs98e3j6furm5rbjiarevghabvej.apps.googleusercontent.com&approval_prompt=force">
                        <div id="customBtn" class="customGPlusSignIn">
                            <span class="icon"></span>
                            <span class="buttonText">Google</span>
                        </div>
                    </a>
                </div>

                <div class="register-link">
                    <p>You have an account? <a href="login.jsp">Login</a></p>
                </div>
                <c:set var="register" value="${requestScope.errorregister}" />
                <c:if test="${not empty register}">
                    <div id="error-message" class="error-message">
                        <i class="bx bxs-error"></i> ${register}
                    </div>
                </c:if>
            </form>
        </div>
        <script>
            function showError() {
                var errorMessage = document.getElementById("error-message");
                if (errorMessage) { // Kiểm tra nếu phần tử tồn tại
                    errorMessage.style.display = "block";
                    setTimeout(function () {
                        errorMessage.style.display = "none";
                    }, 3000);
                }
            }
            window.onload = function () {
                showError();
            };
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }
        </script>
    </body>
</html>
