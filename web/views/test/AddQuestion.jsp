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
        <style>
            .answer-group {
                margin-bottom: 20px;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: #f9f9f9;
                position: relative;
            }
            .answer-header {
                font-weight: bold;
                margin-bottom: 10px;
                color: #007bff;
            }
            .add-answer-btn {
                margin-bottom: 20px;
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }
            .add-answer-btn:hover {
                background-color: #218838;
            }
            .remove-answer-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 4px;
                cursor: pointer;
                position: absolute;
                top: 10px;
                right: 10px;
            }
            .remove-answer-btn:hover {
                background-color: #c82333;
            }
            .hidden {
                display: none;
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
                                    <div id="answer-container">
                                        <!-- First answer option (always visible) -->
                                        <div class="answer-group" id="answer-group-1">
                                            <div class="answer-header">Answer Option 1</div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="answerContent1">Answer Content:</label>
                                                <div class="col-sm-7">
                                                    <input class="form-control" type="text" id="answerContent1" name="answerContent[]" required placeholder="Enter answer option 1">
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="isCorrect1">Correct Answer:</label>
                                                <div class="col-sm-7">
                                                    <input type="radio" id="isCorrect1" name="isCorrect" value="0" required>
                                                    <label for="isCorrect1">Correct Answer</label>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-2 col-form-label" for="explanation1">Explanation (Optional):</label>
                                                <div class="col-sm-7">
                                                    <textarea class="form-control" id="explanation1" name="explanation[]" rows="2" placeholder="Explain why this answer is correct/incorrect"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Additional answer options (initially hidden) -->
                                        <c:forEach var="i" begin="2" end="6">
                                            <div class="answer-group hidden" id="answer-group-${i}">
                                                <div class="answer-header">Answer Option ${i}</div>
                                                <button type="button" class="remove-answer-btn" onclick="removeAnswer(${i})">
                                                    <i class="fa fa-times"></i> Remove
                                                </button>

                                                <div class="form-group row">
                                                    <label class="col-sm-2 col-form-label" for="answerContent${i}">Answer Content:</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" type="text" id="answerContent${i}" name="answerContent[]" placeholder="Enter answer option ${i}">
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
                                                    <label class="col-sm-2 col-form-label" for="explanation${i}">Explanation (Optional):</label>
                                                    <div class="col-sm-7">
                                                        <textarea class="form-control" id="explanation${i}" name="explanation[]" rows="2" placeholder="Explain why this answer is correct/incorrect"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Button to add more answers -->
                                    <div class="form-group row">
                                        <div class="col-sm-9">
                                            <button type="button" class="add-answer-btn" onclick="addNewAnswer()">
                                                <i class="fa fa-plus"></i> Add Another Answer Option
                                            </button>
                                        </div>
                                    </div>

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
            // Biến toàn cục để theo dõi số lượng câu trả lời hiện tại
            var currentAnswerCount = 1;
            var maxPredefinedAnswers = 6; // Số lượng câu trả lời được định nghĩa sẵn trong HTML
            var answerGroups = [1]; // Mảng lưu trữ các ID của câu trả lời đang hiển thị
            
            // Hàm thêm câu trả lời mới
            function addNewAnswer() {
                // Tăng số lượng câu trả lời
                currentAnswerCount++;
                answerGroups.push(currentAnswerCount);
                
                if (currentAnswerCount <= maxPredefinedAnswers) {
                    // Hiển thị câu trả lời tiếp theo từ các câu trả lời đã được định nghĩa sẵn
                    var nextAnswerGroup = document.getElementById('answer-group-' + currentAnswerCount);
                    if (nextAnswerGroup) {
                        nextAnswerGroup.classList.remove('hidden');
                        
                        // Đặt thuộc tính required cho input
                        var answerInput = document.getElementById('answerContent' + currentAnswerCount);
                        if (answerInput) {
                            answerInput.setAttribute('required', 'required');
                        }
                    }
                } else {
                    // Tạo câu trả lời mới động nếu đã vượt quá số lượng câu trả lời được định nghĩa sẵn
                    createNewAnswerOption(currentAnswerCount);
                }
                
                // Cập nhật lại tiêu đề và số thứ tự
                updateAnswerNumbers();
            }
            
            // Hàm xóa câu trả lời
            function removeAnswer(index) {
                var answerGroup = document.getElementById('answer-group-' + index);
                if (answerGroup) {
                    // Xóa thuộc tính required trước khi ẩn
                    var answerInput = document.getElementById('answerContent' + index);
                    if (answerInput) {
                        answerInput.removeAttribute('required');
                    }
                    
                    // Bỏ chọn radio button nếu đang được chọn
                    var radioButton = document.getElementById('isCorrect' + index);
                    if (radioButton && radioButton.checked) {
                        radioButton.checked = false;
                    }
                    
                    // Xóa nội dung các trường
                    answerInput.value = '';
                    var explanation = document.getElementById('explanation' + index);
                    if (explanation) {
                        explanation.value = '';
                    }
                    
                    // Ẩn câu trả lời
                    answerGroup.classList.add('hidden');
                    
                    // Xóa khỏi mảng answerGroups
                    var position = answerGroups.indexOf(index);
                    if (position !== -1) {
                        answerGroups.splice(position, 1);
                    }
                    
                    // Cập nhật lại tiêu đề và số thứ tự
                    updateAnswerNumbers();
                }
            }
            
            // Hàm cập nhật lại số thứ tự của các câu trả lời
            function updateAnswerNumbers() {
                // Sắp xếp mảng answerGroups để đảm bảo thứ tự đúng
                answerGroups.sort(function(a, b) {
                    return a - b;
                });
                
                // Cập nhật lại tiêu đề và giá trị của các câu trả lời
                for (var i = 0; i < answerGroups.length; i++) {
                    var index = answerGroups[i];
                    var displayNumber = i + 1; // Số thứ tự hiển thị (bắt đầu từ 1)
                    
                    // Cập nhật tiêu đề
                    var header = document.querySelector('#answer-group-' + index + ' .answer-header');
                    if (header) {
                        header.textContent = 'Answer Option ' + displayNumber;
                    }
                    
                    // Cập nhật placeholder trong input
                    var answerInput = document.getElementById('answerContent' + index);
                    if (answerInput) {
                        answerInput.placeholder = 'Enter answer option ' + displayNumber;
                    }
                    
                    // Cập nhật giá trị của radio button
                    var radioButton = document.getElementById('isCorrect' + index);
                    if (radioButton) {
                        radioButton.value = (displayNumber - 1).toString(); // Giá trị bắt đầu từ 0
                    }
                }
            }
            
            // Hàm tạo câu trả lời mới động
            function createNewAnswerOption(index) {
                var answerContainer = document.getElementById('answer-container');
                
                // Tạo div chứa câu trả lời mới
                var newAnswerGroup = document.createElement('div');
                newAnswerGroup.className = 'answer-group';
                newAnswerGroup.id = 'answer-group-' + index;
                
                // Tạo header cho câu trả lời
                var header = document.createElement('div');
                header.className = 'answer-header';
                header.textContent = 'Answer Option ' + answerGroups.length; // Sử dụng số thứ tự dựa trên số lượng câu trả lời hiện tại
                newAnswerGroup.appendChild(header);
                
                // Tạo nút xóa
                var removeButton = document.createElement('button');
                removeButton.type = 'button';
                removeButton.className = 'remove-answer-btn';
                removeButton.innerHTML = '<i class="fa fa-times"></i> Remove';
                removeButton.onclick = function(event) { 
                    event.preventDefault();
                    removeAnswer(index); 
                };
                newAnswerGroup.appendChild(removeButton);
                
                // Tạo phần nhập nội dung câu trả lời
                var contentRow = document.createElement('div');
                contentRow.className = 'form-group row';
                contentRow.innerHTML = `
                    <label class="col-sm-2 col-form-label" for="answerContent${index}">Answer Content:</label>
                    <div class="col-sm-7">
                        <input class="form-control" type="text" id="answerContent${index}" name="answerContent[]" required placeholder="Enter answer option ${answerGroups.length}">
                    </div>
                `;
                newAnswerGroup.appendChild(contentRow);
                
                // Tạo phần chọn câu trả lời đúng
                var correctRow = document.createElement('div');
                correctRow.className = 'form-group row';
                correctRow.innerHTML = `
                    <label class="col-sm-2 col-form-label" for="isCorrect${index}">Correct Answer:</label>
                    <div class="col-sm-7">
                        <input type="radio" id="isCorrect${index}" name="isCorrect" value="${answerGroups.length-1}">
                        <label for="isCorrect${index}">Correct Answer</label>
                    </div>
                `;
                newAnswerGroup.appendChild(correctRow);
                
                // Tạo phần giải thích
                var explanationRow = document.createElement('div');
                explanationRow.className = 'form-group row';
                explanationRow.innerHTML = `
                    <label class="col-sm-2 col-form-label" for="explanation${index}">Explanation (Optional):</label>
                    <div class="col-sm-7">
                        <textarea class="form-control" id="explanation${index}" name="explanation[]" rows="2" placeholder="Explain why this answer is correct/incorrect"></textarea>
                    </div>
                `;
                newAnswerGroup.appendChild(explanationRow);
                
                // Thêm câu trả lời mới vào container
                answerContainer.appendChild(newAnswerGroup);
            }
            
            // Xác thực form trước khi gửi
            document.getElementById('questionForm').onsubmit = function(e) {
                // Kiểm tra quiz đã được chọn chưa
                var quizSelect = document.getElementById('quizID');
                if (!quizSelect.value) {
                    e.preventDefault();
                    alert('Please select a quiz');
                    quizSelect.focus();
                    return false;
                }

                // Kiểm tra đã chọn câu trả lời đúng chưa
                var radioButtons = document.querySelectorAll('input[name="isCorrect"]');
                var hasCorrectAnswer = false;
                for (var i = 0; i < radioButtons.length; i++) {
                    if (radioButtons[i].checked) {
                        hasCorrectAnswer = true;
                        break;
                    }
                }

                if (!hasCorrectAnswer) {
                    e.preventDefault();
                    alert('Please select one correct answer.');
                    return false;
                }
                
                // Kiểm tra phải có ít nhất 2 câu trả lời
                if (answerGroups.length < 2) {
                    e.preventDefault();
                    alert('Please add at least 2 answer options.');
                    return false;
                }
                
                // Kiểm tra tất cả các trường câu trả lời hiển thị đã được điền chưa
                for (var i = 0; i < answerGroups.length; i++) {
                    var index = answerGroups[i];
                    var answerContent = document.getElementById('answerContent' + index);
                    if (answerContent && !answerContent.value.trim()) {
                        e.preventDefault();
                        alert('Please fill in the content for Answer Option ' + index);
                        answerContent.focus();
                        return false;
                    }
                }
                
                return true;
            };
        </script>
    </body>
</html>
