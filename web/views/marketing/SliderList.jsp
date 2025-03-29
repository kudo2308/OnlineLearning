<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
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
        <title>Slider List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sliderListStyle.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>
            <hr style="color: #dddddd">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Slider Page</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                <li>Slider List</li>
            </ul>
        </div>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar (nếu có) -->
                <nav class="col-md-2 d-none d-md-block bg-light sidebar">
                    <!-- Nội dung sidebar -->
                </nav>

                <!-- Nội dung chính -->
                <main class="col-md-10 ms-sm-auto px-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Slider Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <a href="${pageContext.request.contextPath}/slider?action=add" class="btn btn-primary">
                                <i class="fas fa-plus-circle me-1"></i>Add new slider
                            </a>
                        </div>
                    </div>

                    <div class="table-container">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Title</th>
                                    <th>Link</th>
                                    <th>Status</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="slider" items="${sliders}">
                                    <tr>
                                        <td>${slider.sliderId}</td>
                                        <td style="width: 100px; height: 50px; ">
                                            <img src="${pageContext.request.contextPath}${slider.imageUrl}" 
                                                 alt="${slider.title}" class="img-thumbnail">
                                        </td>
                                        <td>${slider.title}</td>
                                        <td>
                                            <a href="${slider.linkUrl}" target="_blank" class="text-primary">
                                                <i class="fas fa-external-link-alt me-1"></i>View link
                                            </a>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${slider.status == 1}">
                                                    <span class="status-active">
                                                        <i class="fasme-1"></i>Active
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-inactive">
                                                        <i class="fasme-1"></i>Inactive
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${slider.description}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/slider?action=edit&id=${slider.sliderId}" 
                                                   class="btn btn-sm btn-warning" 
                                                   title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button onclick="confirmDelete(${slider.sliderId})" 
                                                        class="btn btn-sm btn-danger" 
                                                        title="Delete">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS và Popper.js -->

    </body>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    <script>
                                                    function confirmDelete(sliderId) {
                                                        if (confirm('Bạn có chắc chắn muốn xóa slider này?')) {
                                                            // Debug URL để kiểm tra giá trị 'id'
                                                            console.log('${pageContext.request.contextPath}/slider?action=delete&id=' + sliderId);
                                                            window.location.href = '${pageContext.request.contextPath}/slider?action=delete&id=' + sliderId;
                                                        }
                                                    }

    </script>
</html>