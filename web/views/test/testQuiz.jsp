<%-- 
    Document   : testQuiz
    Created on : Feb 23, 2025, 1:01:11 AM
    Author     : dohie
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style3.css" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning - Quiz</title>
        <%@include file="/common/header.jsp" %>
    </head>
    <body>
        
        <div class="container">
            <!-- Left Navigation -->
            <div class="quiz-navigation">
                <input type="search" placeholder="Search..." class="search-input">
                <ul>
                    <c:forEach items="${quizzes}" var="quiz">
                        <li>
                            <span class="material-icons">quiz</span>
                            <a href="${pageContext.request.contextPath}/Test?action=take&id=${quiz.quizID}">${quiz.name}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Main Content -->
            <main>
                <c:choose>
                    <c:when test="${empty quiz}">
                        <!-- Display list of quizzes -->
                        <h2>TEST LIST</h2>
                        <div class="quiz-list">
                            <c:forEach items="${quizzes}" var="quiz">
                                <div class="quiz-item">
                                    <div class="quiz-content">
                                        <h3>${quiz.name}</h3>
                                        <p>${quiz.description}</p>
                                        <div class="quiz-details">
                                            <span><i class="material-icons">timer</i> Duration: ${quiz.duration} minutes</span>
                                            <span><i class="material-icons">quiz</i> Questions: ${quiz.totalQuestion}</span>
                                            <span><i class="material-icons">grade</i> Pass Rate: ${quiz.passRate}%</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/Test?action=take&id=${quiz.quizID}" class="start-quiz-btn">
                                        START QUIZ <i class="material-icons">arrow_forward</i>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Display quiz questions -->
                        <div class="quiz-header">
                            <h2>${quiz.name}</h2>
                            <div class="quiz-info">
                                <p>${quiz.description}</p>
                                <div class="quiz-meta">
                                    <span><i class="material-icons">timer</i> Time Remaining: <span id="timer">${quiz.duration}:00</span></span>
                                    <span><i class="material-icons">quiz</i> Questions: ${quiz.totalQuestion}</span>
                                    <span><i class="material-icons">grade</i> Pass Rate: ${quiz.passRate}%</span>
                                </div>
                            </div>
                        </div>

                        <form id="quizForm" action="${pageContext.request.contextPath}/quiz?action=submit" method="post">
                            <input type="hidden" name="quizId" value="${quiz.quizID}">
                            <div class="questions-container">
                                <c:forEach items="${questions}" var="question" varStatus="status">
                                    <div class="question-item" id="question${status.index + 1}">
                                        <h3>Question ${status.index + 1} of ${quiz.totalQuestion}</h3>
                                        <p class="question-text">${question.content}</p>
                                        <div class="options">
                                            <c:forEach items="${question.answers}" var="answer">
                                                <label class="option">
                                                    <input type="radio" name="question${question.questionID}" value="${answer.answerID}" required>
                                                    ${answer.content}
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="navigation-buttons">
                                <button type="button" class="nav-btn prev-btn" onclick="showQuestion(currentQuestion - 1)" disabled>
                                    <span class="material-icons">arrow_back</span> Previous
                                </button>
                                <button type="submit" class="submit-btn" id="submitBtn">
                                    <span class="material-icons">done_all</span> Submit Quiz
                                </button>
                                <button type="button" class="nav-btn next-btn" onclick="showQuestion(currentQuestion + 1)">
                                    Next <span class="material-icons">arrow_forward</span>
                                </button>
                            </div>
                        </form>

                        <script>
                            let currentQuestion = 1;
                            const totalQuestions = ${quiz.totalQuestion};
                            let timeLeft = ${quiz.duration} * 60; // Convert minutes to seconds

                            function showQuestion(questionNumber) {
                                if (questionNumber < 1 || questionNumber > totalQuestions) return;
                                
                                // Hide all questions
                                document.querySelectorAll('.question-item').forEach(q => q.style.display = 'none');
                                
                                // Show the current question
                                document.getElementById('question' + questionNumber).style.display = 'block';
                                
                                // Update navigation buttons
                                document.querySelector('.prev-btn').disabled = questionNumber === 1;
                                document.querySelector('.next-btn').disabled = questionNumber === totalQuestions;
                                
                                currentQuestion = questionNumber;
                            }

                            // Initialize timer
                            function updateTimer() {
                                const minutes = Math.floor(timeLeft / 60);
                                const seconds = timeLeft % 60;
                                document.getElementById('timer').textContent = 
                                    minutes.toString().padStart(2, '0') + ':' + 
                                    seconds.toString().padStart(2, '0');
                                
                                if (timeLeft <= 300) { // 5 minutes remaining
                                    document.getElementById('timer').style.color = '#e74c3c';
                                }
                                
                                if (timeLeft <= 0) {
                                    clearInterval(timerInterval);
                                    document.getElementById('quizForm').submit();
                                }
                                
                                timeLeft--;
                            }

                            // Show first question on load
                            showQuestion(1);

                            // Start timer
                            const timerInterval = setInterval(updateTimer, 1000);
                            updateTimer();

                            // Form validation before submit
                            document.getElementById('quizForm').addEventListener('submit', function(e) {
                                const questions = document.querySelectorAll('.question-item');
                                let unanswered = [];
                                
                                questions.forEach((q, index) => {
                                    const inputs = q.querySelectorAll('input[type="radio"]:checked');
                                    if (inputs.length === 0) {
                                        unanswered.push(index + 1);
                                    }
                                });
                                
                                if (unanswered.length > 0) {
                                    e.preventDefault();
                                    alert('Please answer all questions before submitting.\nUnanswered questions: ' + unanswered.join(', '));
                                    showQuestion(unanswered[0]);
                                }
                            });
                        </script>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <footer>
            <p>&copy; 2025 Online Learning System</p>
        </footer>
    </body>
</html>