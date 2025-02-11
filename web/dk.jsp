<%-- 
    Document   : dk
    Created on : Oct 10, 2024, 2:04:35 PM
    Author     : VICTUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/register.css">
    </head>
    <body>
        <div class="video-background">
            <video autoplay loop muted playsinline>
                <source src="assets/images/5818973-hd_1920_1080_24fps.mp4" type="video/mp4">
            </video>
        </div>
        <div class="wrapper">
            <form action="register" method="post" onsubmit="return validateForm()">
                <h1>Register</h1>
                <div class="input-box">
                    <input type="text" placeholder="Username" name="user" value="${param.user}" id="user">
                    <i class='bx bxs-user'></i>
                </div>

                <div class="input-box">
                    <input type="text" placeholder="Fullname" name="fullname"  value="${param.fullname}" id="fullname">
                    <i class='bx bxs-user'></i>
                </div>
                <div class="input-box">
                    <input type="email" placeholder="Email" name="email" value="${param.email}" id="email" >
                    <i class='bx bxs-envelope'></i>
                </div>
                <div class="input-box">
                    <input type="password" placeholder="Password" name="pass" id="pass">
                    <i class='bx bxs-lock-alt'></i>
                </div>
                <div class="input-box">
                    <input type="text" placeholder="Address" name="address"  value="${param.address}" id="address">
                    <i class='bx bxs-home'></i>
                </div>

                <div class="input-box">
                    <input type="text" placeholder="Phone" name="phone" value="${param.phone}" id="phone" >
                    <i class='bx bxs-phone'></i>
                </div>
                <button type="submit" class="btn">Register</button>
                <div class="register-link">
                    <p>You have an account? <a href="register.jsp">Login</a></p>
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
                errorMessage.style.display = "block";
                setTimeout(function () {
                    errorMessage.style.display = "none";
                }, 3000);
            }
            window.onload = function () {
                showError();
            };
        </script>
    </body>
</html>
