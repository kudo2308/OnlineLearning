<%-- 
    Document   : addPromotion
    Created on : Mar 27, 2025, 10:24:35 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="EduChamp : Education HTML Template" />

        <!-- OG -->
        <meta property="og:title" content="EduChamp : Education HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Coupon List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/promotionStyle.css" />
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Online Learning</title>
        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/pagination.css">

        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

            <div class="container">
            <c:if test="${not empty message}">
                <div class="notification ${messageType}">${message}</div>
            </c:if>

            <!-- Form Thêm Khuyến Mãi Mới -->
            <div class="card">
                <h1>New Promotion</h1>
                <form action="${pageContext.request.contextPath}/promotion" method="post">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group">
                        <label for="promotionCode">Promotion Code:</label>
                        <input type="text" id="promotionCode" name="promotionCode" required 
                               placeholder="Enter promotion (for example: SUMMER2025)">
                    </div>

                    <div class="form-group">
                        <label for="discountType">Discount Type:</label>
                        <select id="discountType" name="discountType" required>
                            <option value="percentage">Percent(%)</option>
                            <option value="fixed">Fixed price(VNĐ)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="discountValue">Discount Value:</label>
                        <input type="number" id="discountValue" name="discountValue" min="0" required
                               placeholder="Value price">
                    </div>

                    <!-- Lựa chọn Áp Dụng Cho -->
                    <div class="form-group">
                        <label for="applyTo">Apply for:</label>
                        <select id="applyTo" name="applyTo" onchange="showFilterOptions(this.value)">
                            <option value="all">All Course</option>
                            <option value="category">Category</option>
                            <option value="expert">Expert</option>
                            <option value="course">Course</option>
                        </select>
                    </div>

                    <!-- Lựa chọn Danh Mục -->
                    <div id="categoryFilter" class="filter-section">
                        <div class="form-group">
                            <label for="categoryID">Choose category:</label>
                            <select id="categoryID" name="categoryID">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}">${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Giảng Viên -->
                    <div id="expertFilter" class="filter-section">
                        <div class="form-group">
                            <label for="expertID">Choose expert:</label>
                            <select id="expertID" name="expertID">
                                <c:forEach var="expert" items="${experts}">
                                    <option value="${expert.userID}">${expert.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Khóa Học -->
                    <div id="courseFilter" class="filter-section">
                        <div class="form-group">
                            <label for="courseID">Choose course:</label>
                            <select id="courseID" name="courseID">
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.courseID}">${course.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Thêm option hiển thị giá đã giảm -->
                    <div class="form-group checkbox-container">
                        <input type="checkbox" id="showDiscountedPrice" name="showDiscountedPrice" checked>
                        <label for="showDiscountedPrice">Show discout price on the course</label>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">Create</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showFilterOptions(value) {
                // Ẩn tất cả các section filter
                document.getElementById('categoryFilter').style.display = 'none';
                document.getElementById('expertFilter').style.display = 'none';
                document.getElementById('courseFilter').style.display = 'none';

                // Hiển thị section filter tương ứng
                if (value === 'category') {
                    document.getElementById('categoryFilter').style.display = 'block';
                } else if (value === 'expert') {
                    document.getElementById('expertFilter').style.display = 'block';
                } else if (value === 'course') {
                    document.getElementById('courseFilter').style.display = 'block';
                }
            }

            // Khởi tạo hiển thị mặc định
            window.onload = function () {
                const applyTo = document.getElementById('applyTo').value;
                showFilterOptions(applyTo);
            };
        </script>
    </body>
</html>