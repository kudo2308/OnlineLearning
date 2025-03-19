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
            <form action="changepass?email=${requestScope.email}" method="post">
            <h1>Change password</h1>
            <hr>
            <h2>New password</h2>  
            <div class="input-box">
                    <input type="password" name="pass">
                    <i class='bx bxs-user'></i>
            </div> 
            <h2>Re-enter password</h2>  
            <div class="input-box">
                <input type="password" name="re-pass">
                    <i class='bx bxs-user'></i>
            </div>
            <br>
            <div class="verify">
                <button id="send-btn" type="button" class="btn" style="background: red;"><a style=" text-decoration: none; color: white;" href="forget?change=true">Cancel change</a> </button>
                <button id="send-btn" type="submit" class="btn" style="color: white;background: green;">Change password</button>
            </div>
            </form>
            <c:set var="error" value="${requestScope.errorchangepass}" />
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
