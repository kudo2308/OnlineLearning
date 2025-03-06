<%-- 
    Document   : Cart
    Created on : Mar 3, 2025, 9:52:37 PM
    Author     : ASUS
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cartStyle.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
    </head>

    <body>

        <jsp:include page="/common/header.jsp"></jsp:include>
        <hr style="color: #dddddd">
            <div class="container">

                <div class="cart-container">
                    <div class="cart-des">
                        <h2>Shopping Cart</h2>
                        <!--                    <p class="course-count">3 Courses in Cart</p>-->
                    <c:forEach var="item" items="${cart}">
                        <div class="cart-item">
                            <img src="${pageContext.request.contextPath}${item.course.imageUrl}" alt="Adobe Illustrator Course">
                            <div class="course-details">
                                <a href="${pageContext.request.contextPath}/coursedetail?courseId=${item.course.courseID}">${item.course.title}</a>
                                <p>
                                    <c:if test="${not empty item.course.expert}">
                                        ${item.course.expert.fullName}
                                    </c:if>
                                </p>
                                <!--                                <p>4 total hours | 13 lectures | All Levels</p>-->
                                <form action="cart?action=delete&courseId=${item.course.courseID}" method="post">
                                    <button class="action-box" type="submit">Remove</button>
                                </form>

                            </div>
                            <div class="price">
                                <p class="discounted">${item.course.price}</p>
                                <p class="original">₫399,000</p>
                            </div>
                            <label class="checkbox-container">
                                <input type="checkbox" class="course-checkbox" data-price="${item.course.price}">
                                <span class="checkmark"></span> Select
                            </label>
                        </div>
                    </c:forEach>

                </div>

                <div class="checkout-out">
                    <div class="checkout">
                        <p class="total">Total: <span id="total-price"></span></p>
                        <button class="checkout-btn" onclick="checkout()">Proceed to Checkout</button>

                        <!-- Coupon Section -->
                        <div class="coupon">
                            <p>Promotions</p>
                            <input type="text" placeholder="Enter Coupon">
                            <button class="apply-btn">Apply</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Course List -->


        <script src="${pageContext.request.contextPath}/assets/js/CartJs.js"></script>
    </body>
</html>
