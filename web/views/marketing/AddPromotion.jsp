<%-- 
    Document   : addPromotion
    Created on : Mar 27, 2025, 10:24:35 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
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
        <title>New Promotion</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">

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
            .filter-section {
                display: none;
                margin-top: 15px;
                padding: 15px;
                background: #f9f9f9;
                border-radius: 4px;
                border-left: 4px solid #4CAF50;
            }
            
            .checkbox-container {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            
            .checkbox-container input[type="checkbox"] {
                margin-right: 8px;
                width: 18px;
                height: 18px;
            }
            
            .notification {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
                font-weight: bold;
                text-align: center;
            }
            
            .success {
                background-color: #dff0d8;
                color: #3c763d;
                border: 1px solid #d6e9c6;
            }
            
            .error {
                background-color: #f2dede;
                color: #a94442;
                border: 1px solid #ebccd1;
            }
        </style>
    </head>

    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <!-- Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">New Promotion</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>New Promotion</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>New Promotion</h4>
                            </div>
                            
                            <c:if test="${not empty message}">
                                <div class="notification ${messageType}">${message}</div>
                            </c:if>
                            
                            <div class="widget-inner">
                                <form class="edit-profile m-b30" action="${pageContext.request.contextPath}/promotion" method="post">
                                    <input type="hidden" name="action" value="create">
                                    
                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Promotion Code:</label>
                                        <div class="col-sm-7">
                                            <input type="text" id="promotionCode" name="promotionCode" required 
                                                   placeholder="Enter promotion (for example: SUMMER2025)" class="form-control">
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Discount Type:</label>
                                        <div class="col-sm-7">
                                            <select id="discountType" name="discountType" required class="form-control">
                                                <option value="percentage">Percent(%)</option>
                                                <option value="fixed">Fixed price(VNĐ)</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Discount Value:</label>
                                        <div class="col-sm-7">
                                            <input type="number" id="discountValue" name="discountValue" min="0" required
                                                   placeholder="Value price" class="form-control">
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Apply for:</label>
                                        <div class="col-sm-7">
                                            <select id="applyTo" name="applyTo" onchange="showFilterOptions(this.value)" class="form-control">
                                                <option value="all">All Course</option>
                                                <option value="category">Category</option>
                                                <option value="expert">Expert</option>
                                                <option value="course">Course</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div id="categoryFilter" class="filter-section">
                                        <div class="form-group row">
                                            <label class="col-sm-2 col-form-label">Choose category:</label>
                                            <div class="col-sm-7">
                                                <select id="categoryID" name="categoryID" class="form-control">
                                                    <c:forEach var="category" items="${categories}">
                                                        <option value="${category.categoryID}">${category.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="expertFilter" class="filter-section">
                                        <div class="form-group row">
                                            <label class="col-sm-2 col-form-label">Choose expert:</label>
                                            <div class="col-sm-7">
                                                <select id="expertID" name="expertID" class="form-control">
                                                    <c:forEach var="expert" items="${experts}">
                                                        <option value="${expert.userID}">${expert.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="courseFilter" class="filter-section">
                                        <div class="form-group row">
                                            <label class="col-sm-2 col-form-label">Choose course:</label>
                                            <div class="col-sm-7">
                                                <select id="courseID" name="courseID" class="form-control">
                                                    <c:forEach var="course" items="${courses}">
                                                        <option value="${course.courseID}">${course.title}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <div class="col-sm-2"></div>
                                        <div class="col-sm-7">
                                            <div class="checkbox-container">
                                                <input type="checkbox" id="showDiscountedPrice" name="showDiscountedPrice" checked>
                                                <label for="showDiscountedPrice">Show discout price on the course</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <div class="col-sm-2"></div>
                                        <div class="col-sm-7">
                                            <button type="submit" class="btn btn-primary">Create</button>
                                        </div>
                                    </div>
                                </form>
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
            function showFilterOptions(value) {
                // Ẩn tất cả các section filter
                document.getElementById('categoryFilter').style.display = 'none';
                document.getElementById('expertFilter').style.display = 'none';
                document.getElementById('courseFilter').style.display = 'none';

                // Hiển thị section filter tương ứng
                if (value === 'category') {
                    document.getElementById('categoryFilter').style.display = 'block';
                } else if (value === 'expert') {
                    document.getElementById('expertFilter').style.display = 'block';
                } else if (value === 'course') {
                    document.getElementById('courseFilter').style.display = 'block';
                }
            }

            // Khởi tạo hiển thị mặc định
            window.onload = function () {
                const applyTo = document.getElementById('applyTo').value;
                showFilterOptions(applyTo);
            };
        </script>
    </body>
</html>