<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <!-- REVOLUTION SLIDER END -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

        <!-- REVOLUTION SLIDER CSS ============================================= -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />


        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/layers.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/navigation.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homestyle.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning</title>
    </head>
    <body>
        <jsp:include page="../common/header.jsp"></jsp:include>

            <div id="nav-categories">
            <c:if test="${not empty categories}">
                <c:forEach var="category" items="${categories}">
                    <a href="${pageContext.request.contextPath}/CourseSearch?categoryId=${category.categoryID}">${category.name}</a>
                </c:forEach>
            </c:if>
        </div>

        <main>

            <div class="body-slide">
                <div class="slide-show">
                    <div class="list-images">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner1.jpg" alt="Banner 1">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner2.jpg" alt="Banner 2">
                        <img class="img-banners" src="${pageContext.request.contextPath}/assets/images/banner/banner3.jpg" alt="Banner 3">
                    </div>
                    <div class="btns">
                        <span class="btn-left btn material-icons md-36">
                            keyboard_arrow_left
                        </span>
                        <span class="btn-right btn material-icons md-36">
                            keyboard_arrow_right
                        </span>
                    </div>
                </div>
            </div>

            <div class="product-list">
                <span
                    class="material-symbols-outlined arrow-left"
                    onclick="scrollb('wow', 'left')">
                    arrow_back
                </span>
                <span
                    class="material-symbols-outlined arrow-right"
                    onclick="scrollb('wow', 'right')">
                    arrow_forward
                </span>
                <div class="view-more">
                    <h1>Recent Course</h1>
                    <a href="${pageContext.request.contextPath}/CourseSearch" class="btn-see-more">See More</a>
                </div>
                <ul id="wow">
                    <c:if test="${not empty recentCourses}">
                        <c:forEach var="recentCourses" items="${recentCourses}">
                            <li>
                                <a href="${pageContext.request.contextPath}/coursedetail?courseId=${recentCourses.courseID}"><img
                                        class="image-product"
                                        src="${pageContext.request.contextPath}${recentCourses.imageUrl}"  alt="${recentCourses.title}"></a>
                                <a style="color: black; text-decoration: none" href="${pageContext.request.contextPath}/coursedetail?courseId=${recentCourses.courseID}">
                                    ${recentCourses.title}
                                </a>
                                <br>
                                <a href="#" class="expert-name">${recentCourses.expert.fullName}</a>
                                <p class="des-course">${recentCourses.description}$</p>
                                <span>${recentCourses.price}đ <del>190,000đ</del> (${recentCourses.register})</span>

                            </li>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty recentCourses}">
                        <li>There are currently no courses available.</li>
                        </c:if>
                </ul>
            </div>

            <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/background/bg1.jpg);">
                <div class="overlay"></div> <!-- Lớp phủ màu tối -->
                <div class="container">
                    <div class="page-banner-entry">
                        <h1 class="text-white">Blog Classic</h1>
                    </div>
                </div>
            </div>
            <!-- Recent News -->
            <div class="section-area section-sp2">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12 heading-bx left">
                            <h2 class="title-head">Recent <span>News</span></h2>
                            <p>It is a long established fact that a reader will be distracted by the readable content of a page</p>
                        </div>
                    </div>

                    <!-- Swiper Container -->
                    <div class="swiper blog-slider">
                        <div class="swiper-wrapper">
                            <c:if test="${not empty blogs}">
                                <c:forEach var="blog" items="${blogs}">
                                    <div class="swiper-slide">
                                        <div class="post action-card">
                                            <div class="recent-news">
                                                <div class="action-box">
                                                    <a href="${pageContext.request.contextPath}/BlogDetail?blogId=${blog.blogId}"><img src="${pageContext.request.contextPath}${blog.imgUrl}" alt=""></a>
                                                </div>
                                                <div class="info-bx">
                                                    <ul class="media-post">
                                                        <li><a href="#"><i class="fa fa-calendar"></i>${blog.createAt}</a></li>
                                                        <li><a href="#"><i class="fa fa-user"></i>${blog.author.fullName}</a></li>
                                                    </ul>
                                                    <h5 class="post-title">
                                                        <a href="${pageContext.request.contextPath}/BlogDetail?blogId=${blog.blogId}">
                                                            ${blog.title}
                                                        </a>
                                                    </h5>
                                                    <p class="truncate-text">${blog.content}</p>
                                                    <div class="post-extra">
                                                        <a href="${pageContext.request.contextPath}/BlogDetail?blogId=${blog.blogId}" class="btn-link">READ MORE</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>

                        <!-- Swiper Navigation Buttons -->
                        <div class="swiper-button-next"></div>
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-pagination"></div>
                    </div>

                </div>
            </div>
            <!-- Recent News End -->
        </main>
        <script src="${pageContext.request.contextPath}/assets/js/js.js"></script>
        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

        <script>
                        var swiper = new Swiper('.blog-slider', {
                            slidesPerView: 3, // Hiển thị 3 blog cùng lúc trên desktop
                            spaceBetween: 20, // Khoảng cách giữa các blog
                            loop: true, // Lặp vô hạn
                            navigation: {
                                nextEl: '.swiper-button-next',
                                prevEl: '.swiper-button-prev',
                            },
                            pagination: {
                                el: '.swiper-pagination',
                                clickable: true,
                            },
                            breakpoints: {
                                1024: {slidesPerView: 3}, // Desktop
                                768: {slidesPerView: 2}, // Tablet
                                480: {slidesPerView: 1}   // Mobile
                            }
                        });
        </script>

    </body>
</html>
