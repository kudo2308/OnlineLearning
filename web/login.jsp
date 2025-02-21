
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/login.css">
    </head>
    <body>
        <!--        <div class="video-background">
                    <video autoplay loop muted playsinline>
                        <source src="assets/images/5818973-hd_1920_1080_24fps.mp4" type="video/mp4">
                    </video>
                </div>-->
        <div class="wrapper">
            <form action="login" method="post">
                <h1>Login</h1>
                <div class="input-box">
                    <input type="text" placeholder="Email" name="email" value="${cookie.email.value}">
                    <i class='bx bxs-user'></i>
                </div>
                <div class="input-box">
                    <input type="password" placeholder="Password" name="pass" value="${cookie.pass.value}">
                    <i class='bx bxs-lock-alt' ></i>
                </div>
                <div class="remember-forgot">
                    <label><input type="checkbox" name="remember" ${cookie['remember'] != null ? 'checked' : ''}>Remember Me</label>
                    <a href="forget">Forgot Password</a>
                </div>
                <div style="text-align: center;">
                    <button type="submit" class="btn">Login</button>
                </div>
                <hr style="border: 1px solid lightgray;">             
                <div class="google-btn-container">
                    <a class="g_link" href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/SWP_OLSver1/Logingooglehandler&response_type=code&client_id=847733471444-6gh1cs98e3j6furm5rbjiarevghabvej.apps.googleusercontent.com&approval_prompt=force">
                        <div id="customBtn" class="customGPlusSignIn">
                            <span class="icon"></span>
                            <span class="buttonText">Google</span>
                        </div>
                    </a>
                </div>
                <div class="register-link">
                    <p>Don't have an account? <a href="register.jsp">Register</a></p>
                </div>
            </form>
            <c:set var="error" value="${requestScope.errorlogin}" />
            <c:if test="${not empty error}">
                <div id="error-message" class="error-message">
                    <i class="bx bxs-error"></i> ${error}
                </div>
            </c:if>
            <c:set var="success" value="${requestScope.success}" />
            <c:if test="${not empty success}">
                <div id="success" class="success">
                    <i class="bx bxs-error"></i> ${success}
                </div>
            </c:if>
        </div>
    </body>
    <script>
        function showMessage() {
            var errorMessage = document.getElementById("error-message");
            var successMessage = document.getElementById("success");

            // Hiển thị thông báo lỗi nếu có
            if (errorMessage) {
                errorMessage.style.display = "block";
                setTimeout(function () {
                    errorMessage.style.display = "none";
                }, 3000);
            }

            // Hiển thị thông báo thành công nếu có
            if (successMessage) {
                successMessage.style.display = "block";
                setTimeout(function () {
                    successMessage.style.display = "none";
                }, 3000);
            }
        }

        // Gọi hàm khi trang đã tải xong
        window.onload = function () {
            showMessage();
        };
    </script>
</html>
