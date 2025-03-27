<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lesson View</title>
        <%@include file="/common/header.jsp" %>
        <style>
            :root {
                --primary-color: #4f46e5;
                --primary-light: #818cf8;
                --primary-dark: #3730a3;
                --text-color: #1f2937;
                --text-light: #6b7280;
                --border-color: #e5e7eb;
                --bg-light: #f8fafc;
                --sidebar-width: 320px;
                --header-height: 130px;
            }

            /* Main Layout */
            body {
                margin: 0;
                padding: 0;
                overflow-x: hidden;
            }

            .lesson-container {
                display: flex;
                min-height: calc(100vh - var(--header-height));
                background-color: var(--bg-light);
                margin-top: var(--header-height);
                position: relative;
            }

            /* Sidebar Styles */
            .lesson-sidebar {
                width: var(--sidebar-width);
                background: white;
                border-right: 1px solid var(--border-color);
                padding: 1.5rem;
                overflow-y: auto;
                position: fixed;
                height: calc(100vh - var(--header-height));
                left: 0;
                top: var(--header-height);
                box-shadow: 2px 0 4px rgba(0, 0, 0, 0.05);
                z-index: 10;
            }

            /* Main Content Styles */
            .lesson-content {
                flex: 1;
                margin-left: var(--sidebar-width);
                padding: 2rem;
                max-width: calc(100% - var(--sidebar-width));
                min-height: calc(100vh - var(--header-height));
                overflow-y: auto;
            }

            .course-info {
                padding-bottom: 1.5rem;
                border-bottom: 1px solid var(--border-color);
                margin-bottom: 1.5rem;
            }

            .course-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--text-color);
                margin-bottom: 0.5rem;
            }

            .course-progress {
                color: var(--text-light);
                font-size: 0.875rem;
            }

            /* Package Styles */
            .package-header {
                padding: 1rem;
                background-color: #f3f4f6;
                border-left: 4px solid var(--primary-color);
                margin-bottom: 0.5rem;
                margin-top: 1.5rem;
            }
            
            .package-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--text-color);
                margin: 0;
            }
            
            /* Lesson Styles */
            .lesson-list {
                list-style: none;
                padding: 0;
                margin: 0 0 0 1rem;
            }
            
            .lesson-item {
                margin-bottom: 0.5rem;
            }
            
            .lesson-link {
                display: block;
                padding: 0.75rem 1rem;
                border-radius: 0.5rem;
                color: var(--text-color);
                text-decoration: none;
                transition: all 0.2s ease;
                border: 1px solid transparent;
            }
            
            .lesson-link:hover {
                background: rgba(79, 70, 229, 0.05);
                border-color: var(--primary-light);
                transform: translateX(2px);
            }
            
            .lesson-link.active {
                background: var(--primary-color);
                color: white;
                transform: translateX(4px);
                box-shadow: 0 2px 4px rgba(79, 70, 229, 0.2);
            }
            
            .lesson-info {
                flex: 1;
            }
            
            .lesson-name {
                font-weight: 500;
                margin-bottom: 0.25rem;
                line-height: 1.4;
            }
            
            .lesson-duration {
                font-size: 0.875rem;
                color: var(--text-light);
            }
            
            .active .lesson-duration {
                color: rgba(255, 255, 255, 0.8);
            }

            /* Lesson List Styles */
            .lesson-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .lesson-item {
                margin-bottom: 0.75rem;
            }

            .lesson-link {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 1rem;
                border-radius: 0.5rem;
                color: var(--text-color);
                text-decoration: none;
                transition: all 0.2s ease;
                border: 1px solid transparent;
            }

            .lesson-link:hover {
                background: rgba(79, 70, 229, 0.05);
                border-color: var(--primary-light);
                transform: translateX(2px);
            }

            .lesson-link.active {
                background: var(--primary-color);
                color: white;
                transform: translateX(4px);
                box-shadow: 0 2px 4px rgba(79, 70, 229, 0.2);
            }

            .lesson-number {
                width: 28px;
                height: 28px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.875rem;
                font-weight: 500;
                flex-shrink: 0;
            }

            .lesson-info {
                flex: 1;
            }

            .lesson-name {
                font-weight: 500;
                margin-bottom: 0.25rem;
                line-height: 1.4;
            }

            .lesson-package {
                font-size: 0.875rem;
                color: var(--primary-color);
                margin-bottom: 0.25rem;
            }

            .lesson-duration {
                font-size: 0.875rem;
                color: var(--text-light);
            }

            .active .lesson-duration {
                color: rgba(255, 255, 255, 0.8);
            }

            /* Main Content Styles */
            .lesson-header {
                margin-bottom: 2rem;
            }

            .lesson-title {
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-color);
                margin-bottom: 1rem;
                line-height: 1.3;
            }

            /* Video Container Styles */
            .video-container {
                position: relative;
                width: 100%;
                height: 0;
                padding-bottom: 56.25%; /* 16:9 aspect ratio */
                margin-bottom: 2rem;
                background-color: #000;
                overflow: hidden;
            }
            
            .video-container iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
            }
            
            .fullscreen-button {
                position: absolute;
                bottom: 20px;
                right: 20px;
                background-color: rgba(0, 0, 0, 0.5);
                color: white;
                border: none;
                border-radius: 4px;
                padding: 8px 12px;
                cursor: pointer;
                z-index: 10;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            
            .fullscreen-button:hover {
                background-color: rgba(0, 0, 0, 0.8);
            }
            
            /* When in fullscreen mode */
            .video-container.fullscreen {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                padding-bottom: 0;
                z-index: 9999;
            }

            /* Lesson Content */
            .lesson-text-content {
                background: white;
                padding: 2rem;
                border-radius: 0.75rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                line-height: 1.6;
                color: var(--text-color);
            }

            /* Video Update Form */
            .video-update-form {
                background: white;
                padding: 1.5rem;
                border-radius: 0.75rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 2rem;
            }

            .video-update-form h3 {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--text-color);
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .form-label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: var(--text-color);
            }

            .form-control {
                width: 100%;
                padding: 0.75rem;
                border-radius: 0.5rem;
                border: 1px solid var(--border-color);
                background-color: white;
                font-size: 1rem;
                transition: border-color 0.2s ease;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 0.5rem;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
            }

            /* Document Links */
            .document-links {
                margin-top: 2rem;
            }

            .document-links h3 {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--text-color);
            }

            .document-link {
                display: inline-flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1rem 1.5rem;
                background-color: white;
                border: 1px solid var(--border-color);
                border-radius: 0.5rem;
                color: var(--text-color);
                text-decoration: none;
                margin-right: 1rem;
                margin-bottom: 1rem;
                transition: all 0.2s ease;
            }

            .document-link:hover {
                border-color: var(--primary-color);
                transform: translateY(-2px);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            .document-icon {
                font-size: 1.5rem;
                color: var(--primary-color);
            }

            /* Breadcrumb */
            .breadcrumb {
                display: flex;
                align-items: center;
                margin-bottom: 1.5rem;
                font-size: 0.875rem;
            }

            .breadcrumb a {
                color: var(--text-light);
                text-decoration: none;
                transition: color 0.2s ease;
            }

            .breadcrumb a:hover {
                color: var(--primary-color);
            }

            .breadcrumb-separator {
                margin: 0 0.5rem;
                color: var(--text-light);
            }

            .breadcrumb-current {
                font-weight: 500;
                color: var(--text-color);
            }

            /* Lesson Navigation */
            .lesson-navigation {
                display: flex;
                justify-content: space-between;
                margin-top: 2rem;
                padding-top: 1.5rem;
                border-top: 1px solid var(--border-color);
            }

            .nav-button {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.25rem;
                background-color: white;
                border: 1px solid var(--border-color);
                border-radius: 0.5rem;
                color: var(--text-color);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.2s ease;
            }

            .nav-button:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
            }

            .nav-button.disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .nav-button.next {
                background-color: var(--primary-color);
                color: white;
            }

            .nav-button.next:hover {
                background-color: var(--primary-dark);
            }
            
            .nav-button.quiz-button {
                background-color: #28a745;
                border-color: #28a745;
            }
            
            .nav-button.quiz-button:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            /* Video error styles */
            .video-error {
                padding: 2rem;
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 0.5rem;
                text-align: center;
                margin: 1rem 0;
            }
            
            .video-error p {
                margin-bottom: 0.5rem;
            }
            
            .video-error a {
                color: var(--primary-color);
                text-decoration: underline;
            }

            /* Modal Styles */
            .modal {
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .modal-content {
                background-color: white;
                padding: 2rem;
                border-radius: 0.5rem;
                max-width: 500px;
                width: 90%;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                position: relative;
                text-align: center;
            }
            
            .close-button {
                position: absolute;
                top: 0.5rem;
                right: 1rem;
                font-size: 1.5rem;
                cursor: pointer;
            }
            
            #quizInfo {
                margin-top: 1.5rem;
            }
            
            #startQuizButton {
                display: inline-block;
                margin-top: 1.5rem;
                text-decoration: none;
                border-radius: 0.25rem;
            }
            
            .lesson-link.quiz-link {
                background-color: #f8f9fa;
                border-left: 3px solid #28a745;
            }
            
            .lesson-link.quiz-link:hover {
                background-color: #e9ecef;
                border-color: #218838;
            }
            
            .lesson-link.quiz-link .lesson-name {
                color: #28a745;
                font-weight: 600;
            }
            
            .lesson-item.quiz-item {
                margin-top: 8px;
                margin-bottom: 8px;
            }
        </style>
    </head>
    <body>
        <div class="lesson-container">
            <!-- Sidebar -->
            <div class="lesson-sidebar">
                <div class="course-info">
                    <h2 class="course-title">${currentLesson.course.title}</h2>
                    <div class="course-progress">
                        <span>${courseProgress}% completed</span>
                    </div>
                </div>
                
                <!-- Lessons grouped by package -->
                <div class="package-lessons">
                    <c:set var="currentPackageId" value="0" />
                    
                    <c:forEach items="${lessonList}" var="lesson" varStatus="status">
                        <c:if test="${currentPackageId != lesson.packages.packageID}">
                            <c:if test="${currentPackageId != 0}">
                                <!-- Check for quiz at the end of the package -->
                                <c:set var="packageQuiz" value="${null}" />
                                <c:forEach items="${quizList}" var="quiz">
                                    <c:if test="${quiz.packageID == currentPackageId}">
                                        <c:set var="packageQuiz" value="${quiz}" />
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${packageQuiz != null}">
                                    <li class="lesson-item quiz-item">
                                        <a href="${pageContext.request.contextPath}/Test?action=take&id=${packageQuiz.quizID}" 
                                           class="lesson-link quiz-link">
                                            <div class="lesson-info">
                                                <div class="lesson-name"><i class="fas fa-check-circle"></i> Quiz: ${packageQuiz.name}</div>
                                                <div class="lesson-duration">${packageQuiz.duration} minutes</div>
                                            </div>
                                        </a>
                                    </li>
                                </c:if>
                                </ul>
                            </c:if>
                            
                            <div class="package-header">
                                <h3 class="package-title">Package: ${lesson.packages.name}</h3>
                            </div>
                            
                            <ul class="lesson-list">
                            <c:set var="currentPackageId" value="${lesson.packages.packageID}" />
                        </c:if>
                        
                        <li class="lesson-item">
                            <a href="${pageContext.request.contextPath}/lesson?id=${lesson.lessonID}" 
                               class="lesson-link ${lesson.lessonID == currentLesson.lessonID ? 'active' : ''}">
                                <div class="lesson-info">
                                    <div class="lesson-name">Lesson: ${lesson.title}</div>
                                    <div class="lesson-duration">${lesson.duration} minutes</div>
                                </div>
                            </a>
                        </li>
                        
                        <c:if test="${status.last}">
                            <!-- Check for quiz at the end of the last package -->
                            <c:set var="packageQuiz" value="${null}" />
                            <c:forEach items="${quizList}" var="quiz">
                                <c:if test="${quiz.packageID == currentPackageId}">
                                    <c:set var="packageQuiz" value="${quiz}" />
                                </c:if>
                            </c:forEach>
                            
                            <c:if test="${packageQuiz != null}">
                                <li class="lesson-item quiz-item">
                                    <a href="${pageContext.request.contextPath}/Test?action=take&id=${packageQuiz.quizID}" 
                                       class="lesson-link quiz-link">
                                        <div class="lesson-info">
                                            <div class="lesson-name"><i class="fas fa-check-circle"></i> Quiz: ${packageQuiz.name}</div>
                                            <div class="lesson-duration">${packageQuiz.duration} minutes</div>
                                        </div>
                                    </a>
                                </li>
                            </c:if>
                            </ul>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="lesson-content">
                <!-- Breadcrumb -->
                <nav class="breadcrumb" aria-label="breadcrumb">
                    <a href="${pageContext.request.contextPath}/my-courses">
                        <i class="fas fa-home"></i> 
                        <span>Courses</span>
                    </a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseID}">
                        ${currentLesson.course.title}
                    </a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="#">
                        <i class="fas fa-folder"></i> ${currentLesson.packages.name}
                    </a>
                    <span class="breadcrumb-separator">/</span>
                    <span class="breadcrumb-current">${currentLesson.title}</span>
                </nav>

                <!-- Lesson Header -->
                <div class="lesson-header">
                    <h1 class="lesson-title">${currentLesson.title}</h1>
                </div>

                <!-- Video Container (if video lesson) -->
                <c:if test="${not empty currentLesson.videoUrl}">
                    <div class="video-container">
                        <c:choose>
                            <c:when test="${fn:contains(currentLesson.videoUrl, 'youtube.com') || fn:contains(currentLesson.videoUrl, 'youtu.be')}">
                                <!-- Extract video ID directly using simpler approach -->
                                <c:set var="videoId" value="" />
                                
                                <c:if test="${fn:contains(currentLesson.videoUrl, 'watch?v=')}">
                                    <c:set var="videoId" value="${fn:substringAfter(currentLesson.videoUrl, 'watch?v=')}" />
                                    <c:if test="${fn:contains(videoId, '&')}">
                                        <c:set var="videoId" value="${fn:substringBefore(videoId, '&')}" />
                                    </c:if>
                                </c:if>
                                
                                <c:if test="${fn:contains(currentLesson.videoUrl, 'youtu.be/')}">
                                    <c:set var="videoId" value="${fn:substringAfter(currentLesson.videoUrl, 'youtu.be/')}" />
                                    <c:if test="${fn:contains(videoId, '?')}">
                                        <c:set var="videoId" value="${fn:substringBefore(videoId, '?')}" />
                                    </c:if>
                                </c:if>
                                
                                <iframe 
                                    id="youtube-player"
                                    src="https://www.youtube.com/embed/${videoId}" 
                                    title="${currentLesson.title}" 
                                    frameborder="0" 
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                    allowfullscreen
                                    style="width: 100%; height: 100%;">
                                </iframe>
                            </c:when>
                            <c:otherwise>
                                <!-- For non-YouTube videos -->
                                <iframe 
                                    src="${currentLesson.videoUrl}" 
                                    title="${currentLesson.title}" 
                                    frameborder="0" 
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                    allowfullscreen
                                    style="width: 100%; height: 100%;">
                                </iframe>
                            </c:otherwise>
                        </c:choose>
                      
                    </div>
                </c:if>

                <!-- Lesson Content -->
                <div class="lesson-text-content">
                    ${currentLesson.content}
                </div>

                <!-- Document Links (if any) -->
                <c:if test="${not empty currentLesson.documentUrl}">
                    <div class="document-links">
                        <h3>Tài liệu tham khảo</h3>
                        <a href="${currentLesson.documentUrl}" class="document-link" target="_blank">
                            <span class="document-icon"><i class="fas fa-file-pdf"></i></span>
                            <span>Download Lesson PDF</span>
                        </a>
                    </div>
                </c:if>

                <!-- Lesson Navigation -->
                <div class="lesson-navigation">
                    <c:if test="${not empty prevLesson}">
                        <a href="${pageContext.request.contextPath}/lesson?id=${prevLesson.lessonID}" class="nav-button prev">
                            <i class="fas fa-arrow-left"></i>
                            <span>Previous Lesson</span>
                        </a>
                    </c:if>
                    
                    <!-- Debug info (hidden) -->
                    <div style="display: none;">
                        <p>packageCompleted: ${packageCompleted}</p>
                        <p>hasQuiz: ${hasQuiz}</p>
                        <p>nextLesson: ${not empty nextLesson}</p>
                        <c:if test="${hasQuiz == true}">
                            <p>quizInfo: ${quizInfo.quizID} - ${quizInfo.name}</p>
                        </c:if>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty nextLesson}">
                            <a href="${pageContext.request.contextPath}/lesson?id=${nextLesson.lessonID}" class="nav-button next">
                                <span>Next Lesson</span>
                                <i class="fas fa-arrow-right"></i>
                            </a>
                        </c:when>
                        <c:when test="${packageCompleted == true && hasQuiz == true}">
                            <a href="${pageContext.request.contextPath}/Test?action=take&id=${quizInfo.quizID}" class="nav-button next quiz-button">
                                <span>Test Quiz</span>
                                <i class="fas fa-check-circle"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/my-courses" class="nav-button next">
                                <span>Finish Course</span>
                                <i class="fas fa-check"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Quiz Modal -->
        <div id="quizModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close-button">&times;</span>
                <h2>Congratulations!</h2>
                <p>You have completed all lessons in this package.</p>
                <div id="quizInfo">
                    <h3>Ready for a Quiz?</h3>
                    <p id="quizDescription"></p>
                    <p><strong>Duration:</strong> <span id="quizDuration"></span> minutes</p>
                    <a id="startQuizButton" href="#" class="btn-primary">Start Quiz</a>
                </div>
            </div>
        </div>

        <!-- Hidden quiz data if available -->
        <c:if test="${packageCompleted == true && hasQuiz == true}">
            <div id="quizData" 
                 data-quiz-id="${quizInfo.quizID}" 
                 data-quiz-name="${quizInfo.name}" 
                 data-quiz-description="${quizInfo.description}" 
                 data-quiz-duration="${quizInfo.duration}"
                 style="display: none;">
            </div>
        </c:if>

        <script>
            const videoContainer = document.querySelector('.video-container');
            const fullscreenButton = document.querySelector('.fullscreen-button');

            if (fullscreenButton) {
                fullscreenButton.addEventListener('click', () => {
                    if (videoContainer.classList.contains('fullscreen')) {
                        videoContainer.classList.remove('fullscreen');
                        fullscreenButton.textContent = 'Enter Fullscreen';
                    } else {
                        videoContainer.classList.add('fullscreen');
                        fullscreenButton.textContent = 'Exit Fullscreen';
                    }
                });
            }
            
            // Check if package is completed and has quiz when page loads
            document.addEventListener('DOMContentLoaded', function() {
                const quizDataElement = document.getElementById('quizData');
                if (quizDataElement) {
                    // Get quiz data from the hidden element
                    const quizInfo = {
                        quizId: quizDataElement.getAttribute('data-quiz-id'),
                        name: quizDataElement.getAttribute('data-quiz-name'),
                        description: quizDataElement.getAttribute('data-quiz-description'),
                        duration: quizDataElement.getAttribute('data-quiz-duration')
                    };
                    showQuizModal(quizInfo);
                }
            });
            
            // YouTube API integration for tracking video progress
            let player;
            let videoCompleted = false;
            let videoTotalTime = 0;
            let progressCheckInterval;
            let lessonId = "${currentLesson.lessonID}";
            
            // Load YouTube API
            const tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            const firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            
            // Create YouTube player when API is ready
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('youtube-player', {
                    events: {
                        'onReady': onPlayerReady,
                        'onStateChange': onPlayerStateChange
                    }
                });
            }
            
            // When player is ready, get video duration
            function onPlayerReady(event) {
                videoTotalTime = player.getDuration();
                console.log("Video duration: " + videoTotalTime + " seconds");
            }
            
            // Track video state changes
            function onPlayerStateChange(event) {
                // When video starts playing
                if (event.data == YT.PlayerState.PLAYING) {
                    startProgressTracking();
                }
                
                // When video is paused
                if (event.data == YT.PlayerState.PAUSED) {
                    stopProgressTracking();
                    checkVideoProgress();
                }
                
                // When video ends
                if (event.data == YT.PlayerState.ENDED) {
                    stopProgressTracking();
                    markLessonAsComplete();
                }
            }
            
            // Start tracking progress
            function startProgressTracking() {
                if (!progressCheckInterval) {
                    progressCheckInterval = setInterval(checkVideoProgress, 5000); // Check every 5 seconds
                }
            }
            
            // Stop tracking progress
            function stopProgressTracking() {
                if (progressCheckInterval) {
                    clearInterval(progressCheckInterval);
                    progressCheckInterval = null;
                }
            }
            
            // Check video progress and mark as complete if 80% watched
            function checkVideoProgress() {
                if (player && !videoCompleted) {
                    const currentTime = player.getCurrentTime();
                    const progressPercent = (currentTime / videoTotalTime) * 100;
                    console.log("Video progress: " + progressPercent.toFixed(2) + "%");
                    
                    // Update progress bar
                    updateProgressBar(progressPercent);
                    
                    // If watched 80% or more, mark as complete
                    if (progressPercent >= 80) {
                        markLessonAsComplete();
                    }
                }
            }
            
            // Update progress bar
            function updateProgressBar(percent) {
                // You can implement a visual progress bar here if needed
                console.log("Updating progress bar: " + percent.toFixed(2) + "%");
            }
            
            // Mark lesson as complete
            function markLessonAsComplete() {
                if (!videoCompleted) {
                    videoCompleted = true;
                    console.log("Lesson marked as complete!");
                    
                    // Call API to update lesson progress
                    fetch('${pageContext.request.contextPath}/lesson-progress', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `lessonId=${lessonId}&completed=true`
                    })
                    .then(response => response.json())
                    .then(data => {
                        console.log("Progress updated:", data);
                        
                        // Update course progress display
                        if (data.courseProgress) {
                            document.querySelector('.progress-bar-fill').style.width = data.courseProgress + '%';
                            document.querySelector('.progress-text').textContent = data.courseProgress + '%';
                        }
                        
                        // Check if package is completed and quiz is available
                        if (data.packageCompleted && data.hasQuiz) {
                            showQuizModal(data.quizInfo);
                        }
                    })
                    .catch(error => {
                        console.error("Error updating progress:", error);
                    });
                }
            }
            
            // Show quiz modal
            function showQuizModal(quizInfo) {
                const modal = document.getElementById('quizModal');
                const quizDescription = document.getElementById('quizDescription');
                const quizDuration = document.getElementById('quizDuration');
                const startQuizButton = document.getElementById('startQuizButton');
                
                // Set quiz information
                quizDescription.textContent = quizInfo.description;
                quizDuration.textContent = quizInfo.duration;
                startQuizButton.href = '${pageContext.request.contextPath}/Test?action=take&id=' + quizInfo.quizId;
                
                // Show modal
                modal.style.display = 'flex';
                
                // Close modal when clicking the close button
                document.querySelector('.close-button').addEventListener('click', () => {
                    modal.style.display = 'none';
                });
                
                // Close modal when clicking outside the modal content
                modal.addEventListener('click', (event) => {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                });
            }
        </script>
    </body>
</html>
