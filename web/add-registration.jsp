<%-- 
    Document   : add-registration
    Created on : Feb 25, 2025, 10:31:00 AM
    Author     : ducba
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thêm Đăng Ký</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>Thêm Đăng Ký Khóa Học</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <form action="AddRegistration" method="post">
            <div class="form-group">
                <label for="email">Email Người Dùng:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="courseID">Chọn Khóa Học:</label>
                <select class="form-control" id="courseID" name="courseID" onchange="updatePrice()" required>
                    <option value="">-- Chọn khóa học --</option>
                    <c:forEach var="course" items="${courses}">
                        <option value="${course.courseID}" data-price="${course.price}">${course.title}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="price">Giá Khóa Học:</label>
                <input type="text" class="form-control" id="price" name="price" readonly>
            </div>
            <button type="submit" class="btn btn-primary">Lưu</button>
        </form>
    </div>

    <script>
        function updatePrice() {
            const courseSelect = document.getElementById("courseID");
            const priceInput = document.getElementById("price");
            const selectedOption = courseSelect.options[courseSelect.selectedIndex];
            if (selectedOption.value !== "") {
                priceInput.value = selectedOption.getAttribute("data-price");
            } else {
                priceInput.value = "";
            }
        }
    </script>
</body>
</html>