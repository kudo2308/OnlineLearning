<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homecss.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<header class="ttr-header">
    <div class="ttr-header-wrapper">
        <!--sidebar menu toggler start -->
        <div class="ttr-toggle-sidebar ttr-material-button">
            <i class="ti-close ttr-open-icon"></i>
            <i class="ti-menu ttr-close-icon"></i>
        </div>
        <!--sidebar menu toggler end -->
        <div class="ttr-logo-box">
            <div>
                <a href="home" class="ttr-logo">
                    <img alt="" class="ttr-logo-mobile" src="assets/images/logo-mobile.png" width="30" height="30">
                    <img alt="" class="ttr-logo-desktop" src="assets/images/logo-white.png" width="160" height="27">
                </a>
            </div>
        </div>
        <div class="ttr-header-menu">
            <!-- header left menu start -->
            <ul class="ttr-header-navigation">
                <li>
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="ttr-material-button ttr-submenu-toggle">DASHBOARD</a>
                </li>
                <li>
                    <a href="#" class="ttr-material-button ttr-submenu-toggle">QUICK MENU <i class="fa fa-angle-down"></i></a>
                    <div class="ttr-header-submenu">
                        <ul>
                            <li><a href="#">Courses List</a></li>
                            <li><a href="${pageContext.request.contextPath}/UserList">Users List</a></li>
                            <li><a href="#">Registration List</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
            <!-- header left menu end -->
        </div>
        <div class="ttr-header-right ttr-with-seperator">
            <!-- header right menu start -->
            <ul class="ttr-header-navigation">
                <li>
                    <a href="#" class="ttr-material-button ttr-search-toggle"><i class="fa fa-search"></i></a>
                </li>
                <li>
                    <div class="notification-dropdown">
                        <a id="bell" href="#" class="notification-icon">
                            <span class="material-icons md-18" style="margin: 16px 8px;    height: 60px;    text-align: center;">notifications_none</span>
                            <span class="notification-bad" id="notification-bad" style="display: none;">0</span>
                        </a>
                        <div class="notification-content" id="notification-content" style="right: 15px;top: 37px;">
                            <div class="notification-header">
                                <h3>Notify</h3>
                                <a href="#" id="mark-all-read">Mark all read</a>
                            </div>
                            <div class="notification-list" id="notification-list">
                                <!-- Notifications will be loaded dynamically via JavaScript -->
                            </div>
                            <div class="notification-footer">
                                <a href="${pageContext.request.contextPath}/adminNotify">See all</a>
                            </div>
                        </div>
                    </div>
                </li>
                <li>
                    <a href="#" class="ttr-material-button ttr-submenu-toggle"><span class="ttr-user-avatar">
                            <c:choose>
                                <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/profile/unknow.jpg'}">
                                    <img class="avt" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                </c:when>
                                <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                                    <img class="avt" src="${sessionScope.account.img}">
                                </c:when>
                                <c:otherwise>
                                    <img class="avt" src="${pageContext.request.contextPath}${sessionScope.account.img}">
                                </c:otherwise>
                            </c:choose> 
                        </span></a>
                    <div class="ttr-header-submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
            <!-- header right menu end -->
        </div>
        <!--header search panel start -->
        <div class="ttr-search-bar">
            <form class="ttr-search-form">
                <div class="ttr-search-input-wrapper">
                    <input type="text" name="qq" placeholder="search something..." class="ttr-search-input">
                    <button type="submit" name="search" class="ttr-search-submit"><i class="ti-arrow-right"></i></button>
                </div>
                <span class="ttr-search-close ttr-search-toggle">
                    <i class="ti-close"></i>
                </span>
            </form>
        </div>
        <!--header search panel end -->
    </div>

    <script>
        var contextPath = '${pageContext.request.contextPath}';
        document.addEventListener('DOMContentLoaded', function () {
            if (document.getElementById('notification-bad')) {
                fetchNotificationCount();
                setInterval(fetchNotificationCount, 30000);
                document.getElementById('bell').addEventListener('click', function (e) {
                    e.preventDefault();
                    var notificationContent = document.getElementById('notification-content');
                    if (notificationContent.style.display === 'block') {
                        notificationContent.style.display = 'none';
                    } else {
                        notificationContent.style.display = 'block';
                        fetchNotifications();
                    }
                });
                document.getElementById('mark-all-read').addEventListener('click', function (e) {
                    e.preventDefault();
                    markAllAsRead();
                });
                document.addEventListener('click', function (e) {
                    var notificationDropdown = document.querySelector('.notification-dropdown');
                    var notificationContent = document.getElementById('notification-content');
                    if (!notificationDropdown.contains(e.target) && notificationContent.style.display === 'block') {
                        notificationContent.style.display = 'none';
                    }
                });
            }
        });
        function fetchNotificationCount() {
            fetch(contextPath + '/notifications?action=count', {
                method: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
                    .then(response => response.json())
                    .then(data => {
                        var badge = document.getElementById('notification-bad');
                        if (data.count > 0) {
                            badge.textContent = data.count > 99 ? '99+' : data.count;
                            badge.style.display = 'block';
                        } else {
                            badge.style.display = 'none';
                        }
                    })
                    .catch(error => console.error('Error fetching notification count:', error));
        }

        function fetchNotifications() {
            var notificationList = document.getElementById('notification-list');
            notificationList.innerHTML = '<div class="loading">Loading...</div>';
            fetch(contextPath + '/notifications?action=getUnread', {
                method: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
                    .then(response => response.json())
                    .then(data => {
                        notificationList.innerHTML = '';
                        if (data.length === 0) {
                            notificationList.innerHTML = '<div class="notification-item">No notifications received</div>';
                            return;
                        }
                        data.forEach(notification => {
                            var notificationItem = document.createElement('div');
                            notificationItem.className = 'notification-item unread notification-type-' + notification.type;
                            notificationItem.setAttribute('data-id', notification.notificationID);
                            notificationItem.setAttribute('data-type', notification.type);
                            notificationItem.setAttribute('data-related-id', notification.relatedID);
                            var title = document.createElement('div');
                            title.className = 'notification-title';
                            title.textContent = notification.title;
                            var content = document.createElement('div');
                            content.className = 'notification-content';
                            content.textContent = notification.content;
                            var meta = document.createElement('div');
                            meta.className = 'notification-meta';
                            var timeSpan = document.createElement('span');
                            timeSpan.className = 'notification-time';
                            timeSpan.textContent = formatTime(new Date(notification.createdAt));
                            var typeSpan = document.createElement('span');
                            typeSpan.className = 'notification-type type-' + notification.type;
                            typeSpan.textContent = notification.type;
                            meta.appendChild(timeSpan);
                            meta.appendChild(typeSpan);
                            notificationItem.appendChild(title);
                            notificationItem.appendChild(content);
                            notificationItem.appendChild(meta);
                            notificationItem.addEventListener('click', function () {
                                markAsRead(notification.notificationID);
                                handleNotificationClick(notification);
                            });
                            notificationList.appendChild(notificationItem);
                        });
                    })
                    .catch(error => {
                        console.error('Error fetching notifications:', error);
                        notificationList.innerHTML = '<div class="notification-item">Error loading notifications</div>';
                    });
        }

        function markAsRead(notificationID) {
            fetch(contextPath + '/notifications?action=markRead&id=' + notificationID, {
                method: 'POST',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
                    .then(() => fetchNotificationCount())
                    .catch(error => console.error('Error marking notification as read:', error));
        }

        function markAllAsRead() {
            fetch(contextPath + '/notifications?action=markAllRead', {
                method: 'POST',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
                    .then(() => {
                        fetchNotificationCount();
                        fetchNotifications();
                    })
                    .catch(error => console.error('Error marking all notifications as read:', error));
        }

        function handleNotificationClick(notification) {
            switch (notification.type) {
                case 'course':
                    if (notification.relatedID) {
                        window.location.href = contextPath + '/lesson?courseId=' + notification.relatedID;
                    }
                    break;
                case 'message':
                    window.location.href = contextPath + '/notifications';
                    break;
                case 'fee':
                    window.location.href = contextPath + '/notifications';
                    break;
                case 'wallet':
                    window.location.href = contextPath + '/notifications';
                    break;
                case 'system':
                    window.location.href = contextPath + '/notifications';
                    break;
                case 'other':
                    window.location.href = contextPath + '/notifications';
                    break;
                default:
                    window.location.href = contextPath + '/notifications';
                    break;
            }
        }

        function formatTime(date) {
            const now = new Date();
            const diff = Math.floor((now - date) / 1000);
            if (diff < 60)
                return 'just send';
            else if (diff < 3600)
                return Math.floor(diff / 60) + ' minutes ago';
            else if (diff < 86400)
                return Math.floor(diff / 3600) + ' hours ago';
            else if (diff < 604800)
                return Math.floor(diff / 86400) + ' days ago';
            else
                return date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();
        }

        function updateCartCount() {
            fetch('${pageContext.request.contextPath}/cart?action=count', {
                method: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
                    .then(response => response.json())
                    .then(data => {
                        var cartCount = document.querySelector('.cart-count');
                        if (data.count > 0) {
                            if (!cartCount) {
                                var cartIcon = document.getElementById('cart');
                                cartCount = document.createElement('span');
                                cartCount.className = 'cart-count';
                                cartIcon.appendChild(cartCount);
                            }
                            cartCount.textContent = data.count;
                            cartCount.style.display = 'block';
                        } else {
                            if (cartCount) {
                                cartCount.style.display = 'none';
                            }
                        }
                    })
                    .catch(error => console.error('Error updating cart count:', error));
        }

        document.addEventListener('DOMContentLoaded', function () {
            updateCartCount();
            setInterval(updateCartCount, 30000);
        });

    </script>
</header>