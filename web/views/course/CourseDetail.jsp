<%-- 
    Document   : CourseDetail.jsp
    Created on : Feb 5, 2025, 10:39:43 PM
    Author     : dohie
--%>

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
        <link rel="icon" href="<c:url value='/assets/images/favicon.ico'/>" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/images/favicon.png'/>" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>${course.title} | EduChamp</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/assets.css'/>">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/typography.css'/>">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/shortcodes/shortcodes.css'/>">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
        <link class="skin" rel="stylesheet" type="text/css" href="<c:url value='/assets/css/color/color-1.css'/>">
    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-icon-bx"></div>

            <!-- Header Top ==== -->
            <jsp:include page="/common/header.jsp"/>
            <!-- header END ==== -->

            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(<c:url value='/assets/images/banner/banner2.jpg'/>);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">${course.title}</h1>
                        </div>
                    </div>
                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="<c:url value='/home'/>">Home</a></li>
                            <li><a href="<c:url value='/course'/>">Courses</a></li>
                            <li>${course.title}</li>
                        </ul>
                    </div>
                </div>
                <!-- Breadcrumb row END -->

                <!-- inner page banner END -->
                <div class="content-block">
                    <!-- About Us -->
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-8 col-md-7 col-sm-12">
                                    <div class="courses-post">
                                        <div class="ttr-post-media media-effect">
                                            <img src="${course.imageUrl}" alt="">
                                        </div>
                                        <div class="ttr-post-info m-b30">
                                            <div class="ttr-post-title">
                                                <h2 class="post-title">${course.title}</h2>
                                            </div>
                                            <div class="ttr-post-text">
                                                <p>${course.description}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="courese-overview" id="overview">
                                        <div class="row">
                                            <div class="col-md-12 col-lg-12">
                                                <h4 class="m-b5">Course Overview</h4>
                                                <ul class="course-features">
                                                    <li><i class="ti-book"></i> <span class="label">Lessons</span> <span class="value">${course.totalLesson}</span></li>
                                                    <li><i class="ti-user"></i> <span class="label">Expert</span> <span class="value">${course.expert.fullName}</span></li>
                                                    <li><i class="ti-time"></i> <span class="label">Duration</span> <span class="value">60 hours</span></li>
                                                    <li><i class="ti-tag"></i> <span class="label">Category</span> <span class="value">${course.category.name}</span></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-md-5 col-sm-12">
                                    <div class="bg-primary text-white contact-info-bx m-b30">
                                        <h2 class="m-b10 title-head">Course <span>Information</span></h2>
                                        <p>Contact us to get more information about this course.</p>
                                        <div class="widget widget_getintuch">
                                            <ul>
                                                <li><i class="ti-location-pin"></i>FPT University</li>
                                                <li><i class="ti-mobile"></i>0936751968 (24/7 Support Line)</li>
                                                <li><i class="ti-email"></i>info@yourdomain.com</li>
                                            </ul>
                                        </div>
                                        <h5 class="m-t0 m-b20">Follow Us</h5>
                                        <ul class="list-inline contact-social-bx">
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-facebook"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-twitter"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-linkedin"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-google-plus"></i></a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Related Courses -->
                    <div class="section-area section-sp2">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="heading-bx left">
                                        <h2 class="title-head">Related <span>Courses</span></h2>
                                        <p>Here are some other courses you might be interested in.</p>
                                    </div>
                                    <div class="row">
                                        <c:forEach items="${relatedCourses}" var="relatedCourse">
                                            <div class="col-md-6 col-lg-4 col-sm-6 m-b30">
                                                <div class="cours-bx">
                                                    <div class="action-box">
                                                        <img src="${relatedCourse.imageUrl}" alt="">
                                                        <a href="<c:url value='/course-details?id=${relatedCourse.courseID}'/>" class="btn">Read More</a>
                                                    </div>
                                                    <div class="info-bx text-center">
                                                        <h5><a href="<c:url value='/course-details?id=${relatedCourse.courseID}'/>">${relatedCourse.title}</a></h5>
                                                        <span>${relatedCourse.category.name}</span>
                                                    </div>
                                                    <div class="cours-more-info">
                                                        <div class="review">
                                                            <span>Expert</span>
                                                            <h6>${relatedCourse.expert.fullName}</h6>
                                                        </div>
                                                        <div class="price">
                                                            <h5>$${relatedCourse.pricePackageID}</h5>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Content END-->

            <!-- Footer ==== -->
            <jsp:include page="/common/footer.jsp"/>
            <!-- Footer END ==== -->

            <button class="back-to-top fa fa-chevron-up"></button>
        </div>
        <!-- External JavaScripts -->
        <script src="<c:url value='/assets/js/jquery.min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/bootstrap/js/popper.min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/bootstrap/js/bootstrap.min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/bootstrap-select/bootstrap-select.min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js'/>"></script>
        <script src="<c:url value='/assets/vendors/magnific-popup/magnific-popup.js'/>"></script>
        <script src="<c:url value='/assets/vendors/counter/waypoints-min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/counter/counterup.min.js'/>"></script>
        <script src="<c:url value='/assets/vendors/imagesloaded/imagesloaded.js'/>"></script>
        <script src="<c:url value='/assets/vendors/masonry/masonry.js'/>"></script>
        <script src="<c:url value='/assets/vendors/masonry/filter.js'/>"></script>
        <script src="<c:url value='/assets/vendors/owl-carousel/owl.carousel.js'/>"></script>
        <script src="<c:url value='/assets/js/functions.js'/>"></script>
        <script src="<c:url value='/assets/js/contact.js'/>"></script>
    </body>
</html>
