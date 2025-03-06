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
