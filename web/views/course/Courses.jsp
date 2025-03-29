<%-- 
    Document   : Courses
    Created on : Feb 15, 2025, 11:13:43 AM
    Author     : ASUS
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
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
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=filter_alt" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/CourseStyle.css">
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    </head>
    <body id="bg">
        <div class="page-wraper">



            <!-- Navigation Menu END ==== -->

            <!-- header END ==== -->
            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner3.jpg);">
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
                            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                            <li>All Courses</li>
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
                                <div class="col-lg-4 col-md-4 col-sm-12 m-b30">
                                    <div class="widget courses-search-bx placeani">
                                        <div class="form-group">
                                            <form id="search" action="CourseSearch" method="get">
                                                <label>Search courses</label>
                                                <div class="input-group">
                                                    <input name="search" type="text" placeholder="What do you want to learn?" value="" >
                                                </div>
                                        </div>
                                    </div>
                                    <div class="widget widget_archive">
                                        <h5>Filter by Category</h5>
                                        <c:forEach var="category" items="${categories}">
                                            <div class="category-checkbox">
                                                <input 
                                                    type="checkbox" 
                                                    name="categoryId" 
                                                    value="${category.categoryID}" 
                                                    id="cat-${category.categoryID}"
                                                    <c:if test="${selectedCategories != null && fn:contains(fn:join(selectedCategories, ','), category.categoryID)}">checked</c:if>>
                                                <label for="cat-${category.categoryID}">${category.name}</label>
                                            </div>
                                        </c:forEach>
                                        <button class="sub-but" type="submit">Search</button>
                                        <hr>
                                        <!-- Lọc theo giá -->
                                        <h5 class="widget-title style-1">PRICE</h5>
                                        <div class="price-range">
                                            <input type="number" name="minPrice" placeholder="Min Price" class="range-control min-ui" value="${minPrice != 0 ? minPrice : ''}">
                                            <input type="number" name="maxPrice" placeholder="Max Price" class="range-control max-ui" value="${maxPrice != Double.MAX_VALUE ? maxPrice : ''}">
                                            <button class="filter-icon-btn" type="submit" title="Apply price filter">
                                                <span class="material-symbols-outlined">filter_alt</span>
                                            </button>
                                        </div>

                                    </div>
                                    </form>
                                </div>
                                <div class="col-lg-8 col-md-8 col-sm-12">
                                    <div class="row">
                                        <c:forEach var="course" items="${courses}">
                                            <div class="col-md-6 col-lg-4 col-sm-6 m-b30 sync">
                                                <div class="cours-bx">
                                                    <div class="action-box">
                                                        <img src="${pageContext.request.contextPath}${course.imageUrl}" alt="">
                                                        <a href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseID}" class="btn">View Details</a>
                                                    </div>
                                                    <div class="info-bx text-center sync">
                                                        <h5><a href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseID}">${course.title}</a></h5>
                                                        <span>${course.category.getName()}</span>
                                                    </div>
                                                    <div class="cours-more-info">
                                                        <div class="review">
                                                            <span>3 Review</span>
                                                            <ul class="cours-star">
                                                                <li class="active"><i class="fa fa-star"></i></li>
                                                                <li class="active"><i class="fa fa-star"></i></li>
                                                                <li class="active"><i class="fa fa-star"></i></li>
                                                                <li><i class="fa fa-star"></i></li>
                                                                <li><i class="fa fa-star"></i></li>
                                                            </ul>
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${course.discountPrice != null}">
                                                                <div class="price">
                                                                    <del><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="đ" pattern="#,###" />đ</del>
                                                                    <h5><fmt:formatNumber value="${course.discountPrice}" type="currency" currencySymbol="đ" pattern="#,###" />đ</h5>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span>
                                                                    <h5><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="đ" pattern="#,###" />đ</h5>
                                                                    (${course.register})
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                    </div>
                                    <!-- PHÂN TRANG - LUÔN HIỂN THỊ CUỐI TRANG -->
                                    <div class="pagination-container">
                                        <div class="pagination-bx rounded-sm gray clearfix">
                                            <c:if test="${totalPages > 1}">
                                                <ul class="pagination">
                                                    <c:if test="${currentPage > 1}">
                                                        <li><a href="?page=${currentPage - 1}&search=${searchKeyword}"><i class="fa fa-chevron-left"></i></a></li>
                                                            </c:if>

                                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                                        <li class="${currentPage == i ? 'active' : ''}">
                                                            <a href="?page=${i}&search=${searchKeyword}">${i}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${currentPage < totalPages}">
                                                        <li><a href="?page=${currentPage + 1}&search=${searchKeyword}"><i class="fa fa-chevron-right"></i></a></li>
                                                            </c:if>
                                                </ul>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
    </body>
</html>
