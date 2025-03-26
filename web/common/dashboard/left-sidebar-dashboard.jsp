<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="ttr-sidebar">
    <div class="ttr-sidebar-wrapper content-scroll">
        <!-- side menu logo start -->
        <div class="ttr-sidebar-logo">
            <a href="#"><img alt="" src="assets/images/logo.png" width="122" height="27"></a>
            <div class="ttr-sidebar-toggle-button">
                <i class="ti-arrow-left"></i>
            </div>
        </div>
        <!-- side menu logo end -->
        <!-- sidebar menu start -->
        <nav class="ttr-sidebar-navi">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/courses" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Courses</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>

                    <ul>
                        <li>
                            <a href="courses" class="ttr-material-button"><span class="ttr-label">Course List</span></a>
                        </li>
                         <li>
                            <a href="packages" class="ttr-material-button"><span class="ttr-label">Packages List</span></a>
                        </li>
                         <li>
                            <a href="lessons" class="ttr-material-button"><span class="ttr-label">Lesson List</span></a>
                        </li>
<!--                        <li>
                            <a href="addCourse" class="ttr-material-button"><span class="ttr-label">Add Course</span></a>
                        </li>

                        <li>
                            <a href="addLesson" class="ttr-material-button"><span class="ttr-label">Add Lesson</span></a>
                        </li>-->
                        <li>
                            <a href="QuizList" class="ttr-material-button"><span class="ttr-label">Quiz List</span></a>
                        </li>

                        <li>
                            <a href="AddQuiz" class="ttr-material-button"><span class="ttr-label">Add Quiz</span></a>
                        </li>
                        <li>
                            <a href="AddQuestion" class="ttr-material-button"><span class="ttr-label">Add Question</span></a>
                        </li>
                        <li>
                            <a href="manageQuestion" class="ttr-material-button"><span class="ttr-label">Question List</span></a>
                        </li>
                    </ul>
                </li>      
                <li class="ttr-seperate"></li>
            </ul>

        </nav>

    </div>
</div>