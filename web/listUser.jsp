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

                    <div class="container">
                        <a href="addUser.jsp" class="add-btn">➕ Add New User</a>
                        <div class="search-box">
                            <!-- Form tìm kiếm -->
                            <form method="get" action="UserList">
                                <input type="hidden" name="page" value="1"> <!-- Fix lỗi mất trang -->
                                <input type="text" name="searchValue" placeholder="Search by name" value="${searchValue}">
                            <select name="roleName" style="padding: 11px; width: 250px; border: 1px solid #ccc; border-radius: 5px;">
                                <option value="">All Roles</option>
                                <option value="Admin" ${roleName == 'Admin' ? 'selected' : ''}>Admin</option>
                                <option value="Expert" ${roleName == 'Expert' ? 'selected' : ''}>Expert</option>
                                <option value="Student" ${roleName == 'Student' ? 'selected' : ''}>Student</option>
                                <option value="Saler" ${roleName == 'Saler' ? 'selected' : ''}>Saler</option>
                                <option value="Marketing" ${roleName == 'Marketing' ? 'selected' : ''}>Marketing</option>
                            </select>
                            <button type="submit" style="width: 100px; background: linear-gradient(45deg, #4c1864 0%, #3f189a 100%);"> Filter </button>
                        </form>


                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Image</th>
                                <th>Email</th>
                                <th>Password</th>
                                <th>Last sign in</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="account" items="${listAccount}">
                                <tr>
                                    <td>${account.userID}</td>        
                                    <td>${account.fullName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty account.image || account.image == '/assets/images/profile/unknow.jpg'}">
                                                <img style="width: 50px; height: 50px" src="${pageContext.request.contextPath}/assets/images/profile/unknow.jpg">
                                            </c:when>
                                            <c:when test="${fn:startsWith(account.image, 'https://')}">
                                                <img style="width: 50px; height: 50px" src="${account.image}">
                                            </c:when>
                                            <c:otherwise>
                                                <img style="width: 50px; height: 50px" src="${pageContext.request.contextPath}${account.image}">
                                            </c:otherwise>
                                        </c:choose> 
                                    </td>
                                    <td>${account.email}</td>
                                     <td>${account.password}</td>
                                    <td class="last-sign-in" data-time="${account.updatedAt}">${account.updatedAt}</td>
                                    <td>${account.role.roleName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${account.status == 'True'}">Active</c:when>
                                            <c:otherwise>Inactive</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <!-- Edit Button -->
                                            <form method="get" action="EditUserServlet">
                                                <input type="hidden" name="userID" value="${account.userID}">
                                                <button type="submit" class="edit-btn">Edit</button>
                                            </form>

                                            <!-- Block/Unblock Button -->
                                            <form method="post" action="BlockUserServlet">
                                                <input type="hidden" name="gmail" value="${account.email}">
                                                 <input type="hidden" name="status" value="${account.status}">
                                                <c:choose>
                                                    <c:when test="${account.status == 'True'}">
                                                        <button type="submit" class="block-btn">Block</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="unblock-btn">Unblock</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                            <!-- Delete Button -->
                                            <form method="post" action="DeleteUserServlet">
                                                <input type="hidden" name="gmail" value="${account.email}">
                                                <button type="submit" class="delete-btn">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listAccount}">
                                <tr>
                                    <td colspan="7" style="text-align: center;">No users found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="UserList?page=${currentPage - 1}&searchValue=${fn:escapeXml(searchValue)}&roleName=${fn:escapeXml(roleName)}">Previous</a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="UserList?page=${i}&searchValue=${fn:escapeXml(searchValue)}&roleName=${fn:escapeXml(roleName)}" 
                               class="${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="UserList?page=${currentPage + 1}&searchValue=${fn:escapeXml(searchValue)}&roleName=${fn:escapeXml(roleName)}">Next</a>
                        </c:if>
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
        document.addEventListener("DOMContentLoaded", function () {
            const timeElements = document.querySelectorAll(".last-sign-in");

            timeElements.forEach(el => {
                const timeString = el.getAttribute("data-time");
                if (timeString) {
                    const formattedTime = timeago.format(new Date(timeString));
                    el.textContent = formattedTime;
                }
            });
        });


    </script>
</html>
