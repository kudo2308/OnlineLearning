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
        <style>
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
        <jsp:include page="../../common/dashboard/header-dashboard.jsp"></jsp:include>
            <!-- header end -->
            <!-- Left sidebar menu start -->
        <jsp:include page="../../common/dashboard/left-sidebar-dashboard.jsp"></jsp:include>
            <!-- Left sidebar menu end -->

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
                                    <a id="addCourse" href="addCourse" class="btn btn-primary">Add Course</a>

                                    <form action="courses" class="d-flex align-items-center mx-3">
                                        <input type="text" id="searchName" name="name" placeholder="Search by name" value="${name}" class="form-control me-2">
                                        <button id="searchButton" name="action" value="searchByName" class="btn btn-secondary">Search</button>
                                    </form>

                                    <form action="courses" class="d-flex align-items-center mx-3">
                                        <select id="filterCategory" name="categoryId" class="form-control me-2">
                                            <option value="0">All Category</option>
                                            <c:forEach items="${categories}" var="categories">
                                                <option ${categoryId == categories.categoryID ? 'selected' : ""} value="${categories.categoryID}">${categories.name}</option>
                                            </c:forEach>
                                        </select>

                                        <select id="filterStatus" name="status" class="form-control me-2">
                                            <option value="">All Status</option>
                                            <option ${status eq 'Draft' ? 'selected' : ""} value="Draft">Draft</option>
                                            <option ${status eq 'Pending' ? 'selected' : ""} value="Pending">Pending</option>
                                            <option ${status eq 'Public' ? 'selected' : ""} value="Public">Public</option>
                                            <option ${status eq 'Rejected' ? 'selected' : ""} value="Rejected">Rejected</option>
                                            <option ${status eq 'Blocked' ? 'selected' : ""} value="Blocked">Blocked</option>
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
                                                    <a href="editCourse?courseId=${courses.courseID}" class="btn btn-warning">Edit</a>
                                                    <c:if test="${courses.status ne 'Blocked'}">
                                                        <a href="deleteCourse?courseId=${courses.courseID}" class="btn btn-danger">Delete</a>
                                                    </c:if>
                                                    <a href="packages?courseId=${courses.courseID}" class="btn btn-danger">Packages</a>
                                                    <c:if test="${courses.status ne 'Public' && courses.status ne 'Pending' && courses.status ne 'Blocked'}">
                                                        <a href="sellCourse?courseId=${courses.courseID}" class="btn btn-warning">Sell</a>
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
        <c:set var="error" value="${requestScope.error}" />
        <c:if test="${not empty error}">
            <div id="error-message" class="error-message">
                <i class="bx bxs-error"></i> ${error}
            </div>
        </c:if>
        <c:set var="success" value="${requestScope.success}" />
        <c:if test="${not empty success}">
            <div id="success" class="success">
                <i class="bx bxs-error"></i> ${success}
            </div>
        </c:if>
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
        <div class="ttr-overlay"></div>
        <script>
        function showMessage() {
            var errorMessage = document.getElementById("error-message");
            var successMessage = document.getElementById("success");

            // Hiển thị thông báo lỗi nếu có
            if (errorMessage) {
                errorMessage.style.display = "block";
                setTimeout(function () {
                    errorMessage.style.display = "none";
                }, 3000);
            }

            // Hiển thị thông báo thành công nếu có
            if (successMessage) {
                successMessage.style.display = "block";
                setTimeout(function () {
                    successMessage.style.display = "none";
                }, 3000);
            }
        }

        // Gọi hàm khi trang đã tải xong
        window.onload = function () {
            showMessage();
        };
<<<<<<< HEAD
=======
    </script>
        
    </body>
>>>>>>> ce3fcaf96198d4785a68d11363e6f37e26a121e1

        </body>

                <!-- Mirrored from educhamp.themetrades.com/demo/admin/courses.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:11:35 GMT -->
</html>
