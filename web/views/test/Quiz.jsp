<%-- 
    Document   : testQuiz
    Created on : Feb 23, 2025, 1:01:11 AM
    Author     : dohie
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="language" value="${not empty sessionScope.language ? sessionScope.language : ''}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="text" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="Online Learning System" />

        <!-- OG -->
        <meta property="og:title" content="Online Learning System" />
        <meta property="og:description" content="Online Learning System" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Online Learning - Quiz</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/color/color-1.css">
        <style>
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top: 120px;
                left: 0;
                right: 0;
                background-color: rgba(208, 22, 39, 0.8);
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }

            .success {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #00CC00;
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }
            
            .quiz-navigation {
                width: 100%;
                padding: 15px;
                overflow-y: auto;
            }
            
            .quiz-navigation ul {
                list-style: none;
                padding: 0;
                margin: 15px 0 0 0;
            }
            
            .quiz-navigation li {
                display: flex;
                align-items: center;
                padding: 10px;
                margin-bottom: 5px;
                border-radius: 8px;
                transition: background-color 0.3s;
            }
            
            .quiz-navigation li:hover {
                background-color: #f0f0f0;
            }
            
            .quiz-navigation li .material-icons {
                margin-right: 10px;
                color: #51be78;
            }
            
            .quiz-navigation li a {
                color: #333;
                text-decoration: none;
                font-weight: 500;
                flex: 1;
            }
            
            .quiz-navigation li.active {
                background-color: #e8f5e9;
            }
            
            .quiz-navigation li.active a {
                color: #51be78;
                font-weight: 600;
            }
            
            .quiz-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #fff;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 5px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                transition: transform 0.3s, box-shadow 0.3s;
            }
            
            .quiz-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            
            .quiz-content {
                flex: 1;
            }
            
            .quiz-content h3 {
                color: #183661;
                margin-bottom: 10px;
                font-weight: 600;
            }
            
            .quiz-content p {
                color: #555;
                margin-bottom: 10px;
                line-height: 1.5;
            }
            
            .quiz-details {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 15px;
            }
            
            .quiz-details span {
                display: flex;
                align-items: center;
                font-size: 14px;
                color: #666;
                background-color: #f8f9fa;
                padding: 5px 10px;
                border-radius: 20px;
            }
            
            .quiz-details span i {
                margin-right: 5px;
                font-size: 16px;
                color: #51be78;
            }
            
            .start-quiz-btn {
                display: flex;
                align-items: center;
                background: linear-gradient(45deg, #51be78, #3f9d5f);
                color: white;
                padding: 10px 20px;
                border-radius: 30px;
                text-decoration: none;
                font-weight: 600;
                transition: background 0.3s, transform 0.2s;
                white-space: nowrap;
            }
            
            .start-quiz-btn:hover {
                background: linear-gradient(45deg, #3f9d5f, #51be78);
                color: white;
                transform: scale(1.05);
            }
            
            .start-quiz-btn i {
                margin-left: 8px;
            }
            
            .quiz-list {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }
            
            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
            }
            
            .alert i {
                margin-right: 10px;
                font-size: 18px;
            }
            
            .alert-info {
                background-color: #e3f2fd;
                color: #0d47a1;
                border-left: 4px solid #2196f3;
            }
            
            .alert-warning {
                background-color: #fff8e1;
                color: #ff8f00;
                border-left: 4px solid #ffc107;
            }
            
            .quiz-header {
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            
            .quiz-info {
                margin-top: 15px;
            }
            
            .quiz-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 15px;
            }
            
            .quiz-meta span {
                display: flex;
                align-items: center;
                font-size: 14px;
                color: #666;
            }
            
            .quiz-meta span i {
                margin-right: 5px;
                font-size: 18px;
                color: #51be78;
            }
            
            #timer {
                font-weight: 600;
            }
            
            .question-item {
                background-color: #fff;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: none;
            }
            
            .question-item h3 {
                color: #51be78;
                margin-bottom: 15px;
                font-size: 18px;
            }
            
            .question-text {
                font-size: 16px;
                color: #333;
                margin-bottom: 20px;
                line-height: 1.6;
            }
            
            .options {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }
            
            .option {
                display: flex;
                align-items: center;
                padding: 12px 15px;
                border-radius: 8px;
                background-color: #f9f9f9;
                transition: background-color 0.3s;
            }
            
            .option:hover {
                background-color: #f0f0f0;
            }
            
            .option input[type="radio"] {
                margin-right: 12px;
            }
            
            .option label {
                font-size: 15px;
                color: #333;
                cursor: pointer;
                flex: 1;
            }
            
            .quiz-navigation-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }
            
            .quiz-navigation-buttons button {
                padding: 10px 20px;
                border-radius: 30px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                transition: background-color 0.3s;
            }
            
            .prev-btn {
                background-color: #f0f0f0;
                color: #333;
            }
            
            .prev-btn:hover {
                background-color: #e0e0e0;
            }
            
            .next-btn {
                background-color: #51be78;
                color: white;
            }
            
            .next-btn:hover {
                background-color: #3f9d5f;
            }
            
            .submit-btn {
                background-color: #183661;
                color: white;
                padding: 12px 25px;
                border-radius: 30px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                transition: background-color 0.3s;
            }
            
            .submit-btn:hover {
                background-color: #0f2443;
            }
            
            .search-box {
                position: relative;
                margin-bottom: 20px;
            }
            
            .search-input {
                width: 100%;
                padding: 12px 15px 12px 40px;
                border: 1px solid #ddd;
                border-radius: 30px;
                font-size: 14px;
                transition: border-color 0.3s;
            }
            
            .search-input:focus {
                border-color: #51be78;
                outline: none;
            }
            
            .search-icon {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #999;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">

        <!-- header start -->
        <jsp:include page="../../common/dashboard/header-dashboard.jsp"></jsp:include>
        <!-- header end -->
        <!-- Left sidebar menu start -->
       
        <!-- Left sidebar menu end -->

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Quizzes</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Quizzes</li>
                    </ul>
                </div>	
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <c:choose>
                                    <c:when test="${not empty quizzes}">
                                        <h4>Available Quizzes</h4>
                                    </c:when>
                                    <c:otherwise>
                                        <h4>${quiz.name}</h4>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="widget-inner">
                                <c:choose>
                                    <c:when test="${not empty quizzes}">
                                        <!-- Display list of quizzes -->
                                        <div class="mb-3 d-flex align-items-center gap-3">
                                            <div class="search-box">
                                                <i class="fa fa-search search-icon"></i>
                                                <input type="text" class="search-input" placeholder="Search quizzes...">
                                            </div>
                                        </div>
                                        
                                        <div class="quiz-list">
                                            <div id="noResults" style="display: none;" class="alert alert-warning">
                                                <i class="fa fa-exclamation-triangle"></i> No quizzes match your search.
                                            </div>
                                            
                                            <c:forEach items="${quizzes}" var="q">
                                                <div class="quiz-item">
                                                    <div class="quiz-content">
                                                        <h3>${q.name}</h3>
                                                        <p>${q.description}</p>
                                                        <div class="quiz-details">
                                                            <span><i class="fa fa-question-circle"></i> ${q.totalQuestion} Questions</span>
                                                            <span><i class="fa fa-clock"></i> ${q.duration} Minutes</span>
                                                            <span><i class="fa fa-trophy"></i> ${q.passRate}% Pass Rate</span>
                                                        </div>
                                                    </div>
                                                    <a href="Test?action=take&id=${q.quizID}" class="start-quiz-btn">
                                                        Start Quiz <i class="fa fa-arrow-right"></i>
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Display quiz questions -->
                                        <div class="quiz-header">
                                            <div class="quiz-info">
                                                <p>${quiz.description}</p>
                                                <div class="quiz-meta">
                                                    <span><i class="fa fa-question-circle"></i> ${quiz.totalQuestion} Questions</span>
                                                    <span><i class="fa fa-clock"></i> <span id="timer">00:00</span> Remaining</span>
                                                    <span><i class="fa fa-trophy"></i> ${quiz.passRate}% Pass Rate</span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <form id="quizForm" action="submitQuiz" method="post">
                                            <input type="hidden" name="quizID" value="${quiz.quizID}">
                                            
                                            <c:forEach items="${questions}" var="question" varStatus="status">
                                                <div id="question${status.index + 1}" class="question-item">
                                                    <h3>Question ${status.index + 1} of ${quiz.totalQuestion}</h3>
                                                    <div class="question-text">${question.content}</div>
                                                    
                                                    <div class="options">
                                                        <c:forEach items="${question.answers}" var="answer">
                                                            <div class="option">
                                                                <input type="radio" id="q${question.questionID}_a${answer.answerID}" 
                                                                       name="answer_${question.questionID}" value="${answer.answerID}">
                                                                <label for="q${question.questionID}_a${answer.answerID}">${answer.content}</label>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    
                                                    <div class="quiz-navigation-buttons">
                                                        <button type="button" class="prev-btn" onclick="prevQuestion()">Previous</button>
                                                        
                                                        <c:choose>
                                                            <c:when test="${status.index + 1 == quiz.totalQuestion}">
                                                                <button type="submit" class="submit-btn">Submit Quiz</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="next-btn" onclick="nextQuestion()">Next</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
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
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
        <script src='${pageContext.request.contextPath}/assets/admin/assets/vendors/switcher/switcher.js'></script>

        <script>
            // Define variables for quiz functionality
            let currentQuestion = 1;
            const quizTotalQuestion = ${empty quiz ? 0 : quiz.totalQuestion};
            const quizDuration = ${empty quiz ? 0 : quiz.duration};
            let timeLeft = quizDuration * 60; // Convert minutes to seconds
            let timerInterval;

            // Function to show a specific question
            function showQuestion(questionNumber) {
                // Validate question number
                if (questionNumber < 1 || questionNumber > quizTotalQuestion) {
                    return;
                }
                
                // Hide all questions
                document.querySelectorAll('.question-item').forEach(q => {
                    q.style.display = 'none';
                });
                
                // Show the current question
                const questionElement = document.getElementById('question' + questionNumber);
                if (questionElement) {
                    questionElement.style.display = 'block';
                }
                
                // Update navigation buttons
                const prevBtn = document.querySelector('.prev-btn');
                const nextBtn = document.querySelector('.next-btn');
                
                if (prevBtn) {
                    prevBtn.disabled = questionNumber === 1;
                }
                
                if (nextBtn) {
                    nextBtn.disabled = questionNumber === quizTotalQuestion;
                }
                
                // Update current question
                currentQuestion = questionNumber;
            }

            // Function to go to previous question
            function prevQuestion() {
                if (currentQuestion > 1) {
                    showQuestion(currentQuestion - 1);
                }
            }

            // Function to go to next question
            function nextQuestion() {
                if (currentQuestion < quizTotalQuestion) {
                    showQuestion(currentQuestion + 1);
                }
            }

            // Initialize timer
            function updateTimer() {
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    const quizForm = document.getElementById('quizForm');
                    if (quizForm) {
                        quizForm.submit();
                    }
                    return;
                }
                
                const minutes = Math.floor(timeLeft / 60);
                const seconds = timeLeft % 60;
                const timerElement = document.getElementById('timer');
                
                if (timerElement) {
                    timerElement.textContent = 
                        minutes.toString().padStart(2, '0') + ':' + 
                        seconds.toString().padStart(2, '0');
                    
                    // Change color when 5 minutes or less remaining
                    if (timeLeft <= 300) {
                        timerElement.style.color = '#e74c3c';
                    }
                }
                
                timeLeft--;
            }

            // Show first question on load
            document.addEventListener('DOMContentLoaded', function() {
                if (quizTotalQuestion > 0) {
                    showQuestion(1);
                    // Start timer only if we're in quiz mode
                    if (timeLeft > 0) {
                        timerInterval = setInterval(updateTimer, 1000);
                        updateTimer();
                    }
                }

                // Form validation before submit
                const quizForm = document.getElementById('quizForm');
                if (quizForm) {
                    quizForm.addEventListener('submit', function(e) {
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
                            alert('Please answer all questions before submitting. Unanswered questions: ' + unanswered.join(', '));
                            showQuestion(unanswered[0]);
                        }
                    });
                }
                
                // Search functionality
                const searchInput = document.querySelector('.search-input');
                if (searchInput) {
                    searchInput.addEventListener('input', function(e) {
                        const searchTerm = e.target.value.toLowerCase().trim();
                        const quizItems = document.querySelectorAll('.quiz-item');
                        let hasResults = false;
                        
                        quizItems.forEach(item => {
                            const quizName = item.querySelector('h3').textContent.toLowerCase();
                            const quizDesc = item.querySelector('p').textContent.toLowerCase();
                            
                            if (quizName.includes(searchTerm) || quizDesc.includes(searchTerm)) {
                                item.style.display = 'flex';
                                hasResults = true;
                            } else {
                                item.style.display = 'none';
                            }
                        });
                        
                        // Show/hide no results message
                        const noResultsElement = document.getElementById('noResults');
                        if (noResultsElement) {
                            noResultsElement.style.display = hasResults ? 'none' : 'block';
                        }
                    });
                }
            });
        </script>
    </body>
</html>