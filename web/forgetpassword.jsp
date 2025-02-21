<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/fogetpass.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="wrapper">
            <form action="forget" method="post">
            <h1>Forgot Password</h1>
            <hr>
            <p>Forgot your password? Don't worry, enter your gmail below and I will send you an OTP code to reset your password.</p>
            <h2>Email</h2>  
            <div class="input-box">
                    <input type="text" placeholder="Email" name="email">
                    <i class='bx bxs-user'></i>
            </div>
            <a href="#">Can't recover your account?</a>
            <br>
            <hr>
            <div class="verify">
                <div id="resend-btn" class="resend-btn" style="margin: auto 0"><a href="login">Go back</a></div>
                <button id="send-btn" type="submit" class="btn">Send me a code to reset password</button>
            </div>
            </form>
            <c:set var="error" value="${requestScope.errorforget}" />
            <c:if test="${not empty error}">
                <div id="error-message" class="error-message">
                    <i class="bx bxs-error"></i> ${error}
                </div>
            </c:if>
        </div>
    </body>
    <script>
        function showMessage() {
            var errorMessage = document.getElementById("error-message");
            if (errorMessage) {
                errorMessage.style.display = "block";
                setTimeout(function () {
                    errorMessage.style.display = "none";
                }, 3000);
            }
        }

        // Gọi hàm khi trang đã tải xong
        window.onload = function () {
            showMessage();
        };
    </script>
</html>
