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

                            <c:choose>
                                <c:when test="${not empty sessionScope.account}">
                                    <button id="openModal">Post</button>
                                </c:when>

                            </c:choose>
                            <c:if test="${not empty successMessage}">
                                <span class="alert alert-success">
                                    ${successMessage}
                                </span>
                            </c:if>

                            <c:if test="${not empty errorMessage}">
                                <span class="alert alert-danger">
                                    ${errorMessage}
                                </span>
                            </c:if>
                            <div id="popup" class="modal">
                                <span class="close">&times;</span>
                                <div class="container-post-blog">
                                    <h2>Add new blog</h2>

                                    <form class="add-post" action="Blog" method="POST" enctype="multipart/form-data">
                                        <!-- Tiêu đề blog -->
                                        <label for="title">Title:</label>
                                        <input type="text" id="title" name="title" placeholder="Title" required>

                                        <!-- Nội dung blog -->
                                        <label for="content">Content:</label>
                                        <textarea id="content" name="content" placeholder="Enter content" required></textarea>

                                        <!-- Chọn ảnh -->
                                        <label for="image">Image:</label>
                                        <input type="file" id="image" name="imageUrl" accept="image/*" required>

                                        <!-- Chọn danh mục -->
                                        <label for="category">Category:</label>
                                        <select id="category" name="categoryId" required>
                                            <c:forEach var="category" items="${categories}">
                                                <option value="${category.categoryID}">${category.name}</option>
                                            </c:forEach>
                                        </select>

                                        <!--Status-->
                                        <label for="Status">Status:</label>
                                        <select id="status" name="status" required>
                                            <option value="true">Public</option>
                                            <option value="false">Private</option>
                                        </select>

                                        <!-- Nút gửi -->
                                        <button class="submit-but" type="submit">Post</button>
                                    </form>
                                </div>
                            </div>
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
                                            <a href="${pageContext.request.contextPath}/BlogDetail?blogId=${blog.blogId}" class="btn-link">READ MORE</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty blogs}">
                        <li>Blog is empty</li>
                        </c:if>
                </div> <!-- Kết thúc danh sách bài viết -->

                <!-- phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
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

<!-- Footer END ==== -->
<button class="back-to-top fa fa-chevron-up"></button>
</div>
<script src="${pageContext.request.contextPath}/assets/js/pop_up.js"></script>
</body>

</html>

