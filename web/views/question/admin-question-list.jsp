<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <meta property="og:title" content="EduChamp : Education HTML Template" />
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

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
        <style>
            /* Custom button styles */
            .btn-custom {
                padding: 6px 12px;
                margin-right: 5px;
                border-radius: 4px;
                font-size: 14px;
                transition: all 0.3s ease;
                min-width: 70px; /* Đảm bảo nút trong bảng đồng nhất kích thước */
            }

            /* Nút Show */
            .btn-show {
                background-color: #17a2b8;
                border-color: #17a2b8;
                color: white;
            }
            .btn-show:hover {
                background-color: #138496;
                border-color: #117a8b;
            }

            /* Nút Hide */
            .btn-hide {
                background-color: #6c757d;
                border-color: #6c757d;
                color: white;
            }
            .btn-hide:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }

            /* Nút Edit */
            .btn-edit {
                background-color: #ffc107;
                border-color: #ffc107;
                color: #212529;
            }
            .btn-edit:hover {
                background-color: #e0a800;
                border-color: #d39e00;
            }

            /* Nút Import Question */
            .btn-import {
                background-color: #28a745;
                border-color: #28a745;
                color: white;
                padding: 8px 16px; /* Kích thước lớn hơn cho nút chính */
                white-space: nowrap; /* Ngăn text xuống dòng */
            }
            .btn-import:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            /* Nút Filter */
            .btn-filter {
                background-color: #007bff;
                border-color: #007bff;
                color: white;
                margin-left: 5px; /* Khoảng cách nhỏ bên trái nút Filter */
            }
            .btn-filter:hover {
                background-color: #0069d9;
                border-color: #0062cc;
            }

            /* Nút Clear */
            .btn-clear {
                background-color: #dc3545;
                border-color: #dc3545;
                color: white;
                padding: 8px 16px; /* Kích thước lớn hơn cho nút chính */
                white-space: nowrap; /* Ngăn text xuống dòng */
            }
            .btn-clear:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }

            /* Bố cục tổng thể của phần nút Import và Filter */
            .filter-section {
                display: flex;
                align-items: center;
                gap: 20px; /* Khoảng cách giữa nút Import và form filter */
                margin-bottom: 20px; /* Khoảng cách dưới để tách biệt với bảng */
            }

            /* Form filter */
            .filter-form {
                display: flex;
                align-items: center;
                gap: 10px; /* Khoảng cách đều giữa các phần tử trong form */
            }
            .filter-form .form-control {
                margin-right: 5px; /* Khoảng cách nhỏ giữa các trường */
            }
        </style>
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
                        <h4 class="breadcrumb-title">Questions</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li>Questions</li>
                        </ul>
                    </div>	
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Questions List</h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="filter-section">
                                        <a id="importQuestion" href="" class="btn btn-custom btn-import">Import Question</a>
                                        <form action="manageQuestion" class="filter-form">
                                            <input type="text" id="searchContent" name="content" placeholder="Search by content" value="${content}" class="form-control">         
                                        <select id="filterSubject" name="titleCourse" class="form-control">
                                            <option value="">All Courses</option>
                                            <c:forEach items="${courses}" var="courses">
                                                <option ${titleCourse eq courses.title ? 'selected' : ""} value="${courses.title}">${courses.title}</option>
                                            </c:forEach>
                                        </select>
                                        <select id="filterQuiz" name="quizName" class="form-control">
                                            <option value="">All Quizzes</option>
                                            <c:forEach items="${quizz}" var="quiz">
                                                <option ${quizName eq quiz.name ? 'selected' : ""} value="${quiz.name}">${quiz.name}</option>
                                            </c:forEach>
                                        </select>
                                        <select id="filterStatus" name="status" class="form-control">
                                            <option ${status eq '1' ? 'selected' : ""} value="1">Active</option>
                                            <option ${status eq '0' ? 'selected' : ""} value="0">Hidden</option>
                                        </select>
                                        <select id="sortOrder" name="sort" class="form-control">
                                            <option value="1" ${sort eq 'newest' ? 'selected' : ''}>Newest First</option>
                                            <option value="0" ${sort eq 'oldest' ? 'selected' : ''}>Oldest First</option>
                                        </select>
                                        <button id="filterButton" name="action" value="FilterAll" class="btn btn-custom btn-filter">Filter</button>

                                        <a href="manageQuestion" class="btn btn-custom btn-clear">Clear</a>
                                    </form>
                                </div>

                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Content</th>
                                            <th>Course</th>
                                            <th>Quiz</th>  
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="questionTableBody">
                                        <c:forEach items="${questions}" var="questions">
                                            <tr>
                                                <td>${questions.questionID}</td>
                                                <td>${questions.content}</td>
                                                <td>${questions.quiz.course.title}</td>
                                                <td>${questions.quiz.name}</td>
                                                <td>${questions.status == true ? "Active" : "Hidden"}</td>
                                                <td>
                                                    <button class="btn btn-custom btn-show">Show</button>
                                                    <button class="btn btn-custom btn-hide">Hide</button>
                                                    <a href="${pageContext.request.contextPath}/updateQuestion?id=${questions.questionID}" class="btn btn-custom btn-edit">Edit</a>
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
    </body>

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/courses.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:11:35 GMT -->
</html>