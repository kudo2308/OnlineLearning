<%-- 
    Document   : PromotionManagerment
    Created on : Mar 25, 2025, 6:13:28 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Khuyến mãi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <style>
            .container {
                width: 90%;
                margin: 20px auto;
            }

            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }

            h2 {
                color: #333;
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            input[type="text"],
            input[type="number"],
            select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .btn {
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }

            .btn-primary {
                background: #4CAF50;
                color: white;
            }

            .btn-danger {
                background: #f44336;
                color: white;
            }

            .filter-section {
                display: none;
                margin-top: 15px;
                padding: 15px;
                background: #f9f9f9;
                border-radius: 4px;
            }

            .table-responsive {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #f5f5f5;
            }

            .status-active {
                color: green;
                font-weight: bold;
            }

            .status-inactive {
                color: red;
                font-weight: bold;
            }

            .notification {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
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

            .action-button {
                margin-right: 5px;
                padding: 5px 10px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
            }

            .edit-btn {
                background: #2196F3;
                color: white;
            }

            .delete-btn {
                background: #f44336;
                color: white;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .container {
                    width: 95%;
                }

                th, td {
                    padding: 8px 10px;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/common/header.jsp"></jsp:include>
            <hr style="color: #dddddd">

            <div class="container">
            <c:if test="${not empty message}">
                <div class="notification ${messageType}">${message}</div>
            </c:if>

            <!-- Form Tạo Khuyến Mãi Mới -->
            <div class="card">
                <h2>Tạo Khuyến Mãi Mới</h2>
                <form action="${pageContext.request.contextPath}/admin/promotion" method="post">
                    <div class="form-group">
                        <label for="promotionCode">Mã Khuyến Mãi:</label>
                        <input type="text" id="promotionCode" name="promotionCode" required>
                    </div>

                    <div class="form-group">
                        <label for="discountType">Loại Giảm Giá:</label>
                        <select id="discountType" name="discountType" required>
                            <option value="percentage">Phần trăm (%)</option>
                            <option value="fixed">Số tiền cố định (VNĐ)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="discountValue">Giá Trị Giảm Giá:</label>
                        <input type="number" id="discountValue" name="discountValue" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="applyTo">Áp Dụng Cho:</label>
                        <select id="applyTo" name="applyTo" onchange="showFilterOptions(this.value)">
                            <option value="all">Tất cả khóa học</option>
                            <option value="category">Theo danh mục</option>
                            <option value="expert">Theo giảng viên</option>
                            <option value="course">Theo khóa học cụ thể</option>
                        </select>
                    </div>

                    <!-- Lựa chọn Danh Mục -->
                    <div id="categoryFilter" class="filter-section">
                        <div class="form-group">
                            <label for="categoryID">Chọn Danh Mục:</label>
                            <select id="categoryID" name="categoryID">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}">${category.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Giảng Viên -->
                    <div id="expertFilter" class="filter-section">
                        <div class="form-group">
                            <label for="expertID">Chọn Giảng Viên:</label>
                            <select id="expertID" name="expertID">
                                <c:forEach var="expert" items="${experts}">
                                    <option value="${expert.expertID}">${expert.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Khóa Học -->
                    <div id="courseFilter" class="filter-section">
                        <div class="form-group">
                            <label for="courseID">Chọn Khóa Học:</label>
                            <select id="courseID" name="courseID">
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.courseID}">${course.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Tạo Khuyến Mãi</button>
                    </div>
                </form>
            </div>

            <!-- Danh sách Khuyến Mãi -->
            <!-- Form Tạo Khuyến Mãi Mới -->
            <div class="card">
                <h2>Tạo Khuyến Mãi Mới</h2>
                <form action="${pageContext.request.contextPath}/admin/promotion" method="post">
                    <div class="form-group">
                        <label for="promotionCode">Mã Khuyến Mãi:</label>
                        <input type="text" id="promotionCode" name="promotionCode" required>
                    </div>

                    <div class="form-group">
                        <label for="discountType">Loại Giảm Giá:</label>
                        <select id="discountType" name="discountType" required>
                            <option value="percentage">Phần trăm (%)</option>
                            <option value="fixed">Số tiền cố định (VNĐ)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="discountValue">Giá Trị Giảm Giá:</label>
                        <input type="number" id="discountValue" name="discountValue" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="applyTo">Áp Dụng Cho:</label>
                        <select id="applyTo" name="applyTo" onchange="showFilterOptions(this.value)">
                            <option value="all">Tất cả khóa học</option>
                            <option value="category">Theo danh mục</option>
                            <option value="expert">Theo giảng viên</option>
                            <option value="course">Theo khóa học cụ thể</option>
                        </select>
                    </div>

                    <!-- Lựa chọn Danh Mục -->
                    <div id="categoryFilter" class="filter-section">
                        <div class="form-group">
                            <label for="categoryID">Chọn Danh Mục:</label>
                            <select id="categoryID" name="categoryID">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}">${category.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Giảng Viên -->
                    <div id="expertFilter" class="filter-section">
                        <div class="form-group">
                            <label for="expertID">Chọn Giảng Viên:</label>
                            <select id="expertID" name="expertID">
                                <c:forEach var="expert" items="${experts}">
                                    <option value="${expert.expertID}">${expert.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Lựa chọn Khóa Học -->
                    <div id="courseFilter" class="filter-section">
                        <div class="form-group">
                            <label for="courseID">Chọn Khóa Học:</label>
                            <select id="courseID" name="courseID">
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.courseID}">${course.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Tạo Khuyến Mãi</button>

                        <!-- Nút Làm Mới (Reset) -->
                        <button type="reset" class="btn btn-secondary" style="margin-left: 10px; background-color: #6c757d; color: white;">Làm Mới</button>

                        <!-- Nút Xuất Báo Cáo -->
                        <button type="button" class="btn btn-info" style="margin-left: 10px; background-color: #17a2b8; color: white;" onclick="exportPromotionReport()">Xuất Báo Cáo</button>
                    </div>
                </form>
            </div>

            <script>
                function exportPromotionReport() {
                    // Chuyển hướng đến servlet/controller xử lý xuất báo cáo
                    window.location.href = '${pageContext.request.contextPath}/admin/promotion?action=export';
                }
            </script>

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