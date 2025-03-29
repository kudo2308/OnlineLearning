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
        <title>Add Quiz</title>

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
                        <h4 class="breadcrumb-title">Add Quiz</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li>Add Quiz</li>
                        </ul>
                    </div>
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Add Quiz</h4>
                                </div>
                                <div class="widget-inner">
                                    <form class="edit-profile m-b30" action="${pageContext.request.contextPath}/AddQuiz" method="POST">
                                    <input type="hidden" name="action" value="add">

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Name</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="text" id="name" name="name" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Description</label>
                                        <div class="col-sm-7">
                                            <textarea class="form-control" id="description" name="description" required></textarea>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Duration (minutes)</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="duration" name="duration" min="1" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Pass Rate (%)</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="passRate" name="passRate" min="0" max="100" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Total Questions</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="totalQuestion" name="totalQuestion" min="1" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Course</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="courseID" name="courseID" required onchange="loadPackages()">
                                                <option value="">Select a course</option>
                                                <c:forEach items="${courses}" var="course">
                                                    <option value="${course.courseID}">${course.title}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row" id="packageContainer">
                                        <label class="col-sm-2 col-form-label">Package</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="packageID" name="packageID" required>
                                                <option value="">Select a package</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <div class="col-sm-7">
                                            <button type="submit" class="btn">Create Quiz</button>
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
        <script src="assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>
        <script src="assets/admin/assets/vendors/calendar/moment.min.js"></script>
        <script src="assets/admin/assets/vendors/calendar/fullcalendar.js"></script>
        <script src="assets/admin/assets/vendors/switcher/switcher.js"></script>
        <script>
            function loadPackages() {
                var courseId = $("#courseID").val();
                if (courseId === "") {
                    // Clear package dropdown if no course is selected
                    $("#packageID").html('<option value="">Select a package</option>');
                    return;
                }
                
                // Show loading message
                $("#packageID").html('<option value="">Loading packages...</option>');
                
                // Fetch packages via AJAX
                $.ajax({
                    url: "${pageContext.request.contextPath}/AddQuiz",
                    type: "POST",
                    data: {
                        action: "getPackages",
                        courseID: courseId
                    },
                    success: function(data) {
                        // Clear existing options
                        var packageSelect = $("#packageID");
                        packageSelect.empty();
                        packageSelect.append('<option value="">Select a package</option>');
                        
                        // Add new options based on the response
                        if (data && data.length > 0) {
                            $.each(data, function(index, pkg) {
                                packageSelect.append('<option value="' + pkg.packageID + '">' + pkg.name + '</option>');
                            });
                        } else {
                            packageSelect.append('<option value="">No packages available for this course</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading packages:", error);
                        $("#packageID").html('<option value="">Error loading packages</option>');
                    }
                });
            }
            
            // Load packages if a course is already selected when the page loads
            $(document).ready(function() {
                if ($("#courseID").val() !== "") {
                    loadPackages();
                }
            });
        </script>
    </body>
</html>
