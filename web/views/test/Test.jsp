<%-- 
    Document   : Test
    Created on : Feb 23, 2025, 2:15:52 AM
    Author     : dohie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Quiz</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/test.css">
    </head>
    <body>
        <div class="container">
            <!-- Left Sidebar -->
            <div class="left-sidebar">
                <input type="search" placeholder="Search...">
                <ul class="quiz-list">
                    <c:forEach items="${quizList}" var="quiz">
                        <li><a href="Test?action=take&id=${quiz.quizID}">${quiz.name}</a></li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1>TEST QUIZ</h1>
                
                <form action="Test" method="post">
                    <input type="hidden" name="quizId" value="${quiz.quizID}">
                    
                    <c:if test="${not empty quiz}">
                        <div class="quiz-info">
                            <h2>${quiz.name}</h2>
                            <p>${quiz.description}</p>
                            <div class="quiz-meta">
                                <span>Duration: ${quiz.duration} minutes</span>
                                <span>Total Questions: ${quiz.totalQuestion}</span>
                                <span>Pass Rate: ${quiz.passRate}%</span>
                            </div>
                        </div>
                    </c:if>

                    <div class="question-container">
                        <c:if test="${not empty currentQuestion}">
                            <p class="question-text">${currentQuestion.content}</p>
                            <div class="options">
                                <c:forEach var="i" begin="1" end="4">
                                    <label class="option">
                                        <input type="radio" name="question${currentQuestion.questionID}" value="${i}">
                                        Option ${i}
                                    </label>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <!-- Question Numbers -->
                    <div class="question-numbers">
                        <c:forEach begin="1" end="${totalQuestions}" var="num">
                            <span class="question-number ${currentQuestionNum == num ? 'active' : ''}" 
                                  onclick="goToQuestion(${num})">${num}</span>
                        </c:forEach>
                    </div>

                    <!-- Navigation -->
                    <div class="navigation-buttons">
                        <button type="button" class="nav-btn" onclick="prevQuestion()">PREV</button>
                        <button type="submit" name="action" value="submit" class="nav-btn">SUBMIT</button>
                        <button type="button" class="nav-btn" onclick="nextQuestion()">NEXT</button>
                    </div>

                    <!-- Comment Section -->
                    <div class="comment-section">
                        <h3>COMMENT ABOUT TEST QUIZ</h3>
                        <textarea name="comment" placeholder="Enter your comment here..."></textarea>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function goToQuestion(num) {
                // Add logic to navigate to specific question
                document.querySelector('.question-number.active').classList.remove('active');
                document.querySelector('.question-number:nth-child(' + num + ')').classList.add('active');
                
                // Make AJAX call to load question content
                fetch('Test?action=question&num=' + num)
                    .then(response => response.json())
                    .then(data => {
                        // Update question content
                        document.querySelector('.question-text').textContent = data.content;
                        // Update options
                        let options = document.querySelectorAll('.option input');
                        options.forEach((option, index) => {
                            option.checked = false;
                            if (data.selectedAnswer === (index + 1)) {
                                option.checked = true;
                            }
                        });
                    });
            }

            function prevQuestion() {
                let currentNum = parseInt(document.querySelector('.question-number.active').textContent);
                if (currentNum > 1) {
                    goToQuestion(currentNum - 1);
                }
            }

            function nextQuestion() {
                let currentNum = parseInt(document.querySelector('.question-number.active').textContent);
                if (currentNum < ${totalQuestions}) {
                    goToQuestion(currentNum + 1);
                }
            }
        </script>
    </body>
</html>
