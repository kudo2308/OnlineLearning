
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/lesson-details.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:10:19 GMT -->
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
                        <h4 class="breadcrumb-title">Lesson Details</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li>Lesson Details</li>
                        </ul>
                    </div>
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Lesson Information</h4>
                                </div>
                                <div class="widget-inner">
                                    <form action="updateLesson" method="post" class="edit-profile m-b30">
                                        <div class="row">
                                            <div class="form-group col-12">
                                                <label class="col-form-label">Title</label>
                                                <div>
                                                    <input required class="form-control" type="text" name="title" value="${lesson.title}">
                                            </div>
                                        </div>
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Content</label>
                                            <div>
                                                <textarea required class="form-control" name="content">${lesson.content}</textarea>
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Lesson Type</label>
                                            <div>
                                                <input style="display: none" class="form-control" type="text" name="lessonId" value="${lesson.lessonID}">
                                                <input required class="form-control" type="text" name="lessonType" value="${lesson.lessonType}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Video URL</label>
                                            <div>
                                                <input required class="form-control" type="text" name="videoUrl" value="${lesson.videoUrl}" oninput="updateVideoPreview()">
                                            </div>
                                        </div>
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Video Preview</label>
                                            <div>
                                                <iframe id="videoPreview" width="100%" height="400" src="${lesson.videoUrl}" frameborder="0" allowfullscreen></iframe>
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Course</label>
                                            <div>
                                                <input class="form-control" disabled type="text" name="courseName" value="${lesson.course.title}">
                                                <input class="form-control" style="display: none" type="text" name="courseId" value="${lesson.course.courseID}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Package</label>
                                             <div>
                                                <input required class="form-control" type="text" id="packagesInput" value="" list="packagesSuggestions">
                                                <datalist id="packagesSuggestions">
                                                    <c:forEach items="${packages}" var="packages">
                                                        <option style="display: none" value="${packages.name}" data-id="${packages.packageID}"></option>
                                                    </c:forEach>
                                                    <input type="hidden" name="packageId" id="packageId" value="">
                                                </datalist>
                                            </div>
                                        </div>

                                        <div class="form-group col-6">
                                            <label class="col-form-label">Document URL</label>
                                            <div>
                                                <input class="form-control" type="text" name="documentUrl" value="${lesson.documentUrl}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Duration (minutes)</label>
                                            <div>
                                                <input readonly class="form-control" type="number" name="duration" value="${lesson.duration}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Order Number</label>
                                            <div>
                                                <input required class="form-control" type="number" name="orderNumber" value="${lesson.orderNumber}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Status</label>
                                            <div>
                                                <select class="form-control" name="status">
                                                    <option ${lesson.status ==  true? 'selected' : ''} value="1">Active</option>
                                                    <option ${!lesson.status ==  true ? 'selected' : ''} value="0">Blocked</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Created At</label>
                                            <div>
                                                <input disabled class="form-control" type="datetime-local" name="createdAt" value="${lesson.createdAt}">
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label class="col-form-label">Updated At</label>
                                            <div>
                                                <input disabled class="form-control" type="datetime-local" name="createdAt" value="${lesson.updatedAt}">
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">Save</button>
                                            <a href="lessons" class="btn btn-secondary">Cancel</a>
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
        <script src='assets/admin/assets/vendors/switcher/switcher.js'></script>

        <script>
            document.getElementById("packagesInput").addEventListener("input", function () {
                let input = this.value;
                let datalist = document.getElementById("packagesSuggestions").options;
                let hiddenInput = document.getElementById("packageId");

                for (let option of datalist) {
                    if (option.value === input) {
                        hiddenInput.value = option.getAttribute("data-id");
                        break;
                    }
                }
            });

        </script>
    </body>


</html>
