<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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
    <jsp:include page="./public/header-admin.jsp"></jsp:include>
    
    <div class="ttr-wrapper">
        <!-- Sidebar -->
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>
        
        <!-- Main Content -->
        <div class="ttr-content">
            <div class="ttr-content-wrapper">
                <div class="container-fluid">
                    <h1 class="h2 mb-4">Admin Dashboard</h1>
                    <!-- Date Range Filter -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/admin-dashboard" method="get" class="row g-3 align-items-center">
                                        <div class="col-md-3">
                                            <label for="dateRange" class="form-label">Date Range</label>
                                            <div class="input-group">
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
                                            <button type="submit" class="btn btn-warning">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
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
                                            <div class="stat-value">${totalUsers}</div>
                                            <div class="stat-label">Total Users</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">+${newUsers} new in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card" style="background: linear-gradient(to right, #36b9cc, #258391);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value">${totalRegistrations}</div>
                                            <div class="stat-label">Total Registrations</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-clipboard-list"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">+${newRegistrations} new in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card" style="background: linear-gradient(to right, #f6c23e, #dda20a);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$" maxFractionDigits="0" /></div>
                                            <div class="stat-label">Total Revenue</div>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="text-white-50">+<fmt:formatNumber value="${periodRevenue}" type="currency" currencySymbol="$" maxFractionDigits="0" /> in this period</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Card END -->  
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-chart-line me-2"></i> Monthly Registrations
                                </div>
                                <div class="card-body">
                                    <canvas id="registrationChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-money-bill-wave me-2"></i> Monthly Revenue
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-tasks me-2"></i> Registration Status
                                </div>
                                <div class="card-body">
                                    <canvas id="registrationStatusChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-warning text-white">
                                    <i class="fas fa-chart-pie me-2"></i> Course Distribution
                                </div>
                                <div class="card-body">
                                    <canvas id="courseStatusChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-list me-2"></i> Recent Registrations
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Student</th>
                                                    <th>Course</th>
                                                    <th>Registration Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="registration" items="${recentRegistrations}" varStatus="status">
                                                    <tr>
                                                        <td>${registration.user.fullName}</td>
                                                        <td>${registration.course.title}</td>
                                                        <td><fmt:formatDate value="${registration.createdAt}" pattern="dd/MM/yyyy" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${registration.status == 'Completed'}">
                                                                    <span class="badge bg-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${registration.status == 'In Progress'}">
                                                                    <span class="badge bg-primary">In Progress</span>
                                                                </c:when>
                                                                <c:when test="${registration.status == 'Pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${registration.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty recentRegistrations}">
                                                    <tr>
                                                        <td colspan="4" class="text-center">No recent registrations</td>
                                                    </tr>
                                                </c:if>
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
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Student</th>
                                                    <th>Course</th>
                                                    <th>Amount</th>
                                                    <th>Payment Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="transaction" items="${recentTransactions}" varStatus="status">
                                                    <tr>
                                                        <td>${transaction.user.fullName}</td>
                                                        <td>${transaction.course.title}</td>
                                                        <td><fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="$" maxFractionDigits="0" /></td>
                                                        <td><fmt:formatDate value="${transaction.createdAt}" pattern="dd/MM/yyyy" /></td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty recentTransactions}">
                                                    <tr>
                                                        <td colspan="4" class="text-center">No recent transactions</td>
                                                    </tr>
                                                </c:if>
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
    <div class="ttr-overlay"></div>      
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/waypoints-min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/counterup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/masonry.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/filter.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src='${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>

<!-- Chart.js initialization -->
<script>
    $(document).ready(function() {
        // Registration chart
        const registrationCtx = document.getElementById('registrationChart').getContext('2d');
        
        // Parse monthly registration data from server
        let monthlyRegistrations = {};
        <c:forEach items="${monthlyRegistrations}" var="entry">
            monthlyRegistrations['${entry.key}'] = ${entry.value};
        </c:forEach>
        
        // Log data for debugging
        console.log("Monthly Registration Data:", monthlyRegistrations);
        
        // Get months in chronological order (they should already be sorted from the DAO)
        const months = Object.keys(monthlyRegistrations);
        const registrationCounts = months.map(month => monthlyRegistrations[month]);
        
        // Format months for display (yyyy-MM to MMM yyyy)
        const formattedMonths = months.map(month => {
            const [year, monthNum] = month.split('-');
            return new Date(year, monthNum - 1).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
        });
        
        new Chart(registrationCtx, {
            type: 'bar',
            data: {
                labels: formattedMonths,
                datasets: [{
                    label: 'Course Registrations',
                    data: registrationCounts,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)',
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1,
                    borderRadius: 5
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
                        },
                        title: {
                            display: true,
                            text: 'Number of Registrations'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Month'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Registrations: ' + context.raw;
                            }
                        }
                    }
                }
            }
        });
        
        // Registration Status Chart
        const registrationStatusCtx = document.getElementById('registrationStatusChart').getContext('2d');
        
        // Calculate total registrations and percentages
        const totalRegistrationsCount = ${pendingRegistrations} + ${activeRegistrations} + ${completedRegistrations} + ${cancelledRegistrations};
        const pendingPercentage = Math.round((${pendingRegistrations} / totalRegistrationsCount) * 100) || 0;
        const activePercentage = Math.round((${activeRegistrations} / totalRegistrationsCount) * 100) || 0;
        const completedPercentage = Math.round((${completedRegistrations} / totalRegistrationsCount) * 100) || 0;
        const cancelledPercentage = Math.round((${cancelledRegistrations} / totalRegistrationsCount) * 100) || 0;
        
        new Chart(registrationStatusCtx, {
            type: 'doughnut',
            data: {
                labels: [
                    'Pending (' + pendingPercentage + '%)',
                    'Active (' + activePercentage + '%)',
                    'Completed (' + completedPercentage + '%)',
                    'Cancelled (' + cancelledPercentage + '%)'
                ],
                datasets: [{
                    data: [
                        ${pendingRegistrations},
                        ${activeRegistrations},
                        ${completedRegistrations},
                        ${cancelledRegistrations}
                    ],
                    backgroundColor: [
                        'rgba(255, 193, 7, 0.8)',
                        'rgba(13, 110, 253, 0.8)',
                        'rgba(25, 135, 84, 0.8)',
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderColor: [
                        'rgba(255, 193, 7, 1)',
                        'rgba(13, 110, 253, 1)',
                        'rgba(25, 135, 84, 1)',
                        'rgba(220, 53, 69, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            font: {
                                size: 12
                            },
                            padding: 20
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw;
                                const percentage = Math.round((value / totalRegistrationsCount) * 100);
                                return `${label}: ${value}`;
                            }
                        }
                    }
                },
                elements: {
                    arc: {
                        borderWidth: 0
                    }
                },
                cutout: '60%'
            }
        });
        
        // Course Status Chart
        const courseStatusCtx = document.getElementById('courseStatusChart').getContext('2d');
        new Chart(courseStatusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Draft', 'Archived'],
                datasets: [{
                    data: [
                        ${courseDAO.getCoursesCountByStatus('Active')},
                        ${courseDAO.getCoursesCountByStatus('Draft')},
                        ${courseDAO.getCoursesCountByStatus('Archived')}
                    ],
                    backgroundColor: [
                        'rgba(25, 135, 84, 0.8)',
                        'rgba(13, 110, 253, 0.8)',
                        'rgba(108, 117, 125, 0.8)'
                    ],
                    borderColor: [
                        'rgba(25, 135, 84, 1)',
                        'rgba(13, 110, 253, 1)',
                        'rgba(108, 117, 125, 1)'
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
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw;
                                const total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                                const percentage = Math.round((value / total) * 100);
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    });
</script>
<script>
    // Total Revenue Chart
    const ctx = document.getElementById('revenueChart').getContext('2d');
    
    // Parse monthly revenue data from server
    let monthlyRevenueData = {};
    <c:forEach items="${monthlyRevenue}" var="entry">
        monthlyRevenueData['${entry.key}'] = ${entry.value};
    </c:forEach>
    
    // Log data for debugging
    console.log("Monthly Revenue Data:", monthlyRevenueData);
    
    // Get months in chronological order (they should already be sorted from the DAO)
    const revenueMonths = Object.keys(monthlyRevenueData);
    const revenueValues = revenueMonths.map(month => monthlyRevenueData[month]);
    
    // Format months for display (yyyy-MM to MMM yyyy)
    const formattedRevenueMonths = revenueMonths.map(month => {
        const [year, monthNum] = month.split('-');
        return new Date(year, monthNum - 1).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
    });
    
    const revenueChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: formattedRevenueMonths,
            datasets: [{
                label: 'Revenue ($)',
                data: revenueValues,
                backgroundColor: 'rgba(46, 204, 113, 0.2)',
                borderColor: 'rgba(46, 204, 113, 1)',
                borderWidth: 2,
                pointBackgroundColor: 'rgba(46, 204, 113, 1)',
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
                    ticks: {
                        callback: function(value) {
                            return '$' + value.toLocaleString('en-US');
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Revenue: $' + context.raw.toLocaleString('en-US');
                        }
                    }
                }
            }
        }
    });
    
    // Toggle custom date inputs based on date range selection
    function toggleCustomDateInputs() {
        const dateRange = document.getElementById('dateRange').value;
        const customDateInputs = document.querySelectorAll('.custom-date');
        
        customDateInputs.forEach(input => {
            input.style.display = dateRange === 'custom' ? 'block' : 'none';
        });
    }
</script>
</html>
