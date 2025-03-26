<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <meta name="description" content="EduChamp : Education HTML Template" />
        
        <!-- OG -->
        <meta property="og:title" content="EduChamp : Education HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">
        
        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />
        
        <!-- PAGE TITLE HERE ============================================= -->
        <title>Take Quiz - ${quiz.name}</title>
        
        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <!--[if lt IE 9]>
        <script src="${pageContext.request.contextPath}/assets/js/html5shiv.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/respond.min.js"></script>
        <![endif]-->
        
        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">
        
        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">
        
        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">
        
        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/color/color-1.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            /* Full Screen Layout */
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                overflow: hidden;
            }
            
            .ttr-wrapper {
                padding: 0 !important;
                margin: 0 !important;
                height: 100vh;
                width: 100vw;
                max-width: 100%;
                overflow: hidden;
            }
            
            .container-fluid {
                padding: 0;
                height: 100%;
            }
            
            .db-breadcrumb {
                padding: 10px 20px;
                margin-bottom: 0;
                background-color: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }
            
            .row {
                margin: 0;
                height: calc(100% - 50px); /* Subtract breadcrumb height */
            }
            
            .col-lg-12 {
                padding: 0;
                height: 100%;
            }
            
            .widget-box {
                height: 100%;
                margin-bottom: 0;
                border-radius: 0;
                box-shadow: none;
            }
            
            .widget-inner {
                height: calc(100% - 50px); /* Subtract widget header height */
                padding: 0;
                overflow: hidden;
            }
            
            /* Quiz Container Layout */
            .quiz-container {
                display: flex;
                gap: 0;
                margin-top: 0;
                height: 100%;
            }
            
            /* Left Panel Styling */
            .left-panel {
                width: 300px;
                background-color: #f8f9fa;
                border-radius: 0;
                padding: 20px;
                box-shadow: none;
                border-right: 1px solid #dee2e6;
                height: 100%;
                overflow-y: auto;
            }
            
            /* Timer Styling */
            .timer-container {
                margin-bottom: 20px;
                text-align: center;
            }
            
            .timer-label {
                font-size: 14px;
                color: #6c757d;
                margin-bottom: 5px;
            }
            
            .timer-value {
                font-size: 24px;
                font-weight: bold;
                color: #007bff;
            }
            
            /* Progress Bar for Timer */
            .timer-progress {
                width: 100%;
                height: 10px;
                background-color: #e9ecef;
                border-radius: 5px;
                margin-top: 10px;
                overflow: hidden;
            }
            
            .timer-bar {
                height: 100%;
                background-color: #007bff;
                width: 100%; /* Will be updated by JS */
            }
            
            /* Question Navigation Grid */
            .question-nav-grid {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 8px;
                margin-bottom: 20px;
            }
            
            .question-nav-item {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                aspect-ratio: 1;
                background-color: #e9ecef;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.2s ease;
            }
            
            .question-nav-item:hover {
                background-color: #dee2e6;
            }
            
            .question-nav-item.current {
                background-color: #007bff;
                color: white;
            }
            
            .question-nav-item.answered {
                background-color: #28a745;
                color: white;
            }
            
            .question-nav-item.marked {
                background-color: #ffc107;
                color: #212529;
            }
            
            .question-nav-item.answered.marked {
                background: linear-gradient(135deg, #28a745 50%, #ffc107 50%);
                color: white;
            }
            
            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }
            
            .action-button {
                flex: 1;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
                text-align: center;
                transition: all 0.2s ease;
            }
            
            .action-button.primary {
                background-color: #007bff;
                color: white;
            }
            
            .action-button.primary:hover {
                background-color: #0069d9;
            }
            
            .action-button.secondary {
                background-color: #6c757d;
                color: white;
            }
            
            .action-button.secondary:hover {
                background-color: #5a6268;
            }
            
            .mark-button {
                background-color: #ffc107;
                color: #212529;
                border: none;
                padding: 8px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
                margin-right: 10px;
                transition: all 0.2s ease;
            }
            
            .mark-button:hover {
                background-color: #e0a800;
            }
            
            .mark-button.marked {
                background-color: #e0a800;
            }
            
            /* Right Panel - Question Content */
            .right-panel {
                flex: 1;
                background-color: #fff;
                border-radius: 0;
                padding: 20px;
                box-shadow: none;
                height: 100%;
                overflow-y: auto;
            }
            
            .question-container {
                display: none; /* Hidden by default, shown via JS */
            }
            
            .question-header {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #dee2e6;
                color: #343a40;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .question-content {
                font-size: 16px;
                margin-bottom: 20px;
                line-height: 1.5;
            }
            
            /* Answer Options */
            .options-list {
                list-style-type: none;
                padding: 0;
                margin: 0 0 30px 0;
            }
            
            .option-item {
                margin-bottom: 10px;
                padding: 12px 15px;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            
            .option-item:hover {
                background-color: #f8f9fa;
            }
            
            .option-item.selected {
                background-color: #e8f4ff;
                border-color: #007bff;
            }
            
            .option-label {
                display: flex;
                align-items: center;
                cursor: pointer;
                width: 100%;
            }
            
            .option-radio {
                margin-right: 10px;
            }
            
            .option-text {
                flex: 1;
            }
            
            /* Quiz Navigation Buttons */
            .quiz-navigation {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }
            
            .nav-button {
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.2s ease;
            }
            
            .prev-button {
                background-color: #f0f0f0;
                color: #333;
            }
            
            .prev-button:hover {
                background-color: #e0e0e0;
            }
            
            .next-button {
                background-color: #007bff;
                color: white;
            }
            
            .next-button:hover {
                background-color: #0069d9;
            }
            
            .submit-button {
                background-color: #28a745;
                color: white;
            }
            
            .submit-button:hover {
                background-color: #218838;
            }
            
            /* Dropdown Styling */
            .dropdown-toggle {
                cursor: pointer;
                padding: 8px 12px;
                background-color: #f8f9fa;
                border-radius: 4px;
                font-size: 14px;
                color: #6c757d;
                text-align: center;
            }
            
            .dropdown-menu {
                min-width: 100%;
                padding: 10px;
                font-size: 14px;
            }
            
            .dropdown-item {
                padding: 5px 0;
                color: #6c757d;
            }
            
            /* Responsive Design */
            @media (max-width: 768px) {
                .quiz-container {
                    flex-direction: column;
                }
                
                .left-panel {
                    width: 100%;
                    margin-bottom: 20px;
                }
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <!-- header start -->
        <jsp:include page="../../common/dashboard/header-dashboard.jsp"></jsp:include>
        <!-- header end -->
  
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Take Quiz</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/Test?action=list">Quizzes</a></li>
                        <li>Take Quiz</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Quiz: ${quiz.name}</h4>
                            </div>
                            <div class="widget-inner">
                                <form id="quizForm" action="${pageContext.request.contextPath}/Test?action=submit" method="post">
                                    <input type="hidden" name="quizId" value="${quiz.quizID}">
                                    
                                    <div class="quiz-container">
                                        <!-- Left Panel - Question Navigation and Timer -->
                                        <div class="left-panel">
                                            <div class="timer-container">
                                                <div class="timer-label">Thời gian còn lại</div>
                                                <div class="timer-value" id="timer">00:00:00</div>
                                                <div class="timer-progress">
                                                    <div class="timer-bar" id="timer-bar"></div>
                                                </div>
                                            </div>
                                            
                                            <div class="question-nav-grid">
                                                <c:forEach var="question" items="${questions}" varStatus="status">
                                                    <div class="question-nav-item" data-question="${status.index + 1}">${status.index + 1}</div>
                                                </c:forEach>
                                            </div>
                                            
                                            <div class="action-buttons">
                                                <button type="button" id="skipBtn" class="action-button secondary">Nộp bài</button>
                                                <button type="button" id="saveBtn" class="action-button primary">Lưu bài làm</button>
                                            </div>
                                            
                                            <div class="dropdown mt-3">
                                                <div class="dropdown-toggle" data-toggle="dropdown">
                                                    Lưu ý khi làm bài
                                                </div>
                                                <div class="dropdown-menu">
                                                    <div class="dropdown-item">- Bạn có thể quay lại câu hỏi trước đó</div>
                                                    <div class="dropdown-item">- Bài làm sẽ tự động nộp khi hết thời gian</div>
                                                    <div class="dropdown-item">- Câu đã trả lời sẽ có màu xanh lá</div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Right Panel - Question Content -->
                                        <div class="right-panel">
                                            <c:forEach var="question" items="${questions}" varStatus="status">
                                                <div id="question-${status.index + 1}" class="question-container" style="display: none;">
                                                    <div class="question-header">
                                                        CÂU HỎI ${status.index + 1} (SINGLECHOICE)
                                                        <button type="button" class="mark-button" onclick="toggleMark('${status.index + 1}')">
                                                            <i class="fa fa-bookmark"></i> Đánh dấu
                                                        </button>
                                                    </div>
                                                    <div class="question-content">
                                                        ${question.content}
                                                    </div>
                                                    <ul class="options-list">
                                                        <c:forEach var="answer" items="${question.answers}">
                                                            <c:if test="${not empty answer.content}">
                                                                <li class="option-item">
                                                                    <label class="option-label">
                                                                        <input type="radio" name="question${question.questionID}" value="${answer.answerID}" class="option-radio">
                                                                        <span class="option-text">${answer.content}</span>
                                                                    </label>
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </ul>
                                                    
                                                    <div class="quiz-navigation">
                                                        <button type="button" class="nav-button prev-button" data-question="${status.index}" ${status.index == 0 ? 'disabled' : ''}>
                                                            <i class="fa fa-arrow-left"></i> Câu trước
                                                        </button>
                                                        
                                                        <c:choose>
                                                            <c:when test="${status.index + 1 == questions.size()}">
                                                                <button type="button" class="nav-button submit-button" id="submitBtn">
                                                                    <i class="fa fa-check"></i> Nộp bài
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="nav-button next-button" data-question="${status.index + 2}">
                                                                    Câu tiếp <i class="fa fa-arrow-right"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
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
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
        
        <script>
            $(document).ready(function() {
                // Initialize variables
                let currentQuestion = 1;
                const totalQuestions = parseInt("${questions.size()}");
                let timerInterval = null;
                
                // Initialize - show first question
                showQuestion(1);
                
                // Start the timer
                startTimer();
                
                // Timer functionality
                function startTimer() {
                    const quizDuration = parseInt("${quiz.duration}"); // in minutes
                    let totalSeconds = quizDuration * 60;
                    
                    // Update timer display immediately
                    updateTimerDisplay(totalSeconds);
                    
                    timerInterval = setInterval(function() {
                        totalSeconds--;
                        
                        if (totalSeconds <= 0) {
                            clearInterval(timerInterval);
                            alert("Hết thời gian! Bài làm của bạn sẽ được nộp tự động.");
                            $("#quizForm").submit();
                            return;
                        }
                        
                        updateTimerDisplay(totalSeconds);
                        
                        // Change color when time is running low
                        if (totalSeconds <= 300) { // 5 minutes remaining
                            $("#timer").css("color", "#F44336");
                        }
                    }, 1000);
                }
                
                // Function to update timer display
                function updateTimerDisplay(totalSeconds) {
                    const hours = Math.floor(totalSeconds / 3600);
                    const minutes = Math.floor((totalSeconds % 3600) / 60);
                    const seconds = totalSeconds % 60;
                    
                    $("#timer").text(
                        (hours < 10 ? "0" + hours : hours) + ":" +
                        (minutes < 10 ? "0" + minutes : minutes) + ":" +
                        (seconds < 10 ? "0" + seconds : seconds)
                    );
                    
                    // Update progress bar
                    const progress = (totalSeconds / (parseInt("${quiz.duration}") * 60)) * 100;
                    $("#timer-bar").css("width", progress + "%");
                }
                
                // Question navigation via number buttons
                $(".question-nav-item").click(function() {
                    const questionNumber = parseInt($(this).data("question"));
                    showQuestion(questionNumber);
                });
                
                // Option selection - using event delegation for better performance
                $(document).on("click", ".option-item", function() {
                    const radio = $(this).find("input[type='radio']");
                    radio.prop("checked", true);
                    
                    // Remove selected class from all options in this question
                    $(this).closest(".options-list").find(".option-item").removeClass("selected");
                    
                    // Add selected class to this option
                    $(this).addClass("selected");
                    
                    // Mark question as answered in navigation
                    const questionId = $(this).closest(".question-container").attr("id");
                    const questionNumber = parseInt(questionId.split("-")[1]);
                    $(".question-nav-item[data-question='" + questionNumber + "']").addClass("answered");
                    
                    // Auto-save answer
                    saveProgress();
                });
                
                // Skip button functionality
                $("#skipBtn").click(function() {
                    const unansweredCount = totalQuestions - $(".question-nav-item.answered").length;
                    
                    if (unansweredCount > 0) {
                        const confirmSubmit = confirm("Bạn có " + unansweredCount + " câu hỏi chưa trả lời. Bạn có chắc chắn muốn nộp bài?");
                        if (confirmSubmit) {
                            $("#quizForm").submit();
                        }
                    } else {
                        $("#quizForm").submit();
                    }
                });
                
                // Submit button in the last question
                $("#submitBtn").click(function() {
                    const unansweredCount = totalQuestions - $(".question-nav-item.answered").length;
                    
                    if (unansweredCount > 0) {
                        const confirmSubmit = confirm("Bạn có " + unansweredCount + " câu hỏi chưa trả lời. Bạn có chắc chắn muốn nộp bài?");
                        if (confirmSubmit) {
                            $("#quizForm").submit();
                        }
                    } else {
                        $("#quizForm").submit();
                    }
                });
                
                // Save progress button
                $("#saveBtn").click(function() {
                    saveProgress();
                    
                    // Show save confirmation
                    const saveStatus = $("<div class='save-status'></div>")
                        .text("Bài làm đã được lưu lúc " + new Date().toLocaleTimeString())
                        .appendTo(".left-panel");
                    
                    setTimeout(function() {
                        saveStatus.fadeOut(function() {
                            $(this).remove();
                        });
                    }, 3000);
                });
                
                // Function to save progress (can be implemented with AJAX)
                function saveProgress() {
                    // Collect all answers
                    const answers = {};
                    $("input[type='radio']:checked").each(function() {
                        const name = $(this).attr("name");
                        const value = $(this).val();
                        answers[name] = value;
                    });
                    
                    console.log("Saved answers:", answers);
                    
                    // Example AJAX implementation (commented out)
                    /*
                    $.ajax({
                        url: "${pageContext.request.contextPath}/Test?action=save",
                        type: "POST",
                        data: {
                            quizId: "${quiz.quizID}",
                            answers: JSON.stringify(answers)
                        },
                        success: function(response) {
                            const saveStatus = $("<div class='save-status'></div>")
                                .text("Bài làm đã được lưu lúc " + new Date().toLocaleTimeString())
                                .appendTo(".left-panel");
                            
                            setTimeout(function() {
                                saveStatus.fadeOut(function() {
                                    $(this).remove();
                                });
                            }, 3000);
                        },
                        error: function(error) {
                            alert("Có lỗi xảy ra khi lưu bài làm. Vui lòng thử lại.");
                        }
                    });
                    */
                }
                
                // Add event listeners for navigation buttons
                $(".prev-button, .next-button").click(function() {
                    const questionNumber = parseInt($(this).data("question"));
                    showQuestion(questionNumber);
                });
                
                // Handle form submission to prevent accidental navigation
                $(window).on("beforeunload", function() {
                    const answeredCount = $(".question-nav-item.answered").length;
                    if (answeredCount > 0 && answeredCount < totalQuestions) {
                        return "Bạn có câu trả lời chưa được lưu. Bạn có chắc chắn muốn rời khỏi trang?";
                    }
                });
                
                // Initialize - check if any questions are already answered (e.g., from a saved session)
                function initializeAnsweredQuestions() {
                    $("input[type='radio']:checked").each(function() {
                        const questionContainer = $(this).closest(".question-container");
                        const questionId = questionContainer.attr("id");
                        const questionNumber = parseInt(questionId.split("-")[1]);
                        
                        // Mark as answered in the navigation
                        $(".question-nav-item[data-question='" + questionNumber + "']").addClass("answered");
                        
                        // Mark the selected option
                        $(this).closest(".option-item").addClass("selected");
                    });
                }
                
                // Call initialization function
                initializeAnsweredQuestions();
            });
            
            // Function to show specific question (defined outside document.ready to be globally accessible)
            function showQuestion(questionNumber) {
                // Ensure questionNumber is valid
                if (questionNumber < 1) questionNumber = 1;
                const totalQuestions = parseInt("${questions.size()}");
                if (questionNumber > totalQuestions) questionNumber = totalQuestions;
                
                // Hide all questions
                $(".question-container").hide();
                
                // Show the selected question
                $("#question-" + questionNumber).show();
                
                // Update the navigation highlight
                $(".question-nav-item").removeClass("current");
                $(".question-nav-item[data-question='" + questionNumber + "']").addClass("current");
                
                // Update current question variable
                window.currentQuestion = questionNumber;
            }
            
            function toggleMark(questionNumber) {
                $(".question-nav-item[data-question='" + questionNumber + "']").toggleClass("marked");
            }
        </script>
    </body>
</html>
