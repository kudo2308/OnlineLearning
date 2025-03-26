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
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>My Blog</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/CouponStyle.css" />
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

            <!-- Main container start -->
            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Coupon Management</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                            <li>Coupon List</li>
                        </ul>
                    </div>

                    <!-- Main content container -->
                    <div class="container-right">
                    <c:if test="${not empty message}">
                        <div class="alert2 alert-success" id="alert-box">
                            <c:choose>
                                <c:when test="${message eq 'created'}">Coupon add successfully!</c:when>
                                <c:when test="${message eq 'updated'}">Coupon update successfully!</c:when>
                                <c:when test="${message eq 'deleted'}">Coupon remove successfully!</c:when>
                            </c:choose>
                            <button class="close-btn" onclick="closeAlert()">×</button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert2 alert-danger" id="alert-box">
                            <c:choose>
                                <c:when test="${error eq 'deleteFailed'}">Can not remove coupon, please try again!</c:when>
                                <c:when test="${error eq 'missingCouponCode'}">Mã coupon không được để trống!</c:when>
                            </c:choose>
                            <button class="close-btn" onclick="closeAlert()">×</button>
                        </div>
                    </c:if>
                    <form id="filter-form" action="myblog" method="get">
                        <select name="categoryId" class="form-control2" onchange="document.getElementById('filter-form').submit();">
                            <option value="0" ${selectedCategory == 0 ? 'selected' : ''}>All Categories</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryID}" ${selectedCategory == category.categoryID ? 'selected' : ''}>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="filter-search">
                            <div class="input-group">
                                <input name="search" type="text" class="form-control" placeholder="Search blogs" value="${searchKeyword}">
                            </div>
                        </div>
                    </form>
                    <div class="table-container">
                        <table>
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
                                            <td>${coupon.couponCode}</td>
                                            <td>${coupon.discountType}</td>
                                            <td>${coupon.discountValue}</td>
                                            <td>${coupon.status == true ? 'Active' : 'Inactive'}</td>
                                            <td>${coupon.createdAt}</td>
                                            <td class="action-buttons">
                                                <form action="couponList" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="couponID" value="${coupon.couponID}">
                                                    <button class="delete-btn" onclick="return confirm('Are you sure?')">
                                                        <span class="material-symbols-outlined">delete</span>
                                                    </button>
                                                </form>

                                                <button onclick="showEditForm('${coupon.couponID}', '${coupon.couponCode}', '${coupon.discountType}', '${coupon.discountValue}', '${coupon.status}')">
                                                    <span class="material-symbols-outlined">edit</span>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty couponList}">
                                    <tr><td colspan="7">No coupons found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <div class="pagination-bx rounded-sm gray clearfix">
                                <ul class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <li class="previous">
                                            <a href="?page=${currentPage - 1}">
                                                <i class="ti-arrow-left"></i> Prev
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li class="${currentPage == i ? 'active' : ''}">
                                            <a href="?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="next">
                                            <a href="?page=${currentPage + 1}">
                                                Next <i class="ti-arrow-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- Modal for editing coupon -->
        <div id="editForm" class="modal" style="display: none;">
            <div class="container-post-blog">
                <span class="close" onclick="closeEditForm()">&times;</span>
                <h2>Edit Coupon</h2>
                <form action="couponList" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editCouponID" name="couponID">

                    <label>Coupon Code:</label>
                    <input type="text" id="editCouponCode" name="couponCode" required>

                    <label>Discount Type:</label>
                    <br>
                    <select id="editDiscountType" name="discountType">
                        <option value="percentage">Percentage</option>
                        <option value="fixed">Fixed</option>
                    </select>
                    <br>
                    <label>Discount Value:</label>
                    <input type="number" id="editDiscountValue" name="discountValue" required>

                    <label>Status:</label>
                    <br>
                    <select id="editStatus" name="status">
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>

                    <button class="submit-but" type="submit">Update</button>
                </form>
            </div>
        </div>

        <script>
            function showEditForm(couponID, couponCode, discountType, discountValue, status) {
                const modal = document.getElementById("editForm");
                modal.style.display = "flex"; // Show modal on edit button click

                // Populate form fields with coupon data
                document.getElementById("editCouponID").value = couponID;
                document.getElementById("editCouponCode").value = couponCode;
                document.getElementById("editDiscountType").value = discountType;
                document.getElementById("editDiscountValue").value = discountValue;
                document.getElementById("editStatus").value = status;
            }

            function closeEditForm() {
                document.getElementById("editForm").style.display = "none"; // Close modal on close button click
            }

            // Close modal if clicked outside of the modal
            window.onclick = function (event) {
                const modal = document.getElementById("editForm");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            }

            // Close alert after 5 seconds
            setTimeout(() => {
                const alertBox = document.getElementById("alert-box");
                if (alertBox) {
                    alertBox.classList.add("hide-alert");
                    setTimeout(() => alertBox.style.display = "none", 500);
                }
            }, 5000);

            // Close alert manually
            function closeAlert() {
                const alertBox = document.getElementById("alert-box");
                alertBox.classList.add("hide-alert");
                setTimeout(() => alertBox.style.display = "none", 500);
            }
        </script>

    </body>

</html>
