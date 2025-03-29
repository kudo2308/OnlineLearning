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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Slider Management</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/pagination.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/marketing.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <!-- Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Slider Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Slider List</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box card-marketing">
                            <div class="wc-title d-flex justify-content-between align-items-center">
                                <h4>Slider List</h4>
                                <a href="${pageContext.request.contextPath}/slider?action=add" class="btn btn-marketing-primary">
                                    <i class="fa fa-plus-circle me-1"></i>Add new slider
                                </a>
                            </div>
                            
                            <div class="widget-inner marketing-container">
                                <c:if test="${not empty message}">
                                    <div class="notification success">
                                        ${message}
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty error}">
                                    <div class="notification error">
                                        ${error}
                                    </div>
                                </c:if>
                                
                                <!-- Filter section -->
                                <div class="filter-section mb-4">
                                    <form action="${pageContext.request.contextPath}/slider" method="get" class="row g-3 align-items-center">
                                        <input type="hidden" name="action" value="list">
                                        <div class="col-md-4">
                                            <div class="form-group mb-0">
                                                <label for="searchTitle" class="visually-hidden">Title</label>
                                                <input type="text" class="form-control" id="searchTitle" name="searchTitle" placeholder="Search by title" value="${param.searchTitle}">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group mb-0">
                                                <label for="status" class="visually-hidden">Status</label>
                                                <select class="form-control" id="status" name="status">
                                                    <option value="">All Status</option>
                                                    <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-marketing-primary w-100">
                                                <i class="fa fa-search"></i> Filter
                                            </button>
                                        </div>
                                    </form>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table table-marketing">
                                        <thead>
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
                                                    <td>
                                                        <img src="${pageContext.request.contextPath}${slider.imageUrl}" 
                                                             alt="${slider.title}" class="img-thumbnail">
                                                    </td>
                                                    <td>${slider.title}</td>
                                                    <td>
                                                        <a href="${slider.linkUrl}" target="_blank" class="text-primary">
                                                            <i class="fa fa-external-link-alt me-1"></i>View link
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${slider.status == 1}">
                                                                <span class="status-active">
                                                                    <i class="fa fa-check-circle me-1"></i>Active
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-inactive">
                                                                    <i class="fa fa-times-circle me-1"></i>Inactive
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${slider.description}</td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/slider?action=edit&id=${slider.sliderId}" 
                                                               class="btn btn-sm btn-warning" 
                                                               title="Edit">
                                                                <i class="fa fa-edit"></i>
                                                            </a>
                                                            <button type="button" 
                                                                    onclick="confirmDelete('${slider.sliderId}')" 
                                                                    class="btn btn-sm btn-danger" 
                                                                    title="Delete">
                                                                <i class="fa fa-trash-alt"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
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
                                                        <a class="page-link" href="${pageContext.request.contextPath}/slider?action=list&page=${currentPage - 1}&searchTitle=${param.searchTitle}&status=${param.status}">Previous</a>
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
                                                    <a class="page-link" href="${pageContext.request.contextPath}/slider?action=list&page=${i}&searchTitle=${param.searchTitle}&status=${param.status}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/slider?action=list&page=${currentPage + 1}&searchTitle=${param.searchTitle}&status=${param.status}">Next</a>
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
            function confirmDelete(sliderId) {
                if (confirm('Bạn có chắc chắn muốn xóa slider này?')) {
                    window.location.href = '${pageContext.request.contextPath}/slider?action=delete&id=' + sliderId;
                }
            }
            
            // Auto-hide notifications after 5 seconds
            $(document).ready(function() {
                setTimeout(function() {
                    $('.notification').fadeOut('slow');
                }, 5000);
            });
        </script>
    </body>
</html>