<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thông báo | Online Learning</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <style>
            .notifications-container {
                max-width: 800px;
                margin: 0 auto;
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

            .notification-list {
                border: 1px solid #eee;
                border-radius: 8px;
                overflow: hidden;
            }

            .notification-item {
                padding: 15px;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
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

            .notification-content {
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
        </style>
    </head>
    <body>

        <jsp:include page="common/header.jsp"></jsp:include>
            <nav style="height: 0 ;border-bottom: 1px solid #ddd"></nav>
            <div class="notifications-container">
                <div class="notification-header">
                    <h1>Notify</h1>
                    <button id="mark-all-read-btn" class="clear-all-btn">Read all</button>
                </div>

                <div class="notification-list">
                <c:if test="${empty notifications}">
                    <div class="no-notifications">
                        <p>You not have notification.</p>
                    </div>
                </c:if>

                <c:forEach var="notification" items="${notifications}">
                    <div class="notification-item ${notification.isRead ? '' : 'unread'}" 
                         data-id="${notification.notificationID}" 
                         data-type="${notification.type}" 
                         data-related-id="${notification.relatedID}">
                        <div class="notification-title">${notification.title}</div>
                        <div class="notification-content">${notification.content}</div>
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
            </div>
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

                        // Đánh dấu đã đọc
                        if (this.classList.contains('unread')) {
                            markAsRead(id);
                            this.classList.remove('unread');
                        }

                        // Chuyển hướng dựa trên loại thông báo
                        redirectBasedOnType(type, relatedId);
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

                function redirectBasedOnType(type, relatedId) {
                    switch (type) {
                        case 'course':
                            window.location.href = '${pageContext.request.contextPath}/lesson?courseId=' + relatedId;
                            break;
                        case 'message':
                            window.location.href = '${pageContext.request.contextPath}/chat?id=' + relatedId;
                            break;
                        case 'payment':
                            window.location.href = '${pageContext.request.contextPath}/order-details?id=' + relatedId;
                            break;
                        case 'system':
                            window.location.href = '${pageContext.request.contextPath}/system-notice?id=' + relatedId;
                            break;
                        default:
                            window.location.href = '${pageContext.request.contextPath}/dashboard';
                            break;
                    }
                }
            });
        </script>
    </body>
</html>