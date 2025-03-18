<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<title>Online Learning</title>

<nav>
</nav>

<header class="logo-body">
    <div id="logo">
        <a href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo">
        </a>
    </div>

    <!-- Search form -->
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
                <a id="my-course" class="instructor"
                   href="${pageContext.request.contextPath}/courses">
                    Instructor
                </a>
            </c:when>
            <c:when test="${empty sessionScope.account || empty sessionScope.account.roles}">
                <a id="my-course" class="instructor"
                   href="${pageContext.request.contextPath}/login">
                    Instructor
                </a>
            </c:when>

            <c:otherwise>
                <div class="popover-container">
                    <a href="#"  id="my-course" >Instructor</a>
                    <div class="popover-content">
                        <p>Become a Expert and put your courses on Online Learning</p>
                        <a href="${pageContext.request.contextPath}/instructor" class="learn-btn">Get started</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <a id="my-course" href="${pageContext.request.contextPath}/Blog">Blog</a>

        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <a id="my-course" href="${pageContext.request.contextPath}/course">My Course</a>
                <!-- Display Hello, account.name if account exists in session -->
                <a id="bell" href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">
                    <span class="material-icons md-18">notifications_none</span>
                </a>
                <a href="${pageContext.request.contextPath}/cart" id="cart">
                    <span class="material-icons md-18">shopping_cart</span>
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
                                        <img style=" border-radius: 50%;" class="avt" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                    </c:when>
                                    <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                                        <img style=" border-radius: 50%;" class="avt" src="${sessionScope.account.img}">
                                    </c:when>
                                    <c:otherwise>
                                        <img  style=" border-radius: 50%;" class="avt" src="${pageContext.request.contextPath}${sessionScope.account.img}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="account-info">
                                <p class="account-name">${sessionScope.account.username}</p>
                                <p class="account-email">${sessionScope.account.gmail}</p>
                            </div>
                        </div>
                        <ul class="acount-menu">
                            <li><a href="${pageContext.request.contextPath}/publicprofile?email=${sessionScope.account.gmail}">View Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/userprofile">Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/myblog">My blog</a></li>
                            <li><a href="${pageContext.request.contextPath}/private">Social & Privacy</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">Sign out</a></li>

                        </ul>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Default sign in or register if no account in session -->
                <div class="auth-buttons">
                    <a class="login" href="${pageContext.request.contextPath}/login">Log in</a>
                    <a class="signup" href="${pageContext.request.contextPath}/register">Sign up</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>