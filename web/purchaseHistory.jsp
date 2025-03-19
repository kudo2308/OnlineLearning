<%-- 
    Document   : purchaseHistory
    Created on : Mar 17, 2025, 2:27:21 PM
    Author     : VICTUS
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Online Learning</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"/>
        <link rel="stylesheet" href="assets/css/purchase.css"/>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
            <nav style="height: 0 ;border-bottom: 1px solid #ddd"></nav>
            <main class="purchase-history-container">
                <div class="purchase-header">
                    <h1>Purchase History</h1>
                    <p>View all your course purchases and payment details</p>
                </div>

                <div class="purchase-filters">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Search by course title..." onkeyup="filterOrders()">
                        <i class="material-icons">search</i>
                    </div>
                    <div class="filter-options">
                        <select id="paymentStatus" onchange="filterOrders()">
                            <option value="all">All Statuses</option>
                            <option value="paid">Paid</option>
                            <option value="pending">Pending</option>
                            <option value="failed">Failed</option>
                            <!--<option value="refunded">Refunded</option>-->
                        </select>
                        <select id="sortBy" onchange="filterOrders()">
                            <option value="date-desc">Newest First</option>
                            <option value="date-asc">Oldest First</option>
                            <option value="price-desc">Price: High to Low</option>
                            <option value="price-asc">Price: Low to High</option>
                        </select>
                    </div>
                </div>

                <div class="purchase-list">
                <c:if test="${empty orderList}">
                    <div class="no-purchases">
                        <i class="material-icons">shopping_cart</i>
                        <h2>No purchases yet</h2>
                        <p>You haven't made any purchases yet. Browse our courses to get started!</p>
                        <a href="${pageContext.request.contextPath}/CourseSearch" class="btn-primary">Browse Courses</a>
                    </div>
                </c:if>

                <c:if test="${not empty orderList}">
                    <table class="purchase-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Courses</th>
                                <th>Total Amount</th>
                                <th>Payment Method</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderList}" var="order">
                                <tr class="order-row" data-status="${order.paymentStatus}" data-date="${order.createdAt}" data-price="${order.totalAmount}">
                                    <td>${order.orderID}</td>
                                    <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <div class="course-list">
                                            <c:forEach items="${order.orderItems}" var="item" varStatus="status">
                                                <div class="course-item">
                                                    <span class="course-title">${item.courseTitle}</span>
                                                    <c:if test="${status.count < order.orderItems.size()}">
                                                        <span class="separator">|</span>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </td>
                                    <td class="price">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td>${order.paymentMethod}</td>
                                    <td>
                                        <span class="status-badge status-${order.paymentStatus}">
                                            ${order.paymentStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-details?id=${order.orderID}" class="btn-view">
                                            <i class="material-icons">visibility</i> View
                                        </a>
                                        <c:if test="${order.paymentStatus eq 'paid'}">
                                            <a href="${pageContext.request.contextPath}/download-invoice?id=${order.orderID}" class="btn-invoice">
                                                <i class="material-icons">receipt</i> Invoice
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/purchase-history?page=${currentPage - 1}" class="page-link">
                                <i class="material-icons">chevron_left</i> Previous
                            </a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/purchase-history?page=${i}" 
                               class="page-link ${currentPage == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/purchase-history?page=${currentPage + 1}" class="page-link">
                                Next <i class="material-icons">chevron_right</i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>       
        <script>
            function filterOrders() {
                const searchInput = document.getElementById('searchInput').value.toLowerCase();
                const statusFilter = document.getElementById('paymentStatus').value;
                const sortBy = document.getElementById('sortBy').value;
                const orderRows = document.querySelectorAll('.order-row');

                // Filter rows
                orderRows.forEach(row => {
                    const courseTitle = row.querySelector('.course-title').textContent.toLowerCase();
                    const rowStatus = row.dataset.status;

                    const statusMatch = statusFilter === 'all' || rowStatus === statusFilter;
                    const searchMatch = courseTitle.includes(searchInput);

                    if (statusMatch && searchMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });

                // Sort rows
                const tableBody = document.querySelector('.purchase-table tbody');
                const rows = Array.from(tableBody.querySelectorAll('tr:not([style*="display: none"])'));

                rows.sort((a, b) => {
                    switch (sortBy) {
                        case 'date-desc':
                            return new Date(b.dataset.date) - new Date(a.dataset.date);
                        case 'date-asc':
                            return new Date(a.dataset.date) - new Date(b.dataset.date);
                        case 'price-desc':
                            return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                        case 'price-asc':
                            return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                        default:
                            return 0;
                    }
                });

                // Re-append sorted rows
                rows.forEach(row => tableBody.appendChild(row));
            }
        </script>
    </body>
</html>
