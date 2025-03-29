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
        <style>
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top: 120px;
                left: 0;
                right: 0;
                background-color: rgba(208, 22, 39, 0.8);
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }

            .success {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #00CC00;
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/common/header.jsp"></jsp:include>
            <hr style="color: #dddddd">
            <div class="container">

                <div class="cart-container">
                    <div class="cart-des">
                        <h2>Shopping Cart</h2>
                        <p class="course-count">${totalCourse} Courses in Cart</p>
                    <c:forEach var="item" items="${cart}">
                        <div class="cart-item">
                            <img src="${pageContext.request.contextPath}${item.course.imageUrl}" alt="Course">
                            <div class="course-details">
                                <a href="${pageContext.request.contextPath}/coursedetail?courseId=${item.course.courseID}">${item.course.title}</a>
                                <p>${item.course.expert.fullName}</p>
                                <form class="action-box" action="cart?action=delete&courseId=${item.course.courseID}" method="post">
                                    <button type="submit">Remove</button>
                                </form>
                            </div>
                            <c:choose>
                                <c:when test="${item.course.discountPrice > 0}">
                                    <div class="price">
                                        <p class="discounted">
                                            <fmt:formatNumber value="${item.course.discountPrice}" type="currency" currencySymbol="" pattern="#,###" />đ
                                        </p>
                                        <p class="original">
                                            <fmt:formatNumber value="${item.course.price}" type="currency" currencySymbol="" pattern="#,###" />đ
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="price">
                                        <p class="discounted">
                                            <fmt:formatNumber value="${item.course.price}" type="currency" currencySymbol="" pattern="#,###" />đ
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <form class="action-box" action="cart?action=delete&courseId=${item.course.courseID}" method="post">
                                <button  type="submit">Remove</button>
                            </form>

                            <label class="checkbox-container">
                                <input type="checkbox" class="course-checkbox" 
                                       data-price="${item.course.discountPrice}" 
                                       data-course-id="${item.course.courseID}" 
                                       data-expert-id="${item.course.expertID}">
                            </label>
                        </div>
                    </c:forEach>
                </div>

                <div class="checkout-out">
                    <div class="checkout">
                        <div class="price-checkout">
                            <p class="total">Total:</p>
                            <span id="total-price">0đ</span>
                        </div>
                        <div class="price-checkout">
                            <p class="discounted-price">Discounted Price:</p>
                            <span id="discounted-price">0đ</span>
                        </div>

                        <div class="coupon">
                            <p>Promotions</p>
                            <form id="couponForm" action="javascript:void(0);" method="GET">
                                <input id="couponCode" type="text" name="couponCode" placeholder="Enter Coupon">
                                <button class="apply-btn" type="button">Apply</button>
                            </form>
                        </div>
                        <button class="checkout-btn" onclick="checkout()">Proceed to Checkout</button>

                        <!-- Coupon Section -->
                        <!-- Coupon Section -->


                    </div>
                </div>

            </div>
        </div>
        <c:set var="error" value="${requestScope.error}" />
        <c:if test="${not empty error}">
            <div id="error-message" class="error-message">
                <i class="bx bxs-error"></i> ${error}
            </div>
        </c:if>
        <c:set var="success" value="${requestScope.success}" />
        <c:if test="${not empty success}">
            <div id="success" class="success">
                <i class="bx bxs-error"></i> ${success}
            </div>
        </c:if>

        <script src="${pageContext.request.contextPath}/assets/js/CartJs.js"></script>
        <script>
                            function showMessage() {
                                var errorMessage = document.getElementById("error-message");
                                var successMessage = document.getElementById("success");

                                // Hiển thị thông báo lỗi nếu có
                                if (errorMessage) {
                                    errorMessage.style.display = "block";
                                    setTimeout(function () {
                                        errorMessage.style.display = "none";
                                    }, 3000);
                                }

                                // Hiển thị thông báo thành công nếu có
                                if (successMessage) {
                                    successMessage.style.display = "block";
                                    setTimeout(function () {
                                        successMessage.style.display = "none";
                                    }, 3000);
                                }
                            }

                            // Gọi hàm khi trang đã tải xong
                            window.onload = function () {
                                showMessage();
                            };
        </script>
    </body>
</html>
