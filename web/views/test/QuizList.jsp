<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>Quiz List</title>

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
                    <h4 class="breadcrumb-title">Quiz List</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                        <li>Quiz List</li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Quiz List</h4>
                                <a href="${pageContext.request.contextPath}/AddQuiz" class="btn btn-primary mt-2">Add Quiz</a>
                            </div>
                            <div class="widget-inner">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3">
                                                    <select class="form-control" id="courseFilter">
                                                        <option value="">All Courses</option>
                                                        <c:forEach items="${courses}" var="course">
                                                            <option value="${course.courseID}">${course.title}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-lg-3">
                                                    <select class="form-control" id="packageFilter">
                                                        <option value="">All Packages</option>
                                                        <c:forEach items="${packages}" var="pkg">
                                                            <option value="${pkg.packageID}">${pkg.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-lg-3">
                                                    <select class="form-control" id="statusFilter">
                                                        <option value="">All Status</option>
                                                        <option value="true">Active</option>
                                                        <option value="false">Inactive</option>
                                                    </select>
                                                </div>
                                                <div class="col-lg-3">
                                                    <button class="btn" id="filterBtn">Filter</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Course</th>
                                                <th>Package</th>
                                                <th>Title</th>
                                                <th>Duration</th>
                                                <th>Pass Rate</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${quizzes}" var="quiz">
                                                <tr>
                                                    <td>${quiz.quizID}</td>
                                                    <td>${quiz.course.title}</td>
                                                    <td>${quiz.packages.name}</td>
                                                    <td>${quiz.name}</td>
                                                    <td>${quiz.duration} minutes</td>
                                                    <td>${quiz.passRate}%</td>
                                                    <td>${quiz.status ? 'Active' : 'Inactive'}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/QuizList?action=edit&id=${quiz.quizID}" class="btn btn-sm btn-warning">Edit</a>
                                                        <a href="${pageContext.request.contextPath}/QuizList?action=delete&id=${quiz.quizID}" class="btn btn-sm btn-danger">Delete</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination Controls -->
                                <c:if test="${totalPages > 1}">
                                    <div class="text-center mt-4">
                                        <ul class="pagination justify-content-center">
                                            <!-- Previous Button -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/QuizList?action=list&page=${currentPage - 1}<c:if test="${courseId > 0}">&courseId=${courseId}</c:if><c:if test="${packageId > 0}">&packageId=${packageId}</c:if><c:if test="${status != null}">&status=${status}</c:if>" ${currentPage == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                                            </li>
                                            
                                            <!-- Page Numbers -->
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/QuizList?action=list&page=${i}<c:if test="${courseId > 0}">&courseId=${courseId}</c:if><c:if test="${packageId > 0}">&packageId=${packageId}</c:if><c:if test="${status != null}">&status=${status}</c:if>">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <!-- Next Button -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/QuizList?action=list&page=${currentPage + 1}<c:if test="${courseId > 0}">&courseId=${courseId}</c:if><c:if test="${packageId > 0}">&packageId=${packageId}</c:if><c:if test="${status != null}">&status=${status}</c:if>" ${currentPage == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
                                            </li>
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
        <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>
        
        <script>
            $(document).ready(function() {
                // Filter functionality
                $("#filterBtn").click(function() {
                    var courseId = $("#courseFilter").val();
                    var packageId = $("#packageFilter").val();
                    var status = $("#statusFilter").val();
                    
                    // Construct URL with filter parameters
                    var url = "${pageContext.request.contextPath}/QuizList?action=list";
                    if (courseId) url += "&courseId=" + courseId;
                    if (packageId) url += "&packageId=" + packageId;
                    if (status) url += "&status=" + status;
                    
                    // Redirect to the filtered URL
                    window.location.href = url;
                });
            });
        </script>
    </body>
</html>
