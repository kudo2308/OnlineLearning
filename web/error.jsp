<%-- 
    Document   : error
    Created on : Feb 23, 2025, 3:22:25 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang Lỗi</title>
        <style>
            body {
                background: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                color: #333;
            }
            .container {
                max-width: 600px;
                margin: 80px auto;
                padding: 30px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }
            h1 {
                color: #dc3545;
                font-size: 36px;
                margin-bottom: 10px;
            }
            p {
                font-size: 18px;
                line-height: 1.6;
            }
            .error-details {
                margin-top: 20px;
                padding: 15px;
                background: #f1f1f1;
                border-left: 4px solid #dc3545;
                border-radius: 4px;
                font-size: 16px;
            }
            a {
                color: #007bff;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            .btn-home {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background: #007bff;
                color: #fff;
                border-radius: 4px;
                text-decoration: none;
            }
            .btn-home:hover {
                background: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Oops! Đã xảy ra lỗi.</h1>
            <p>Xin lỗi, trang bạn yêu cầu không thể hiển thị do có sự cố xảy ra.</p>

            <div class="error-details">
                <p><strong>Lỗi chi tiết:</strong></p>
                <p>${msg}</p>
            </div>

            <p>Bạn có thể quay lại trang chủ hoặc thử lại sau.</p>
            
        </div>
    </body>
</html>

