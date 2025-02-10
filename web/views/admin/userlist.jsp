<%-- 
    Document   : edituser.jsp
    Created on : Feb 6, 2025, 2:07:47 PM
    Author     : ducba
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>User Management</title>
        <style>
            /* 🌟 Reset CSS */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }

            /* 🌟 Căn giữa nội dung */
            body {
                background-color: #f4f4f9;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                min-height: 100vh;
                padding: 20px;
            }

            /* 🌟 Container chính */
            .container {
                background: white;
                padding: 20px;
                width: 90%;
                max-width: 900px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
                border-radius: 8px;
                text-align: center;
            }

            /* 🌟 Tiêu đề */
            h1 {
                font-size: 24px;
                color: #333;
                margin-bottom: 20px;
            }

            /* 🌟 Nút thêm người dùng */
            .add-btn {
                display: inline-block;
                padding: 10px 15px;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                font-size: 16px;
                transition: background 0.3s;
                margin-bottom: 15px;
            }
            .search-box {
                margin-bottom: 15px;
                text-align: center;
            }

            .search-box input {
                padding: 8px;
                width: 250px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .search-box button {
                padding: 8px 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }

            .search-box button:hover {
                background-color: #0056b3;
            }

            .add-btn:hover {
                background-color: #218838;
            }

            /* 🌟 Bảng danh sách người dùng */
            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                margin-top: 20px;
            }

            th, td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: center;
            }

            th {
                background-color: #007bff;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            /* 🌟 Các nút hành động */
            .action-buttons {
                display: flex;
                justify-content: center;
                gap: 10px;
            }

            .edit-btn, .block-btn, .unblock-btn, .delete-btn{
                padding: 6px 12px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                transition: 0.3s;
            }

            .edit-btn {
                background-color: #007bff;
                color: white;
            }

            .edit-btn:hover {
                background-color: #0056b3;
            }

            .block-btn {
                background-color: #dc3545;
                color: white;
            }

            .block-btn:hover {
                background-color: orange;
            }

            .unblock-btn {
                background-color: #28a745;
                color: white;
            }

            .unblock-btn:hover {
                background-color: #218838;
            }
            .delete-btn:hover{
                background-color: #dc3545;
                color: white;
            }
            .pagination {
                text-align: center;
                margin-top: 20px;
            }
            .pagination a {
                display: inline-block;
                padding: 8px 12px;
                margin: 0 5px;
                text-decoration: none;
                background-color: #007bff;
                color: white;
                border-radius: 5px;
            }
            .pagination a.active {
                background-color: #0056b3;
            }
            .sidebar {
                width: 250px;
                height: 100vh;
                background: #f9f9f9;
                color: #222;
                padding-top: 20px;
                position: fixed;
                left: 0;
                top: 0;
            }
            .sidebar a {
                color: #222;
                text-decoration: none;
                display: block;
                padding: 15px 20px;
                font-size: 16px;
            }
            .sidebar a:hover {
                background: #28a745;
            }


        </style>
    </head>
    <body>
        
        <jsp:include page="/common/header.jsp"/>
        
        <div class="container">
            <h1>User Management</h1>
                <a href="adduser.jsp" class="add-btn">➕ Add New User</a>
            <div class="search-box">
                <form method="post" action="UserListServlet">
                    <input type="text" name="searchValue" placeholder="Search by name..." value="${param.searchValue}">
                    <button type="submit">🔍 Search</button>
                </form>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${listUser}">
                        <tr>
                            <td>${user.userName}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.roleID == 1}">Admin</c:when>
                                    <c:when test="${user.roleID == 2}">Expert</c:when>
                                    <c:when test="${user.roleID == 3}">Student</c:when>
                                    <c:when test="${user.roleID == 4}">Sale</c:when>
                                    <c:when test="${user.roleID == 5}">Marketing</c:when>
                                    <c:otherwise>Unknown</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <!-- Edit Button -->
                                    <form method="get" action="EditUserServlet">
                                        <input type="hidden" name="userName" value="${user.userName}">
                                        <button type="submit" class="edit-btn">Edit</button>
                                    </form>

                                    <!-- Block/Unblock Button -->
                                    <form method="post" action="BlockUserServlet">
                                        <input type="hidden" name="userName" value="${user.userName}">
                                        <c:choose>
                                            <c:when test="${user.status == 1}">
                                                <button type="submit" class="block-btn">Block</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="unblock-btn">Unblock</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                    <form method="post" action="DeleteUserServlet">
                                        <input type="hidden" name="userName" value="${user.userName}">
                                        <button type="submit" class="delete-btn"> Delete</button>
                                    </form>
                                
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty listUser}">
                        <tr>
                            <td colspan="5" style="text-align: center;">No users found.</td>
                        </tr>
                    </c:if>


                </tbody>
            </table>
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="UserList?page=${currentPage - 1}">Previous</a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="UserList?page=${i}" 
                       class="${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="UserList?page=${currentPage + 1}">Next</a>
                </c:if>
            </div>
        </div>
        <jsp:include page="/common/footer.jsp"/>
    </body>
</html>
