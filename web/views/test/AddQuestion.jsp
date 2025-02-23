<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Question</title>
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
                max-width: 800px;
                margin: 20px auto;
            }

            h1 {
                color: #2c3e50;
                text-align: center;
                margin-bottom: 30px;
                font-size: 2em;
                font-weight: 600;
            }

            .progress-info {
                background: #ebf8ff;
                color: #2b6cb0;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-weight: 500;
                border: 1px solid #bee3f8;
            }

            .form-group, .select-group {
                margin-bottom: 24px;
            }

            .answer-group {
                background: #f8fafc;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #e2e8f0;
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
                background: white;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            textarea:focus,
            select:focus {
                outline: none;
                border-color: #4299e1;
                box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
            }

            .radio-group {
                display: flex;
                align-items: center;
                margin-top: 8px;
            }

            .radio-group input[type="radio"] {
                margin-right: 8px;
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .radio-group label {
                margin: 0;
                cursor: pointer;
            }

            button[type="submit"] {
                background: #4299e1;
                color: white;
                padding: 14px 28px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                width: 100%;
                transition: all 0.3s ease;
                margin-top: 20px;
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

            .answer-header {
                color: #2d3748;
                font-weight: 600;
                margin-bottom: 16px;
                padding-bottom: 8px;
                border-bottom: 2px solid #e2e8f0;
            }

            .explanation-field {
                margin-top: 12px;
            }

            @media (max-width: 768px) {
                .container {
                    padding: 20px;
                }

                h1 {
                    font-size: 1.5em;
                }

                .answer-group {
                    padding: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Add New Question</h1>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <c:if test="${remainingQuestions != null}">
                <div class="progress-info">
                    <p>Remaining questions to add: ${remainingQuestions}</p>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/AddQuestion" method="POST" id="questionForm">
                <input type="hidden" name="action" value="add">
                
                <div class="select-group">
                    <label for="quizID">Select Quiz:</label>
                    <select id="quizID" name="quizID" required ${selectedQuizId != null ? 'readonly' : ''}>
                        <option value="">-- Select a quiz --</option>
                        <c:forEach items="${quizzes}" var="quiz">
                            <option value="${quiz.quizID}" ${quiz.quizID == selectedQuizId ? 'selected' : ''}>${quiz.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="content">Question Content:</label>
                    <textarea id="content" name="content" rows="4" required placeholder="Enter your question here"></textarea>
                </div>

                <div class="form-group">
                    <label for="pointPerQuestion">Points:</label>
                    <input type="number" id="pointPerQuestion" name="pointPerQuestion" required min="1" placeholder="Enter points for this question">
                </div>

                <!-- Answer Options -->
                <div class="answers-container">
                    <c:forEach begin="0" end="3" var="i">
                        <div class="answer-group">
                            <div class="answer-header">Answer Option ${i + 1}</div>
                            
                            <div class="form-group">
                                <label for="answerContent${i}">Answer Content:</label>
                                <input type="text" id="answerContent${i}" name="answerContent[]" required placeholder="Enter answer option ${i + 1}">
                            </div>
                            
                            <div class="radio-group">
                                <input type="radio" id="isCorrect${i}" name="isCorrect" value="${i}" required>
                                <label for="isCorrect${i}">Correct Answer</label>
                            </div>
                            
                            <div class="explanation-field">
                                <label for="explanation${i}">Explanation (Optional):</label>
                                <textarea id="explanation${i}" name="explanation[]" rows="2" placeholder="Explain why this answer is correct/incorrect"></textarea>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <button type="submit">Add Question</button>
            </form>
        </div>
        
        <script>
            document.getElementById('questionForm').onsubmit = function(e) {
                // Validate quiz selection
                const quizSelect = document.getElementById('quizID');
                if (!quizSelect.value) {
                    e.preventDefault();
                    alert('Please select a quiz');
                    quizSelect.focus();
                    return false;
                }
                
                // Validate correct answer selection
                const radioButtons = document.querySelectorAll('input[name="isCorrect"]');
                let hasCorrectAnswer = false;
                radioButtons.forEach(radio => {
                    if (radio.checked) hasCorrectAnswer = true;
                });
                
                if (!hasCorrectAnswer) {
                    e.preventDefault();
                    alert('Please select one correct answer.');
                    return false;
                }
                return true;
            };
        </script>
    </body>
</html>
