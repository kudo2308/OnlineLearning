<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <title>User Management</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        
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
            
            .pagination-container {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }
            
            .pagination-container .page-item {
                margin: 0 2px;
            }
            
            .action-buttons form {
                display: inline-block;
                margin-right: 5px;
            }
            
            .action-buttons button {
                padding: 5px 10px;
                border-radius: 4px;
                border: none;
                cursor: pointer;
            }
            
            .edit-btn {
                background-color: #ffc107;
                color: #212529;
            }
            
            .block-btn {
                background-color: #dc3545;
                color: white;
            }
            
            .unblock-btn {
                background-color: #28a745;
                color: white;
            }
            
            .delete-btn {
                background-color: #dc3545;
                color: white;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">User Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                        <li>User List</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>User List</h4>
                            </div>
                            <div class="widget-inner">
                                <!-- Search and Filter Section -->
                                <div class="mb-3 d-flex align-items-center gap-3">
                                    <form action="UserList" class="d-flex align-items-center mx-3">
                                        <input type="text" name="searchValue" placeholder="Search by name" value="${param.searchValue}" class="form-control me-2">
                                        <select name="roleName" class="form-control me-2">
                                            <option value="">All Roles</option>
                                            <option value="Admin" ${param.roleName == 'Admin' ? 'selected' : ''}>Admin</option>
                                            <option value="Expert" ${param.roleName == 'Expert' ? 'selected' : ''}>Expert</option>
                                            <option value="Student" ${param.roleName == 'Student' ? 'selected' : ''}>Student</option>
                                            <option value="Sale" ${param.roleName == 'Sale' ? 'selected' : ''}>Sale</option>
                                            <option value="Marketing" ${param.roleName == 'Marketing' ? 'selected' : ''}>Marketing</option>
                                        </select>
                                        <select name="status" class="form-control me-2">
                                            <option value="">All Status</option>
                                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                                            <option value="0" ${param.status == '0' ? 'selected' : ''}>Blocked</option>
                                        </select>
                                        <button type="submit" class="btn btn-secondary">Filter</button>
                                    </form>
                                    <a href="adduser.jsp" class="btn btn-success">Add New User</a>
                                </div>
                                
                                <!-- Users Table -->
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>User ID</th>
                                            <th>Full Name</th>
                                            <th>Image</th>
                                            <th>Email</th>
                                            <th>Last sign in</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="account" items="${listAccount}">
                                            <tr>
                                                <td>${account.userID}</td>        
                                                <td>${account.fullName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${empty account.image || account.image == '/assets/images/profile/unknow.jpg'}">
                                                            <img style="width: 50px; height: 50px" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                                        </c:when>
                                                        <c:when test="${fn:startsWith(account.image, 'https://')}">
                                                            <img style="width: 50px; height: 50px" src="${account.image}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img style="width: 50px; height: 50px" src="${pageContext.request.contextPath}${account.image}">
                                                        </c:otherwise>
                                                    </c:choose> 
                                                </td>
                                                <td>${account.email}</td>
                                                <td class="last-sign-in" data-time="${account.updatedAt}">
                                                    <c:choose>
                                                        <c:when test="${not empty account.updatedAt}">
                                                            <fmt:formatDate value="${account.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </c:when>
                                                        <c:otherwise>Never</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${account.role.roleName}</td>
                                                <td>
                                                    <span class="${account.status == 'True' ? 'status-active' : 'status-inactive'}">
                                                        ${account.status == 'True' ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex">
                                                        <a href="ViewUser?id=${account.userID}" class="btn btn-warning btn-sm me-1">View</a>
                                                        
                                                        <c:choose>
                                                            <c:when test="${account.status == 'True'}">
                                                                <form method="post" action="BlockUserServlet" style="display: inline;">
                                                                    <input type="hidden" name="userID" value="${account.userID}">
                                                                    <button type="submit" class="btn btn-danger btn-sm">Block</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form method="post" action="BlockUserServlet" style="display: inline;">
                                                                    <input type="hidden" name="userID" value="${account.userID}">
                                                                    <button type="submit" class="btn btn-success btn-sm">Unblock</button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty listAccount}">
                                            <tr>
                                                <td colspan="8" style="text-align: center;">No users found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-container">
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="UserList?page=${currentPage - 1}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleName ? '&roleName='.concat(param.roleName) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="UserList?page=${i}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleName ? '&roleName='.concat(param.roleName) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="UserList?page=${currentPage + 1}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleName ? '&roleName='.concat(param.roleName) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
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
        <script src="assets/admin/assets/js/jquery.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>
        
        <script>
            // Format the last sign in time
            document.addEventListener('DOMContentLoaded', function() {
                const timeElements = document.querySelectorAll('.last-sign-in');
                timeElements.forEach(function(element) {
                    const timestamp = element.getAttribute('data-time');
                    if (timestamp && timestamp !== '') {
                        const date = new Date(timestamp);
                        const now = new Date();
                        const diffMs = now - date;
                        const diffMins = Math.round(diffMs / 60000);
                        const diffHours = Math.round(diffMs / 3600000);
                        
                        if (diffMins < 60) {
                            element.textContent = diffMins + ' minutes ago';
                        } else if (diffHours < 24) {
                            element.textContent = diffHours + ' hour' + (diffHours > 1 ? 's' : '') + ' ago';
                        } else {
                            const options = { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' };
                            element.textContent = date.toLocaleDateString('en-GB', options).replace(',', '');
                        }
                    }
                });
            });
        </script>
    </body>
</html>
