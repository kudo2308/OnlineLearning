<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Question</title>
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
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
                    <h4 class="breadcrumb-title">Add Question</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="#"><i class="fa fa-home"></i>Home</a></li>
                        <li>Add Question</li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Add Question</h4>
                            </div>
                            <div class="widget-inner">
                                <form class="edit-profile m-b30" action="${pageContext.request.contextPath}/AddQuestion" method="POST" id="questionForm">
                                    <input type="hidden" name="action" value="add">

                                    <c:if test="${not empty error}">
                                        <div class="error-message">${error}</div>
                                    </c:if>

                                    <c:if test="${remainingQuestions != null}">
                                        <div class="progress-info">
                                            <p>Remaining questions to add: ${remainingQuestions}</p>
                                        </div>
                                    </c:if> 

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="quizID">Select Quiz:</label>
                                        <div class="col-sm-7">
                                            <select class="form-control" id="quizID" name="quizID" required ${selectedQuizId != null ? 'readonly' : ''}>
                                                <option value="">-- Select a quiz --</option>
                                                <c:forEach items="${quizzes}" var="quiz">
                                                    <option value="${quiz.quizID}" ${quiz.quizID == selectedQuizId ? 'selected' : ''}>${quiz.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="content">Question Content:</label>
                                        <div class="col-sm-7">
                                            <textarea class="form-control" id="content" name="content" rows="4" required placeholder="Enter your question here"></textarea>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="col-sm-2 col-form-label" for="pointPerQuestion">Points:</label>
                                        <div class="col-sm-7">
                                            <input class="form-control" type="number" id="pointPerQuestion" name="pointPerQuestion" required>
                                        </div>
                                    </div>

                                    <!-- Answer Options -->
                                    <c:forEach var="i" begin="0" end="3">
                                        <div class="answer-group">
                                            <div class="answer-header">Answer Option ${i + 1}</div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="answerContent${i}">Answer Content:</label>
                                                <div class="col-sm-7">
                                                    <input class="form-control" type="text" id="answerContent${i}" name="answerContent[]" required placeholder="Enter answer option ${i + 1}">
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="isCorrect${i}">Correct Answer:</label>
                                                <div class="col-sm-7">
                                                    <input type="radio" id="isCorrect${i}" name="isCorrect" value="${i}" required>
                                                    <label for="isCorrect${i}">Correct Answer</label>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="explanation${i}">Explanation (Optional):</label>
                                                <div class="col-sm-7">
                                                    <textarea class="form-control" id="explanation${i}" name="explanation[]" rows="2" placeholder="Explain why this answer is correct/incorrect"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="form-group row">
                                        <div class="col-sm-7">
                                            <button type="submit" class="btn">Add Question</button>
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
        <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="assets/admin/assets/js/functions.js"></script>
        <script src="assets/admin/assets/js/admin.js"></script>
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
