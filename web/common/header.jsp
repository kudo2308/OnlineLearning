<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<title>Online Learning</title>

<nav>
    <!-- Your navigation bar code -->
    <c:choose>
        <c:when test="${not empty sessionScope.account}">
            <!-- Display Hello, account.name if account exists in session -->
            <a href="${pageContext.request.contextPath}/account">Hello, ${sessionScope.account.fullName}</a>
            <a href="${pageContext.request.contextPath}/logout">Sign out</a>
        </c:when>
        <c:otherwise>
            <!-- Default sign in or register if no account in session -->
            <a href="${pageContext.request.contextPath}/login">Sign in or Register</a>
        </c:otherwise>
    </c:choose>
</nav>

<header class="logo-body">
    <div id="logo">
        <a href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo">
        </a>
    </div>

    <!-- Search form -->
    <form id="search" action="course" method="post" style="display: inline;">
        <div class="material-icons magnification-glass md-18">search</div>
        <input type="text" name="search" placeholder="Search for anything" />
    </form>

    <!-- Category dropdown form -->
    <select id="categories-dropdown" onchange="this.form.submit())">
        <option href="${pageContext.request.contextPath}/products">All categories</option>
        <div class="material-icons md-18">
            arrow_drop_down
            <div class="dropdown-content">
                <c:forEach var="category" items="${categories}">
                    <option href="${pageContext.request.contextPath}/products?category=1">${category.name}</option>
                </c:forEach>

            </div>
    </select>

    <div class="right">
        <a id="my-course" href="${pageContext.request.contextPath}/blog">Blog</a>
        <a id="my-course" href="${pageContext.request.contextPath}/course">My Course</a>
        <a id="bell" href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">
            <span class="material-icons md-18">notifications_none</span>
        </a>
        <a href="${pageContext.request.contextPath}/cart" id="cart">
            <span class="material-icons md-18">shopping_cart</span>
        </a>
        <div class="image-container">
            <img class="avt" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
            <ul class="menu">
                <li>My learning</li>
                <li>My cart</li>
                <li>My account</li>
                <li>Logout</li>
            </ul>
        </div>
    </div>
</header>
