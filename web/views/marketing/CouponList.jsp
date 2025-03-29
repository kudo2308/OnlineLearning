<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

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
        <title>Coupon List</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
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
            
            .alert2 {
                padding: 15px;
                border-radius: 4px;
                position: relative;
                margin-bottom: 20px;
            }
            
            .alert-success2 {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .alert-danger2 {
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
            
            .action-buttons {
                display: flex;
                gap: 5px;
            }
            
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                align-items: center;
                justify-content: center;
            }
            
            .modal-content {
                background-color: #fff;
                padding: 20px;
                border-radius: 5px;
                width: 80%;
                max-width: 500px;
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
        </style>
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <!-- Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Coupon Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Coupon List</li>
                    </ul>
                </div>

                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box card-marketing">
                            <div class="wc-title d-flex justify-content-between">
                                <h4>Coupon List</h4>
                                <button class="btn btn-marketing-primary" onclick="showAddForm()">
                                    <i class="fa fa-plus-circle"></i> Add Coupon
                                </button>
                            </div>
                            
                            <div class="widget-inner marketing-container">
                                <c:if test="${not empty message}">
                                    <div class="alert2 alert-success2" id="alert-box">
                                        <c:choose>
                                            <c:when test="${message eq 'created'}">Coupon add successfully!</c:when>
                                            <c:when test="${message eq 'updated'}">Coupon update successfully!</c:when>
                                            <c:when test="${message eq 'deleted'}">Coupon remove successfully!</c:when>
                                        </c:choose>
                                        <button class="close-btn" onclick="closeAlert()">×</button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty error}">
                                    <div class="alert2 alert-danger2" id="alert-box">
                                        <c:choose>
                                            <c:when test="${error eq 'deleteFailed'}">Can not remove coupon, please try again!</c:when>
                                            <c:when test="${error eq 'missingCouponCode'}">Coupon do not blank!</c:when>
                                        </c:choose>
                                        <button class="close-btn" onclick="closeAlert()">×</button>
                                    </div>
                                </c:if>

                                <!-- Filter section -->
                                <div class="filter-section mb-4">
                                    <form id="filter-form" action="couponList" method="get" class="row g-3 align-items-center">
                                        <div class="col-md-4">
                                            <select name="discountType" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                                <option value="">All Discount Types</option>
                                                <option value="percentage" ${discountType == 'percentage' ? 'selected' : ''}>Percentage</option>
                                                <option value="fixed" ${discountType == 'fixed' ? 'selected' : ''}>Fixed</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <select name="status" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                                <option value="">All Status</option>
                                                <option value="true" ${status == 'true' ? 'selected' : ''}>Active</option>
                                                <option value="false" ${status == 'false' ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <input name="search" type="text" class="form-control" placeholder="Search coupons" value="${searchKeyword}">
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary" type="submit">Search</button>
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
                                                <th>Coupon Code</th>
                                                <th>Discount Type</th>
                                                <th>Discount Value</th>
                                                <th>Status</th>
                                                <th>Created At</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${not empty couponList}">
                                                <c:forEach var="coupon" items="${couponList}">
                                                    <tr>
                                                        <td>${coupon.couponID}</td>
                                                        <td>
                                                            <span class="badge bg-primary text-white">${coupon.couponCode}</span>
                                                        </td>
                                                        <td>${coupon.discountType}</td>
                                                        <td>${coupon.discountValue}</td>
                                                        <td>
                                                            <span class="${coupon.status ? 'status-active' : 'status-inactive'}">
                                                                ${coupon.status ? 'Active' : 'Inactive'}
                                                            </span>
                                                        </td>
                                                        <td>${coupon.createdAt}</td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <form action="couponList" method="POST" style="display:inline;">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="couponID" value="${coupon.couponID}">
                                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                                                        <span class="material-symbols-outlined">delete</span>
                                                                    </button>
                                                                </form>

                                                                <button class="btn btn-sm btn-warning" onclick="showEditForm('${coupon.couponID}', '${coupon.couponCode}', '${coupon.discountType}', '${coupon.discountValue}', '${coupon.status}')">
                                                                    <span class="material-symbols-outlined">edit</span>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination if needed -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-container">
                                        <ul class="pagination">
                                            <c:choose>
                                                <c:when test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/couponList?page=${currentPage - 1}&discountType=${discountType}&status=${status}&search=${searchKeyword}">Previous</a>
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
                                                    <a class="page-link" href="${pageContext.request.contextPath}/couponList?page=${i}&discountType=${discountType}&status=${status}&search=${searchKeyword}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/couponList?page=${currentPage + 1}&discountType=${discountType}&status=${status}&search=${searchKeyword}">Next</a>
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

        <!-- Modal for editing coupon -->
        <div id="editForm" class="modal">
            <div class="modal-content">
                <h2>Edit Coupon</h2>
                <form action="couponList" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editCouponID" name="couponID">

                    <div class="form-group mb-3">
                        <label for="editCouponCode">Coupon Code:</label>
                        <input type="text" class="form-control" id="editCouponCode" name="couponCode" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editDiscountType">Discount Type:</label>
                        <select class="form-control" id="editDiscountType" name="discountType" required>
                            <option value="percentage">Percentage</option>
                            <option value="fixed">Fixed Amount</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editDiscountValue">Discount Value:</label>
                        <input type="number" class="form-control" id="editDiscountValue" name="discountValue" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editStatus">Status:</label>
                        <select class="form-control" id="editStatus" name="status">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>

                    <div class="form-group d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" onclick="closeEditForm()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal for adding coupon -->
        <div id="addForm" class="modal">
            <div class="modal-content">
                <h2>Add New Coupon</h2>
                <form action="couponList" method="POST">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group mb-3">
                        <label for="couponCode">Coupon Code:</label>
                        <input type="text" class="form-control" id="couponCode" name="couponCode" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="discountType">Discount Type:</label>
                        <select class="form-control" id="discountType" name="discountType" required>
                            <option value="percentage">Percentage</option>
                            <option value="fixed">Fixed Amount</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="discountValue">Discount Value:</label>
                        <input type="number" class="form-control" id="discountValue" name="discountValue" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="status">Status:</label>
                        <select class="form-control" id="status" name="status">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>

                    <div class="form-group d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" onclick="closeAddForm()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Coupon</button>
                    </div>
                </form>
            </div>
        </div>

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
            function showEditForm(couponID, couponCode, discountType, discountValue, status) {
                const modal = document.getElementById("editForm");
                modal.style.display = "flex"; // Show modal on edit button click
                
                // Set form values
                document.getElementById("editCouponID").value = couponID;
                document.getElementById("editCouponCode").value = couponCode;
                document.getElementById("editDiscountType").value = discountType;
                document.getElementById("editDiscountValue").value = discountValue;
                document.getElementById("editStatus").value = status;
            }
            
            function closeEditForm() {
                document.getElementById("editForm").style.display = "none";
            }
            
            function showAddForm() {
                document.getElementById("addForm").style.display = "flex";
            }
            
            function closeAddForm() {
                document.getElementById("addForm").style.display = "none";
            }
            
            function closeAlert() {
                document.getElementById("alert-box").style.display = "none";
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                const editModal = document.getElementById("editForm");
                const addModal = document.getElementById("addForm");
                if (event.target === editModal) {
                    editModal.style.display = "none";
                }
                if (event.target === addModal) {
                    addModal.style.display = "none";
                }
            };
            
            // Auto-close alerts after 5 seconds
            setTimeout(function() {
                const alertBox = document.getElementById("alert-box");
                if (alertBox) {
                    alertBox.style.display = "none";
                }
            }, 5000);
        </script>
    </body>
</html>
