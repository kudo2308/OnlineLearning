<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="./assets/css/userprofile.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning</title>
    </head>
    <jsp:include page="common/header.jsp"></jsp:include>
        <hr>
        <body>
            <div class="container mt-5">
                <div class="d-flex">
                    <div class="sidebar p-3 border rounded bg-white">

                    <c:choose>
                        <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/avatar/unknow.jpg'}">
                            <img src="assets/images/avatar/unknow.jpg" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:when>
                        <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                            <img src="${sessionScope.account.img}" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <img src=".${sessionScope.account.img}" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:otherwise>
                    </c:choose>
                    <h5 class="text-center">${sessionScope.account.username}</h5>
                    <a href="${pageContext.request.contextPath}/publicprofile?email=${sessionScope.account.gmail}">View Profile</a>
                    <a href="userprofile">Profile Public</a>
                    <a href="photo">Photo</a>
                    <a href="changepassuser">Change Password</a>
                    <a href="${pageContext.request.contextPath}/private">Social & Privacy</a>
                    <br>
                    <br>
                </div>
                <div style="margin:0 ;border: 1px solid #f4f1f1  " class="profile-container ms-4 flex-grow-1">
                    <div class="header-profile">
                        <h1>Change password</h1>
                        <p class="text-muted"></p>
                    </div>
                    <hr>
                     <form action="changepassuser" method="post">
                    <div class="mb-3">
                        <label class="form-label">Old password</label>
                        <input type="password" name="oldpass" class="form-control" value="${requestScope.oldpass}">
                    </div>
                    <br>
                    <div class="mb-3">
                        <label class="form-label">New password</label>
                        <input type="password" name="newpass" class="form-control" value="${requestScope.newpass}">
                    </div>
                    <br>
                    <div class="mb-3">
                        <label class="form-label">Re-enter password</label>
                        <input type="password" name="repass" class="form-control" >
                    </div>
                    <br>
                      <button type="submit" class="btn save-btn ">Change</button>
                    </form>
                </div>
            </div>
        </div>

        <c:set var="error" value="${requestScope.errorchange}" />
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
    </body>
    <jsp:include page="common/footer.jsp"></jsp:include> 
    <script src="${pageContext.request.contextPath}/assets/js/js.js"></script>
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
