<%-- 
    Document   : edituser.jsp
    Created on : Feb 6, 2025, 2:07:47 PM
    Author     : ducba
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>User Profile</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            /* 🌟 Sidebar */
            .sidebar {
                width: 250px;
                height: 100vh;
                position: fixed;
                background: #6a1b9a;
                color: white;
                padding: 20px;
            }

            .sidebar h2 {
                text-align: center;
                margin-bottom: 20px;
                font-weight: bold;
            }

            .sidebar a {
                color: white;
                text-decoration: none;
                padding: 10px;
                display: block;
                border-radius: 5px;
                transition: 0.3s;
            }

            .sidebar a:hover {
                background: rgba(255, 255, 255, 0.2);
                padding-left: 15px;
            }

            /* 🌟 Main Content */
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

            .topbar {
                background: #6a1b9a;
                padding: 15px;
                color: white;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-radius: 10px;
                margin-bottom: 20px;
            }

            /* 🌟 Profile Container */
            .profile-container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
                max-width: 800px;
                margin: auto;
            }

            h1 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #333;
            }

            .form-control:focus {
                border-color: #6a1b9a;
                box-shadow: 0px 0px 5px rgba(106, 27, 154, 0.3);
            }

            /* 🌟 Buttons */
            .btn-save {
                background: #ff9800;
                color: white;
                font-weight: bold;
                transition: 0.3s;
            }

            .btn-save:hover {
                background: #e68900;
                transform: scale(1.05);
            }

            .btn-cancel {
                background: #333;
                color: white;
                font-weight: bold;
                transition: 0.3s;
            }

            .btn-cancel:hover {
                background: #222;
                transform: scale(1.05);
            }

            /* Error message */
            .error {
                color: #dc3545;
                font-weight: bold;
                margin-bottom: 10px;
            }

        </style>
    </head>
    <body>

        <jsp:include page="/common/header.jsp"/>

        <div class="main-content">
            <!-- Profile Form -->
            <div class="profile-container">
                <h1>User Profile</h1>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>

                <form method="post" action="EditUserServlet">

                    <!-- Hidden field for userName -->
                    <input type="hidden" name="userName" value="${user.userName}">

                    <!-- Full Name Field -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Full Name</label>
                        <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                    </div>

                    <!-- Email Field -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Email</label>
                        <input type="email" class="form-control" name="email" value="${user.email}" required>
                    </div>

                    <!-- Role Field -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Role</label>
                        <select class="form-select" name="roleID">
                            <option value="1" ${user.roleID == 1 ? 'selected' : ''}>Admin</option>
                            <option value="2" ${user.roleID == 2 ? 'selected' : ''}>Expert</option>
                            <option value="3" ${user.roleID == 3 ? 'selected' : ''}>Student</option>
                        </select>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-save px-4 py-2">Save Changes</button>
                        <a href="UserList" class="btn btn-cancel px-4 py-2">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>





