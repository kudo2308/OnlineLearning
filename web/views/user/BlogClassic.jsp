<%-- 
    Document   : BlogClassic
    Created on : Feb 9, 2025, 9:35:13 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
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
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/blogStyle.css" />
            <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
            <link
                rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

            <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
            <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

            <!-- PAGE TITLE HERE ============================================= -->
            <title>Online Learning</title>
            <!-- MOBILE SPECIFIC ============================================= -->
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <!--[if lt IE 9]>
            <script src="assets/js/html5shiv.min.js"></script>
            <script src="assets/js/respond.min.js"></script>
            <![endif]-->

            <!-- All PLUGINS CSS ============================================= -->
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">

            <!-- TYPOGRAPHY ============================================= -->
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

            <!-- SHORTCODES ============================================= -->
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">

            <!-- STYLESHEETS ============================================= -->
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
            <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

            <jsp:include page="/common/header.jsp"></jsp:include>

            </div>
        <div class="breadcrumb-row">
            <div class="container">
                <ul class="list-inline">
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/Blog?categoryId = 0">Blog list</a></li>
            </ul>
        </div>
    </div>
    <!-- Page Heading Box END ==== -->
    <!-- Page Content Box ==== -->
    <div class="content-block">
        <!-- Blog Grid ==== -->
        <div class="section-area section-sp1">
            <div class="container">
                <div class="widget courses-search-bx placeani">
                    <div class="form-group filter-blog">
                        <div class="filter-cate">
                            <form id="filter-form" action="Blog" method="get">
                                <select name="categoryId" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                    <option value="0" ${selectedCategory == 0 ? 'selected' : ''}>All Categories</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryID}" ${selectedCategory == category.categoryID ? 'selected' : ''}>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                        </div>
                        <div class="filter-search">
                                <div class="input-group">
                                    <input name="search" type="text" required class="form-control" placeholder="Search blogs">
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="row row-cols-1 row-cols-md-3 g-4" id="masonry">

                    <c:if test="${not empty blogs}">
                        <c:forEach var="blog" items="${blogs}">
                            <div class="post action-card col-lg-4 col-md-6 col-sm-12 col-xs-12 m-b40">
                                <div class="recent-news">
                                    <div class="action-box">
                                        <img src="${pageContext.request.contextPath}${blog.imgUrl}" alt="">
                                    </div>
                                    <div class="info-bx">
                                        <ul class="media-post">
                                            <li><a href="#"><i class="fa fa-calendar"></i>${blog.createAt}</a></li>
                                            <li><a href="#"><i class="fa fa-user"></i>${blog.author.fullName}</a></li>
                                        </ul>
                                        <h5 class="post-title"><a href="${pageContext.request.contextPath}/BlogDetail?blogId=${blog.blogId}">${blog.title}</a></h5>
                                        <p class="truncate-text">${blog.content}</p>
                                        <div class="post-extra">
                                            <a href="#" class="btn-link">READ MORE</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty blogs}">
                        <li>Hiện chưa có sản phẩm mới.</li>
                        </c:if>

                    <!-- Phân trang -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-bx rounded-sm gray clearfix">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="previous">
                                        <a href="?page=${currentPage - 1}&categoryId=${selectedCategory}&search=${searchKeyword}">
                                            <i class="ti-arrow-left"></i> Prev
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="${currentPage == i ? 'active' : ''}">
                                        <a href="?page=${i}&categoryId=${selectedCategory}&search=${searchKeyword}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="next">
                                        <a href="?page=${currentPage + 1}&categoryId=${selectedCategory}&search=${searchKeyword}">
                                            Next <i class="ti-arrow-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </c:if>
                    <!-- Pagination END ==== -->
                </div>
            </div>
            <!-- Blog Grid END ==== -->
        </div>
        <!-- Page Content Box END ==== -->
    </div>
    <!-- Page Content Box END ==== -->
    <!-- Footer ==== -->
    <footer>
        <div class="footer-top">
            <div class="pt-exebar">
                <div class="container">
                    <div class="d-flex align-items-stretch">
                        <div class="pt-logo mr-auto">
                            <a href="index.html"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                        </div>
                        <div class="pt-social-link">
                            <ul class="list-inline m-a0">
                                <li><a href="#" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                                <li><a href="#" class="btn-link"><i class="fa fa-twitter"></i></a></li>
                                <li><a href="#" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                                <li><a href="#" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                            </ul>
                        </div>
                        <div class="pt-btn-join">
                            <a href="#" class="btn ">Join Now</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 col-md-12 col-sm-12 footer-col-4">
                        <div class="widget">
                            <h5 class="footer-title">Sign Up For A Newsletter</h5>
                            <p class="text-capitalize m-b20">Weekly Breaking news analysis and cutting edge advices on job searching.</p>
                            <div class="subscribe-form m-b20">
                                <form class="subscription-form" action="http://educhamp.themetrades.com/demo/assets/script/mailchamp.php" method="post">
                                    <div class="ajax-message"></div>
                                    <div class="input-group">
                                        <input name="email" required="required"  class="form-control" placeholder="Your Email Address" type="email">
                                        <span class="input-group-btn">
                                            <button name="submit" value="Submit" type="submit" class="btn"><i class="fa fa-arrow-right"></i></button>
                                        </span> 
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-5 col-md-7 col-sm-12">
                        <div class="row">
                            <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                <div class="widget footer_widget">
                                    <h5 class="footer-title">Company</h5>
                                    <ul>
                                        <li><a href="index.html">Home</a></li>
                                        <li><a href="about-1.html">About</a></li>
                                        <li><a href="faq-1.html">FAQs</a></li>
                                        <li><a href="contact-1.html">Contact</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                <div class="widget footer_widget">
                                    <h5 class="footer-title">Get In Touch</h5>
                                    <ul>
                                        <li><a href="http://educhamp.themetrades.com/admin/index.html">Dashboard</a></li>
                                        <li><a href="blog-classic-grid.html">Blog</a></li>
                                        <li><a href="portfolio.html">Portfolio</a></li>
                                        <li><a href="event.html">Event</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                <div class="widget footer_widget">
                                    <h5 class="footer-title">Courses</h5>
                                    <ul>
                                        <li><a href="courses.html">Courses</a></li>
                                        <li><a href="courses-details.html">Details</a></li>
                                        <li><a href="membership.html">Membership</a></li>
                                        <li><a href="profile.html">Profile</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-3 col-md-5 col-sm-12 footer-col-4">
                        <div class="widget widget_gallery gallery-grid-4">
                            <h5 class="footer-title">Our Gallery</h5>
                            <ul class="magnific-image">
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic1.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic1.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic2.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic2.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic3.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic3.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic4.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic4.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic5.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic5.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic6.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic6.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic7.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic7.jpg" alt=""></a></li>
                                <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic8.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic8.jpg" alt=""></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 text-center"><a target="_blank" href="https://www.templateshub.net">Templates Hub</a></div>
                </div>
            </div>
        </div>
    </footer>
    <!-- Footer END ==== -->
    <button class="back-to-top fa fa-chevron-up"></button>
</div>
</body>

</html>

