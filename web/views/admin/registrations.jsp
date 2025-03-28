<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
        <title>Registration Management</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/color/color-1.css">
        
        <style>
            .status-badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: bold;
                display: inline-block;
                min-width: 80px;
                text-align: center;
            }
            .status-pending {
                background-color: #FFF3CD;
                color: #856404;
            }
            .status-active {
                background-color: #D4EDDA;
                color: #155724;
            }
            .status-completed {
                background-color: #D1ECF1;
                color: #0C5460;
            }
            .status-cancelled {
                background-color: #F8D7DA;
                color: #721C24;
            }
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
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">

        <!-- header start -->
        <jsp:include page="../../public/header-admin.jsp"></jsp:include>
        <!-- header end -->
        
        <!-- Left sidebar menu start -->
        <jsp:include page="../../public/sidebar-admin.jsp"></jsp:include>
        <!-- Left sidebar menu end -->

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Registration Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Registration Management</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Registration List</h4>
                            </div>
                            <div class="widget-inner">
                                <!-- Search and Filter Section -->
                                <div class="mb-3 d-flex align-items-center gap-3">
                                    <form action="${pageContext.request.contextPath}/admin-registrations" class="d-flex align-items-center mx-3">
                                        <input type="text" name="search" placeholder="Search by name" value="${searchQuery}" class="form-control me-2">
                                        <select name="searchType" class="form-control me-2">
                                            <option value="fullname" ${searchType == 'fullname' ? 'selected' : ''}>By Name</option>
                                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>By Email</option>
                                        </select>
                                        <button type="submit" class="btn btn-secondary">Search</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/admin-registrations" class="d-flex align-items-center mx-3">
                                        <select id="statusFilter" name="status" class="form-control me-2">
                                            <option value="all" ${statusFilter == 'all' || empty statusFilter ? 'selected' : ''}>All Status</option>
                                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="completed" ${statusFilter == 'completed' ? 'selected' : ''}>Completed</option>
                                            <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-secondary">Filter</button>
                                    </form>
                                </div>

                                <!-- Registrations Table -->
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Student</th>
                                            <th>Course</th>
                                            <th>Price</th>
                                            <th>Status</th>
                                            <th>Registration Date</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="registration" items="${registrations}">
                                            <tr>
                                                <td>${registration.registrationID}</td>
                                                <td>
                                                    <div>${registration.user.fullName}</div>
                                                    <div><small>${registration.user.email}</small></div>
                                                </td>
                                                <td>${registration.course.title}</td>
                                                <td><fmt:formatNumber value="${registration.price}" type="currency" currencySymbol="₫"/></td>
                                                <td>
                                                    <span class="status-badge status-${registration.status}">
                                                        ${registration.status}
                                                    </span>
                                                </td>
                                                <td><fmt:formatDate value="${registration.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>
                                                    <div class="d-flex">
                                                        <c:if test="${registration.status == 'pending'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-registrations" class="me-1">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="active">
                                                                <button type="submit" class="btn btn-primary">Approve</button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-registrations">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="cancelled">
                                                                <button type="submit" class="btn btn-danger">Reject</button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <a href="${pageContext.request.contextPath}/coursedetailadmin?courseId=${registration.courseID}" class="btn btn-warning me-1">View</a>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-registrations">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="cancelled">
                                                                <button type="submit" class="btn btn-danger">Delete</button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <!-- Update Status Dropdown -->
                                                        <form method="post" action="${pageContext.request.contextPath}/admin-registrations" class="ms-1">
                                                            <input type="hidden" name="action" value="update-status">
                                                            <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                            <select name="status" class="form-control" onchange="this.form.submit()" style="background-color: #f7b924; color: white; border: none; height: 38px;">
                                                                <option value="" disabled selected>Update Status</option>
                                                                <option value="pending" ${registration.status == 'pending' ? 'disabled' : ''}>Pending</option>
                                                                <option value="active" ${registration.status == 'active' ? 'disabled' : ''}>Active</option>
                                                                <option value="completed" ${registration.status == 'completed' ? 'disabled' : ''}>Completed</option>
                                                                <option value="cancelled" ${registration.status == 'cancelled' ? 'disabled' : ''}>Cancelled</option>
                                                            </select>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty registrations}">
                                            <tr>
                                                <td colspan="7" style="text-align: center;">No registrations found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-container">
                                        <div class="pagination-bx rounded-sm gray clearfix">
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="previous">
                                                        <a href="${pageContext.request.contextPath}/admin-registrations?page=${currentPage - 1}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">
                                                            <i class="ti-arrow-left"></i> Prev
                                                        </a>
                                                    </li>
                                                </c:if>
                                                
                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                    <li class="${currentPage == i ? 'active' : ''}">
                                                        <a href="${pageContext.request.contextPath}/admin-registrations?page=${i}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="next">
                                                        <a href="${pageContext.request.contextPath}/admin-registrations?page=${currentPage + 1}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">
                                                            Next <i class="ti-arrow-right"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Page Information -->
                                <div class="text-center mt-2">
                                    <small>Showing page ${currentPage} of ${totalPages > 0 ? totalPages : 1}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <!-- Success/Error Messages -->
        <c:set var="error" value="${requestScope.error}" />
        <c:if test="${not empty error}">
            <div id="error-message" class="error-message">
                <i class="bx bxs-error"></i> ${error}
            </div>
        </c:if>
        
        <c:set var="success" value="${sessionScope.successMessage}" />
        <c:if test="${not empty success}">
            <div id="success" class="success">
                <i class="bx bxs-error"></i> ${success}
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        
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
        <script src='${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
        <script src='${pageContext.request.contextPath}/assets/admin/assets/vendors/switcher/switcher.js'></script>
        <link href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
        
        <script>
            function showMessage() {
                var errorMessage = document.getElementById("error-message");
                var successMessage = document.getElementById("success");

                // Display error message if exists
                if (errorMessage) {
                    errorMessage.style.display = "block";
                    setTimeout(function () {
                        errorMessage.style.display = "none";
                    }, 3000);
                }

                // Display success message if exists
                if (successMessage) {
                    successMessage.style.display = "block";
                    setTimeout(function () {
                        successMessage.style.display = "none";
                    }, 3000);
                }
            }

            // Call function when page is loaded
            window.onload = function () {
                showMessage();
            };
        </script>
    </body>
</html>
