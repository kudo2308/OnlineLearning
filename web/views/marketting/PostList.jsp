<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from educhamp.themetrades.com/demo/admin/add-lesson.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 22 Feb 2019 13:10:19 GMT -->
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
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>My Blog</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/PostListStyle.css" />
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

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
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/pagination.css">

        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

            <!--Main container start -->
            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Dashboard</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                            <li>User List</li>
                        </ul>
                    </div>	

                    <div class="main-container">

                        <div class="container-right">
                        <c:if test="${not empty message}">
                            <div class="alert2 alert-success" id="alert-box">
                                <c:choose>
                                    <c:when test="${message eq 'deleted'}">Blog đã được xóa thành công!</c:when>
                                    <c:when test="${message eq 'updated'}">Blog đã được cập nhật thành công!</c:when>
                                </c:choose>
                                <button class="close-btn" onclick="closeAlert()">×</button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert2 alert-danger" id="alert-box">
                                <c:choose>
                                    <c:when test="${error eq 'deleteFailed'}">Không thể xóa blog, thử lại sau!</c:when>
                                    <c:when test="${error eq 'missingBlogId'}">Không tìm thấy blog ID!</c:when>
                                    <c:when test="${error eq 'invalidAction'}">Hành động không hợp lệ!</c:when>
                                    <c:when test="${error eq 'missingTitle'}">Tiêu đề không được để trống!</c:when>
                                    <c:when test="${error eq 'missingContent'}">Nội dung không được để trống!</c:when>
                                </c:choose>
                                <button class="close-btn" onclick="closeAlert()">×</button>
                            </div>
                        </c:if>


                        <form id="filter-form" action="myblog" method="get">
                            <select name="categoryId" class="form-control2" onchange="document.getElementById('filter-form').submit();">
                                <option value="0" ${selectedCategory == 0 ? 'selected' : ''}>All Categories</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}" ${selectedCategory == category.categoryID ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="filter-search">
                                <div class="input-group">
                                    <input name="search" type="text" class="form-control" placeholder="Search blogs" value="${searchKeyword}">
                                </div>
                            </div>
                        </form>

                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Image</th>
                                        <th>Title</th>
                                        <th>Author</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th>Published Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${not empty blogs}">
                                        <c:forEach var="blog" items="${blogs}">
                                            <tr>
                                                <td>${blog.blogId}</td>
                                                <td><img src="${pageContext.request.contextPath}${blog.imgUrl}" height="30" width="50"></td>
                                                <td>${blog.title}</td>
                                                <td>${blog.author.fullName}</td>
                                                <td>${blog.category.name}</td>
                                                <td>${blog.status}</td>
                                                <td>${blog.createAt}</td>
                                                <td class="action-buttons">
                                                    <form action="${pageContext.request.contextPath}/postList" method="POST">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="blogId" value="${blog.blogId}">
                                                        <button class="delete-btn" onclick="return confirm('Are you sure?')">
                                                            <span class="material-symbols-outlined">delete</span>
                                                        </button>
                                                    </form>

                                                    <button onclick="showEditForm('${blog.blogId}', '${blog.title}', '${blog.content}', '${blog.imgUrl}', '${blog.categoryID}', '${blog.status}')">
                                                        <span class="material-symbols-outlined">edit</span>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty blogs}">
                                        <tr><td colspan="8">No blogs found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>

                        </div>
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
                    </div>
                </div>

                <div id="editForm" class="modal" style="display: none;">
                    <div class="container-post-blog">
                        <span class="close" onclick="closeEditForm()">&times;</span>
                        <h2>Edit Blog</h2>
                        <form action="postList" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" id="editBlogId" name="blogId">  <!-- Hidden field for blogId -->

                            <label>Title:</label>
                            <input type="text" id="editTitle" name="title" required>

                            <label>Content:</label>
                            <textarea id="editContent" name="content" required></textarea>

                            <label>Image:</label>
                            <input type="file" id="editImageUrl" name="imageUrl" onchange="previewImage(event)">
                            <img id="imagePreview" src="#" style="display: none; max-width: 100px; margin-top: 10px;">


                            <label>Category:</label>
                            <select class="editCategoryId" name="categoryId" id="editCategoryId">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}">${category.name}</option>
                                </c:forEach>
                            </select>

                            <label>Status:</label>
                            <select class="editStatus" name="status" id="editStatus">
                                <option value="Public">Public</option>
                                <option value="Private">Private</option>
                            </select>

                            <button class="submit-but" type="submit">Update</button>
                        </form>
                    </div>
                </div>
            </div>

        </main>
        <div class="ttr-overlay"></div>      
    </body>
    <script src="assets/admin/assets/js/jquery.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="assets/admin/assets/vendors/counter/waypoints-min.js"></script>
    <script src="assets/admin/assets/vendors/counter/counterup.min.js"></script>
    <script src="assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="assets/admin/assets/vendors/masonry/masonry.js"></script>
    <script src="assets/admin/assets/vendors/masonry/filter.js"></script>
    <script src="assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
    <script src="assets/admin/assets/js/functions.js"></script>
    <script src="assets/admin/assets/js/admin.js"></script>    <script src="https://cdnjs.cloudflare.com/ajax/libs/timeago.js/4.0.2/timeago.min.js"></script>
    <script>
                                function showEditForm(blogId, title, content, imageUrl, categoryId, status) {
                                    const modal = document.getElementById("editForm");
                                    modal.style.display = "flex"; // Hiển thị modal khi bấm edit

                                    // Gán giá trị vào các trường trong form
                                    document.getElementById("editBlogId").value = blogId;
                                    document.getElementById("editTitle").value = title;
                                    document.getElementById("editContent").value = content;
                                    document.getElementById("editCategoryId").value = categoryId;
                                    document.getElementById("editStatus").value = status;

                                    // Hiển thị ảnh cũ
                                    const imagePreview = document.getElementById("imagePreview");
                                    if (imageUrl && imageUrl.trim() !== "") {
                                        imagePreview.src = `${imageUrl}`;
                                        imagePreview.style.display = "block"; // Hiển thị ảnh
                                    } else {
                                        imagePreview.style.display = "none"; // Nếu không có ảnh cũ, ẩn preview
                                    }
                                }


                                function closeEditForm() {
                                    document.getElementById("editForm").style.display = "none"; // Ẩn modal khi đóng
                                }

// Đóng modal khi nhấn vào vùng bên ngoài modal
                                window.onclick = function (event) {
                                    const modal = document.getElementById("editForm");
                                    if (event.target === modal) {
                                        modal.style.display = "none";
                                    }
                                }

                                function previewImage(event) {
                                    const image = document.getElementById("imagePreview");
                                    image.src = URL.createObjectURL(event.target.files[0]);
                                    image.style.display = "block"; // Hiển thị ảnh khi người dùng tải ảnh mới lên
                                }
                                // Ẩn thông báo sau 5 giây
                                setTimeout(() => {
                                    const alertBox = document.getElementById("alert-box");
                                    if (alertBox) {
                                        alertBox.classList.add("hide-alert");
                                        setTimeout(() => alertBox.style.display = "none", 500);
                                    }
                                }, 5000);

// Ẩn thông báo khi nhấn nút đóng
                                function closeAlert() {
                                    const alertBox = document.getElementById("alert-box");
                                    alertBox.classList.add("hide-alert");
                                    setTimeout(() => alertBox.style.display = "none", 500);
                                }


    </script>
</html>
