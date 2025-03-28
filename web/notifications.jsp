<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Notification | Online Learning</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
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
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
            <nav style="height: 0; border-bottom: 1px solid #ddd"></nav>

            <div class="notifications-container">
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

            <c:if test="${sessionScope.account.roles == 'Expert'}">
                <div class="notifications-create-section">
                    <div class="expert-notification-section">
                        <h2>Create Notification</h2>
                        <form id="expert-notification-form" action="${pageContext.request.contextPath}/notifications" method="post">
                            <input type="hidden" name="action" value="createNotification">
                            <input type="hidden" name="type" value="course">

                            <div class="form-group">
                                <label for="notification-scope">Notification Scope:</label>
                                <select id="notification-scope" name="notificationScope" required>
                                    <option value="">Select Notification Scope</option>
                                    <option value="all-courses">All My Courses</option>
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

                            <button type="submit" class="send-notification-btn">Send Notification</button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>
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
                        case 'payment':
                            if (relatedId !== null) {
                                    window.location.href = '${pageContext.request.contextPath}/' + relatedLinkId;
                            } else {
                                    window.location.href = '${pageContext.request.contextPath}/order-details?id=' + relatedId;
                            }

                            break;
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

                    // Fetch submission
                    fetch('${pageContext.request.contextPath}/notifications', {
                        method: 'POST',
                        body: formData
                    })
                            .then(response => {
                                // First, check if the response is OK
                                if (!response.ok) {
                                    // If not OK, try to parse the error message
                                    return response.text().then(text => {
                                        throw new Error(`HTTP error! status: ${response.status}, message: ${text}`);
                                    });
                                }
                                // If OK, parse JSON
                                return response.json();
                            })
                            .then(data => {
                                if (data.success) {
                                    alert('Notification sent successfully!');
                                    form.reset();
                                    resetFormSections();
                                } else {
                                    alert('Failed to send notification: ' + data.message);
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert(error.message);
                            });
                });
            });
        </script>
    </body>
</html>