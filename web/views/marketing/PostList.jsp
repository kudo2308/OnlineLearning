<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Blog List</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/pagination.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        
        <style>
            .status-active {
                background-color: #d4edda;
                color: #155724;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            
            .alert2 {
                padding: 15px;
                border-radius: 4px;
                position: relative;
                margin-bottom: 20px;
            }
            
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .close-btn {
                position: absolute;
                right: 10px;
                top: 10px;
                cursor: pointer;
                font-weight: bold;
            }
            
            .action-buttons {
                display: flex;
                gap: 5px;
            }
            
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                align-items: center;
                justify-content: center;
            }
            
            .modal-content {
                background-color: #fff;
                padding: 20px;
                border-radius: 5px;
                width: 80%;
                max-width: 500px;
            }
            
            .blog-image {
                max-width: 100px;
                max-height: 60px;
                object-fit: cover;
                border-radius: 4px;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Blog Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Blog List</li>
                    </ul>
                </div>

                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title d-flex justify-content-between">
                                <h4>Blog List</h4>
                                <a href="${pageContext.request.contextPath}/post?action=add" class="btn btn-primary">
                                    <i class="fa fa-plus-circle"></i> Add New Blog
                                </a>
                            </div>
                            
                            <div class="widget-inner">
                                <c:if test="${not empty message}">
                                    <div class="alert2 alert-success" id="alert-box">
                                        <c:choose>
                                            <c:when test="${message eq 'deleted'}">Blog deleted successfully!</c:when>
                                            <c:when test="${message eq 'updated'}">Blog updated successfully!</c:when>
                                        </c:choose>
                                        <button class="close-btn" onclick="closeAlert()">×</button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty error}">
                                    <div class="alert2 alert-danger" id="alert-box">
                                        <c:choose>
                                            <c:when test="${error eq 'updateFailed'}">Update Failed!</c:when>
                                            <c:when test="${error eq 'deleteFailed'}">Can not delete blog, please try again</c:when>
                                            <c:when test="${error eq 'missingBlogId'}">Not found blog ID</c:when>
                                            <c:when test="${error eq 'invalidAction'}">Action is invalid </c:when>
                                            <c:when test="${error eq 'missingTitle'}">Title have to filled</c:when>
                                            <c:when test="${error eq 'missingContent'}">Please fill content</c:when>
                                        </c:choose>
                                        <button class="close-btn" onclick="closeAlert()">×</button>
                                    </div>
                                </c:if>

                                <form id="filter-form" action="postList" method="get" class="mb-4">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <select name="categoryId" class="form-control" onchange="document.getElementById('filter-form').submit();">
                                                <option value="0" ${selectedCategory == 0 ? 'selected' : ''}>All Categories</option>
                                                <c:forEach var="category" items="${categories}">
                                                    <option value="${category.categoryID}" ${selectedCategory == category.categoryID ? 'selected' : ''}>
                                                        ${category.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="input-group">
                                                <input name="search" type="text" class="form-control" placeholder="Search blogs" value="${searchKeyword}">
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary" type="submit">Search</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
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
                                                        <td>
                                                            <img src="${pageContext.request.contextPath}${blog.imgUrl}" 
                                                                 alt="${blog.title}" class="blog-image">
                                                        </td>
                                                        <td>${blog.title}</td>
                                                        <td>${blog.author.fullName}</td>
                                                        <td>${blog.category.name}</td>
                                                        <td>${blog.status}</td>
                                                        <td>${blog.createAt}</td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <form action="${pageContext.request.contextPath}/postList" method="POST" style="display:inline;">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="blogId" value="${blog.blogId}">
                                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                                                        <span class="material-symbols-outlined">delete</span>
                                                                    </button>
                                                                </form>

                                                                <button class="btn btn-sm btn-warning" 
                                                                        onclick="showEditForm('${blog.blogId}', '${blog.title}', '${blog.content}', '${blog.imgUrl}', '${blog.categoryID}', '${blog.status}')">
                                                                    <span class="material-symbols-outlined">edit</span>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination if needed -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-container">
                                        <ul class="pagination">
                                            <c:choose>
                                                <c:when test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/postList?page=${currentPage - 1}&categoryId=${selectedCategory}&search=${searchKeyword}">Previous</a>
                                                    </li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item disabled">
                                                        <span class="page-link">Previous</span>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/postList?page=${i}&categoryId=${selectedCategory}&search=${searchKeyword}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/postList?page=${currentPage + 1}&categoryId=${selectedCategory}&search=${searchKeyword}">Next</a>
                                                    </li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item disabled">
                                                        <span class="page-link">Next</span>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>
                                        </ul>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- Modal for editing blog -->
        <div id="editForm" class="modal">
            <div class="modal-content">
                <h2>Edit Blog</h2>
                <form action="${pageContext.request.contextPath}/postList" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editBlogId" name="blogId">

                    <div class="form-group mb-3">
                        <label for="editTitle">Title:</label>
                        <input type="text" class="form-control" id="editTitle" name="title" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editContent">Content:</label>
                        <textarea class="form-control" id="editContent" name="content" rows="5" required></textarea>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editImage">Current Image:</label>
                        <div>
                            <img id="currentImage" src="" alt="Current Image" style="max-width: 200px; max-height: 150px; margin-bottom: 10px;">
                        </div>
                        <label for="editImage">New Image (optional):</label>
                        <input type="file" class="form-control-file" id="editImage" name="image">
                    </div>

                    <div class="form-group mb-3">
                        <label for="editCategory">Category:</label>
                        <select class="form-control" id="editCategory" name="categoryId" required>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryID}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="editStatus">Status:</label>
                        <select class="form-control" id="editStatus" name="status">
                            <option value="Published">Published</option>
                            <option value="Draft">Draft</option>
                        </select>
                    </div>

                    <div class="form-group d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" onclick="closeEditForm()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>

        <script>
            function showEditForm(blogId, title, content, imgUrl, categoryId, status) {
                const modal = document.getElementById("editForm");
                modal.style.display = "flex";
                
                // Set form values
                document.getElementById("editBlogId").value = blogId;
                document.getElementById("editTitle").value = title;
                document.getElementById("editContent").value = content;
                document.getElementById("currentImage").src = "${pageContext.request.contextPath}" + imgUrl;
                document.getElementById("editCategory").value = categoryId;
                document.getElementById("editStatus").value = status;
            }
            
            function closeEditForm() {
                document.getElementById("editForm").style.display = "none";
            }
            
            function closeAlert() {
                document.getElementById("alert-box").style.display = "none";
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                const editModal = document.getElementById("editForm");
                if (event.target === editModal) {
                    editModal.style.display = "none";
                }
            };
            
            // Auto-close alerts after 5 seconds
            setTimeout(function() {
                const alertBox = document.getElementById("alert-box");
                if (alertBox) {
                    alertBox.style.display = "none";
                }
            }, 5000);
        </script>
    </body>
</html>
