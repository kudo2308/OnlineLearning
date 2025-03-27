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
        <link rel="stylesheet" type="text/css" href="./assets/css/public_profile.css">
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
    <jsp:include page="./common/header.jsp"></jsp:include>
        <nav style="height: 0">
        </nav>
        <br>
    <c:if test="${empty requestScope.privateUser}">
        <div class="header-profile" style="padding:10px 0 ; margin-bottom:10px; background-color:#d4e2df">
        <main class="profile-container">
            <section class="profile-intro">
                <!-- Avatar or user image -->
                <div class="profile-avatar">
                   
                      <c:choose>
                        <c:when test="${empty requestScope.img || requestScope.img == '/assets/images/profile/unknow.jpg'}">
                            <img src="assets/images/avatar/unknow.jpg"  alt="Avatar">
                        </c:when>
                        <c:when test="${fn:startsWith(requestScope.img, 'https://')}">
                            <img  src="${requestScope.img}">
                        </c:when>
                        <c:otherwise>
                            <img src=".${requestScope.img}" alt="Avatar">
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- User basic info -->
                <div class="profile-details">
                    <h1 class="profile-name" style="text-align: center;">${requestScope.fullname}</h1>
                    <p class="profile-username">@${requestScope.email}</p>
                    <div class="social-links">
                        <c:if test="${not empty sessionScope.xspace}">
                            <a 
                                href="https://x.com/${sessionScope.xspace}" 
                                class="social-link" 
                                target="_blank" 
                                rel="noopener noreferrer"
                                aria-label="X"
                                >
                                <img src="assets/images/x-icon.png" alt="X" width="18" height="18">
                            </a>
                        </c:if>
                        <c:if test="${not empty sessionScope.facebook}">
                            <a 
                                href="https://facebook.com/${sessionScope.facebook}" 
                                class="social-link" 
                                target="_blank" 
                                rel="noopener noreferrer"
                                aria-label="Facebook"
                                >
                                <img src="assets/images/facebook-icon.png" alt="Facebook" width="18" height="18">
                            </a>
                        </c:if>                           
                        <c:if test="${not empty sessionScope.linkedin}">
                            <a 
                                href="https://linkedin.com/${sessionScope.linkedin}" 
                                class="social-link" 
                                target="_blank" 
                                rel="noopener noreferrer"
                                aria-label="LinkedIn"
                                >
                                <img src="assets/images/linkedin-icon.png" alt="LinkedIn" width="18" height="18">
                            </a>
                        </c:if>
                        <c:if test="${not empty sessionScope.youtube}">
                            <a 
                                href="https://youtube.com/${sessionScope.youtube}" 
                                class="social-link" 
                                target="_blank" 
                                rel="noopener noreferrer"
                                aria-label="YouTube"
                                >
                                <img src="assets/images/youtube-icon.png" alt="YouTube" width="18" height="18">
                            </a>
                        </c:if>
                    </div>
                </div>
            </section>

            <!-- Description or about content -->
            <section class="profile-about">
                <p>${sessionScope.description}</p>
            </section>
        </main>
    </div>
        <!-- Courses Section -->
        <c:if test="${not empty requestScope.recentCourses}">   
            <div class="product-list">
                <c:if test="${fn:length(recentCourses) > 3}">
                    <span class="material-symbols-outlined arrow-left">arrow_back</span>
                    <span class="material-symbols-outlined arrow-right">arrow_forward</span>
                </c:if>
                <div class="view-more">
                    <h1 style="font-weight: 700; font-size: 18px;">Registered Courses</h1>
                </div>
                <ul id="wow">
                    <c:if test="${not empty recentCourses}">
                        <c:forEach var="course" items="${recentCourses}">
                            <li>
                                <img class="image-product"
                                     src="${pageContext.request.contextPath}${course.imageUrl}"  
                                     alt="${course.title}">
                                <p>
                                    <a style="color: black; text-decoration: none" href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseID}">
                                        ${course.title}
                                    </a>
                                </p>
                                <p class="des-course">${course.description}</p>
                                <span>${course.price}đ</span>
                            </li>
                        </c:forEach>
                    </c:if>

                </ul>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.listCourseTeach}">   
            <div class="product-list">
                <c:if test="${fn:length(listCourseTeach) > 3}">
                    <span class="material-symbols-outlined arrow-left">arrow_back</span>
                    <span class="material-symbols-outlined arrow-right">arrow_forward</span>
                </c:if>
                <div class="view-more">
                    <h1 style="font-weight: 700; font-size: 18px;">My Courses</h1>
                </div>
                <ul id="wow1">
                    <c:if test="${not empty listCourseTeach}">
                        <c:forEach var="course1" items="${listCourseTeach}">
                            <li>
                                <img
                                    class="image-product"
                                    src="${pageContext.request.contextPath}${course1.imageUrl}"  alt="${course1.title}">
                                <p>
                                    <a style="color: black; text-decoration: none" href="${pageContext.request.contextPath}/coursedetail?courseId=${course1.courseID}">
                                        ${course1.title}
                                    </a> 
                                <p class="des-course">${course1.description}$</p>
                                <span>${course1.price}đ</span>

                            </li>
                        </c:forEach>
                    </c:if>

                </ul>
            </div>
        </c:if>
    </c:if>
    <c:if test="${not empty requestScope.privateUser}">   
        <br>
        <h1 style="text-align: center">${requestScope.privateUser}</h1>
        <br>
    </c:if>
    <jsp:include page="common/footer.jsp"></jsp:include> 
    <script src="assets/js/profile.js"></script>
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
