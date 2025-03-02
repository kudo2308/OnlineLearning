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
        </style>
    </head>
    <jsp:include page="common/header.jsp"></jsp:include>
        <hr>
        <body>
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
                    <a href="#">View Profile</a>
                    <a href="userprofile">Profile Public</a>
                    <a href="photo.jsp">Photo</a>
                    <a href="changepassuser">Change Password</a>
                    <a href="#">Subscriptions</a>
                </div>
                <div class="profile-container ms-4 flex-grow-1">
                    <div class="header-profile">
                        <h1>Public profile</h1>
                        <p class="text-muted">Add information about yourself</p>
                    </div>
                    <hr>
                    <form action="userprofile" method="post">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullname" class="form-control" value="${requestScope.fullname}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3">${requestScope.description}</textarea>                              
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Gender</label>

                            <select class="form-select" name="gender">
                                <c:choose>
                                    <c:when test="${not empty requestScope.gender}">
                                    </c:when>
                                    <c:otherwise>
                                        <option value="" ${empty requestScope.gender ? 'selected' : ''}>-- Select Gender --</option>
                                    </c:otherwise>
                                </c:choose>

                                <option value="Male" ${requestScope.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${requestScope.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Others" ${requestScope.gender == 'Others' ? 'selected' : ''}>Others</option>
                            </select>
                        </div>                                         
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" name="phone" class="form-control" value="${requestScope.phone}">                              
                        </div>                                             
                        <div class="mb-3">
                            <label class="form-label">Address</label>
                            <input type="text" name="address" id="full_address" class="form-control" value="${requestScope.address}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Date of Birth</label>
                            <div class="dob">
                                <input type="text"  class="form-control" id="dob" value="${requestScope.dob}">
                                <input type="date" class="form-control" id="input"  name="dob">   
                            </div>
                        </div>
                        <button type="submit" class="btn save-btn w-100">Save</button>
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
