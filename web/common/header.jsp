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
    <form id="search" action="course" method="post" style="display: inline;">
        <div class="material-icons magnification-glass md-18">search</div>
        <input type="text" name="search" placeholder="Search for anything" />
    </form>

    <!-- Category dropdown form -->
   <div class="categories-container">
    <form id="categories-dropdown" action="courses" method="get">
        <select class="select-category" name="category" onchange="this.form.submit()">
            <option value="">All categories</option>
            <c:forEach var="category" items="${categories}">
                <option value="${category.categoryID}">${category.name}</option>
            </c:forEach>
        </select>
    </form>
</div>

    <div class="right">
        <a id="my-course" href="${pageContext.request.contextPath}/Blog">Blog</a>
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
