<%-- 
    Document   : listUser.jsp
    Created on : Feb 10, 2025, 12:26:29 PM
    Author     : ducba
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>EduChamp : Education HTML Template </title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->

        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>

            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Dashboard</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                            <li>User List</li>
                        </ul>
                    </div>	
                </div>
                <body class="container mt-5">

                    <div class="card shadow-sm p-4">
                        <h1 class="mb-3 text-center">Add New User</h1>

                    <form method="post" action="AddUserServlet">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${fullname}" >
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="${email}" >
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" >
                        </div>


                        <div class="mb-3">
                            <label class="form-label" style="display: block">Role</label>
                            <select name="roleID" class="form-select" style="padding: 11px; width: 250px; border: 1px solid #ccc; border-radius: 5px;">
                                <option value="" selected disabled hidden>Choose Roles</option>
                                <option value="1" ${roleID == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${roleID == 2 ? 'selected' : ''}>Expert</option>
                                <option value="3" ${roleID == 3 ? 'selected' : ''}>Student</option>
                                <option value="4" ${roleID == 4 ? 'selected' : ''}>Marketing</option>
                                <option value="5" ${roleID == 5 ? 'selected' : ''}>Saler</option>
                            </select>
                        </div>
                        <br>
                        <div class="d-flex gap-2" style="justify-content: space-around;">
                            <button type="submit" class="btn btn-primary px-4">Add User</button>
                            <a href="UserList" class="btn btn-secondary px-4">Cancel</a>
                        </div>
                    </form>
                </div>

                <c:set var="error" value="${requestScope.error}" />
                <c:if test="${not empty error}">
                    <div id="error-message" class="error-message">
                        <i class="bx bxs-error"></i> ${error}
                    </div>
                </c:if>
                <c:set var="success" value="${requestScope.success}" />
                <c:if test="${not empty success}">
                    <div id="success" class="success">
                        <i class="bx bxs-error"></i> ${success}
                    </div>
                </c:if>
        </main>
        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
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
        <script src="assets/admin/assets/js/admin.js"></script>
        <script>
            function showMessage() {
                var errorMessage = document.getElementById("error-message");
                var successMessage = document.getElementById("success");

                // Hiển thị thông báo lỗi nếu có
                if (errorMessage) {
                    errorMessage.style.display = "block";
                    setTimeout(function () {
                        errorMessage.style.display = "none";
                    }, 3000);
                }

                // Hiển thị thông báo thành công nếu có
                if (successMessage) {
                    successMessage.style.display = "block";
                    setTimeout(function () {
                        successMessage.style.display = "none";
                    }, 3000);
                }
            }

            // Gọi hàm khi trang đã tải xong
            window.onload = function () {
                showMessage();
            };
        </script>
    </body>
</html>
