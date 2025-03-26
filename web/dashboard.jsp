<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
        
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <!-- Custom styles for modern dashboard -->
        <style>
            .progress {
                height: 5px;
            }
            
            /* Modern dashboard styles */
            .widget-card {
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }
            
            .widget-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            }
            
            .widget-bg1 {
                background: linear-gradient(45deg, #6a11cb, #2575fc);
            }
            
            .widget-bg2 {
                background: linear-gradient(45deg, #11998e, #38ef7d);
            }
            
            .widget-bg3 {
                background: linear-gradient(45deg, #ff5e62, #ff9966);
            }
            
            .widget-bg4 {
                background: linear-gradient(45deg, #4e54c8, #8f94fb);
            }
            
            .wc-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
            }
            
            .wc-des {
                font-size: 14px;
                opacity: 0.8;
                margin-bottom: 15px;
            }
            
            .wc-stats {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 15px;
                display: block;
            }
            
            .progress-bar-section {
                margin-top: 15px;
            }
            
            .progress {
                height: 6px;
                border-radius: 3px;
                background-color: rgba(255, 255, 255, 0.3);
                margin-bottom: 8px;
            }
            
            .progress-bar {
                border-radius: 3px;
                background-color: rgba(255, 255, 255, 0.8) !important;
            }
            
            /* Financial summary card */
            .financial-summary {
                display: flex;
                justify-content: space-between;
                text-align: center;
                padding: 20px;
            }
            
            .financial-item {
                flex: 1;
                padding: 15px 10px;
            }
            
            .financial-label {
                font-size: 16px;
                margin-bottom: 10px;
                opacity: 0.9;
            }
            
            .financial-value {
                font-size: 24px;
                font-weight: 700;
            }
            
            /* Chart container */
            .chart-container {
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            /* Tables */
            .card {
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }
            
            .card-header {
                background-color: #f8f9fa;
                border-bottom: 1px solid #eee;
                padding: 15px 20px;
            }
            
            .card-title {
                margin: 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }
            
            .table {
                margin-bottom: 0;
            }
            
            .table th {
                font-weight: 600;
                color: #555;
                border-top: none;
            }
            
            .table td, .table th {
                padding: 12px 15px;
                vertical-align: middle;
            }
            
            /* Status badges */
            .badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
            }
            
            .badge-success {
                background-color: #e6f7ee;
                color: #00b74a;
            }
            
            .badge-warning {
                background-color: #fff4e5;
                color: #ff9800;
            }
            
            .badge-danger {
                background-color: #fbe9e7;
                color: #f44336;
            }
            
            /* Notifications */
            .notification-container {
                padding: 20px;
            }
            
            .notification-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .notification-badge {
                background-color: #FFC107;
                color: white;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
            }
            
            .notification-empty {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 30px 0;
                color: #888;
            }
            
            .financial-summary {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
            }
            
            .financial-item {
                text-align: center;
                flex: 1;
                padding: 10px;
            }
            
            .financial-label {
                color: rgba(255, 255, 255, 0.8);
                margin-bottom: 5px;
            }
            
            .financial-value {
                color: white;
                font-size: 24px;
                margin: 0;
            }
            
            .chart-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .notification-item {
                padding: 15px;
                border-bottom: 1px solid #eee;
            }
            
            .notification-icon {
                font-size: 18px;
                margin-right: 10px;
            }
            
            /* Modern tables */
            .table-container {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .table-header {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .modern-table {
                border-collapse: collapse;
                width: 100%;
            }
            
            .modern-table th, .modern-table td {
                border: 1px solid #ddd;
                padding: 15px;
                text-align: left;
            }
            
            .modern-table th {
                background-color: #f8f9fa;
                font-weight: 600;
            }
            
            .modern-table td {
                vertical-align: middle;
            }
            
            .status-badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
            }
            
            .status-active {
                background-color: #e6f7ee;
                color: #00b74a;
            }
            
            .status-pending {
                background-color: #fff4e5;
                color: #ff9800;
            }
            
            .status-inactive {
                background-color: #fbe9e7;
                color: #f44336;
            }
            
            .chart-container {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .notification-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }
            
            .notification-badge {
                background-color: #f44336;
                color: white;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
            }
            
            .notification-container {
                max-height: 250px;
                overflow-y: auto;
            }
            
            .notification-empty {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 200px;
                color: #888;
            }
        </style>
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
                        </ul>
                    </div>
                    
                    <!-- Date Range Information -->
                    <div class="row">
                        <div class="col-12">
                            <div class="widget-card" style="background: linear-gradient(45deg, #3a7bd5, #00d2ff); color: white; padding: 15px;">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 style="margin: 0; color: white;">Dashboard Overview: ${dateInfo.selectedRangeTitle}</h4>
                                        <p style="margin: 5px 0 0 0; font-size: 14px;">
                                            Selected Period: ${dateInfo.selectedRangeStart} - ${dateInfo.selectedRangeEnd}<br>
                                            Base Period: ${dateInfo.previousMonthStart} - ${dateInfo.previousMonthEnd}
                                        </p>
                                        <p style="margin: 5px 0 0 0; font-size: 12px; opacity: 0.8;">
                                            *Growth percentages compare current month to previous month
                                        </p>
                                    </div>
                                    <div>
                                        <button type="button" class="btn" style="background-color: rgba(255,255,255,0.2); color: white;" data-toggle="modal" data-target="#dateFilterModal">
                                            <i class="fa fa-calendar" style="margin-right: 5px;"></i> Change Date Range
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Date Filter Modal -->
                    <div class="modal fade" id="dateFilterModal" tabindex="-1" role="dialog" aria-labelledby="dateFilterModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="dateFilterModalLabel">Filter Dashboard by Date Range</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET">
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="dateRangeSelect">Preset Date Ranges</label>
                                            <select class="form-control" id="dateRangeSelect" name="dateRange">
                                                <option value="current_month">Current Month</option>
                                                <option value="previous_month">Previous Month</option>
                                                <option value="last_30_days">Last 30 Days</option>
                                                <option value="last_90_days">Last 90 Days</option>
                                                <option value="year_to_date">Year to Date</option>
                                                <option value="custom">Custom Range</option>
                                            </select>
                                        </div>
                                        <div id="customDateRange" style="display: none;">
                                            <div class="form-group">
                                                <label for="startDate">Start Date</label>
                                                <input type="date" class="form-control" id="startDate" name="startDate">
                                            </div>
                                            <div class="form-group">
                                                <label for="endDate">End Date</label>
                                                <input type="date" class="form-control" id="endDate" name="endDate">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary">Apply Filter</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Card -->
                    <div class="row">
                        <div class="col-md-6 col-lg-6 col-xl-6 col-sm-12 col-12">
                            <div class="widget-card widget-bg3">					 
                                <div class="wc-item">
                                    <h4 class="wc-title">
                                        New Orders 
                                        <span class="badge badge-light" style="font-size: 11px; vertical-align: middle;">This Month</span>
                                    </h4>
                                    <span class="wc-des">
                                        Recent Order Amount
                                    </span>
                                    <span class="wc-stats counter">
                                        <c:choose>
                                            <c:when test="${not empty totalOrders}">
                                                ${totalOrders}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="progress wc-progress">
                                        <div class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="${growthPercentages.orderGrowth}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <span class="wc-progress-bx">
                                        <span class="wc-change">
                                            Change
                                        </span>
                                        <span class="wc-number ml-auto">
                                            ${growthPercentages.orderGrowth}%
                                        </span>
                                    </span>
                                </div>				      
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-6 col-xl-6 col-sm-12 col-12">
                            <div class="widget-card widget-bg4">					 
                                <div class="wc-item">
                                    <h4 class="wc-title">
                                        New Users 
                                        <span class="badge badge-light" style="font-size: 11px; vertical-align: middle;">This Month</span>
                                    </h4>
                                    <span class="wc-des">
                                        Joined New User
                                    </span>
                                    <span class="wc-stats counter">
                                        <c:choose>
                                            <c:when test="${not empty totalUsers}">
                                                ${totalUsers}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="progress wc-progress">
                                        <div class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="${growthPercentages.userGrowth}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <span class="wc-progress-bx">
                                        <span class="wc-change">
                                            Change
                                        </span>
                                        <span class="wc-number ml-auto">
                                            ${growthPercentages.userGrowth}%
                                        </span>
                                    </span>
                                </div>				      
                            </div>
                        </div>
                    </div>
                    <div class="row mt-4">
                        <div class="col-md-6 col-lg-6 col-xl-6 col-sm-12 col-12">
                            <div class="widget-card widget-bg1">					 
                                <div class="wc-item">
                                    <h4 class="wc-title">
                                        Total Courses
                                        <span class="badge badge-light" style="font-size: 11px; vertical-align: middle;">This Month</span>
                                    </h4>
                                    <span class="wc-des">
                                        Available Courses
                                    </span>
                                    <span class="wc-stats counter">
                                        <c:choose>
                                            <c:when test="${not empty totalCourses}">
                                                ${totalCourses}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="progress wc-progress">
                                        <div class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="${growthPercentages.courseGrowth}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <span class="wc-progress-bx">
                                        <span class="wc-change">
                                            Change
                                        </span>
                                        <span class="wc-number ml-auto">
                                            ${growthPercentages.courseGrowth}%
                                        </span>
                                    </span>
                                </div>				      
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-6 col-xl-6 col-sm-12 col-12">
                            <div class="widget-card widget-bg2">					 
                                <div class="wc-item">
                                    <h4 class="wc-title">
                                        Total Blogs
                                        <span class="badge badge-light" style="font-size: 11px; vertical-align: middle;">This Month</span>
                                    </h4>
                                    <span class="wc-des">
                                        Published Articles
                                    </span>
                                    <span class="wc-stats counter">
                                        <c:choose>
                                            <c:when test="${not empty totalBlogs}">
                                                ${totalBlogs}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="progress wc-progress">
                                        <div class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="${growthPercentages.blogGrowth}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <span class="wc-progress-bx">
                                        <span class="wc-change">
                                            Change
                                        </span>
                                        <span class="wc-number ml-auto">
                                            ${growthPercentages.blogGrowth}%
                                        </span>
                                    </span>
                                </div>				      
                            </div>
                        </div>
                    </div>
                    <!-- Card END -->	
              
                    <!-- Your Profile Views Chart -->
                    <div class="row mt-4">
                        <div class="col-lg-8 col-md-12">
                            <div class="chart-container">
                                <h4 class="chart-title">Your Profile Views</h4>
                                <div style="height: 300px;">
                                    <canvas id="profileViewsChart"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <div class="chart-container" style="height: 300px;">
                                <div class="notification-header">
                                    <h4 class="chart-title">Notifications</h4>
                                    <div class="notification-badge">
                                        <c:choose>
                                            <c:when test="${not empty recentNotifications}">
                                                ${recentNotifications.size()}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="notification-container">
                                    <c:choose>
                                        <c:when test="${not empty recentNotifications}">
                                            <c:forEach var="notification" items="${recentNotifications}">
                                                <div class="notification-item">
                                                    <div class="d-flex align-items-center mb-3">
                                                        <div class="notification-icon mr-3">
                                                            <c:choose>
                                                                <c:when test="${notification.type == 'success'}"><i class="fa fa-check"></i></c:when>
                                                                <c:when test="${notification.type == 'warning'}"><i class="fa fa-exclamation"></i></c:when>
                                                                <c:when test="${notification.type == 'danger'}"><i class="fa fa-times"></i></c:when>
                                                                <c:otherwise><i class="fa fa-bell"></i></c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="notification-content">
                                                            <p class="mb-1">${notification.title}</p>
                                                            <small class="text-muted">${notification.timestamp}</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="notification-empty">
                                                <i class="fa fa-bell-slash"></i>
                                                <p>No notifications available</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Financial Summary Card -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="widget-card widget-bg4">
                                <div class="wc-item">
                                    <h4 class="wc-title mb-4">
                                        Financial Summary
                                    </h4>
                                    <div class="financial-summary">
                                        <div class="financial-item">
                                            <p class="financial-label">Admin Wallet</p>
                                            <h3 class="financial-value">$
                                                <c:choose>
                                                    <c:when test="${not empty financialSummary.adminWalletBalance}">
                                                        <fmt:formatNumber value="${financialSummary.adminWalletBalance}" maxFractionDigits="0" />
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </h3>
                                        </div>
                                        <div class="financial-item">
                                            <p class="financial-label">Expert Wallets</p>
                                            <h3 class="financial-value">$
                                                <c:choose>
                                                    <c:when test="${not empty financialSummary.expertWalletBalance}">
                                                        <fmt:formatNumber value="${financialSummary.expertWalletBalance}" maxFractionDigits="0" />
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </h3>
                                        </div>
                                        <div class="financial-item">
                                            <p class="financial-label">Pending Payouts</p>
                                            <h3 class="financial-value">$
                                                <c:choose>
                                                    <c:when test="${not empty financialSummary.pendingPayouts}">
                                                        <fmt:formatNumber value="${financialSummary.pendingPayouts}" maxFractionDigits="0" />
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </h3>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Card END -->	
                    
                    <!-- New Users and Orders Section -->
                    <div class="row mt-4">
                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="table-container">
                                <h4 class="table-header">New Users</h4>
                                <table class="modern-table">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Email</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentUsers && recentUsers.size() > 0}">
                                                <c:forEach var="user" items="${recentUsers}">
                                                    <tr>
                                                        <td>${user.username}</td>
                                                        <td>${user.email}</td>
                                                        <td>${user.createdDate}</td>
                                                        <td>
                                                            <span class="status-badge 
                                                                <c:choose>
                                                                    <c:when test="${user.status == 1}">status-active</c:when>
                                                                    <c:otherwise>status-inactive</c:otherwise>
                                                                </c:choose>">
                                                                <c:choose>
                                                                    <c:when test="${user.status == 1}">Active</c:when>
                                                                    <c:otherwise>Inactive</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center">No recent users found</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="table-container">
                                <h4 class="table-header">Orders</h4>
                                <table class="modern-table">
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Course</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentOrders && recentOrders.size() > 0}">
                                                <c:forEach var="order" items="${recentOrders}">
                                                    <tr>
                                                        <td>${order.id}</td>
                                                        <td>${order.courseName}</td>
                                                        <td>$${order.amount}</td>
                                                        <td>
                                                            <span class="status-badge 
                                                                <c:choose>
                                                                    <c:when test="${order.status == 'Completed'}">status-active</c:when>
                                                                    <c:when test="${order.status == 'Pending'}">status-pending</c:when>
                                                                    <c:otherwise>status-inactive</c:otherwise>
                                                                </c:choose>">
                                                                ${order.status}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center">No recent orders found</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        <div class="ttr-overlay"></div>      
    </body>
    <script src="assets/admin/assets/js/jquery.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
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
    
    <!-- Chart.js initialization -->
    <script>
        $(document).ready(function() {
            // Profile Views Chart
            var ctx = document.getElementById('profileViewsChart').getContext('2d');
            
            // Get monthly profile views data from server
            var monthlyViewsData = {};
            <c:if test="${not empty monthlyProfileViews}">
                <c:forEach var="entry" items="${monthlyProfileViews}">
                    monthlyViewsData['${entry.key}'] = ${entry.value};
                </c:forEach>
            </c:if>
            
            // If no data, use default values
            var months = ['January', 'February', 'March', 'April', 'May', 'June'];
            var viewData = [];
            
            // Populate data from server or use defaults
            if (Object.keys(monthlyViewsData).length > 0) {
                months = Object.keys(monthlyViewsData);
                for (var i = 0; i < months.length; i++) {
                    viewData.push(monthlyViewsData[months[i]]);
                }
            } else {
                viewData = [200, 150, 220, 350, 210, 250];
            }
            
            var chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: months,
                    datasets: [{
                        label: 'Profile Views',
                        data: viewData,
                        backgroundColor: 'rgba(102, 51, 153, 0.1)',
                        borderColor: '#663399',
                        borderWidth: 2,
                        pointBackgroundColor: '#663399',
                        pointRadius: 4,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
            
            // Initialize counter
            $('.counter').counterUp({
                delay: 10,
                time: 1000
            });
        });
    </script>
    <script>
        // Handle date range selection
        document.addEventListener('DOMContentLoaded', function() {
            const dateRangeSelect = document.getElementById('dateRangeSelect');
            const customDateRange = document.getElementById('customDateRange');
            
            // Show/hide custom date inputs based on selection
            dateRangeSelect.addEventListener('change', function() {
                if (this.value === 'custom') {
                    customDateRange.style.display = 'block';
                } else {
                    customDateRange.style.display = 'none';
                }
            });
            
            // Set default dates for custom range
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            
            // Set default start date to first day of current month
            const today = new Date();
            const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
            startDateInput.valueAsDate = firstDayOfMonth;
            
            // Set default end date to today
            endDateInput.valueAsDate = today;
        });
    </script>
    <script>
        // Profile Views Chart
        const ctx = document.getElementById('profileViewsChart').getContext('2d');
        const profileViewsChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Profile Views',
                    data: [
                        <c:forEach var="views" items="${monthlyProfileViews}" varStatus="status">
                            ${views}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2,
                    pointBackgroundColor: 'rgba(54, 162, 235, 1)',
                    pointRadius: 4,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
    <script>
        // Set progress bar widths dynamically to avoid CSS lint errors with JSP EL expressions
        document.addEventListener('DOMContentLoaded', function() {
            // Profit growth progress bar
            var profitGrowthValue = <c:out value="${growthPercentages.profitGrowth}" default="0"/>;
            document.querySelector('.row:first-of-type .widget-card.widget-bg1 .progress-bar').style.width = profitGrowthValue + '%';
            
            // Feedback growth progress bar
            var feedbackGrowthValue = <c:out value="${growthPercentages.feedbackGrowth}" default="0"/>;
            document.querySelector('.row:first-of-type .widget-card.widget-bg2 .progress-bar').style.width = feedbackGrowthValue + '%';
            
            // Order growth progress bar
            var orderGrowthValue = <c:out value="${growthPercentages.orderGrowth}" default="0"/>;
            document.querySelector('.widget-card.widget-bg3 .progress-bar').style.width = orderGrowthValue + '%';
            
            // User growth progress bar
            var userGrowthValue = <c:out value="${growthPercentages.userGrowth}" default="0"/>;
            document.querySelector('.widget-card.widget-bg4 .progress-bar').style.width = userGrowthValue + '%';
            
            // Course growth progress bar
            var courseGrowthValue = <c:out value="${growthPercentages.courseGrowth}" default="0"/>;
            document.querySelector('.row:nth-of-type(4) .widget-card.widget-bg1 .progress-bar').style.width = courseGrowthValue + '%';
            
            // Blog growth progress bar
            var blogGrowthValue = <c:out value="${growthPercentages.blogGrowth}" default="0"/>;
            document.querySelector('.row:nth-of-type(4) .widget-card.widget-bg2 .progress-bar').style.width = blogGrowthValue + '%';
        });
    </script>
</html>
