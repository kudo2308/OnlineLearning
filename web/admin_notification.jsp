<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="en">
    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="EduChamp : Education HTML Template" />

        <!-- OG -->
        <meta property="og:title" content="EduChamp : Education HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>EduChamp : Education HTML Template </title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->

        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
        <style>
            .notifications-container {
                display: flex;
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                gap: 20px;
            }

            .notifications-list-section,
            .notifications-create-section {
                flex: 1;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 20px;
            }

            .notification-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .notification-header h1 {
                margin: 0;
                font-size: 24px;
            }

            .clear-all-btn {
                padding: 8px 12px;
                background-color: #1e88e5;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .notification-list1 {
                max-height: 500px;
                overflow-y: auto;
            }

            .notification-item {
                padding: 15px;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
                cursor: pointer;
            }

            .notification-item:last-child {
                border-bottom: none;
            }

            .notification-item:hover {
                background-color: #f9f9f9;
            }

            .notification-item.unread {
                background-color: #f0f7ff;
            }

            .notification-item.unread:hover {
                background-color: #e5f0ff;
            }

            .notification-title {
                font-weight: bold;
                margin-bottom: 8px;
                font-size: 16px;
            }

            .notification-content1 {
                font-size: 14px;
                color: #333;
                margin-bottom: 8px;
            }

            .notification-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 12px;
                color: #777;
            }

            .notification-type {
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 11px;
                text-transform: uppercase;
                font-weight: bold;
            }

            .type-system {
                background-color: #e3f2fd;
                color: #1e88e5;
            }
            .type-course {
                background-color: #e8f5e9;
                color: #4caf50;
            }
            .type-message {
                background-color: #fff8e1;
                color: #ffa000;
            }
            .type-payment {
                background-color: #f3e5f5;
                color: #9c27b0;
            }
            .type-other {
                background-color: #eceff1;
                color: #607d8b;
            }

            .no-notifications {
                text-align: center;
                padding: 40px;
                font-size: 16px;
                color: #777;
            }

            .expert-notification-section h2 {
                margin-bottom: 20px;
                color: #1e88e5;
                text-align: center;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .send-notification-btn {
                background-color: #4caf50;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
                width: 100%;
            }

            .send-notification-btn:hover {
                background-color: #45a049;
            }

            #specific-user-section {
                transition: all 0.3s ease;
            }
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top: 120px;
                left: 0;
                right: 0;
                background-color: rgba(208, 22, 39, 0.8);
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }

            .success {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #00CC00;
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>


            <main class="ttr-wrapper">
                <div class="container notifications-container" style=" height: 750px;">
                    <div class="notifications-list-section">
                        <div class="notification-header">
                            <h1>Notifications</h1>
                            <button id="mark-all-read-btn" class="clear-all-btn">Read all</button>
                        </div>

                        <div class="notification-list1">
                        <c:choose>
                            <c:when test="${empty notifications}">
                                <div class="no-notifications">
                                    <p>You have no notifications.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="notification" items="${notifications}">
                                    <div class="notification-item ${notification.isRead ? '' : 'unread'}" 
                                         data-id="${notification.notificationID}" 
                                         data-type="${notification.type}" 
                                         data-related-id="${notification.relatedID}"
                                         data-related-link="${notification.relatedLink}">
                                        <div class="notification-title">${notification.title}</div>
                                        <div class="notification-content1">${notification.content}</div>
                                        <div class="notification-meta">
                                            <span class="notification-time">
                                                <fmt:formatDate value="${notification.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                            <span class="notification-type type-${notification.type}">
                                                ${notification.type}
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>


                <div class="notifications-create-section">
                    <div class="expert-notification-section">
                        <h2>Create Notification</h2>
                        <form id="expert-notification-form" action="adminNotify?action=createNotification" method="post">
                            <input type="hidden" name="type" value="course">

                            <div class="form-group">
                                <label for="notification-scope">Notification Scope:</label>
                                <select id="notification-scope" name="notificationScope" required>
                                    <option value="">Select Notification Scope</option>
                                    <option value="all-users">All Users</option>

                                    <c:if test="${not empty sessionScope.account && sessionScope.account.roles == 'Admin'}">
                                        <option value="sales">Sales</option>
                                        <option value="marketing">Marketing</option>
                                    </c:if>

                                    <option value="experts">Experts</option>
                                    <option value="student">Student</option>
                                    <option value="specific-course">Specific Course</option>
                                    <option value="specific-user">Specific User</option>
                                </select>
                            </div>

                            <div id="specific-course-section" class="form-group" style="display: none;">
                                <label for="notification-course">Select Course:</label>
                                <select id="notification-course" name="courseId">
                                    <option value="">Select a Course</option>
                                    <c:forEach var="course" items="${expertCourses}">
                                        <option value="${course.courseID}">${course.title}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div id="specific-user-section" class="form-group" style="display: none;">
                                <label for="specific-user-select">Select User:</label>
                                <select id="specific-user-select" name="specificUserId">
                                    <option value="">Select a User</option>
                                    <c:forEach var="user" items="${courseUsers}">
                                        <option value="${user.userID}">${user.fullName} (${user.email})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="notification-title">Title:</label>
                                <input type="text" id="notification-title" name="title" required 
                                       maxlength="100" placeholder="Enter notification title">
                            </div>

                            <div class="form-group">
                                <label for="notification-content">Content:</label>
                                <textarea id="notification-content" name="content" required 
                                          maxlength="500" placeholder="Enter notification content"></textarea>
                            </div>


                            <div class="form-group">
                                <label for="notification-content">Link:</label>
                                <input type="text" id="notification-link" name="link" required 
                                       maxlength="100" placeholder="Enter libk notification ">
                            </div>
                            <button type="submit" class="send-notification-btn">Send Notification</button>
                        </form>
                    </div>
                </div>

            </div>
        </main>
        <c:set var="error" value="${requestScope.error}" />
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
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Xử lý click vào thông báo
                const notificationItems = document.querySelectorAll('.notification-item');
                notificationItems.forEach(item => {
                    item.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const type = this.getAttribute('data-type');
                        const relatedId = this.getAttribute('data-related-id');
                        const relatedLinkId = this.getAttribute('data-related-link');
                        // Đánh dấu đã đọc
                        if (this.classList.contains('unread')) {
                            markAsRead(id);
                            this.classList.remove('unread');
                        }

                        // Chuyển hướng dựa trên loại thông báo
                        redirectBasedOnType(type, relatedId, relatedLinkId);
                    });
                });
                // Xử lý đánh dấu tất cả đã đọc
                document.getElementById('mark-all-read-btn').addEventListener('click', function () {
                    markAllAsRead();
                });
                function markAsRead(notificationID) {
                    fetch('${pageContext.request.contextPath}/notifications?action=markRead&id=' + notificationID, {
                        method: 'POST'
                    })
                            .catch(error => console.error('Error marking notification as read:', error));
                }

                function markAllAsRead() {
                    fetch('${pageContext.request.contextPath}/notifications?action=markAllRead', {
                        method: 'POST'
                    })
                            .then(() => {
                                // Cập nhật UI
                                document.querySelectorAll('.notification-item.unread').forEach(item => {
                                    item.classList.remove('unread');
                                });
                            })
                            .catch(error => console.error('Error marking all notifications as read:', error));
                }

                function redirectBasedOnType(type, relatedId, relatedLinkId) {
                    switch (type) {
                        case 'course':
                            if (relatedId !== null) {
                                window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/lesson?courseId=' + relatedId;
                            }
                            break;
                        case 'message':
                            if (relatedId !== null) {
                                window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/chat?id=' + relatedId;
                            }
                            break;
                        case 'fee':
                            if (relatedId !== null) {
                                window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/order-details?id=' + relatedId;
                            }

                            break;
                        case 'wallet':
                            if (relatedId !== null) {
                                window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/order-details?id=' + relatedId;
                            }

                        case 'system':
                            if (relatedId !== null) {
                                window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/system-notice?id=' + relatedId;
                            }
                            break;
                        default:
                            window.location.href = '${pageContext.request.contextPath}/notifications';
                            break;
                    }
                }


            });
        </script>
        <script>

            document.addEventListener('DOMContentLoaded', function () {
                const notificationScope = document.getElementById('notification-scope');
                const specificCourseSection = document.getElementById('specific-course-section');
                const specificUserSection = document.getElementById('specific-user-section');
                // Reset form sections
                function resetFormSections() {
                    specificCourseSection.style.display = 'none';
                    specificUserSection.style.display = 'none';
                    // Reset select elements
                    document.getElementById('notification-course').selectedIndex = 0;
                    document.getElementById('specific-user-select').selectedIndex = 0;
                }

                notificationScope.addEventListener('change', function () {
                    // Reset all sections first
                    resetFormSections();
                    // Show relevant section based on selection
                    switch (this.value) {
                        case 'specific-course':
                            specificCourseSection.style.display = 'block';
                            break;
                        case 'specific-user':
                            specificUserSection.style.display = 'block';
                            break;
                    }
                });
                // Form submission handling
                const form = document.getElementById('expert-notification-form');
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    const formData = new FormData(form);
                    // Additional validation based on scope
                    const scope = notificationScope.value;
                    switch (scope) {
                        case 'specific-course':
                            if (!formData.get('courseId')) {
                                alert('Please select a course');
                                return;
                            }
                            break;
                        case 'specific-user':
                            if (!formData.get('specificUserId')) {
                                alert('Please select a user');
                                return;
                            }
                            break;
                    }
                    form.submit();
                });
            });
        </script>

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
        <script src="assets/admin/assets/js/jquery.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>    <script src="https://cdnjs.cloudflare.com/ajax/libs/timeago.js/4.0.2/timeago.min.js"></script>
    </body>
</html>