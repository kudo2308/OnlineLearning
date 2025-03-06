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
    <jsp:include page="./common/header.jsp"></jsp:include>
        <nav style="height: 0">
        </nav>
        <br>
        <main class="profile-container">
            <section class="profile-intro">
                <!-- Avatar or user image -->
                <div class="profile-avatar">
                    <!-- Replace with real avatar image URL if desired -->
                    <img src="assets/images/avatar/unknow.jpg" alt="User Avatar"/>
                </div>

                <!-- User basic info -->
                <div class="profile-details">
                    <h1 class="profile-name">Nguyễn Võ Thái Bảo</h1>
                    <p class="profile-username">@adfasdfasdfasdf</p>
                    <div class="social-links">
                        <!-- Nút X (Twitter) -->
                        <a 
                            href="https://x.com/ten_nguoi_dung" 
                            class="social-link" 
                            target="_blank" 
                            rel="noopener noreferrer"
                            aria-label="X"
                            >
                            <!-- Icon X dạng SVG tối giản (dấu X chéo) -->
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                            <path d="M3 3L21 21M21 3L3 21"></path>
                            </svg>
                        </a>

                        <!-- Nút Facebook -->
                        <a 
                            href="https://facebook.com/ten_nguoi_dung" 
                            class="social-link" 
                            target="_blank" 
                            rel="noopener noreferrer"
                            aria-label="Facebook"
                            >
                            <!-- Icon chữ "f" của Facebook -->
                            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                            <path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.88v-6.99H7.898V12h2.54V9.797c0-2.507 1.493-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.261c-1.242 0-1.63.771-1.63 1.56V12h2.773l-.443 2.89h-2.33v6.99C18.343 21.128 22 16.991 22 12z"/>
                            </svg>
                        </a>

                        <!-- Nút LinkedIn -->
                        <a 
                            href="https://linkedin.com/in/ten_nguoi_dung" 
                            class="social-link" 
                            target="_blank" 
                            rel="noopener noreferrer"
                            aria-label="LinkedIn"
                            >
                            <!-- Icon chữ "in" của LinkedIn -->
                            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                            <path d="M19 0h-14c-2.76 0-5 2.24-5 5v14c0 2.76 2.24 5 5 5h14
                                  c2.76 0 5-2.24 5-5v-14c0-2.76-2.24-5-5-5zM8.339 19h-2.667v-8.667h2.667v8.667zM7.005
                                  8.667c-.853 0-1.545-.692-1.545-1.545s.692-1.545 1.545-1.545 1.545.692
                                  1.545 1.545-.692 1.545-1.545 1.545zM19 19h-2.667v-4.333c0-1.033-.021-2.367-1.445-2.367-1.446
                                  0-1.667 1.129-1.667 2.291v4.409h-2.667v-8.667h2.56v1.184h.036c.356-.675 1.226-1.387
                                  2.525-1.387 2.698 0 3.198 1.776 3.198 4.083v4.787z"/>
                            </svg>
                        </a>

                        <!-- Nút YouTube -->
                        <a 
                            href="https://youtube.com/@ten_nguoi_dung" 
                            class="social-link" 
                            target="_blank" 
                            rel="noopener noreferrer"
                            aria-label="YouTube"
                            >
                            <!-- Icon YouTube (biểu tượng nút play) -->
                            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                            <path d="M23.499 6.203a2.999 2.999 0 0 0-2.117-2.129C19.414 3.5 12 3.5 12 3.5s-7.414 0-9.382.574A3 3 0 0 0
                                  .5 6.203 31.388 31.388 0 0 0 0 12a31.388 31.388 0 0 0 .5 5.797 3 3 0 0 0 2.118 2.129C4.586
                                  20.5 12 20.5 12 20.5s7.414 0 9.382-.574a2.999 2.999 0 0 0 2.117-2.129A31.388 31.388 0 0 0
                                  24 12a31.388 31.388 0 0 0-.501-5.797zM9.75 15.451v-6.9L15.25 12l-5.5 3.451z"/>
                            </svg>
                        </a>
                    </div>
                </div>
            </section>

            <!-- Description or about content -->
            <section class="profile-about">
                <h2>Fake Display Burn-in Effects</h2>
                <p>
                    Here are ways to simulate screen burn-in effects. For example,
                    <strong>Pixel Hover</strong> (Windows) can create patterns and tools to mimic
                    burn or screen distortion in an experimental manner.
                </p>
                <h3>Screen Deflector or Glitch Effects</h3>
                <p>
                    You can use external programs (e.g. <strong>Adobe After Effects</strong>)
                    plus a plugin like Twixtor to warp or glitch frames. This is helpful to create
                    illusions of damaged screens or flicker.
                </p>
                <h3>VNC or Remote Desktop Hacks</h3>
                <p>
                    If you’re running remote desktops, you could modify your screen in real time
                    to look like something’s wrong. It’s a fun trick to try out.
                </p>
                <!-- Add more text as needed -->
            </section>
        </main>
        <!-- Courses Section -->
        <div class="product-list">

        <c:if test="${not empty recentCourses}">
            <span
                class="material-symbols-outlined arrow-left"
                onclick="scrollb('wow', 'left')">
                arrow_back
            </span>
            <span
                class="material-symbols-outlined arrow-right"
                onclick="scrollb('wow', 'right')">
                arrow_forward
            </span>
        </c:if>
        <div class="view-more">
            <h1 style="font-weight: 700;font-size: 18px;">Courses you're enrolled in</h1>
        </div>
        <ul id="wow">
            <c:if test="${not empty recentCourses}">
                <c:forEach var="recentCourses" items="${recentCourses}">
                    <li>
                        <img
                            class="image-product"
                            src="${pageContext.request.contextPath}${recentCourses.imageUrl}"  alt="${recentCourses.title}">
                        <p>
                            <a style="color: black; text-decoration: none" href="${pageContext.request.contextPath}/coursedetail?courseId=${recentCourses.courseID}">
                                ${recentCourses.title}
                            </a> 
                        <p class="des-course">${recentCourses.description}$</p>
                        <span>${recentCourses.price}đ</span>

                    </li>
                </c:forEach>
            </c:if>

        </ul>
    </div>

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
