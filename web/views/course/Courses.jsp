<%-- 
    Document   : Courses
    Created on : Feb 15, 2025, 11:13:43 AM
    Author     : ASUS
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="language" value="${not empty sessionScope.language ? sessionScope.language : ''}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="text" />
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>Our Course</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <%@include file="/common/header.jsp" %>
    </head>

    <body data-spy="scroll" data-target=".site-navbar-target" data-offset="300">

        <div class="site-wrap">

            <%@include file="/common/header.jsp" %>

            <div class="site-section ftco-subscribe-1 site-blocks-cover pb-4" style="background-image: url('images/bg_1.jpg')">
                <div class="container">
                    <div class="row align-items-end">
                        <div class="col-lg-7">
                            <h2 class="mb-0"><fmt:message key="course.Courses" /></h2>
                            <p><fmt:message key="course.Message" /></p>
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
            </div>

            <div class="site-section">
                <div class="container">
                    <div class="row">
                        <c:forEach items="${listcourse}" var="c">
                            <div class="col-lg-4 col-md-6 mb-4">
                                <div class="course-1-item">
                                    <figure class="thumnail">
                                        <a href="${pageContext.request.contextPath}/course/${c.slug}"><img src="${c.image}" alt="Image" class="img-fluid"></a>
                                        <div class="price"><fmt:formatNumber value = "${c.price}"/></div>
                                        <div class="category"><h3>${mapcategory.get(c.category).name}</h3></div>  
                                    </figure>
                                    <div class="course-1-content pb-4">
                                        <h2>${c.name}</h2>
                                        <p class="desc mb-4">${c.description}</p>
                                        <p><a href="${pageContext.request.contextPath}/course/${c.slug}" class="btn btn-primary rounded-0 px-4"><fmt:message key="button.Details" /></a></p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <%@include file="/common/footer.jsp" %>

        </div>
        <!-- .site-wrap -->

        <!-- loader -->
        <div id="loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#51be78"/></svg></div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
        <script src="${pageContext.request.contextPath}/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap-datepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/js/aos.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.fancybox.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.sticky.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.mb.YTPlayer.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>

    </body>

</html>
