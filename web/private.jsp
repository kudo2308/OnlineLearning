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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@500&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@500&display=swap" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning</title>
        <style>
            .row .col-md-4 {
                padding-right: 5px;
                padding-left: 5px;
            }
            .account-info p {
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="./common/header.jsp"></jsp:include>
            <nav style="height: 0">
            </nav>
            <div class="container mt-5">
                <div class="d-flex">
                    <div class="sidebar p-3 border rounded bg-white">                 
                    <c:choose>
                        <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/profile/unknow.jpg'}">
                            <img src="assets/images/avatar/unknow.jpg" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:when>
                        <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                            <img  src="${sessionScope.account.img}" class="rounded-circle d-block mx-auto mb-3">
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
                </div>
                <div class="profile-container ms-4 flex-grow-1" style="border: 1px solid #f4f1f1">
                    <div class="header-profile">
                        <h1>Private Information</h1>
                        <p class="text-muted">Add information social about yourself and edit view private profile</p>
                    </div>
                    <hr>
                    <form action="private" method="post">
                        <div class="mb-3">
                            <label class="form-label">X</label>
                            <div class="d-flex">
                                <input type="text" class="form-control" value="http://www.x.com/" style="background-color:#999999" readonly>
                                <input type="text" name="xspace" class="form-control" value="${sessionScope.xspace}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Facebook</label>
                            <div class="d-flex">
                                <input type="text" class="form-control" value="http://www.facebook.com/" style="background-color:#999999" readonly>
                                <input type="text" name="facebook" class="form-control" value="${sessionScope.facebook}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">LinkedIn</label>
                            <div class="d-flex">
                                <input type="text" class="form-control" value="http://www.linkedin.com/" style="background-color:#999999" readonly>
                                <input type="text" name="linkedin" class="form-control" value="${sessionScope.linkedin}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Youtube</label>
                            <div class="d-flex">
                                <input type="text" class="form-control" value="http://www.youtube.com/" style="background-color:#999999" readonly>
                                <input type="text" name="youtube" class="form-control" value="${sessionScope.youtube}">
                            </div>
                        </div>

                        <br>
                        <h2> Edit private  information </h2>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="showProfile" name="showProfile" <c:if test="${showProfile == true}">checked</c:if>>
                            <label class="form-check-label" for="showProfile">
                                Show your profile to logged-in users
                            </label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="showCoursesRegister" name="showCoursesRegister" <c:if test="${showCoursesRegister == true && showProfile == true}">checked</c:if>>
                            <label class="form-check-label" for="showCoursesRegister">
                                Show courses you're taking on your profile page
                            </label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="showCourses" name="showCourses"  <c:if test="${showCourses == true && showProfile == true}">checked</c:if>>
                            <label class="form-check-label" for="showCourses">
                                Display your courses on your profile page
                            </label>
                        </div>
                        <br>
                         <button type="submit" class="btn btn-primary mt-3">Save</button>
                    </form>
                </div>
            </div>
        </div>

        <c:set var="error" value="${requestScope.errorprofile}" />
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
