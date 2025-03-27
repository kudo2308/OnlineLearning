<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homecss.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<title>Online Learning</title>
<nav></nav>
<header class="logo-body">
    <div id="logo">
        <a href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo">
        </a>
    </div>

    <form id="search" action="CourseSearch" method="post">
        <div class="material-icons magnification-glass md-18">search</div>
        <input type="text" name="search" placeholder="Search for anything" />
    </form>

    <!-- Category dropdown form -->
    <select id="categories-dropdown" onchange="this.form.submit()">
        <option value="${pageContext.request.contextPath}/CourseSearch">All categories</option>
        <c:forEach var="category" items="${categories}">
            <option value="${pageContext.request.contextPath}/CourseSearch?categoryId=${category.categoryID}">${category.name}</option>
        </c:forEach>
    </select>



    <div class="right-header">
        <c:choose>
            <c:when test="${not empty sessionScope.account && sessionScope.account.roles == 'Expert'}">
                <a id="my-course" class="instructor" href="${pageContext.request.contextPath}/courses">Instructor</a>
            </c:when>
            <c:when test="${empty sessionScope.account || empty sessionScope.account.roles}">
                <a id="my-course" class="instructor" href="${pageContext.request.contextPath}/login">Instructor</a>
            </c:when>
            <c:otherwise>
                <div class="popover-container">
                    <a href="#" id="my-course">Instructor</a>
                    <div class="popover-content">
                        <p>Become an Expert and put your courses on Online Learning</p>
                        <a href="${pageContext.request.contextPath}/instructor" class="learn-btn">Get started</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <a id="my-course" href="${pageContext.request.contextPath}/Blog">Blog</a>

        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <a id="my-course" href="${pageContext.request.contextPath}/course">My Course</a>
                <div class="notification-dropdown">
                    <a id="bell" href="#" class="notification-icon">
                        <span class="material-icons md-18">notifications_none</span>
                        <span class="notification-bad" id="notification-bad" style="display: none;">0</span>
                    </a>
                    <div class="notification-content" id="notification-content">
                        <div class="notification-header">
                            <h3>Notify</h3>
                            <a href="#" id="mark-all-read">Mark all read</a>
                        </div>
                        <div class="notification-list" id="notification-list">
                            <!-- Notifications will be loaded dynamically via JavaScript -->
                        </div>
                        <div class="notification-footer">
                            <a href="${pageContext.request.contextPath}/notifications">See all</a>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/cart" id="cart" class="cart-icon">
                    <c:if test="${not empty sessionScope.totalCourse and sessionScope.totalCourse > 0}">
                        <span class="cart-count">${sessionScope.totalCourse > 99 ? '99+' : sessionScope.totalCourse}</span>
                    </c:if>
                    <span class="material-icons">shopping_cart</span>
                </a>



                <div class="account-dropdown">
                    <div class="account-avatar">
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
                    </div>
                    <div class="dropdown-content">
                        <div class="account-header">
                            <div class="avatar-circle">
                                <c:choose>
                                    <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/profile/unknow.jpg'}">
                                        <img style="border-radius: 50%;" class="avt" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                    </c:when>
                                    <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                                        <img style="border-radius: 50%;" class="avt" src="${sessionScope.account.img}">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="border-radius: 50%;" class="avt" src="${pageContext.request.contextPath}${sessionScope.account.img}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="account-info">
                                <p class="account-name">${sessionScope.account.username}</p>
                                <p class="account-email">${sessionScope.account.gmail}</p>
                            </div>
                        </div>
                        <ul class="account-menu">
                            <li><a href="${pageContext.request.contextPath}/publicprofile?email=${sessionScope.account.gmail}">View Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/userprofile">Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/myblog">My blog</a></li>
                            <li><a href="${pageContext.request.contextPath}/private">Social & Privacy</a></li>
                                <c:if test="${not empty sessionScope.account && sessionScope.account.roles == 'Expert'}">
                                <li><a href="${pageContext.request.contextPath}/wallet">Expert Wallet</a></li>
                                </c:if>
                            <li><a href="${pageContext.request.contextPath}/purchase">Purchase history </a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">Sign out</a></li>

                        </ul>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="auth-buttons">
                    <a class="login" href="${pageContext.request.contextPath}/login">Log in</a>
                    <a class="signup" href="${pageContext.request.contextPath}/register">Sign up</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>

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
            case 'payment':
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