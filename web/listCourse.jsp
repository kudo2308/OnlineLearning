<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/add-lesson.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:10:19 GMT -->
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
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>

            <!--Main container start -->
            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Courses</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                            <li>Courses</li>
                        </ul>
                    </div>	
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Course List</h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="mb-3 d-flex align-items-center gap-3">

                                        <form action="manager-courses" class="d-flex align-items-center mx-3">
                                            <input type="text" id="searchName" name="name" placeholder="Search by name" value="${name}" class="form-control me-2">
                                        <button id="searchButton" name="action" value="searchByName" class="btn btn-secondary">Search</button>
                                    </form>

                                    <form action="manager-courses" class="d-flex align-items-center mx-3">
                                        <select id="filterCategory" name="categoryId" class="form-control me-2">
                                            <option value="0">All Category</option>
                                            <c:forEach items="${categories}" var="categories">
                                                <option ${categoryId == categories.categoryID ? 'selected' : ""} value="${categories.categoryID}">${categories.name}</option>
                                            </c:forEach>
                                        </select>

                                        <select id="filterStatus" name="status" class="form-control me-2">
                                            
                                            <!--<option ${status eq 'Draft' ? 'selected' : ""} value="Draft">Draft</option>-->
                                            <option ${status eq 'Pending' ? 'selected' : ""} value="Pending">Pending</option>
                                            <option value="" ${status eq '' ? 'selected' : ""}>All Status</option>
                                            <option ${status eq 'Public' ? 'selected' : ""} value="Public">Public</option>
                                            <!--<option ${status eq 'Rejected' ? 'selected' : ""} value="Rejected">Rejected</option>-->
                                            <!--<option ${status eq 'Blocked' ? 'selected' : ""} value="Blocked">Blocked</option>-->
                                        </select>

                                        <button id="filterButton" name="action" value="FilterCategoryAndStatus" class="btn btn-secondary">Filter</button>
                                    </form>
                                </div>

                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Image</th>
                                            <th>Title</th>
                                            <th>Expert</th>  
                                            <th>Price</th> 
                                            <th>Category</th>   
                                            <th>Total Lessons</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="courseTableBody">
                                        <c:forEach items="${courses}" var="courses">
                                            
                                            <tr>
                                                <td>${courses.courseID}</td>
                                                <td><img src=".${courses.imageUrl}" width="50"></td>
                                                <td>${courses.title}</td>
                                                <td>${courses.expert.fullName}</td>
                                                <td>${courses.price}</td>
                                                <td>${courses.category.name}</td>

                                                <td>${courses.totalLesson}</td>
                                                <td>${courses.status}</td>
                                                <td>
                                                    <c:if test="${courses.status eq 'Pending'}">
                                                    <a href="confirm-request?courseId=${courses.courseID}&action=1" class="btn btn-success" style="background-color: green;color: white">Approve</a>
                                                    <a href="confirm-request?courseId=${courses.courseID}&action=0" class="btn btn-danger" style="background-color: red;color: white">Reject</a></c:if>
                                                     <c:if test="${courses.status eq 'Public'}">
                                                    <a href="confirm-request?courseId=${courses.courseID}&action=2" class="btn btn-danger" style="background-color: red;color: white">Delete</a>
                                                     </c:if> 
                                                    <a href="lesson?courseId=${courses.courseID}" class="btn btn-primary" style="background-color: blue;color: white">View</a>
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
                                            <jsp:include page="common/pagination.jsp"></jsp:include>
        <div class="ttr-overlay"></div>      
    </body>
    <script src="assets/admin/assets/js/jquery.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
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
    <script src="assets/admin/assets/js/admin.js"></script>    <script src="https://cdnjs.cloudflare.com/ajax/libs/timeago.js/4.0.2/timeago.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const timeElements = document.querySelectorAll(".last-sign-in");

            timeElements.forEach(el => {
                const timeString = el.getAttribute("data-time");
                if (timeString) {
                    const formattedTime = timeago.format(new Date(timeString));
                    el.textContent = formattedTime;
                }
            });
        });


    </script>
</html>
