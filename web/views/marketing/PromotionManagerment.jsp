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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Promotion List</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/pagination.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/marketing.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        
        <style>
            .notification-container {
                margin-bottom: 20px;
            }
            
            .notification {
                padding: 15px;
                border-radius: 4px;
                position: relative;
                margin-bottom: 15px;
            }
            
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .close-btn {
                position: absolute;
                right: 10px;
                top: 10px;
                cursor: pointer;
                font-weight: bold;
            }
            
            .header-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .filter-list {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }
            
            .filter-search {
                margin-bottom: 20px;
            }
            
            .status-active {
                background-color: #d4edda;
                color: #155724;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            
            .action-button {
                padding: 5px 10px;
                margin: 0 2px;
                border-radius: 4px;
                text-decoration: none;
                display: inline-block;
            }
            
            .edit-btn {
                background-color: #ffc107;
                color: #212529;
            }
            
            .delete-btn {
                background-color: #dc3545;
                color: #fff;
            }
            
            .form-control2 {
                display: block;
                width: 100%;
                padding: 0.375rem 0.75rem;
                font-size: 1rem;
                line-height: 1.5;
                color: #495057;
                background-color: #fff;
                background-clip: padding-box;
                border: 1px solid #ced4da;
                border-radius: 0.25rem;
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }
            
            .card-marketing {
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                padding: 20px;
            }
            
            .table-marketing {
                border-collapse: collapse;
                width: 100%;
                margin-bottom: 20px;
            }
            
            .table-marketing th, .table-marketing td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            
            .table-marketing th {
                background-color: #f0f0f0;
            }
            
            .btn-marketing-primary {
                background-color: #4CAF50;
                color: #fff;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            
            .btn-marketing-primary:hover {
                background-color: #3e8e41;
            }
            
            .pagination-container {
                margin-top: 20px;
            }
            
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .page-item {
                margin: 0 5px;
            }
            
            .page-link {
                color: #337ab7;
                text-decoration: none;
                transition: color 0.2s ease;
            }
            
            .page-link:hover {
                color: #23527c;
            }
            
            .badge {
                display: inline-block;
                padding: 5px 10px;
                font-size: 12px;
                font-weight: bold;
                line-height: 1;
                color: #fff;
                text-align: center;
                white-space: nowrap;
                vertical-align: baseline;
                border-radius: 10px;
            }
            
            .badge-info {
                background-color: #5bc0de;
            }
            
            .badge-secondary {
                background-color: #6c757d;
            }
        </style>
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <!-- Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Promotion Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Promotion List</li>
                    </ul>
                </div>

                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box card-marketing">
                            <div class="wc-title d-flex justify-content-between align-items-center">
                                <h4>Promotion List</h4>
                                <a href="${pageContext.request.contextPath}/promotion" class="btn btn-marketing-primary">
                                    <span class="material-icons">add</span> Add promotion
                                </a>
                            </div>
                            
                            <div class="widget-inner marketing-container">
                                <div id="notificationContainer" class="notification-container">
                                    <c:if test="${not empty message}">
                                        <div class="notification ${messageType}">
                                            ${message}
                                            <span class="close-btn" onclick="this.parentElement.remove()">&times;</span>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Filter section -->
                                <div class="filter-section mb-4">
                                    <form action="${pageContext.request.contextPath}/promotionList?action=" method="get" class="row g-3 align-items-center">
                                        <div class="col-md-4">
                                            <div class="form-group mb-0">
                                                <label for="discountType" class="visually-hidden">Discount Type</label>
                                                <select name="discountType" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                                    <option value="">All Discount Types</option>
                                                    <option value="percentage" ${discountType == 'percentage' ? 'selected' : ''}>Percentage</option>
                                                    <option value="fixed" ${discountType == 'fixed' ? 'selected' : ''}>Fixed</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group mb-0">
                                                <label for="status" class="visually-hidden">Status</label>
                                                <select name="status" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                                    <option value="">All Status</option>
                                                    <option value="true" ${status == 'true' ? 'selected' : ''}>Active</option>
                                                    <option value="false" ${status == 'false' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <input name="search" type="text" class="form-control" placeholder="Search promotions" value="${searchKeyword}">
                                                <div class="input-group-append">
                                                    <button class="btn btn-marketing-primary" type="submit">Search</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-marketing">
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
                                                        <a href="${pageContext.request.contextPath}/promotionList?action=edit&id=${promotion.promotionID}" class="btn btn-sm btn-warning">
                                                            <span class="material-icons">edit</span>
                                                        </a>
                                                        <a href="javascript:void(0);" onclick="deletePromotion('${promotion.promotionID}')" class="btn btn-sm btn-danger">
                                                            <span class="material-icons">delete</span>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-container">
                                        <ul class="pagination">
                                            <c:choose>
                                                <c:when test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/promotionList?page=${currentPage - 1}&discountType=${discountType}&status=${status}&search=${searchKeyword}">Previous</a>
                                                    </li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item disabled">
                                                        <span class="page-link">Previous</span>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/promotionList?page=${i}&discountType=${discountType}&status=${status}&search=${searchKeyword}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/promotionList?page=${currentPage + 1}&discountType=${discountType}&status=${status}&search=${searchKeyword}">Next</a>
                                                    </li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item disabled">
                                                        <span class="page-link">Next</span>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>
                                        </ul>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>

        <script>
            function deletePromotion(id) {
                if (confirm('Bạn có chắc chắn muốn xóa khuyến mãi này không?')) {
                    window.location.href = '${pageContext.request.contextPath}/promotionList?action=delete&id=' + id;
                }
            }

            // Đóng thông báo sau 5 giây
            setTimeout(function () {
                const notification = document.querySelector('.notification');
                if (notification) {
                    notification.style.display = 'none';
                }
            }, 5000);
        </script>
    </body>
</html>