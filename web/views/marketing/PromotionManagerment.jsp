<%-- 
    Document   : PromotionList
    Created on : Mar 27, 2025, 10:45:32 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/promotionListStyle.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

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
            <hr style="color: #dddddd">

            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Courses</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                <li>Promotion List</li>
            </ul>
        </div>

        <div class="card">
            <div id="notificationContainer" class="notification-container">
                <c:if test="${not empty message}">
                    <div class="notification ${messageType}">
                        ${message}
                        <span class="close-btn" onclick="this.parentElement.remove()">&times;</span>
                    </div>
                </c:if>
            </div>
            <div class="header-actions">
                <h2>Promotion List</h2>
                <a href="${pageContext.request.contextPath}/promotion" class="btn btn-primary">
                    <span class="material-icons">add</span> Add promotion
                </a>
            </div>
            <form id="filter-form" action="promotionList?action=" method="get">
                <div class="filter-list">
                    <!-- Filter by Discount Type -->
                    <select name="discountType" class="form-control2" onchange="document.getElementById('filter-form').submit();">
                        <option value="">All Discount Types</option>
                        <option value="percentage" ${discountType == 'percentage' ? 'selected' : ''}>Percentage</option>
                        <option value="fixed" ${discountType == 'fixed' ? 'selected' : ''}>Fixed</option>
                    </select>

                    <!-- Filter by Status -->
                    <select name="status" class="form-control2" onchange="document.getElementById('filter-form').submit();">
                        <option value="">All Status</option>
                        <option value="true" ${status == 'true' ? 'selected' : ''}>Active</option>
                        <option value="false" ${status == 'false' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="filter-search">
                    <div class="input-group">
                        <input name="search" type="text" class="form-control" placeholder="Search coupons" value="${searchKeyword}">
                    </div>
                </div>
            </form> 
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Promotion Code</th>
                            <th>Discount Type</th>
                            <th>Value</th>
                            <th>Apply for</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="promotion" items="${promotions}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${promotion.promotionCode}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${promotion.discountType eq 'percentage'}">Percent (%)</c:when>
                                        <c:when test="${promotion.discountType eq 'fixed'}">Fixed money (VNĐ)</c:when>
                                        <c:otherwise>${promotion.discountType}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${promotion.discountType eq 'percentage'}">
                                            ${promotion.discountValue}%
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${promotion.categoryID != 0}">
                                            <span class="material-icons">category</span> ${categoryMap[promotion.categoryID]}
                                        </c:when>
                                        <c:when test="${promotion.expertID != 0}">
                                            <span class="material-icons">person</span> ${expertMap[promotion.expertID]}
                                        </c:when>
                                        <c:when test="${promotion.courseID != 0}">
                                            <span class="material-icons">school</span> ${courseMap[promotion.courseID]}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-icons">public</span> All course
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="${promotion.status ? 'status-active' : 'status-inactive'}">
                                        ${promotion.status ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/promotion?action=edit&id=${promotion.promotionID}" class="action-button edit-btn">
                                        <span class="material-icons">edit</span> Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/promotionList?action=toggle&id=${promotion.promotionID}" class="action-button toggle-btn">
                                        <span class="material-icons">toggle_on</span> ${promotion.status ? 'Inactive' : 'Active'}
                                    </a>
                                    <a href="javascript:void(0)" onclick="deletePromotion(${promotion.promotionID})" class="action-button delete-btn">
                                        <span class="material-icons">delete</span> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty promotions}">
                    <div style="text-align: center; padding: 20px; color: #666;">
                        <p>Không có khuyến mãi nào. Hãy thêm khuyến mãi mới!</p>
                    </div>
                </c:if>
            </div>

            <c:if test="${reportGenerated}">
                <div class="card">
                    <h2>Báo Cáo Khuyến Mãi</h2>
                    <!-- Hiển thị nội dung báo cáo ở đây -->
                    <div style="margin-top: 15px;">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã Khuyến Mãi</th>
                                    <th>Số Lượng Khóa Học Áp Dụng</th>
                                    <th>Tổng Giảm Giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="promotion" items="${promotions}">
                                    <tr>
                                        <td>${promotion.promotionCode}</td>
                                        <td><!-- Số lượng khóa học áp dụng --></td>
                                        <td><!-- Tổng giảm giá --></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>

        <script>
            function deletePromotion(id) {
                if (confirm('Bạn có chắc chắn muốn xóa khuyến mãi này không?')) {
                    window.location.href = '${pageContext.request.contextPath}/promotionList?action=delete&id=' + id;
                }
            }

            function resetPrices(id) {
                if (confirm('Bạn có chắc chắn muốn reset giá các khóa học về giá ban đầu không?')) {
                    // Tạo một form để gửi request POST
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '${pageContext.request.contextPath}/promotionList?action=reset&id=' + id;

                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Tự động ẩn thông báo sau 5 giây
            setTimeout(function () {
                const notifications = document.getElementsByClassName('notification');
                for (let i = 0; i < notifications.length; i++) {
                    notifications[i].style.display = 'none';
                }
            }, 5000);
            // Tự động ẩn thông báo sau 5 giây
            setTimeout(function () {
                const notifications = document.querySelectorAll('.notification');
                notifications.forEach(function (notification) {
                    notification.style.opacity = '0';
                    notification.style.transform = 'translateX(100%)';
                    notification.style.transition = 'opacity 0.5s, transform 0.5s';
                    setTimeout(function () {
                        notification.remove();
                    }, 500);
                });
            }, 5000);
            // Hàm để hiển thị thông báo động
            function showNotification(message, type) {
                const container = document.getElementById('notificationContainer');
                const notification = document.createElement('div');
                notification.className = 'notification ' + type;
                notification.innerHTML = message + '<span class="close-btn" onclick="this.parentElement.remove()">&times;</span>';
                container.appendChild(notification);

                // Tự động ẩn sau 5 giây
                setTimeout(function () {
                    notification.style.opacity = '0';
                    notification.style.transform = 'translateX(100%)';
                    notification.style.transition = 'opacity 0.5s, transform 0.5s';
                    setTimeout(function () {
                        notification.remove();
                    }, 500);
                }, 5000);
            }
        </script>
    </body>
</html> 