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
        <title>User Profile - ${user.fullName}</title>

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
            .user-profile {
                display: flex;
                margin-bottom: 30px;
            }

            .user-avatar {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                overflow: hidden;
                margin-right: 30px;
            }

            .user-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .user-info {
                flex: 1;
            }

            .user-info h3 {
                margin-top: 0;
                margin-bottom: 10px;
            }

            .user-info p {
                margin-bottom: 5px;
            }

            .info-label {
                font-weight: bold;
                display: inline-block;
                width: 120px;
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

            .course-card {
                border: 1px solid #e9e9e9;
                border-radius: 5px;
                margin-bottom: 20px;
                padding: 15px;
                transition: all 0.3s ease;
            }

            .course-card:hover {
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .course-image {
                width: 100%;
                height: 180px;
                overflow: hidden;
                border-radius: 5px;
                margin-bottom: 15px;
            }

            .course-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .course-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .course-info {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .course-price {
                font-weight: bold;
                color: #f7b205;
            }

            .course-status {
                display: inline-block;
                padding: 3px 10px;
                border-radius: 3px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-published {
                background-color: #d4edda;
                color: #155724;
            }

            .status-draft {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-completed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-in-progress {
                background-color: #cce5ff;
                color: #004085;
            }

            .back-button {
                margin-bottom: 20px;
            }

            .category-badge {
                display: inline-block;
                padding: 3px 10px;
                border-radius: 3px;
                font-size: 12px;
                font-weight: 600;
                background-color: #e9ecef;
                color: #495057;
                margin-bottom: 10px;
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
                        <h4 class="breadcrumb-title">User Profile</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                            <li><a href="UserList">User List</a></li>
                            <li>User Profile</li>
                        </ul>
                    </div>

                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>User Information</h4>
                                </div>
                                <div class="widget-inner">


                                    <div class="user-profile">
                                        <div class="user-avatar">
                                        <c:choose>
                                            <c:when test="${empty user.image || user.image == '/assets/images/profile/unknow.jpg'}">
                                                <img src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                            </c:when>
                                            <c:when test="${fn:startsWith(user.image, 'https://')}">
                                                <img src="${user.image}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}${user.image}">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="user-info">
                                        <h3>${user.fullName}</h3>
                                        <p><span class="info-label">Email:</span> ${user.email}</p>
                                        <p><span class="info-label">Phone:</span> ${not empty user.phone ? user.phone : 'Not provided'}</p>
                                        <p><span class="info-label">Address:</span> ${not empty user.address ? user.address : 'Not provided'}</p>
                                        <p><span class="info-label">Gender:</span> ${not empty user.genderID ? user.genderID : 'Not specified'}</p>
                                        <p><span class="info-label">Date of Birth:</span> 
                                            <c:choose>
                                                <c:when test="${not empty user.dob}">
                                                    <fmt:formatDate value="${user.dob}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>Not provided</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><span class="info-label">Role:</span> ${user.role.roleName}</p>
                                        <p><span class="info-label">Status:</span> 
                                            <span class="${user.status ? 'status-active' : 'status-inactive'}">
                                                ${user.status ? 'Active' : 'Blocked'}
                                            </span>
                                        </p>
                                        <p><span class="info-label">Joined:</span> 
                                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                        <p><span class="info-label">Last Updated:</span> 
                                            <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                </div>

                                <c:if test="${not empty user.description}">
                                    <div class="user-description mt-4">
                                        <h4>About</h4>
                                        <p>${user.description}</p>
                                    </div>
                                </c:if>

                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${user.role.roleName == 'Expert'}">
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Created Courses</h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="row">
                                        <c:choose>
                                            <c:when test="${not empty courses}">
                                                <c:forEach var="course" items="${courses}">
                                                    <div class="col-md-4 mb-4">
                                                        <div class="card">
                                                            <div class="course-image">
                                                                <c:choose>
                                                                    <c:when test="${empty course.imageUrl}">
                                                                        <img src="${pageContext.request.contextPath}/assets/images/courses/default.jpg" class="card-img-top" alt="Course Image">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}${course.imageUrl}" class="card-img-top" alt="Course Image">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="card-body">
                                                                <h5 class="card-title">${course.title}</h5>
                                                                <p class="card-text text-truncate">${course.description}</p>
                                                                <div class="d-flex justify-content-between align-items-center">
                                                                    <span class="text-primary font-weight-bold">${course.price}đ</span>
                                                                    <span class="badge ${course.status eq '1' || course.status eq 'Published' ? 'badge-success' : 'badge-secondary'}">
                                                                        ${course.status eq '1' || course.status eq 'Published' ? 'Published' : 'Draft'}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-12">
                                                    <p>No courses created by this expert yet.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${user.role.roleName == 'Student'}">
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Purchased Courses</h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="row">
                                        <c:choose>
                                            <c:when test="${not empty courses}">
                                                <c:forEach var="course" items="${courses}">
                                                    <div class="col-md-4 mb-4">
                                                        <div class="card">
                                                            <div class="course-image">
                                                                <c:choose>
                                                                    <c:when test="${empty course.imageUrl}">
                                                                        <img src="${pageContext.request.contextPath}/assets/images/courses/default.jpg" class="card-img-top" alt="Course Image">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}${course.imageUrl}" class="card-img-top" alt="Course Image">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="card-body">
                                                                <h5 class="card-title">${course.title}</h5>
                                                                <p class="card-text text-truncate">${course.description}</p>
                                                                <div class="d-flex justify-content-between align-items-center">
                                                                    <span class="text-primary font-weight-bold">${course.price}đ</span>
                                                                    <span class="badge badge-success">Enrolled</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-12">
                                                    <p>No courses purchased by this student yet.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <div class="back-button">
                    <a href="UserList" class="btn btn-secondary"><i class="fa fa-arrow-left"></i> Back to User List</a>
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
    </body>
</html>
