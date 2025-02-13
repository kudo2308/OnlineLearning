
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/otp.css">
    </head>
    <body>
        <div class="video-background">
            <video autoplay loop muted playsinline>
                <source src="assets/images/5818973-hd_1920_1080_24fps.mp4" type="video/mp4">
            </video>
        </div>
        <div class="wrapper">
            <form action="verifyOtp" method="post">
                <h1>Login</h1>
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group text-center">
                                <label class="margin-align">Enter the Code</label>
                                <div class="form-group-input otp-form-group mb-3">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                    <input type="text" minlength="1" maxlength="1" class="form-control otp-inputbar">
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <c:set var="login" value="${requestScope.errorlogin}" />
                <c:if test="${not empty login }">
                    <div id="error-message" class="error-message">
                        <i class="bx bxs-error"></i> Incorrect username or password.
                    </div>
                </c:if>
                <button type="submit" class="btn">Login</button>
                <div class="register-link">
                    <p>Do  you want change email? <a href="register.jsp">Change</a></p>
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
        // --------otp section------
        $(".otp-inputbar").keypress(function (e) {
            if (e.which !== 8 && e.which !== 0 && (e.which < 48 || e.which > 57)) {
                $("#errmsg").html("Digits Only").show().fadeOut("slow");
                return false;
            }
        });
        $(".otp-inputbar").on("keyup keydown keypress", function (e) {
            if ($(this).val()) {
                $(this).next().focus();
            }
            var KeyID = e.keyCode;
            switch (KeyID) {
                case 8:
                    $(this).val("");
                    $(this).prev().focus();
                    break;
                case 46:
                    $(this).val("");
                    $(this).prev().focus();
                    break;
                default:
                    break;
            }
        });
    </script>
</html>
