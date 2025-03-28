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
        <title>User Management</title>

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
        
        <style>
            .status-active {
                background-color: #d4edda;
                color: #155724;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            .status-blocked {
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
                    <h4 class="breadcrumb-title">User Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
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
                                    <form action="${pageContext.request.contextPath}/UserList" class="d-flex align-items-center mx-3">
                                        <input type="text" name="searchValue" placeholder="Search by name" value="${param.searchValue}" class="form-control me-2">
                                        <select name="roleID" class="form-control me-2">
                                            <option value="">All Roles</option>
                                            <option value="1" ${param.roleID == '1' ? 'selected' : ''}>Admin</option>
                                            <option value="2" ${param.roleID == '2' ? 'selected' : ''}>Expert</option>
                                            <option value="3" ${param.roleID == '3' ? 'selected' : ''}>Student</option>
                                            <option value="4" ${param.roleID == '4' ? 'selected' : ''}>Sale</option>
                                            <option value="5" ${param.roleID == '5' ? 'selected' : ''}>Marketing</option>
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
                                            <th>Email</th>
                                            <th>Last sign in</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${listUser}">
                                            <tr>
                                                <td>${user.userID}</td>
                                                <td>${user.fullName}</td>
                                                <td>${user.email}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.lastLogin}">
                                                            <fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm" />
                                                        </c:when>
                                                        <c:otherwise>Never</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.roleID == 1}">Admin</c:when>
                                                        <c:when test="${user.roleID == 2}">Expert</c:when>
                                                        <c:when test="${user.roleID == 3}">Student</c:when>
                                                        <c:when test="${user.roleID == 4}">Sale</c:when>
                                                        <c:when test="${user.roleID == 5}">Marketing</c:when>
                                                        <c:otherwise>Unknown</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="${user.status == 1 ? 'status-active' : 'status-blocked'}">
                                                        ${user.status == 1 ? 'Active' : 'Blocked'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex">
                                                        <a href="ViewUser?id=${user.userID}" class="btn btn-info btn-sm me-1">View</a>
                                                        <a href="EditUserServlet?userName=${user.userName}" class="btn btn-warning btn-sm me-1">Edit</a>
                                                        
                                                        <c:choose>
                                                            <c:when test="${user.status == 1}">
                                                                <form method="post" action="BlockUserServlet" style="display: inline;">
                                                                    <input type="hidden" name="userName" value="${user.userName}">
                                                                    <button type="submit" class="btn btn-danger btn-sm">Block</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form method="post" action="BlockUserServlet" style="display: inline;">
                                                                    <input type="hidden" name="userName" value="${user.userName}">
                                                                    <button type="submit" class="btn btn-success btn-sm">Unblock</button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty listUser}">
                                            <tr>
                                                <td colspan="7" style="text-align: center;">No users found.</td>
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
                                                    <a class="page-link" href="UserList?page=${currentPage - 1}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleID ? '&roleID='.concat(param.roleID) : ''}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="UserList?page=${i}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleID ? '&roleID='.concat(param.roleID) : ''}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="UserList?page=${currentPage + 1}${not empty param.searchValue ? '&searchValue='.concat(param.searchValue) : ''}${not empty param.roleID ? '&roleID='.concat(param.roleID) : ''}" aria-label="Next">
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
    </body>
</html>
