<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Blog</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/MyBlogStyle.css" />

    </head>
    <body>
        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="main-container">
                <div class="container-sidebar">
                    <aside class="sidebar">
                        <div class="profile-card">
                            <img src="${pageContext.request.contextPath}${account.image}" alt="User Avatar" class="profile-pic">
                        <h3>${account.fullName}</h3>
                        <p>${account.email}</p>
                        <div class="social-icons">
                            <a href="#"><i class="fab fa-facebook"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin"></i></a>
                            <a href="#"><i class="fab fa-google"></i></a>
                        </div>
                    </div>
                </aside>
            </div>

            <div class="container">
                <form id="filter-form" action="Blog" method="get">
                    <select name="categoryId" class="form-control" onchange="document.getElementById('filter-form').submit();">
                        <option value="0" ${selectedCategory == 0 ? 'selected' : ''}>All Categories</option>
                        <c:forEach var="category" items="${category}">
                            <option value="${category.categoryID}" ${selectedCategory == category.categoryID ? 'selected' : ''}>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                    <div class="filter-search">
                        <div class="input-group">
                            <input name="search" type="text" required class="form-control" placeholder="Search blogs">
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
                            <c:forEach var="blog" items="${blogList}">
                                <tr>
                                    <td>${blog.blogId}</td>
                                    <td><img src="${pageContext.request.contextPath}${blog.imgUrl}" width="50"></td>
                                    <td>${blog.title}</td>
                                    <td>${blog.author.fullName}</td>
                                    <td>${blog.category.name}</td>
                                    <td>${blog.status}</td>
                                    <td>${blog.createAt}</td>
                                    <td class="action-buttons">
                                        <form action="${pageContext.request.contextPath}/myblog" method="POST">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="blogId" value="${blog.blogId}">
                                            <button class="delete-btn" onclick="return confirm('Are you sure?')">Delete</button>
                                        </form>

                                        <button onclick="showEditForm('${blog.blogId}', '${blog.title}', '${blog.content}', '${blog.imgUrl}', '${blog.categoryID}', '${blog.status}')">Edit</button>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Form chỉnh sửa blog (ẩn mặc định) -->
        <div id="editForm" class="modal" style="display: none;">
            <div class="container-post-blog">
                <span class="close" onclick="closeEditForm()">&times;</span>
                <h2>Edit Blog</h2>
                <form action="myblog?action=update?blogId=${category.blogId}" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editBlogId" name="blogId">

                    <label>Title:</label>
                    <input type="text" id="editTitle" name="title" required>

                    <label>Content:</label>
                    <textarea id="editContent" name="content" required></textarea>

                    <label>Image:</label>
                    <input type="file" id="editImageUrl" name="imageUrl" onchange="previewImage(event)">
                    <img id="imagePreview" src="#" style="display: none; max-width: 100px; margin-top: 10px;">

                    <label>Category:</label>
                    <select class="editCategoryId" name="categoryId">
                        <c:forEach var="category" items="${category}">
                            <option value="${category.categoryID}">${category.name}</option>
                        </c:forEach>
                    </select>

                    <label>Status:</label>
                    <select class="editCategoryId" name="status">
                        <option value="public">Public</option>
                        <option value="private">Private</option>
                    </select>

                    <button class="submit-but" type="submit">Update</button>
                </form>
            </div>
        </div>
    </body>
    <script>
        function showEditForm(blogId, title, content, imageUrl, categoryId, status) {
            const modal = document.getElementById("editForm");
            modal.style.display = "flex";
            document.getElementById("editBlogId").value = blogId;
            document.getElementById("editTitle").value = title;
            document.getElementById("editContent").value = content;
            document.getElementById("editCategoryId").value = categoryId;
            document.getElementById("editStatus").value = status;
        }

        function closeEditForm() {
            document.getElementById("editForm").style.display = "none";
        }

        // Đóng form khi ấn vào khoảng trống bên ngoài
        window.onclick = function (event) {
            const modal = document.getElementById("editForm");
            if (event.target === modal) {
                modal.style.display = "none";
            }
        }

        function previewImage(event) {
            const image = document.getElementById("imagePreview");
            image.src = URL.createObjectURL(event.target.files[0]);
            image.style.display = "block";
        }
    </script>
</html>
