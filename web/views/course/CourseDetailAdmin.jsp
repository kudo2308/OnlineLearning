

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/courseDetailStyle.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        <style>
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top: 120px;
                left: 0;
                right: 0;
                background-color: rgba(208, 22, 39, 0.8);
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }

            .success {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #00CC00;
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }
        </style>
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
                                    <del><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="đ" pattern="#,###" />đ</del>
                                    <h4 class="price"><fmt:formatNumber value="${course.discountPrice}" type="currency" currencySymbol="đ" pattern="#,###" />đ</h4>
                                </div>
  



                                <div class="teacher-bx">
                                    <a href="publicprofile?email=${course.expert.getEmail()}">
                                        <div class="teacher-info">

                                            <div class="teacher-thumb">
                                                <img src="${pageContext.request.contextPath}${course.expert.image}" alt=""/>
                                            </div>
                                            <div class="teacher-name">
                                                <h5>${course.expert.getFullName()}</h5>
                                                <span>Science Teacher</span>
                                            </div>

                                        </div>
                                    </a>
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
                                        <p>${course.description}</p>
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
                                            <li><i class="ti-user"></i> <span class="label">Register</span> <span class="value">${regisNum}</span></li>
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
                                <c:forEach var="pack" items="${packageList}">
                                    <div class="package-section">
                                        <h5>Package: ${pack.name}</h5>
                                        <ul class="curriculum-list">
                                            <c:forEach var="lesson" items="${packageLessonMap[pack]}">
                                                <li class="curriculum-list-box">
                                                    <div>
                                                        <span>Lesson: ${lesson.title}</span>
                                                    </div>
                                                    <span>${lesson.duration} minutes</span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- contact area END -->

    </div>
    <c:set var="error" value="${requestScope.error}" />
    <c:if test="${not empty error}">
        <div id="error-message" class="error-message">
            <i class="bx bxs-error"></i> ${error}
        </div>
    </c:if>
    <c:set var="success" value="${requestScope.success}" />
    <c:if test="${not empty success}">
        <div id="success" class="success">
            <i class="bx bxs-error"></i> ${success}
        </div>
    </c:if>

    <!-- Footer END ==== -->
    <button class="back-to-top fa fa-chevron-up" ></button>
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
    <script>

        function showMessage() {
            var errorMessage = document.getElementById("error-message");
            var successMessage = document.getElementById("success");

            // Hiển thị thông báo lỗi nếu có
            if (errorMessage) {
                errorMessage.style.display = "block";
                setTimeout(function () {
                    errorMessage.style.display = "none";
                }, 3000);
            }

            // Hiển thị thông báo thành công nếu có
            if (successMessage) {
                successMessage.style.display = "block";
                setTimeout(function () {
                    successMessage.style.display = "none";
                }, 3000);
            }
        }

        // Gọi hàm khi trang đã tải xong
        window.onload = function () {
            showMessage();
        };

    </script>
</body>

</html>
