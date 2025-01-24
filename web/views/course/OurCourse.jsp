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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Our Courses - Online Learning System</title>
        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/public/assets/css/assets.css'/>">
        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/public/assets/css/typography.css'/>">
        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/public/assets/css/shortcodes/shortcodes.css'/>">
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="<c:url value='/public/assets/css/style.css'/>">
        <link class="skin" rel="stylesheet" type="text/css" href="<c:url value='/public/assets/css/color/color-1.css'/>">
    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-icon-bx"></div>

            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(<c:url value='/public/assets/images/banner/banner3.jpg'/>);">
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
                                <!-- Left part start -->
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
                                </div>
                                <!-- Left part END -->

                                <!-- Right part start -->
                                <div class="col-lg-9 col-md-8 col-sm-12">
                                    <div class="row">
                                        <c:forEach items="${courses}" var="course">
                                            <div class="col-md-6 col-lg-4 col-sm-6 m-b30">
                                                <div class="cours-bx">
                                                    <div class="action-box">
                                                        <img src="<c:url value='/public/assets/images/courses/${course.image}'/>" alt="">
                                                        <a href="<c:url value='/course/detail/${course.id}'/>" class="btn">Read More</a>
                                                    </div>
                                                    <div class="info-bx text-center">
                                                        <h5><a href="<c:url value='/course/detail/${course.id}'/>">${course.title}</a></h5>
                                                        <span>${course.category}</span>
                                                    </div>
                                                    <div class="cours-more-info">
                                                        <div class="review">
                                                            <span>${course.reviewCount} Review</span>
                                                            <ul class="cours-star">
                                                                <c:forEach begin="1" end="${course.rating}" var="i">
                                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                                    </c:forEach>
                                                                    <c:forEach begin="${course.rating + 1}" end="5" var="i">
                                                                    <li><i class="fa fa-star"></i></li>
                                                                    </c:forEach>
                                                            </ul>
                                                        </div>
                                                        <div class="price">
                                                            <c:if test="${course.originalPrice > course.price}">
                                                                <del>$${course.originalPrice}</del>
                                                            </c:if>
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
                                                        <li class="previous"><a href="?page=${currentPage - 1}"><i class="ti-arrow-left"></i> Prev</a></li>
                                                        </c:if>
                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="${currentPage == i ? 'active' : ''}">
                                                            <a href="?page=${i}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="next"><a href="?page=${currentPage + 1}">Next <i class="ti-arrow-right"></i></a></li>
                                                            </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Right part END -->
                            </div>
                        </div>
                    </div>
                </div>
                <!-- contact area END -->
            </div>
            <!-- Content END-->
        </div>

        <!-- External JavaScripts -->
        <script src="<c:url value='/public/assets/js/jquery.min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/bootstrap/js/popper.min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/bootstrap/js/bootstrap.min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/bootstrap-select/bootstrap-select.min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/magnific-popup/magnific-popup.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/counter/waypoints-min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/counter/counterup.min.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/imagesloaded/imagesloaded.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/masonry/masonry.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/masonry/filter.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/owl-carousel/owl.carousel.js'/>"></script>
        <script src="<c:url value='/public/assets/js/functions.js'/>"></script>
        <script src="<c:url value='/public/assets/js/contact.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/switcher/switcher.js'/>"></script>
    </body>
</html>
