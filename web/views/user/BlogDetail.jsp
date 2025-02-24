<%-- 
    Document   : BlogDetail
    Created on : Feb 9, 2025, 9:54:38 PM
    Author     : ASUS
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>EduChamp : Education HTML Template </title>

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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    </head>
    <jsp:include page="/common/header.jsp"></jsp:include>
        <body id="bg">
            <div class="page-wraper">

                <!-- Content -->
                <div class="page-content bg-white">
                    <!-- inner page banner -->

                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                        <li>Blog Details</li>
                    </ul>
                </div>
            </div>
            <!-- Breadcrumb row END -->
            <div class="content-block">
                <div class="section-area section-sp1">
                    <div class="container">
                        <div class="row">
                            <!-- Left part start -->
                            <div class="col-lg-8 col-xl-8">
                                <!-- blog start -->
                                <div class="recent-news blog-lg">
                                    <div class="action-box blog-lg">
                                        <img src="${pageContext.request.contextPath}${blog.imgUrl}" alt="">
                                    </div>
                                    <div class="info-bx">
                                        <ul class="media-post">
                                            <li><a href="#"><i class="fa fa-calendar"></i>${blog.createAt}</a></li>
                                            <li><a href="#"><i class="fa fa-comments-o"></i>${blog.author.getFullName()}</a></li>
                                        </ul>
                                        <h5 class="post-title"><a href="#">${blog.title}</a></h5>
                                        <p>${blog.content}</p>
                                        <div class="ttr-divider bg-gray"><i class="icon-dot c-square"></i></div>
                                        <div class="widget_tag_cloud">
                                            <h6>TAGS</h6>
                                            <div class="tagcloud"> 
                                                <a href="#">Design</a> 
                                                <a href="#">User interface</a> 
                                                <a href="#">SEO</a> 
                                                <a href="#">WordPress</a> 
                                                <a href="#">Development</a> 
                                                <a href="#">Joomla</a> 
                                                <a href="#">Design</a> 
                                                <a href="#">User interface</a> 
                                                <a href="#">SEO</a> 
                                                <a href="#">WordPress</a> 
                                                <a href="#">Development</a> 
                                                <a href="#">Joomla</a> 
                                                <a href="#">Design</a> 
                                                <a href="#">User interface</a> 
                                                <a href="#">SEO</a> 
                                                <a href="#">WordPress</a> 
                                                <a href="#">Development</a> 
                                                <a href="#">Joomla</a> 
                                            </div>
                                        </div>
                                        <div class="ttr-divider bg-gray"><i class="icon-dot c-square"></i></div>
                                        <h6>SHARE </h6>
                                        <ul class="list-inline contact-social-bx">
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-facebook"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-twitter"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-linkedin"></i></a></li>
                                            <li><a href="#" class="btn outline radius-xl"><i class="fa fa-google-plus"></i></a></li>
                                        </ul>
                                        <div class="ttr-divider bg-gray"><i class="icon-dot c-square"></i></div>
                                    </div>
                                </div>

                                <!-- blog END -->
                            </div>
                            <!-- Left part END -->
                            <!-- Side bar start -->
                            <div class="col-lg-4 col-xl-4">
                                <aside  class="side-bar sticky-top">
                                    <div class="widget">
                                        <h6 class="widget-title">Search</h6>
                                        <div class="search-bx style-1">
                                            <form id="search-blog" action="Blog" method="get">
                                                <div class="input-group">
                                                    <input name="search" class="form-control" placeholder="Enter your keywords..." type="text">
                                                    <span class="input-group-btn">
                                                        <button type="submit" class="fa fa-search text-primary"></button>
                                                    </span> 
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="widget recent-posts-entry">
                                        <h6 class="widget-title">related posts</h6>
                                        <div class="widget-post-bx">
                                            <c:forEach var="relatedBlog" items="${relatedBlogs}">
                                                <div class="widget-post clearfix">
                                                    <div class="ttr-post-media"> <img src="${pageContext.request.contextPath}${relatedBlog.imgUrl}" width="200" height="143" alt=""> </div>
                                                    <div class="ttr-post-info">
                                                        <div class="ttr-post-header">
                                                            <h6 class="post-title"><a href="${pageContext.request.contextPath}/BlogDetail?blogId=${relatedBlog.blogId}">${relatedBlog.title}</a></h6>
                                                        </div>
                                                        <ul class="media-post">
                                                            <li><a href="#"><i class="fa fa-calendar"></i>${relatedBlog.createAt}</a></li>
                                                            <li><a href="#"><i class="fa fa-comments-o"></i>${relatedBlog.author.getFullName()}</a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </c:forEach>     
                                        </div>
                                    </div>

                                    <div class="widget recent-posts-entry">
                                        <h6 class="widget-title">recent posts</h6>
                                        <div class="widget-post-bx">
                                            <c:forEach var="recentBlog" items="${recentBlogs}">
                                                <div class="widget-post clearfix">
                                                    <div class="ttr-post-media"> <img src="${pageContext.request.contextPath}${recentBlog.imgUrl}" width="200" height="143" alt=""> </div>
                                                    <div class="ttr-post-info">
                                                        <div class="ttr-post-header">
                                                            <h6 class="post-title"><a href="${pageContext.request.contextPath}/BlogDetail?blogId=${recentBlog.blogId}">${recentBlog.title}</a></h6>
                                                        </div>
                                                        <ul class="media-post">
                                                            <li><a href="#"><i class="fa fa-calendar"></i>${recentBlog.createAt}</a></li>
                                                            <li><a href="#"><i class="fa fa-comments-o"></i>${recentBlog.author.getFullName()}</a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </c:forEach>     
                                        </div>
                                    </div>

                                    <div class="widget widget_tag_cloud">
                                        <h6 class="widget-title">Tags</h6>
                                        <div class="tagcloud"> 
                                            <a href="#">Design</a> 
                                            <a href="#">User interface</a> 
                                            <a href="#">SEO</a> 
                                            <a href="#">WordPress</a> 
                                            <a href="#">Development</a> 
                                            <a href="#">Joomla</a> 
                                            <a href="#">Design</a> 
                                            <a href="#">User interface</a> 
                                            <a href="#">SEO</a> 
                                            <a href="#">WordPress</a> 
                                            <a href="#">Development</a> 
                                            <a href="#">Joomla</a> 
                                            <a href="#">Design</a> 
                                            <a href="#">User interface</a> 
                                            <a href="#">SEO</a> 
                                            <a href="#">WordPress</a> 
                                            <a href="#">Development</a> 
                                            <a href="#">Joomla</a> 
                                        </div>
                                    </div>
                                </aside>
                            </div>
                            <!-- Side bar END -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Content END-->
        <!-- Footer ==== -->
        <footer>
            <div class="footer-top">
                <div class="pt-exebar">
                    <div class="container">
                        <div class="d-flex align-items-stretch">
                            <div class="pt-logo mr-auto">
                                <a href="index.html"><img src="assets/images/logo-white.png" alt=""/></a>
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
                                    <li><a href="assets/images/gallery/pic1.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic1.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic2.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic2.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic3.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic3.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic4.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic4.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic5.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic5.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic6.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic6.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic7.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic7.jpg" alt=""></a></li>
                                    <li><a href="assets/images/gallery/pic8.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic8.jpg" alt=""></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 text-center"> <a target="_blank" href="https://www.templateshub.net">Templates Hub</a></div>
                    </div>
                </div>
            </div>
        </footer>
        <!-- Footer END ==== -->
        <!-- scroll top button -->
        <button class="back-to-top fa fa-chevron-up" ></button>
    </div>

</body>

</html>
