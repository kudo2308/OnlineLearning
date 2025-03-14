<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Quiz</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/test.css">
        <style>
            .quiz-info {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .quiz-meta {
                display: flex;
                gap: 20px;
                margin-top: 10px;
                color: #666;
            }

            .question-container {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .question-text {
                font-size: 1.2em;
                margin-bottom: 20px;
                color: #333;
            }

            .options {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .option {
                display: block;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .option:hover {
                background-color: #f5f5f5;
            }

            .option.selected {
                background-color: #2196F3;
                color: white;
                border-color: #2196F3;
            }

            .question-numbers {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin: 20px 0;
            }

            .question-number {
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 1px solid #ddd;
                border-radius: 50%;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .question-number:hover {
                background-color: #f5f5f5;
            }

            .question-number.active {
                background-color: #4CAF50;
                color: white;
                border-color: #4CAF50;
            }

            .question-number.answered {
                background-color: #2196F3;
                color: white;
                border-color: #2196F3;
            }

            .navigation-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }

            .nav-btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background-color: #4CAF50;
                color: white;
                transition: all 0.3s ease;
            }

            .nav-btn:hover {
                background-color: #45a049;
            }

            .comment-section {
                margin-top: 30px;
            }

            .comment-section textarea {
                width: 100%;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                margin-top: 10px;
                resize: vertical;
            }
        </style>
    </head>
     <body>
        <div class="container">
            <!-- Left Sidebar -->
            <div class="left-sidebar">
                <input type="search" placeholder="Search..." onkeyup="searchQuestions(this.value)">
                <ul class="quiz-list">
                    <c:forEach items="${questions}" var="question" varStatus="status">
                        <li onclick="loadQuestion(${status.index + 1})" class="question-item ${currentQuestionNum == status.index + 1 ? 'active' : ''}">
                            Question ${status.index + 1}
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="quiz-header">
                    <h2>${quiz.name}</h2>
                    <!-- Thêm đồng hồ đếm ngược -->
                    <div id="timer" class="timer" style="
                         font-size: 24px; 
                         font-weight: bold; 
                         color: #333; 
                         background: #f8f9fa; 
                         padding: 10px; 
                         border-radius: 5px; 
                         margin: 10px 0; 
                         text-align: center;">
                        Time remaining: <span id="time">00:00</span>
                    </div>
                </div>
                
                <form id="quizForm" action="Test" method="post">
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
                            <div class="question-text">
                                <h3>${currentQuestion.content}</h3>
                            </div>                     
                            <div class="options">
                                <c:choose>
                                    <c:when test="${not empty currentQuestion.answers}">
                                        <c:forEach items="${currentQuestion.answers}" var="answer">
                                            <label class="option">
                                                <input type="radio" 
                                                       name="question${currentQuestion.questionID}" 
                                                       value="${answer.answerID}" 
                                                       onclick="selectOption(this); markAnswered(${currentQuestionNum}); saveAnswer(${currentQuestion.questionID}, ${answer.answerID})">
                                                ${answer.content}
                                            </label>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: red;">No answers available for this question.</p>
                                    </c:otherwise>
                                </c:choose>
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
                        <button type="button" class="nav-btn" onclick="prevQuestion()">Previous</button>
                        <button type="button" class="nav-btn" onclick="nextQuestion()">Next</button>
                    </div>

                    <div class="submit-section" style="text-align: center; margin-top: 20px;">
                        <button type="button" onclick="confirmSubmit()" class="btn btn-primary" style="
                                padding: 10px 30px; 
                                font-size: 18px; 
                                background-color: #28a745; 
                                border: none; 
                                color: white; 
                                border-radius: 5px; 
                                cursor: pointer;">
                            Submit Quiz
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // JavaScript to manage quiz interactions

            let selectedAnswers = {}; // Object to store selected answers

            function saveAnswer(questionId, answerId) {
                selectedAnswers[questionId] = answerId;
                sessionStorage.setItem('answers', JSON.stringify(selectedAnswers));
            }

            function loadSavedAnswers() {
                const savedAnswers = JSON.parse(sessionStorage.getItem('answers')) || {};
                for (let questionId in savedAnswers) {
                    let answerId = savedAnswers[questionId];
                    let radioButton = document.querySelector(`input[name='question${questionId}'][value='${answerId}']`);
                    if (radioButton) {
                        radioButton.checked = true;
                        radioButton.closest('.option').classList.add('selected');
                    }
                }
            }

            function selectOption(radio) {
                const questionId = radio.closest('.question-container').querySelector('input[name="question' + radio.name.split('question')[1] + '"]').name.split('question')[1];
                const answerId = radio.value;

                saveAnswer(questionId, answerId);

                // Handle option selection logic
                const questionDiv = radio.closest('.question-container');
                const options = questionDiv.getElementsByClassName('option');
                for (let option of options) {
                    option.classList.remove('selected');
                }

                radio.closest('.option').classList.add('selected');
                markAnswered(questionId);
            }

            function markAnswered(questionNum) {
                const questionNumber = document.querySelector(`.question-number:nth-child(${questionNum})`);
                if (questionNumber) {
                    questionNumber.classList.add('answered');
                }
            }

            function goToQuestion(num) {
                window.location.href = 'Test?action=question&num=' + num + '&quizId=${quiz.quizID}';
            }

            function prevQuestion() {
                const currentNum = ${currentQuestionNum};
                if (currentNum > 1) {
                    goToQuestion(currentNum - 1);
                }
            }

            function nextQuestion() {
                const currentNum = ${currentQuestionNum};
                const totalQuestions = ${totalQuestions};
                if (currentNum < totalQuestions) {
                    goToQuestion(currentNum + 1);
                }
            }

            let timerStarted = false;
            function startTimer(duration) {
                if (timerStarted) return; 

                timerStarted = true;
                let timer = duration;
                let minutes, seconds;
                const countdown = setInterval(function () {
                    minutes = parseInt(timer / 60, 10);
                    seconds = parseInt(timer % 60, 10);

                    minutes = minutes < 10 ? "0" + minutes : minutes;
                    seconds = seconds < 10 ? "0" + seconds : seconds;

                    document.getElementById('time').textContent = minutes + ":" + seconds;

                    if (--timer < 0) {
                        clearInterval(countdown);
                        alert("Time's up!");
                        document.getElementById('quizForm').submit();
                    }
                }, 1000);
            }

            var timeLimit = ${quiz.timeLimit}; 
            startTimer(timeLimit * 60);

            function confirmSubmit() {
                if (confirm("Bạn có chắc chắn muốn nộp bài không?\nLưu ý: Sau khi nộp bài, bạn sẽ không thể quay lại để sửa.")) {
                    var form = document.getElementById('quizForm');
                    form.action = "Test?action=submit";
                    form.submit();
                }
            }

            // Load saved answers when the page loads
            window.onload = loadSavedAnswers;

        </script>
    </body>
</html>