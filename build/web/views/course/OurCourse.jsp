<%-- 
    Document   : OurCourse
    Created on : Jan 24, 2025, 11:24:02 PM
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
        <title>Our Courses | EduChamp</title>

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
                <div class="page-banner ovbl-dark" style="background-image:url(<c:url value='/assets/images/banner/banner3.jpg'/>);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">Our Courses</h1>
                        </div>
                    </div>
                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="<c:url value='/home'/>">Home</a></li>
                            <li>Our Courses</li>
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
                                <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                                    <div class="widget courses-search-bx placeani">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label>Search Courses</label>
                                                <input name="dzName" type="text" required class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget widget_archive">
                                        <h5 class="widget-title style-1">All Courses</h5>
                                        <ul>
                                            <li class="active"><a href="#">General</a></li>
                                            <li><a href="#">IT & Software</a></li>
                                            <li><a href="#">Photography</a></li>
                                            <li><a href="#">Programming Language</a></li>
                                            <li><a href="#">Technology</a></li>
                                        </ul>
                                    </div>
                                    <div class="widget">
                                        <a href="#"><img src="<c:url value='/assets/images/adv/adv.jpg'/>" alt=""/></a>
                                    </div>
                                    <div class="widget recent-posts-entry widget-courses">
                                        <h5 class="widget-title style-1">Recent Courses</h5>
                                        <div class="widget-post-bx">
                                            <div class="widget-post clearfix">
                                                <div class="ttr-post-media"> <img src="<c:url value='/assets/images/blog/recent-blog/pic1.jpg'/>" width="200" height="143" alt=""> </div>
                                                <div class="ttr-post-info">
                                                    <div class="ttr-post-header">
                                                        <h6 class="post-title"><a href="#">Introduction EduChamp</a></h6>
                                                    </div>
                                                    <div class="ttr-post-meta">
                                                        <ul>
                                                            <li class="price">
                                                                <del>$190</del>
                                                                <h5>$120</h5>
                                                            </li>
                                                            <li class="review">03 Review</li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-9 col-md-8 col-sm-12">
                                    <div class="row">
                                        <c:forEach items="${courseList}" var="course">
                                            <div class="col-md-6 col-lg-4 col-sm-6 m-b30">
                                                <div class="cours-bx">
                                                    <div class="action-box">
                                                        <img src="${course.imageUrl}" alt="">
                                                        <a href="<c:url value='/course-details?id=${course.courseID}'/>" class="btn">Read More</a>
                                                    </div>
                                                    <div class="info-bx text-center">
                                                        <h5><a href="<c:url value='/course-details?id=${course.courseID}'/>">${course.title}</a></h5>
                                                        <span>${course.category.name}</span>
                                                    </div>
                                                    <div class="cours-more-info">
                                                        <div class="review">
                                                            <span>Expert</span>
                                                            <h6>${course.expert.fullName}</h6>
                                                        </div>
                                                        <div class="price">
                                                            <h5>$${course.price}</h5>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <!-- Pagination -->
                                        <div class="col-lg-12 m-b20">
                                            <div class="pagination-bx rounded-sm gray clearfix">
                                                <ul class="pagination">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="previous"><a href="<c:url value='/course?page=${currentPage-1}'/>"><i class="ti-arrow-left"></i> Prev</a></li>
                                                    </c:if>
                                                    
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="${currentPage == i ? 'active' : ''}">
                                                            <a href="<c:url value='/course?page=${i}'/>">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    
                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="next"><a href="<c:url value='/course?page=${currentPage+1}'/>">Next <i class="ti-arrow-right"></i></a></li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
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
        <script src="<c:url value='/assets/vendors/switcher/switcher.js'/>"></script>
    </body>
</html>
