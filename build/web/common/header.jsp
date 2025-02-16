<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<title>Online Learning</title>

<nav>
    <!-- Your navigation bar code -->
    
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
    <select id="categories-dropdown" onchange="this.form.submit())">
        <option href="${pageContext.request.contextPath}/courses">All categories</option>
        <div class="material-icons md-18">
            arrow_drop_down
            <div class="dropdown-content">
                <c:forEach var="category" items="${categories}">
                    <option href="${pageContext.request.contextPath}/products?category=${category.categoryID}">${category.name}</option>
                </c:forEach>

            </div>
    </select>

    <div class="right">
        <a id="my-course" href="${pageContext.request.contextPath}/Blog">Blog</a>
        <a id="my-course" href="${pageContext.request.contextPath}/course">My Course</a>
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <!-- Display Hello, account.name if account exists in session -->
                <a id="bell" href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">
                    <span class="material-icons md-18">notifications_none</span>
                </a>
                <a href="${pageContext.request.contextPath}/cart" id="cart">
                    <span class="material-icons md-18">shopping_cart</span>
                </a>
                <div class="image-container">
                    <img class="avt" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                    <ul class="menu">
                        <li><a href="${pageContext.request.contextPath}/account">Hello, ${sessionScope.account.fullName}</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout">Sign out</a></li>
                    </ul>
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
