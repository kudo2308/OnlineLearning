<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quiz Review</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .header {
                text-align: center;
                margin-bottom: 20px;
            }
            .question-container {
                margin-bottom: 20px;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .question-number {
                font-weight: bold;
                margin-bottom: 10px;
            }
            .options {
                list-style-type: none;
                padding: 0;
            }
            .option {
                margin: 5px 0;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .correct-answer {
                background-color: #e8f5e9;
                border-color: #4caf50;
            }
            .button-container {
                text-align: center;
                margin-top: 20px;
            }
            .button {
                display: inline-block;
                padding: 10px 20px;
                margin: 0 10px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Quiz Review</h1>
            </div>
            
            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-container">
                    <div class="question-number">Question ${status.index + 1}</div>
                    <div class="question-text">${question.content}</div>
                    <ul class="options">
                        <c:forEach items="${question.answers}" var="answer">
                            <li class="option ${answer.isCorrect() ? 'correct-answer' : ''}">
                                ${answer.content}
                                <c:if test="${answer.isCorrect()}">
                                    <span style="color: green; margin-left: 10px;">(Correct Answer)</span>
                                    <div class="explanation" style="margin-top: 10px; padding: 10px; background-color: #f5f5f5; border-left: 3px solid #4CAF50;">
                                        <strong>Explanation:</strong> ${answer.explanation}
                                    </div>
                                </c:if>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:forEach>
            
            <div class="button-container">
                <a href="${pageContext.request.contextPath}/Test?action=take&id=${quiz.quizID}" class="button">Try Again</a>
                <a href="${pageContext.request.contextPath}/Quiz" class="button">Back to Quiz List</a>
            </div>
        </div>
    </body>
</html>
