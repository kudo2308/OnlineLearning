<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Question</title>
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
        <style>
            .answer-group {
                border: 1px solid #ddd;
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                background-color: #f9f9f9;
                position: relative;
                display: block !important;
                width: 100%;
                overflow: visible !important;
                height: auto !important;
            }

            .answer-header {
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
                background-color: #e9e9e9;
                padding: 8px;
                border-radius: 3px;
            }

            .remove-answer-btn {
                background-color: #ff5252;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 3px;
                cursor: pointer;
                margin-top: 10px;
            }

            .remove-answer-btn:hover {
                background-color: #ff0000;
            }

            .add-answer-btn {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 3px;
                cursor: pointer;
                margin-top: 10px;
                margin-bottom: 20px;
            }

            .add-answer-btn:hover {
                background-color: #45a049;
            }

            #answer-container {
                margin-bottom: 20px;
                display: block !important;
                width: 100%;
                overflow: visible !important;
                height: auto !important;
            }

            /* Đảm bảo không có CSS ẩn các phần tử */
            .hidden, .d-none {
                display: block !important;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">

        <!-- header start -->
        <jsp:include page="../../common/dashboard/header-dashboard.jsp"></jsp:include>
            <!-- header end -->
            <!-- Left sidebar menu start -->
        <jsp:include page="../../common/dashboard/left-sidebar-dashboard.jsp"></jsp:include>
            <!-- Left sidebar menu end -->

            <!--Main container start -->
            <main class="ttr-wrapper">
                <div class="container-fluid">
                    <div class="db-breadcrumb">
                        <h4 class="breadcrumb-title">Edit Question</h4>
                        <ul class="db-breadcrumb-list">
                            <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/QuestionList?action=list">Question List</a></li>
                        <li>Edit Question</li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Edit Question</h4>
                            </div>
                            <div class="widget-inner">
                                <form class="edit-profile m-b30" action="${pageContext.request.contextPath}/updateQuestion" method="POST" id="questionForm">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="questionId" value="${question.questionID}">

                                    <c:if test="${not empty error}">
                                        <div class="error-message">${error}</div>
                                    </c:if>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="quizID">Quiz:</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="quizID" name="quizID" required>
                                                <option value="">Select a quiz</option>
                                                <c:forEach items="${quizzes}" var="quiz">
                                                    <option value="${quiz.quizID}" ${quiz.quizID == question.quizID ? 'selected' : ''}>${quiz.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="content">Question Content:</label>
                                        <div class="col-sm-7">
                                            <textarea class="form-control" id="content" name="content" rows="4" required>${question.content}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="pointPerQuestion">Points:</label>
                                        <div class="col-sm-7">
                                            <input type="number" class="form-control" id="pointPerQuestion" name="pointPerQuestion" min="1" value="${question.pointPerQuestion}" required>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="status">Status:</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="status" name="status" required>
                                                <option value="true" ${question.status ? 'selected' : ''}>Active</option>
                                                <option value="false" ${!question.status ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label">Answer Options:</label>                                       
                                    </div>

                                    <div id="answer-container">
                                        <!-- Answer options will be populated here -->
                                        <c:forEach items="${answers}" var="answer" varStatus="status">
                                            <div class="answer-group" id="answer-group-${status.index + 1}">
                                                <div class="answer-header">Answer Option ${status.index + 1}</div>
                                                <input type="hidden" name="answerId[]" value="${answer.answerID}">

                                                <div class="form-group row">
                                                    <label class="col-sm-2 col-form-label">Answer Content:</label>
                                                    <div class="col-sm-9">
                                                        <textarea class="form-control" name="answerContent[]" rows="2" required>${answer.content}</textarea>
                                                    </div>
                                                </div>

                                               <div class="form-group row">
                                                    <label class="col-sm-2 col-form-label" for="isCorrect${i}">Correct Answer:</label>
                                                    <div class="col-sm-7">
                                                        <input type="radio" id="isCorrect${i}" name="isCorrect" value="${i-1}">
                                                        <label for="isCorrect${i}">Correct Answer</label>
                                                    </div>
                                                </div>

                                                <div class="form-group row">
                                                    <label class="col-sm-2 col-form-label">Explanation:</label>
                                                    <div class="col-sm-9">
                                                        <textarea class="form-control" name="explanation[]" rows="2">${answer.explanation}</textarea>
                                                    </div>
                                                </div>

                                            </div>
                                        </c:forEach>
                                    </div>


                                    <div class="form-group row">
                                        <div class="col-sm-10 ml-auto">
                                            <button type="submit" class="btn">Save Changes</button>
                                            <a href="${pageContext.request.contextPath}/QuestionList?action=list" class="btn-secondry">Cancel</a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
        <script src="assets/admin/assets/js/jquery.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="assets/admin/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/vendors/chart/chart.min.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>

        <script>
            // Đảm bảo form được kiểm tra trước khi gửi
            document.getElementById('questionForm').onsubmit = function (e) {
                // Kiểm tra quiz đã được chọn chưa
                var quizSelect = document.getElementById('quizID');
                if (!quizSelect.value) {
                    e.preventDefault();
                    alert("Please select a quiz.");
                    return false;
                }

                // Kiểm tra nội dung câu hỏi
                var contentField = document.getElementById('content');
                if (!contentField.value.trim()) {
                    e.preventDefault();
                    alert("Please enter question content.");
                    return false;
                }

                // Kiểm tra điểm số
                var pointsField = document.getElementById('pointPerQuestion');
                if (!pointsField.value || pointsField.value < 1) {
                    e.preventDefault();
                    alert("Please enter a valid point value (minimum 1).");
                    return false;
                }

                // Kiểm tra đã chọn câu trả lời đúng chưa
                var correctAnswerSelected = false;
                var radios = document.getElementsByName('isCorrect');
                for (var i = 0; i < radios.length; i++) {
                    if (radios[i].checked) {
                        correctAnswerSelected = true;
                        break;
                    }
                }

                if (!correctAnswerSelected) {
                    e.preventDefault();
                    alert("Please select a correct answer.");
                    return false;
                }

                // Kiểm tra nội dung của các câu trả lời
                var answerContents = document.getElementsByName('answerContent[]');
                for (var i = 0; i < answerContents.length; i++) {
                    if (!answerContents[i].value.trim()) {
                        e.preventDefault();
                        alert("Please enter content for all answer options.");
                        answerContents[i].focus();
                        return false;
                    }
                }

                return true;
            };
        </script>
    </body>
</html>
