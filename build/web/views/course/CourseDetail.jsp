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
        <link rel="icon" href="<c:url value='/public/assets/images/favicon.ico'/>" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="<c:url value='/public/assets/images/favicon.png'/>" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Course Details | EduChamp</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

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

            <!-- Header Top ==== -->
            <jsp:include page="../common/header.jsp"/>
            <!-- header END ==== -->

            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(<c:url value='/public/assets/images/banner/banner2.jpg'/>);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">Course Details</h1>
                        </div>
                    </div>
                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="<c:url value='/home'/>">Home</a></li>
                            <li>Course Details</li>
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
                                            <c:if test="${course.originalPrice > course.price}">
                                                <del>$${course.originalPrice}</del>
                                            </c:if>
                                            <h4 class="price">$${course.price}</h4>
                                        </div>  
                                        <div class="course-buy-now text-center">
                                            <a href="#" class="btn radius-xl text-uppercase">Buy Now This Course</a>
                                        </div>
                                        <div class="teacher-bx">
                                            <div class="teacher-info">
                                                <div class="teacher-thumb">
                                                    <img src="<c:url value='/public/assets/images/testimonials/${course.instructor.image}'/>" alt=""/>
                                                </div>
                                                <div class="teacher-name">
                                                    <h5>${course.instructor.name}</h5>
                                                    <span>${course.instructor.designation}</span>
                                                </div>
                                            </div>
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
                                            <div class="price categories">
                                                <span>Categories</span>
                                                <h5 class="text-primary">${course.category}</h5>
                                            </div>
                                        </div>
                                        <div class="course-info-list scroll-page">
                                            <ul class="navbar">
                                                <li><a class="nav-link" href="#overview"><i class="ti-zip"></i>Overview</a></li>
                                                <li><a class="nav-link" href="#curriculum"><i class="ti-bookmark-alt"></i>Curriculum</a></li>
                                                <li><a class="nav-link" href="#instructor"><i class="ti-user"></i>Instructor</a></li>
                                                <li><a class="nav-link" href="#reviews"><i class="ti-comments"></i>Reviews</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-9 col-md-8 col-sm-12">
                                    <div class="courses-post">
                                        <div class="ttr-post-media media-effect">
                                            <a href="#"><img src="<c:url value='/public/assets/images/courses/${course.image}'/>" alt=""></a>
                                        </div>
                                        <div class="ttr-post-info">
                                            <div class="ttr-post-title">
                                                <h2 class="post-title">${course.title}</h2>
                                            </div>
                                            <div class="ttr-post-text">
                                                <p>${course.description}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="courese-overview" id="overview">
                                        <h4>Overview</h4>
                                        <div class="row">
                                            <div class="col-md-12 col-lg-4">
                                                <ul class="course-features">
                                                    <li><i class="ti-book"></i> <span class="label">Lectures</span> <span class="value">${course.lectureCount}</span></li>
                                                    <li><i class="ti-help-alt"></i> <span class="label">Quizzes</span> <span class="value">${course.quizCount}</span></li>
                                                    <li><i class="ti-time"></i> <span class="label">Duration</span> <span class="value">${course.duration}</span></li>
                                                    <li><i class="ti-stats-up"></i> <span class="label">Skill level</span> <span class="value">${course.skillLevel}</span></li>
                                                    <li><i class="ti-smallcap"></i> <span class="label">Language</span> <span class="value">${course.language}</span></li>
                                                    <li><i class="ti-user"></i> <span class="label">Students</span> <span class="value">${course.studentCount}</span></li>
                                                    <li><i class="ti-check-box"></i> <span class="label">Assessments</span> <span class="value">${course.hasAssessments ? 'Yes' : 'No'}</span></li>
                                                </ul>
                                            </div>
                                            <div class="col-md-12 col-lg-8">
                                                <h5 class="m-b5">Course Description</h5>
                                                <p>${course.fullDescription}</p>
                                                <h5 class="m-b5">Certification</h5>
                                                <p>${course.certification}</p>
                                                <h5 class="m-b5">Learning Outcomes</h5>
                                                <ul class="list-checked primary">
                                                    <c:forEach items="${course.learningOutcomes}" var="outcome">
                                                        <li>${outcome}</li>
                                                        </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="" id="curriculum">
                                        <h4>Curriculum</h4>
                                        <div class="accordion" id="courseModules">
                                            <c:forEach items="${course.modules}" var="module" varStatus="moduleStatus">
                                                <div class="card">
                                                    <div class="card-header" id="heading${moduleStatus.index}">
                                                        <h5 class="mb-0">
                                                            <button class="btn btn-link" type="button" data-toggle="collapse" 
                                                                    data-target="#collapse${moduleStatus.index}" 
                                                                    aria-expanded="${moduleStatus.first ? 'true' : 'false'}" 
                                                                    aria-controls="collapse${moduleStatus.index}">
                                                                ${module.title}
                                                            </button>
                                                        </h5>
                                                    </div>
                                                    <div id="collapse${moduleStatus.index}" 
                                                         class="collapse ${moduleStatus.first ? 'show' : ''}" 
                                                         aria-labelledby="heading${moduleStatus.index}" 
                                                         data-parent="#courseModules">
                                                        <div class="card-body">
                                                            <ul class="curriculum-list">
                                                                <c:forEach items="${module.lessons}" var="lesson">
                                                                    <li>
                                                                        <div class="curriculum-list-box">
                                                                            <span><i class="fa ${lesson.type eq 'video' ? 'fa-play' : 'fa-file'}"></i></span>
                                                                            <p>${lesson.title}</p>
                                                                            <span>${lesson.duration}</span>
                                                                        </div>
                                                                    </li>
                                                                </c:forEach>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="" id="instructor">
                                        <h4>Instructor</h4>
                                        <c:forEach items="${course.instructors}" var="instructor">
                                            <div class="instructor-bx">
                                                <div class="instructor-author">
                                                    <img src="<c:url value='/public/assets/images/testimonials/${instructor.image}'/>" alt="">
                                                </div>
                                                <div class="instructor-info">
                                                    <h6>${instructor.name}</h6>
                                                    <span>${instructor.designation}</span>
                                                    <ul class="list-inline m-tb10">
                                                        <li><a href="${instructor.facebook}" class="btn sharp-sm facebook"><i class="fa fa-facebook"></i></a></li>
                                                        <li><a href="${instructor.twitter}" class="btn sharp-sm twitter"><i class="fa fa-twitter"></i></a></li>
                                                        <li><a href="${instructor.linkedin}" class="btn sharp-sm linkedin"><i class="fa fa-linkedin"></i></a></li>
                                                        <li><a href="${instructor.googlePlus}" class="btn sharp-sm google-plus"><i class="fa fa-google-plus"></i></a></li>
                                                    </ul>
                                                    <p class="m-b0">${instructor.description}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div class="" id="reviews">
                                        <h4>Reviews</h4>
                                        <div class="review-bx">
                                            <div class="all-review">
                                                <h2 class="rating-type">${course.averageRating}</h2>
                                                <ul class="cours-star">
                                                    <c:forEach begin="1" end="${course.averageRating}" var="i">
                                                        <li class="active"><i class="fa fa-star"></i></li>
                                                        </c:forEach>
                                                        <c:forEach begin="${course.averageRating + 1}" end="5" var="i">
                                                        <li><i class="fa fa-star"></i></li>
                                                        </c:forEach>
                                                </ul>
                                                <span>${course.reviewCount} Rating</span>
                                            </div>
                                            <div class="review-bar">
                                                <c:forEach items="${course.ratingDistribution}" var="rating">
                                                    <div class="bar-bx">
                                                        <div class="side">
                                                            <div>${rating.stars} star</div>
                                                        </div>
                                                        <div class="middle">
                                                            <div class="bar-container">
                                                                <div class="bar-5" style="width:${rating.percentage}%;"></div>
                                                            </div>
                                                        </div>
                                                        <div class="side right">
                                                            <div>${rating.count}</div>
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
                </div>
            </div>
            <!-- Content END-->

            <!-- Footer ==== -->
            <jsp:include page="../common/footer.jsp"/>
            <!-- Footer END ==== -->

            <button class="back-to-top fa fa-chevron-up"></button>
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
        <script src="<c:url value='/public/assets/js/jquery.scroller.js'/>"></script>
        <script src="<c:url value='/public/assets/js/functions.js'/>"></script>
        <script src="<c:url value='/public/assets/js/contact.js'/>"></script>
        <script src="<c:url value='/public/assets/vendors/switcher/switcher.js'/>"></script>
    </body>
</html>
