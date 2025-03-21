<%-- 
    Document   : OurCourse
    Created on : Jan 24, 2025, 11:24:02 PM
    Author     : dohie
--%>

<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="language" value="${not empty sessionScope.language ? sessionScope.language : ''}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="text" />
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>Courses</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">


        <link href="https://fonts.googleapis.com/css?family=Muli:300,400,700,900" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery.fancybox.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/aos.css">
        <link href="${pageContext.request.contextPath}/assets/css/jquery.mb.YTPlayer.min.css" media="all" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style_2.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    </head>

    <body data-spy="scroll" data-target=".site-navbar-target" data-offset="300">

        <div class="site-wrap">

            <%@include file="/common/header.jsp" %>

            <div class="site-section ftco-subscribe-1 site-blocks-cover pb-4" >
                <div class="container">
                    <div class="row align-items-end">
                        <div class="col-lg-7">
                            <h2 class="mb-0"><fmt:message key="header.course" /></h2>
                        </div>
                    </div>
                </div>
            </div>


            <div class="custom-breadcrumns border-bottom">
                <div class="container">
                    <a href="${pageContext.request.contextPath}/home"><fmt:message key="header.Home" /></a>
                    <span class="mx-3 icon-keyboard_arrow_right"></span>
                    <span class="current"><fmt:message key="header.course" /></span>
                </div>
                <div class="ml-auto" style="margin-bottom: 20px; text-align: right;">
                    <div class="social-wrap" style="position: relative; right: 10px;">
                        <a href="#" class="d-inline-block d-lg-none site-menu-toggle js-menu-toggle text-black"><span
                                class="icon-menu h3"></span></a>
                    </div>
                </div>
            </div>

            <div class="site-section">

                <div class="container">
                    <div class="row" >
                        <div class="col-lg-3 d-lg-block d-none course-category">
                            <div class="category">
                                <div style="background-color: #51be78; color: white; padding: 5px;">
                                    <fmt:message key="course.Category" />
                                </div>
                                <ul>
                                    <a href="${pageContext.request.contextPath}/course/category/top-course"><li><fmt:message key="course.top" /></li></a>
                                    <a href="${pageContext.request.contextPath}/course/category/fee-course"><li><fmt:message key="course.fee" /></li></a>
                                    <a href="${pageContext.request.contextPath}/course/category/free-course"><li><fmt:message key="course.free" /></li></a>
                                </ul>
                            </div>

                            <div class="course-group">
                                <div style="background-color: #51be78; color: white; padding: 5px; margin-top: 100px;">
                                    <fmt:message key="course.CoursesCategories" />
                                </div>
                                <ul>
                                    <c:forEach items="${listallcategory}" var="lac">
                                        <c:if test="${language=='vi_VN'}">
                                            <a href="${pageContext.request.contextPath}/course/category/${lac.slug}"><li>${lac.name_vn}</li></a> 
                                                </c:if>
                                                <c:if test="${language!='vi_VN'}">
                                            <a href="${pageContext.request.contextPath}/course/category/${lac.slug}"><li>${lac.name}</li></a>
                                                </c:if>

                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-9 col-md-12">
                            <div class="container">
                                <div class="row">

                                    <c:forEach items="${listcourse}" var="lc">
                                        <div class="col-xl-4 col-lg-6 mb-4">
                                            <div class="course-1-item">
                                                <figure class="thumnail">
                                                    <a href="${pageContext.request.contextPath}/course/${lc.course.slug}"><img src="${lc.course.image}" alt="Image" class="img-fluid"></a>
                                                    <div class="price">
                                                        <fmt:formatNumber value="${lc.course.price}" type="currency" currencySymbol="₫"/>
                                                    </div>
                                                    <div class="category">
                                                        <h3>${lc.category.name}</h3>
                                                    </div>
                                                </figure>
                                                <div class="course-1-content pb-4">
                                                    <h2 style="height: 60px; overflow: hidden">${lc.course.name}</h2>
                                                    <p class="desc mb-4" style="height: 180px; overflow: hidden;">${lc.course.description}</p>
                                                    <p><a href="${pageContext.request.contextPath}/course/${lc.course.slug}" class="btn btn-primary rounded-0 px-4"><fmt:message key="button.Details" /></a></p>
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

            <%@include file="/common/footer.jsp" %>



        </div>
        <!-- .site-wrap -->

        <!-- loader -->
        <div id="loader" class="show fullscreen"><svg class="circular" width="48px" height="48px">
            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee" />
            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10"
                    stroke="#51be78" />
            </svg></div>

        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery-3.3.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery-ui.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/bootstrap-datepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/aos.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.fancybox.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.sticky.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/js/jquery.mb.YTPlayer.min.js"></script>


        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    </body>

</html>
