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
        <title>Edit Quiz</title>

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
                    <h4 class="breadcrumb-title">Edit Quiz</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/QuizList?action=list">Quiz List</a></li>
                        <li>Edit Quiz</li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Edit Quiz</h4>
                            </div>
                            <div class="widget-inner">
                                <form class="edit-profile m-b30" action="${pageContext.request.contextPath}/QuizList" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="quizId" value="${quiz.quizID}">
                                    
                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Name</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="text" id="name" name="name" value="${quiz.name}" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Description</label>
                                        <div class="col-sm-7">
                                            <textarea class="form-control" id="description" name="description" required>${quiz.description}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Duration (minutes)</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="duration" name="duration" min="1" value="${quiz.duration}" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Pass Rate (%)</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="passRate" name="passRate" min="0" max="100" value="${quiz.passRate}" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Total Questions</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="totalQuestion" name="totalQuestion" min="1" value="${quiz.totalQuestion}" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Course</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="courseID" name="courseID" required onchange="loadPackages()">
                                                <option value="">Select a course</option>
                                                <c:forEach items="${courses}" var="course">
                                                    <option value="${course.courseID}" ${course.courseID == quiz.courseID ? 'selected' : ''}>${course.title}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group row" id="packageContainer">
                                        <label class="col-sm-2 col-form-label">Package</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="packageID" name="packageID" required>
                                                <option value="">Select a package</option>
                                                <c:forEach items="${packages}" var="pkg">
                                                    <option value="${pkg.packageID}" ${pkg.packageID == quiz.packageID ? 'selected' : ''}>${pkg.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Status</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="status" name="status" required>
                                                <option value="true" ${quiz.status ? 'selected' : ''}>Active</option>
                                                <option value="false" ${!quiz.status ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <div class="col-sm-7">
                                            <button type="submit" class="btn">Update Quiz</button>
                                            <a href="${pageContext.request.contextPath}/QuizList?action=list" class="btn-secondry">Cancel</a>
                                        </div>
                                    </div>
                                </form>
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
            // Khi trang được tải, kiểm tra nếu đã chọn khóa học thì hiển thị phần chọn gói
            $(document).ready(function() {
                var courseId = document.getElementById("courseID").value;
                if (courseId !== "") {
                    document.getElementById("packageContainer").style.display = "flex";
                } else {
                    document.getElementById("packageContainer").style.display = "none";
                }
            });
            
            function loadPackages() {
                var courseId = document.getElementById("courseID").value;
                var packageContainer = document.getElementById("packageContainer");
                var packageSelect = document.getElementById("packageID");
                var currentPackageId = "${quiz.packageID}"; // Lưu lại ID gói hiện tại
                
                // Clear previous options
                packageSelect.innerHTML = '<option value="">Select a package</option>';
                
                if (courseId === "") {
                    packageContainer.style.display = "none";
                    return;
                }
                
                // Show the package container
                packageContainer.style.display = "flex";
                
                // Directly fetch packages via AJAX
                $.ajax({
                    url: "${pageContext.request.contextPath}/QuizList",
                    type: "GET",
                    data: {
                        action: "getPackages",
                        courseID: courseId
                    },
                    dataType: "json",
                    success: function(data) {
                        if (data && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                var option = document.createElement("option");
                                option.value = data[i].packageID;
                                option.text = data[i].name;
                                // Nếu là gói hiện tại, đánh dấu là selected
                                if (data[i].packageID == currentPackageId) {
                                    option.selected = true;
                                }
                                packageSelect.appendChild(option);
                            }
                        } else {
                            packageSelect.innerHTML = '<option value="">No packages available</option>';
                        }
                    },
                    error: function() {
                        packageSelect.innerHTML = '<option value="">Error loading packages</option>';
                    }
                });
            }
        </script>
    </body>
</html>
