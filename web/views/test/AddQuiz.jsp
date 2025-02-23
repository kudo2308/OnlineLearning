<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Quiz</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background: #f5f7fa;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .container {
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 600px;
            }

            h1 {
                color: #2c3e50;
                text-align: center;
                margin-bottom: 30px;
                font-size: 2em;
                font-weight: 600;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #34495e;
                font-weight: 500;
            }

            input[type="text"],
            input[type="number"],
            textarea,
            select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: #f8fafc;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            textarea:focus,
            select:focus {
                outline: none;
                border-color: #4299e1;
                box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
            }

            button[type="submit"] {
                background: #4299e1;
                color: white;
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                width: 100%;
                transition: all 0.3s ease;
            }

            button[type="submit"]:hover {
                background: #3182ce;
                transform: translateY(-1px);
            }

            .error-message {
                color: #e53e3e;
                background: #fff5f5;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #feb2b2;
            }

            .success-message {
                color: #38a169;
                background: #f0fff4;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #9ae6b4;
            }

            @media (max-width: 480px) {
                .container {
                    padding: 20px;
                }

                h1 {
                    font-size: 1.5em;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Add New Quiz</h1>
            <form action="${pageContext.request.contextPath}/AddQuiz" method="POST">
                <input type="hidden" name="action" value="add">
             
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="duration">Duration (minutes):</label>
                    <input type="number" id="duration" name="duration" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="passRate">Pass Rate (%):</label>
                    <input type="number" id="passRate" name="passRate" min="0" max="100" required>
                </div>
                
                <div class="form-group">
                    <label for="totalQuestion">Total Questions:</label>
                    <input type="number" id="totalQuestion" name="totalQuestion" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="courseID">Course:</label>
                    <select id="courseID" name="courseID" required>
                        <option value="">Select a course</option>
                        <c:forEach items="${courses}" var="course">
                            <option value="${course.courseID}">${course.title}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <button type="submit">Create Quiz</button>
            </form>
        </div>
    </body>
</html>
