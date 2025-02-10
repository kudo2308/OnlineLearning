<%-- 
    Document   : admin.jsp
    Created on : Feb 8, 2025, 1:51:31 PM
    Author     : ducba
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
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
        .content {
            margin-left: 250px;
            padding: 20px;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ddd;
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .notification-panel {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3 class="text-center">EduChamp</h3>
        <a href="#"><i class="fa fa-tachometer-alt"></i> Dashboard</a>
        <a href="#"><i class="fa fa-users"></i> User List</a>
        <a href="#"><i class="fa fa-book"></i> Courses</a>
        <a href="#"><i class="fa fa-envelope"></i> Mailbox</a>
        <a href="#"><i class="fa fa-calendar"></i> Calendar</a>
        <a href="#"><i class="fa fa-bookmark"></i> Bookmarks</a>
        <a href="#"><i class="fa fa-star"></i> Review</a>
        <a href="#"><i class="fa fa-plus"></i> Add Listing</a>
        <a href="#"><i class="fa fa-user"></i> My Profile</a>
    </div>

    <div class="content">
        <div class="dashboard-header">
            <h2>Dashboard</h2>
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <a href="#" class=" fa fa-bell"></a>
                
            </div>
            <div class="col-md-4">
               
                <a href="#" class="fa fa-user"></a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <h5>Total User</h5>
                    
                    <h3></h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <h5>New Feedbacks</h5>
                    <h3>120</h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <h5>New Orders</h5>
                    <h3>772</h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <h5>New Users</h5>
                    <h3>350</h3>
                </div>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-md-6">
                
            </div>
        </div>
    </div>
</body>
</html>

