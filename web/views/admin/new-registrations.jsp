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
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: capitalize;
                display: inline-block;
            }
            .status-pending {
                background-color: #FFC107;
                color: #000;
            }
            .status-active {
                background-color: #28A745;
                color: #fff;
            }
            .status-completed {
                background-color: #17A2B8;
                color: #fff;
            }
            .status-cancelled {
                background-color: #DC3545;
                color: #fff;
            }
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #FF0000;
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
                    <h4 class="breadcrumb-title">New Registrations</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>New Registrations</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>New Registration List</h4>
                            </div>
                            <div class="widget-inner">
                                <!-- Search and Filter Section -->
                                <div class="mb-3 d-flex align-items-center gap-3">
                                    <form action="${pageContext.request.contextPath}/admin-new-registrations" class="d-flex align-items-center mx-3">
                                        <input type="text" name="search" placeholder="Search by name" value="${searchQuery}" class="form-control me-2">
                                        <select name="searchType" class="form-control me-2">
                                            <option value="fullname" ${searchType == 'fullname' ? 'selected' : ''}>By Name</option>
                                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>By Email</option>
                                        </select>
                                        <button type="submit" class="btn btn-secondary">Search</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/admin-new-registrations" class="d-flex align-items-center mx-3">
                                        <select id="daysFilter" name="days" class="form-control me-2">
                                            <option value="1" ${days == '1' ? 'selected' : ''}>Last 24 Hours</option>
                                            <option value="7" ${days == '7' ? 'selected' : ''}>Last 7 Days</option>
                                            <option value="30" ${days == '30' || empty days ? 'selected' : ''}>Last 30 Days</option>
                                            <option value="90" ${days == '90' ? 'selected' : ''}>Last 90 Days</option>
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
                                        <c:forEach var="registration" items="${newRegistrations}">
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
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-new-registrations" class="me-1">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="active">
                                                                <button type="submit" class="btn btn-primary">Approve</button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-new-registrations">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="cancelled">
                                                                <button type="submit" class="btn btn-danger">Reject</button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <a href="${pageContext.request.contextPath}/coursedetailadmin?courseId=${registration.courseID}" class="btn btn-warning me-1">View</a>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin-new-registrations">
                                                                <input type="hidden" name="action" value="update-status">
                                                                <input type="hidden" name="registrationId" value="${registration.registrationID}">
                                                                <input type="hidden" name="status" value="cancelled">
                                                                <button type="submit" class="btn btn-danger">Delete</button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <!-- Update Status Dropdown -->
                                                        <form method="post" action="${pageContext.request.contextPath}/admin-new-registrations" class="ms-1">
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
                                        
                                        <c:if test="${empty newRegistrations}">
                                            <tr>
                                                <td colspan="7" style="text-align: center;">No new registrations found.</td>
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
                                                        <a href="${pageContext.request.contextPath}/admin-new-registrations?page=${currentPage - 1}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty days ? '&days='.concat(days) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">
                                                            <i class="ti-arrow-left"></i> Prev
                                                        </a>
                                                    </li>
                                                </c:if>
                                                
                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                    <li class="${currentPage == i ? 'active' : ''}">
                                                        <a href="${pageContext.request.contextPath}/admin-new-registrations?page=${i}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty days ? '&days='.concat(days) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="next">
                                                        <a href="${pageContext.request.contextPath}/admin-new-registrations?page=${currentPage + 1}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}${not empty searchType ? '&searchType='.concat(searchType) : ''}${not empty days ? '&days='.concat(days) : ''}${not empty sortOrder ? '&sortOrder='.concat(sortOrder) : ''}">
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
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/switcher/switcher.js"></script>
        
        <!-- Toastr JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
        
        <script>
            // Show error message if exists
            var errorMessage = document.getElementById('error-message');
            if (errorMessage) {
                errorMessage.style.display = 'block';
                setTimeout(function() {
                    errorMessage.style.display = 'none';
                }, 5000); // Hide after 5 seconds
            }
            
            // Show success message if exists
            var successMessage = document.getElementById('success');
            if (successMessage) {
                successMessage.style.display = 'block';
                setTimeout(function() {
                    successMessage.style.display = 'none';
                }, 5000); // Hide after 5 seconds
            }
        </script>
    </body>
</html>
