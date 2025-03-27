<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/courses.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:10:19 GMT -->
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
        <meta property="og:title" content="EduChamp : Educationhom HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>EduChamp : Education HTML Template </title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->

        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">

        <!-- header start -->
        <jsp:include page="../../common/dashboard/header-dashboard.jsp"></jsp:include>
            <!-- header end -->
            <!-- Left sidebar menu start -->
        <jsp:include page="../../common/dashboard/left-sidebar-dashboard.jsp"></jsp:include>
            <!-- Left sidebar menu end -->

            <!--Main container start -->
            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Lessons</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li>Lessons</li>
                        </ul>
                    </div>	
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Lesson List</h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="mb-3 d-flex align-items-center gap-3">
                                        <a id="addCourse" href="addLesson" class="btn btn-primary">Add Lesson</a>
                                        <form action="lessons" class="d-flex align-items-center mx-3">
                                            <select id="filterCategory" name="packageId" class="form-control me-2">
                                                <option value="">All Packages</option>
                                            <c:forEach items="${packages}" var="c">
                                                <option ${c.packageID == packageId ? 'selected' : ""} value="${c.packageID}">${c.name}</option>
                                            </c:forEach>
                                        </select>

                                        <select id="filterStatus" name="status" class="form-control me-2">
                                            <option value="">All Status</option>
                                            <option ${status eq '1' ? 'selected' : ""} value="1">Active</option>
                                            <option ${status eq '0' ? 'selected' : ""} value="0">Blocked</option>
                                        </select>

                                        <button id="filterButton" class="btn btn-secondary">Filter</button>
                                    </form>
                                </div>

                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Title</th>
                                            <th>Course</th>
                                            <th>Package</th>
                                            <th>Lesson Type</th>
                                            <th>Content</th>
                                            <th>Status</th>
                                            <th style="width: 175px">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="courseTableBody">
                                        <c:forEach items="${lessons}" var="p">
                                            <tr>
                                                <td>${p.lessonID}</td>
                                                <td>${p.title}</td>
                                                <td>${p.course.title}</td>
                                                <td>${p.packages.name}</td>
                                                <td>${p.lessonType}</td>
                                                <td>${p.content}</td>
                                                <td>${p.status == true ? "Active" : "Blocked"}</td>
                                                <td>
                                                    <a href="viewLessonForAd?lessonId=${p.lessonID}" class="btn btn-warning">Edit</a>
                                                    <c:if test="${p.status == true}">
                                                        <a href="deleteLesson?lessonId=${p.lessonID}" class="btn btn-danger">Delete</a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="../../common/pagination.jsp"></jsp:include>
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
            <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
            <script src="assets/admin/assets/js/functions.js"></script>
            <script src="assets/admin/assets/vendors/chart/chart.min.js"></script>
            <script src="assets/admin/assets/js/admin.js"></script>
            <script src='assets/admin/assets/vendors/switcher/switcher.js'></script>
            <link href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
            <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
        <c:if test="${message != null}">
            <script type="text/javascript">
                toastr.success(`${message}`, 'Success', {timeOut: 1000});
            </script>
        </c:if>
        <c:if test="${errorMessage != null}">
            <script type="text/javascript">
                toastr.error(`${errorMessage}`, 'Error', {timeOut: 2000});
            </script>
        </c:if>
    </body>

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/courses.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:11:35 GMT -->
</html>
