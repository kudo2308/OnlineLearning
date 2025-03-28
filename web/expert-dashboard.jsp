<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fordashboard.css">
    <!-- Dashboard Assets -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/color/color-1.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            border-radius: 10px 10px 0 0;
            font-weight: bold;
        }
        .stat-card {
            background: linear-gradient(to right, #4e73df, #224abe);
            color: white;
        }
        .stat-card .card-body {
            padding: 20px;
        }
        .stat-card .icon {
            font-size: 2rem;
            opacity: 0.7;
        }
        .stat-card .stat-value {
            font-size: 1.8rem;
            font-weight: bold;
        }
        .stat-card .stat-label {
            font-size: 0.9rem;
            text-transform: uppercase;
            opacity: 0.8;
        }
        .progress {
            height: 10px;
            border-radius: 5px;
        }
        .table-responsive {
            border-radius: 10px;
        }
        .date-filter {
            margin-bottom: 20px;
        }
        .dashboard-content {
            margin-left: 0;
            padding: 20px;
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
    <!-- Header -->
    <jsp:include page="common/dashboard/header-dashboard.jsp" />
    
    <div class="ttr-wrapper">
        <!-- Sidebar -->
        <jsp:include page="common/dashboard/left-sidebar-dashboard.jsp" />
        
        <!-- Main Content -->
        <div class="ttr-content">
            <div class="ttr-content-wrapper">
                <div class="container-fluid">
                    <h1 class="h2 mb-4">Expert Dashboard</h1>
                    
                    <!-- Date Range Filter -->
                    <div class="card date-filter">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/expert-dashboard" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label for="dateRange" class="form-label">Date Range</label>
                                    <select class="form-select" id="dateRange" name="dateRange" onchange="toggleCustomDateInputs()">
                                        <option value="today" ${dateRange == 'today' ? 'selected' : ''}>Today</option>
                                        <option value="yesterday" ${dateRange == 'yesterday' ? 'selected' : ''}>Yesterday</option>
                                        <option value="last7Days" ${dateRange == 'last7Days' ? 'selected' : ''}>Last 7 Days</option>
                                        <option value="last30Days" ${dateRange == 'last30Days' ? 'selected' : ''}>Last 30 Days</option>
                                        <option value="thisMonth" ${dateRange == 'thisMonth' ? 'selected' : ''}>This Month</option>
                                        <option value="lastMonth" ${dateRange == 'lastMonth' ? 'selected' : ''}>Last Month</option>
                                        <option value="custom" ${dateRange == 'custom' ? 'selected' : ''}>Custom Range</option>
                                    </select>
                                </div>
                                <div class="col-md-3 custom-date" style="display: ${dateRange == 'custom' ? 'block' : 'none'};">
                                    <label for="startDate" class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" 
                                           value="<fmt:formatDate value="${startDate}" pattern="yyyy-MM-dd" />">
                                </div>
                                <div class="col-md-3 custom-date" style="display: ${dateRange == 'custom' ? 'block' : 'none'};">
                                    <label for="endDate" class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" 
                                           value="<fmt:formatDate value="${endDate}" pattern="yyyy-MM-dd" />">
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary">Apply Filter</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Stats Overview -->
                    <div class="row">
                        <div class="col-md-3">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value">${totalCourses}</div>
                                            <div class="stat-label">Total Courses</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">+${newCourses} new in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card" style="background: linear-gradient(to right, #1cc88a, #13855c);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value">${totalStudents}</div>
                                            <div class="stat-label">Total Students</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">+${newStudents} new in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card" style="background: linear-gradient(to right, #36b9cc, #258391);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value">${totalLessons}</div>
                                            <div class="stat-label">Total Lessons</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-video"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">Across all courses</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card" style="background: linear-gradient(to right, #f6c23e, #dda20a);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00" /></div>
                                            <div class="stat-label">Total Revenue</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-dollar-sign"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">$<fmt:formatNumber value="${periodRevenue}" pattern="#,##0.00" /> in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Charts -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-chart-line me-2"></i> Monthly Registrations
                                </div>
                                <div class="card-body">
                                    <canvas id="registrationsChart"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-chart-bar me-2"></i> Monthly Revenue
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Registration Status -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-tasks me-2"></i> Registration Status
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <h6>Pending (${pendingRegistrations})</h6>
                                        <div class="progress">
                                            <div class="progress-bar bg-warning" role="progressbar" 
                                                 style="width: ${(pendingRegistrations / (pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations)) * 100}%" 
                                                 aria-valuenow="${pendingRegistrations}" aria-valuemin="0" 
                                                 aria-valuemax="${pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations}"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <h6>Active (${activeRegistrations})</h6>
                                        <div class="progress">
                                            <div class="progress-bar bg-primary" role="progressbar" 
                                                 style="width: ${(activeRegistrations / (pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations)) * 100}%" 
                                                 aria-valuenow="${activeRegistrations}" aria-valuemin="0" 
                                                 aria-valuemax="${pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations}"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <h6>Completed (${completedRegistrations})</h6>
                                        <div class="progress">
                                            <div class="progress-bar bg-success" role="progressbar" 
                                                 style="width: ${(completedRegistrations / (pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations)) * 100}%" 
                                                 aria-valuenow="${completedRegistrations}" aria-valuemin="0" 
                                                 aria-valuemax="${pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations}"></div>
                                        </div>
                                    </div>
                                    <div>
                                        <h6>Cancelled (${cancelledRegistrations})</h6>
                                        <div class="progress">
                                            <div class="progress-bar bg-danger" role="progressbar" 
                                                 style="width: ${(cancelledRegistrations / (pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations)) * 100}%" 
                                                 aria-valuenow="${cancelledRegistrations}" aria-valuemin="0" 
                                                 aria-valuemax="${pendingRegistrations + activeRegistrations + completedRegistrations + cancelledRegistrations}"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-dark text-white">
                                    <i class="fas fa-chart-pie me-2"></i> Course Status Distribution
                                </div>
                                <div class="card-body">
                                    <canvas id="courseStatusChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Data Tables -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-list me-2"></i> Recent Registrations
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Student</th>
                                                    <th>Course</th>
                                                    <th>Status</th>
                                                    <th>Progress</th>
                                                    <th>Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="registration" items="${recentRegistrations}">
                                                    <tr>
                                                        <td>${registration.user.fullName}</td>
                                                        <td>${registration.course.title}</td>
                                                        <td>
                                                            <span class="badge ${registration.status eq 'active' ? 'bg-primary' : 
                                                                                 registration.status eq 'completed' ? 'bg-success' : 
                                                                                 registration.status eq 'pending' ? 'bg-warning' : 'bg-danger'}">
                                                                ${registration.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="progress">
                                                                <div class="progress-bar" role="progressbar" 
                                                                     style="width: ${registration.progress}%" 
                                                                     aria-valuenow="${registration.progress}" 
                                                                     aria-valuemin="0" aria-valuemax="100">
                                                                    ${registration.progress}%
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><fmt:formatDate value="${registration.createdAt}" pattern="yyyy-MM-dd" /></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-money-bill-wave me-2"></i> Recent Transactions
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>User</th>
                                                    <th>Amount</th>
                                                    <th>Type</th>
                                                    <th>Status</th>
                                                    <th>Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="transaction" items="${recentTransactions}">
                                                    <tr>
                                                        <td>${transaction.user.fullName}</td>
                                                        <td>$<fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00" /></td>
                                                        <td>${transaction.transactionType}</td>
                                                        <td>
                                                            <span class="badge ${transaction.status eq 'completed' ? 'bg-success' : 
                                                                                 transaction.status eq 'pending' ? 'bg-warning' : 
                                                                                 transaction.status eq 'failed' ? 'bg-danger' : 'bg-secondary'}">
                                                                ${transaction.status}
                                                            </span>
                                                        </td>
                                                        <td><fmt:formatDate value="${transaction.createdAt}" pattern="yyyy-MM-dd" /></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Courses -->
                    <div class="row mt-4">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-book me-2"></i> Recent Courses
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Title</th>
                                                    <th>Category</th>
                                                    <th>Price</th>
                                                    <th>Status</th>
                                                    <th>Lessons</th>
                                                    <th>Created</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="course" items="${recentCourses}">
                                                    <tr>
                                                        <td>${course.title}</td>
                                                        <td>${course.category.name}</td>
                                                        <td>$<fmt:formatNumber value="${course.price}" pattern="#,##0.00" /></td>
                                                        <td>
                                                            <span class="badge ${course.status eq 'public' ? 'bg-success' : 
                                                                                 course.status eq 'private' ? 'bg-warning' : 
                                                                                 course.status eq 'draft' ? 'bg-secondary' : 'bg-danger'}">
                                                                ${course.status}
                                                            </span>
                                                        </td>
                                                        <td>${course.totalLesson}</td>
                                                        <td><fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" /></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- External JavaScripts -->
    <script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/waypoints-min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/counterup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/masonry.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/filter.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
    
    <script>
        // Toggle custom date inputs based on date range selection
        function toggleCustomDateInputs() {
            const dateRange = document.getElementById('dateRange').value;
            const customDateInputs = document.querySelectorAll('.custom-date');
            
            customDateInputs.forEach(input => {
                input.style.display = dateRange === 'custom' ? 'block' : 'none';
            });
        }
        
        // Chart for Monthly Registrations
        const registrationsCtx = document.getElementById('registrationsChart').getContext('2d');
        const registrationsChart = new Chart(registrationsCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="entry" items="${monthlyRegistrations}" varStatus="status">
                        '${entry.key}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Registrations',
                    data: [
                        <c:forEach var="entry" items="${monthlyRegistrations}" varStatus="status">
                            ${entry.value}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(78, 115, 223, 0.2)',
                    borderColor: 'rgba(78, 115, 223, 1)',
                    borderWidth: 2,
                    pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: 'rgba(78, 115, 223, 1)',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
        
        // Chart for Monthly Revenue
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach var="entry" items="${monthlyRevenue}" varStatus="status">
                        '${entry.key}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Revenue ($)',
                    data: [
                        <c:forEach var="entry" items="${monthlyRevenue}" varStatus="status">
                            ${entry.value}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(28, 200, 138, 0.6)',
                    borderColor: 'rgba(28, 200, 138, 1)',
                    borderWidth: 1
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
        
        // Chart for Course Status Distribution
        const courseStatusCtx = document.getElementById('courseStatusChart').getContext('2d');
        const courseStatusChart = new Chart(courseStatusCtx, {
            type: 'doughnut',
            data: {
                labels: [
                    <c:forEach var="entry" items="${courseStatusDistribution}" varStatus="status">
                        '${entry.key}'${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    data: [
                        <c:forEach var="entry" items="${courseStatusDistribution}" varStatus="status">
                            ${entry.value}${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: [
                        'rgba(28, 200, 138, 0.8)',  // public
                        'rgba(246, 194, 62, 0.8)',  // private
                        'rgba(108, 117, 125, 0.8)', // draft
                        'rgba(231, 74, 59, 0.8)'    // deleted
                    ],
                    borderColor: [
                        'rgba(28, 200, 138, 1)',
                        'rgba(246, 194, 62, 1)',
                        'rgba(108, 117, 125, 1)',
                        'rgba(231, 74, 59, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    </script>
</body>
</html>
