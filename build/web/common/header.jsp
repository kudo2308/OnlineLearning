<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<title>Online Lerning</title>
<nav>
    <div id="nav" class="clearfix">
        <div>
            <!-- Default sign in or register if no account in session -->
            <a href="${pageContext.request.contextPath}/login">Sign in or Register</a>


            <a href="#">Helps and Contact</a>
        </div>
        <div class="right">
            <a id="dropdown-myebuy" href="${pageContext.request.contextPath}/account">My Course</a>
            <a id="bell" href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">
                <span class="material-icons md-18">notifications_none</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" id="cart">
                <span class="material-icons md-18">
                    shopping_cart
                </span>
            </a>
        </div>
    </div>
</nav>
<header class="logo-body">
    <div id="logo">
        <a href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="">
        </a>
    </div>

    <form id="search" action="products" method="post">
        <div class="material-icons magnification-glass md-18">
            search
        </div>
        <input type="text" name="search" placeholder="Search for anything " />
    </form>
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
    <button type="submit" id="button-search">Search</button>
</header>
