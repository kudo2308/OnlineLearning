<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Details - Online Learning</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"/>
        <link rel="stylesheet" href="assets/css/purchase.css"/>
        <style>
            .order-details-container {
                max-width: 1000px;
                margin: 30px auto;
                padding: 20px;
            }
            
            .order-header {
                border-bottom: 1px solid #ddd;
                padding-bottom: 20px;
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .order-header h1 {
                margin: 0;
                font-size: 24px;
            }
            
            .order-meta {
                background-color: #f5f5f5;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }
            
            .order-meta div {
                padding: 8px;
            }
            
            .order-meta h3 {
                margin-top: 0;
                margin-bottom: 10px;
                font-size: 16px;
                color: #555;
            }
            
            .order-meta p {
                margin: 5px 0;
            }
            
            .order-items {
                margin-bottom: 30px;
            }
            
            .order-item {
                display: grid;
                grid-template-columns: 120px 1fr;
                gap: 20px;
                padding: 15px;
                border-bottom: 1px solid #eee;
            }
            
            .order-item img {
                width: 100%;
                border-radius: 5px;
                object-fit: cover;
            }
            
            .item-details {
                display: flex;
                flex-direction: column;
            }
            
            .item-details h3 {
                margin-top: 0;
                margin-bottom: 5px;
            }
            
            .item-meta {
                margin-top: auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .item-meta p {
                margin: 5px 0;
            }
            
            .order-summary {
                background-color: #f5f5f5;
                padding: 15px;
                border-radius: 5px;
                margin-top: 20px;
            }
            
            .summary-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #ddd;
            }
            
            .summary-row:last-child {
                border-bottom: none;
                font-weight: bold;
            }
            
            .back-button {
                background-color: #f5f5f5;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                text-decoration: none;
                color: #333;
                font-weight: 500;
            }
            
            .back-button:hover {
                background-color: #e5e5e5;
            }
            
            .order-actions {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }
            
            .invoice-button {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                text-decoration: none;
            }
            
            .invoice-button:hover {
                background-color: #45a049;
            }
            
            .status-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
                color: white;
            }
            
            .status-paid {
                background-color: #4CAF50;
            }
            
            .status-pending {
                background-color: #ff9800;
            }
            
            .status-failed {
                background-color: #f44336;
            }
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        <nav style="height: 0; border-bottom: 1px solid #ddd"></nav>
        
        <main class="order-details-container">
            <div class="order-header">
                <h1>Order Details</h1>
                <a href="${pageContext.request.contextPath}/purchase" class="back-button">
                    <i class="material-icons">arrow_back</i> Back to Purchase History
                </a>
            </div>
            
            <div class="order-meta">
                <div>
                    <h3>Order Information</h3>
                    <p><strong>Order ID:</strong> #${order.orderID}</p>
                    <p><strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></p>
                    <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                    <p><strong>Status:</strong> 
                        <span class="status-badge status-${order.paymentStatus}">
                            ${order.paymentStatus}
                        </span>
                    </p>
                    <c:if test="${not empty order.vnpayTransactionID}">
                        <p><strong>Transaction ID:</strong> ${order.vnpayTransactionID}</p>
                    </c:if>
                </div>
                
                <div>
                    <h3>Customer Information</h3>
                    <p><strong>Name:</strong> ${account.fullName}</p>
                    <p><strong>Email:</strong> ${account.email}</p>
                    <p><strong>Phone:</strong> ${account.phone}</p>
                </div>
            </div>
            
            <h2>Ordered Courses</h2>
            <div class="order-items">
                <c:forEach items="${order.orderItems}" var="item">
                    <div class="order-item">
                        <img src="${pageContext.request.contextPath}${item.imageUrl}" alt="${item.courseTitle}" 
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-course.jpg';">
                        <div class="item-details">
                            <h3>${item.courseTitle}</h3>
                            <p>Instructor: ${item.expertName}</p>
                            <div class="item-meta">
                                <p>Original Price: <fmt:formatNumber value="${item.originalPrice}" type="currency" currencySymbol="$" /></p>
                                <c:if test="${order.paymentStatus eq 'paid'}">
                                    <a href="${pageContext.request.contextPath}/coursedetail?courseId=${item.courseId}" class="btn-primary">
                                        <i class="material-icons">school</i> Start Learning
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div class="order-summary">
                <h3>Order Summary</h3>
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" /></span>
                </div>
                <div class="summary-row">
                    <span>Discount:</span>
                    <span>$0.00</span>
                </div>
                <div class="summary-row">
                    <span>Total:</span>
                    <span><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" /></span>
                </div>
            </div>
            
            <div class="order-actions">
                <a href="${pageContext.request.contextPath}/purchase" class="back-button">
                    <i class="material-icons">arrow_back</i> Back to Purchase History
                </a>
                
                <c:if test="${order.paymentStatus eq 'paid'}">
                    <a href="${pageContext.request.contextPath}/download-invoice?id=${order.orderID}" class="invoice-button">
                        <i class="material-icons">receipt</i> Download Invoice
                    </a>
                </c:if>
            </div>
        </main>
        
    </body>
</html>