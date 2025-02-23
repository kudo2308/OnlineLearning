<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quiz Results</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 20px;
            }
            
            .container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .result-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .result-header h1 {
                color: #333;
                margin-bottom: 10px;
            }
            
            .quiz-info {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }
            
            .score-display {
                text-align: center;
                margin: 30px 0;
            }
            
            .score-circle {
                width: 200px;
                height: 200px;
                border-radius: 50%;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                font-size: 2.5em;
                color: white;
                position: relative;
            }
            
            .passed {
                background-color: #4CAF50;
            }
            
            .failed {
                background-color: #f44336;
            }
            
            .score-text {
                font-size: 0.4em;
                margin-top: 5px;
            }
            
            .result-details {
                margin-top: 30px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 8px;
            }
            
            .result-details p {
                margin: 10px 0;
                color: #666;
            }
            
            .action-buttons {
                margin-top: 30px;
                text-align: center;
            }
            
            .btn {
                display: inline-block;
                padding: 10px 20px;
                margin: 0 10px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                font-size: 1em;
                transition: background-color 0.3s;
            }
            
            .btn-primary {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-secondary {
                background-color: #2196F3;
                color: white;
            }
            
            .btn:hover {
                opacity: 0.9;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="result-header">
                <h1>Quiz Results</h1>
                <h2>${quiz.name}</h2>
            </div>
            
            <div class="quiz-info">
                <p>${quiz.description}</p>
                <p>Duration: ${quiz.duration} minutes</p>
                <p>Pass Rate: ${quiz.passRate}%</p>
            </div>
            
            <div class="score-display">
                <div class="score-circle ${passed ? 'passed' : 'failed'}">
                    <div class="score-text">
                        <h2>${String.format("%.1f", percentage)}%</h2>
                        <p>Score: ${String.format("%.1f", score)} / ${totalPoints}</p>
                    </div>
                </div>
                
                <div class="result-message">
                    <h3>${passed ? 'Congratulations! You passed!' : 'Sorry, you did not pass.'}</h3>
                    <p>Pass rate required: ${quiz.passRate}%</p>
                </div>

                <div class="score-details" style="margin-top: 20px; text-align: left; padding: 20px; background: #f8f9fa; border-radius: 8px;">
                    <h4>Score Details:</h4>
                    <table style="width: 100%; border-collapse: collapse;">
                        <tr>
                            <td style="padding: 8px 0;">Total Questions:</td>
                            <td>${totalQuestions}</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 0;">Total Score:</td>
                            <td>${String.format("%.1f", score)} points</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 0;">Total Points Possible:</td>
                            <td>${totalPoints} points</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 0;">Score Percentage:</td>
                            <td>${String.format("%.1f", percentage)}%</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 0;">Pass Rate Required:</td>
                            <td>${quiz.passRate}%</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px 0;">Result Status:</td>
                            <td style="color: ${passed ? '#28a745' : '#dc3545'}; font-weight: bold;">
                                ${passed ? 'PASSED' : 'FAILED'}
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            
            <div class="navigation-buttons" style="text-align: center; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/Test?action=take&id=${quiz.quizID}" class="btn btn-primary" style="
                    display: inline-block;
                    padding: 10px 20px;
                    background-color: #4CAF50;
                    color: white;
                    text-decoration: none;
                    border-radius: 5px;
                    margin: 10px;">
                    Try Again
                </a>
                <a href="${pageContext.request.contextPath}/Quiz" class="btn btn-secondary" style="
                    display: inline-block;
                    padding: 10px 20px;
                    background-color: #6c757d;
                    color: white;
                    text-decoration: none;
                    border-radius: 5px;
                    margin: 10px;">
                    Back to Quiz List
                </a>
            </div>
        </div>
    </body>
</html>
