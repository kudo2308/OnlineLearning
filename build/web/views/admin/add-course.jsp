

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
                        <h4 class="breadcrumb-title">Add Course</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li>Add Course</li>
                        </ul>
                    </div>
                    <div class="row">
                        <div class="col-lg-12 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4>Add Course</h4>
                                </div>
                                <div class="wc-title">
                                    <h4 style="color: red" >${msg}</h4>
                                </div>
                                <div class="widget-inner">
                                <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

                                <form class="edit-profile m-b30" action="addCourse" method="post" enctype="multipart/form-data">
                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Title</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="text" name="title" value="${courseRequest.title}" required>
                                            <c:forEach var="violation" items="${violations}">
                                                <c:if test="${violation.propertyPath.toString() == 'title'}">
                                                    <span style="color:red">${violation.message}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Description</label>
                                        <div class="col-sm-7">
                                            <textarea class="form-control" name="description" required>${courseRequest.description}</textarea>
                                            <c:forEach var="violation" items="${violations}">
                                                <c:if test="${violation.propertyPath.toString() == 'description'}">
                                                    <span style="color:red">${violation.message}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Category</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" name="categoryId" required>
                                                <option value="1" ${courseRequest.categoryID == 1 ? 'selected' : ''}>Programming</option>
                                                <option value="2" ${courseRequest.categoryID == 2 ? 'selected' : ''}>Design</option>
                                                <option value="3" ${courseRequest.categoryID == 3 ? 'selected' : ''}>Marketing</option>

                                                <c:forEach items="${categories}" var="categories">
                                                    <option ${courseRequest.categoryID == categories.categoryID ? 'selected' : ''} value="${categories.categoryID}">${categories.name}</option>
                                                </c:forEach>
                                            </select>
                                            <c:forEach var="violation" items="${violations}">
                                                <c:if test="${violation.propertyPath.toString() == 'categoryId'}">
                                                    <span style="color:red">${violation.message}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Image</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="file" name="image" accept="image/*" required>
                                            <c:forEach var="violation" items="${violations}">
                                                <c:if test="${violation.propertyPath.toString() == 'image'}">
                                                    <span style="color:red">${violation.message}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Total Lessons</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" name="totalLesson" value="${courseRequest.totalLesson}" min="1" required>
                                            <c:forEach var="violation" items="${violations}">
                                                <c:if test="${violation.propertyPath.toString() == 'totalLesson'}">
                                                    <span style="color:red">${violation.message}</span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-2"></div>
                                        <div class="col-sm-7">
                                            <button type="submit" class="btn btn-primary">Add Course</button>
                                            <a type="reset" href="courses" class="btn btn-secondary">Back</a>
                                        </div>
                                    </div>
                                </form>

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
