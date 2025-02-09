
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homestyle.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning</title>
    </head>
    <body>
        <jsp:include page="../common/header.jsp"></jsp:include>

            <div id="nav-categories">
                <a href="#">Explore (New!)</a>
            <c:if test="${not empty categories}">
                <c:forEach var="category" items="${categories}">
                    <a href="#">${category.name}</a>
                </c:forEach>
            </c:if>
        </div>

        <main>

            <div class="body-slide">
                <div class="slide-show">
                    <div class="list-images">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner1.jpg" alt="Banner 1">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner2.jpg" alt="Banner 2">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner3.jpg" alt="Banner 3">
                    </div>
                    <div class="btns">
                        <span class="btn-left btn material-icons md-36">
                            keyboard_arrow_left
                        </span>
                        <span class="btn-right btn material-icons md-36">
                            keyboard_arrow_right
                        </span>
                    </div>
                </div>
            </div>

            <div class="product-list">
                <span
                    class="material-symbols-outlined arrow-left"
                    onclick="scrollb('wow', 'left')">
                    arrow_back
                </span>
                <span
                    class="material-symbols-outlined arrow-right"
                    onclick="scrollb('wow', 'right')">
                    arrow_forward
                </span>
                <h1>Courses</h1>
                <ul id="wow">
                    <c:if test="${not empty courses}">
                        <c:forEach var="course" items="${courses}">
                            <li>
                                <img
                                    class="image-product"
                                    src="${pageContext.request.contextPath}/assets/images/courses/pic1.jpg"  alt="${course.title}">
                                <p>
                                    <a style="color: black; text-decoration: none" href="#">
                                        ${course.title}
                                    </a> 
                                    <p class="des-course">${course.description}$</p>
                                    <span>${course.price}$</span>
                                    
                                </p>
                            </li>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty courses}">
                        <li>Hiện chưa có sản phẩm mới.</li>
                        </c:if>
                </ul>
            </div>

        </main>
        <jsp:include page="../common/footer.jsp"></jsp:include> 
        <script src="${pageContext.request.contextPath}/assets/js/js.js"></script>
    </body>
</html>
