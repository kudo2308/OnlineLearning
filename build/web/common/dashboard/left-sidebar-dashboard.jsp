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
                            <a href="addLesson" class="ttr-material-button"><span class="ttr-label">Add Lesson</span></a>
                        </li>

                        <li>
                            <a href="viewLessonForAd" class="ttr-material-button"><span class="ttr-label">Lesson View</span></a>
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
                <li>
                    <a href="#" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-user"></i></span>
                        <span class="ttr-label">My Profile</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <li>
                            <a href="user-profile.html" class="ttr-material-button"><span class="ttr-label">User Profile</span></a>
                        </li>
                        <li>
                            <a href="teacher-profile.html" class="ttr-material-button"><span class="ttr-label">Teacher Profile</span></a>
                        </li>
                    </ul>
                </li>
                <li class="ttr-seperate"></li>
            </ul>

        </nav>

    </div>
</div>