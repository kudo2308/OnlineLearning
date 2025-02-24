

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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
        <link rel="shortcut icon" type="image/x-icon" href="href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>EduChamp : Education HTML Template </title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/courseDetailStyle.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    </head>

    <div class="page-content bg-white">
        <!-- inner page banner -->
        <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner2.jpg);">
            <div class="container">
                <div class="page-banner-entry">
                    <h1 class="text-white">Courses Details</h1>
                </div>
            </div>
        </div>
        <!-- Breadcrumb row -->
        <div class="breadcrumb-row">
            <div class="container">
                <ul class="list-inline">
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li>Courses Details</li>
                </ul>
            </div>
        </div>
        <!-- Breadcrumb row END -->
        <!-- inner page banner END -->
        <div class="content-block">
            <!-- About Us -->
            <div class="section-area section-sp1">
                <div class="container">
                    <div class="row d-flex flex-row-reverse">
                        <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                            <div class="course-detail-bx">
                                <div class="course-price">
                                    <h4 class="price">${course.price}đ</h4>
                                </div>	
                                <div class="course-buy-now text-center">
                                    <a href="#" class="btn radius-xl text-uppercase">Buy Now This Courses</a>
                                </div>
                                <div class="teacher-bx">
                                    <div class="teacher-info">
                                        <div class="teacher-thumb">
                                            <img src="${pageContext.request.contextPath}${course.expert.getImage()}" alt=""/>
                                        </div>
                                        <div class="teacher-name">
                                            <h5>${course.expert.getFullName()}</h5>
                                            <span>Science Teacher</span>
                                        </div>
                                    </div>
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
                                    <div class="price categories">
                                        <span>Categories</span>
                                        <h5 class="text-primary">${course.category.getName()}</h5>
                                    </div>
                                </div>
                                <div class="course-info-list scroll-page">
                                    <ul class="navbar">
                                        <li><a class="nav-link" href="#overview"><i class="ti-zip"></i>Overview</a></li>
                                        <li><a class="nav-link" href="#curriculum"><i class="ti-bookmark-alt"></i>Curriculum</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-9 col-md-8 col-sm-12">
                            <div class="courses-post">
                                <div class="ttr-post-media media-effect">
                                    <a href="#"><img src="${pageContext.request.contextPath}${course.imageUrl}" alt=""></a>
                                </div>
                                <div class="ttr-post-info">
                                    <div class="ttr-post-title ">
                                        <h2 class="post-title">${course.title}</h2>
                                    </div>
                                    <div class="ttr-post-text">
                                        <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p>
                                    </div>
                                </div>
                            </div>
                            <div class="courese-overview" id="overview">
                                <h4>Overview</h4>
                                <div class="row">
                                    <div class="col-md-12 col-lg-4">
                                        <ul class="course-features">
                                            <li><i class="ti-book"></i> <span class="label">Lectures</span> <span class="value">${lessonNumber}</span></li>
                                            <li><i class="ti-help-alt"></i> <span class="label">Quizzes</span> <span class="value">${quiz}</span></li>
                                            <li><i class="ti-time"></i> <span class="label">Duration</span> <span class="value">${durationHour} hours</span></li>
                                        </ul>
                                    </div>
                                    <div class="col-md-12 col-lg-8">
                                        <h5 class="m-b5">Course Description</h5>
                                        <p>${course.description}</p>
                                        <h5 class="m-b5">Certification</h5>
                                        <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p>
                                        <h5 class="m-b5">Learning Outcomes</h5>
                                        <ul class="list-checked primary">
                                            <li>Over 37 lectures and 55.5 hours of content!</li>
                                            <li>LIVE PROJECT End to End Software Testing Training Included.</li>
                                            <li>Learn Software Testing and Automation basics from a professional trainer from your own desk.</li>
                                            <li>Information packed practical training starting from basics to advanced testing techniques.</li>
                                            <li>Best suitable for beginners to advanced level users and who learn faster when demonstrated.</li>
                                            <li>Course content designed by considering current software testing technology and the job market.</li>
                                            <li>Practical assignments at the end of every session.</li>
                                            <li>Practical learning experience with live project work and examples.cv</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="m-b30" id="curriculum">
                                <h4>Curriculum</h4>
                                <ul class="curriculum-list">
                                    <c:forEach var="lessonList" items="${lessonList}">                                       
                                        <li class="curriculum-list-box">
                                            <div >
                                                <span>Lesson ${lessonList.orderNumber}.</span> ${lessonList.title}

                                            </div>
                                            <span>${lessonList.duration} minutes</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- contact area END -->

    </div>
    <!-- Content END-->
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
    <button class="back-to-top fa fa-chevron-up" ></button>
</div>
<!-- External JavaScripts -->
<script src="assets/js/jquery.min.js"></script>
<script src="assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
<script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="assets/vendors/counter/waypoints-min.js"></script>
<script src="assets/vendors/counter/counterup.min.js"></script>
<script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
<script src="assets/vendors/masonry/masonry.js"></script>
<script src="assets/vendors/masonry/filter.js"></script>
<script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src="assets/js/jquery.scroller.js"></script>
<script src="assets/js/functions.js"></script>
<script src="assets/js/contact.js"></script>
<script src="assets/vendors/switcher/switcher.js"></script>
</body>

</html>
