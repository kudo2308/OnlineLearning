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
                --text-color: #1f2937;
                --border-color: #e5e7eb;
                --sidebar-width: 300px;
            }

            .lesson-container {
                display: flex;
                min-height: calc(100vh - 80px);
                background-color: #f8fafc;
                margin-top: 20px;
            }

            /* Sidebar Styles */
            .lesson-sidebar {
                width: var(--sidebar-width);
                background: white;
                border-right: 1px solid var(--border-color);
                padding: 20px;
                overflow-y: auto;
                position: fixed;
                height: calc(100vh - 80px);
            }

            .lesson-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .lesson-item {
                margin-bottom: 10px;
            }

            .lesson-link {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 12px 15px;
                border-radius: 8px;
                color: var(--text-color);
                text-decoration: none;
                transition: all 0.3s ease;
                border: 1px solid transparent;
            }

            .lesson-link:hover {
                background: rgba(79, 70, 229, 0.1);
                border-color: var(--primary-light);
            }

            .lesson-link.active {
                background: var(--primary-color);
                color: white;
            }

            .lesson-link.active .lesson-duration {
                color: rgba(255, 255, 255, 0.8);
            }

            .lesson-number {
                width: 24px;
                height: 24px;
                background: #e5e7eb;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 12px;
                font-size: 0.875rem;
            }

            .active .lesson-number {
                background: white;
                color: var(--primary-color);
            }

            /* Main Content Styles */
            .lesson-content {
                flex: 1;
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            .lesson-header {
                margin-bottom: 30px;
            }

            .lesson-title {
                font-size: 2rem;
                color: var(--text-color);
                margin-bottom: 15px;
                font-weight: 600;
            }

            .lesson-description {
                color: #6b7280;
                font-size: 1.1rem;
                line-height: 1.6;
                margin-bottom: 30px;
            }

            .video-container {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                position: relative;
                padding-top: 56.25%; /* 16:9 Aspect Ratio */
            }

            .video-frame {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
                border-radius: 8px;
            }

            .no-video-message {
                text-align: center;
                padding: 40px 20px;
                color: #6b7280;
                font-size: 1.1rem;
            }

            .no-video-icon {
                font-size: 48px;
                color: #9ca3af;
                margin-bottom: 16px;
            }

            .navigation-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                padding: 20px 0;
                border-top: 1px solid var(--border-color);
            }

            .nav-button {
                padding: 12px 24px;
                border-radius: 8px;
                border: 2px solid var(--primary-color);
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .nav-button:hover {
                background: var(--primary-color);
                color: white;
            }

            .nav-button.disabled {
                opacity: 0.5;
                cursor: not-allowed;
                border-color: #ccc;
                color: #666;
            }

            .nav-button.disabled:hover {
                background: none;
                color: #666;
            }

            /* Breadcrumb Styles */
            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 20px;
                color: #6b7280;
                font-size: 0.875rem;
            }

            .breadcrumb a {
                color: var(--primary-color);
                text-decoration: none;
            }

            .breadcrumb span {
                color: #6b7280;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .lesson-sidebar {
                    display: none;
                }

                .lesson-content {
                    margin-left: 0;
                }
            }

            .course-info {
                padding: 20px;
                border-bottom: 1px solid var(--border-color);
                margin-bottom: 20px;
            }
            
            .course-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-color);
                margin-bottom: 15px;
            }
            
            .course-progress {
                font-size: 0.875rem;
                color: #6b7280;
            }
            
            .progress-bar {
                height: 4px;
                background: #e5e7eb;
                border-radius: 2px;
                margin-top: 8px;
                overflow: hidden;
            }
            
            .progress-fill {
                height: 100%;
                background: var(--primary-color);
                border-radius: 2px;
                transition: width 0.3s ease;
            }
            
            .lesson-info {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 4px;
            }
            
            .lesson-duration {
                font-size: 0.75rem;
                color: #6b7280;
                display: flex;
                align-items: center;
                gap: 4px;
            }
            
            .lesson-duration i {
                font-size: 0.875rem;
            }
        </style>
    </head>
    <body>
        <div class="lesson-container">
            <!-- Sidebar -->
            <div class="lesson-sidebar">
                <div class="course-info">
                    <h2 class="course-title">${currentLesson.course.title}</h2>
                    <p class="course-progress">
                        <span>${totalLessons} lessons</span>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${progressPercentage}%"></div>
                        </div>
                    </p>
                </div>
                
                <ul class="lesson-list">
                    <c:forEach items="${lessonList}" var="lesson" varStatus="status">
                        <li class="lesson-item">
                            <a href="lesson-demo?courseId=${courseId}&lessonId=${lesson.lessonID}" 
                               class="lesson-link ${lesson.lessonID == currentLesson.lessonID ? 'active' : ''}">
                                <span class="lesson-number">${status.index + 1}</span>
                                <div class="lesson-info">
                                    <span class="lesson-name">
                                        #${lesson.lessonID} - ${lesson.title}
                                    </span>
                                    <c:if test="${not empty lesson.duration}">
                                        <span class="lesson-duration">
                                            <i class="fas fa-clock"></i>
                                            ${lesson.duration} min
                                        </span>
                                    </c:if>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="lesson-content">
                <!-- Breadcrumb -->
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/course">Courses</a>
                    <span>/</span>
                    <span>${currentLesson.course.title}</span>
                    <span>/</span>
                    <span>${currentLesson.title}</span>
                </div>

                <!-- Lesson Header -->
                <div class="lesson-header">
                    <h1 class="lesson-title">${currentLesson.title}</h1>
                    <p class="lesson-description">${currentLesson.description}</p>
                </div>

                <!-- Video Container -->
                <div class="video-container">
                    <c:choose>
                        <c:when test="${not empty currentLesson.videoUrl}">
                            <iframe class="video-frame"
                                    src="${currentLesson.videoUrl}"
                                    title="${currentLesson.title}"
                                    frameborder="0"
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                    allowfullscreen>
                            </iframe>
                        </c:when>
                        <c:otherwise>
                            <div class="no-video-message">
                                <div class="no-video-icon">
                                    <i class="fas fa-video-slash"></i>
                                </div>
                                <p>No video available for this lesson</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Navigation Buttons -->
                <div class="navigation-buttons">
                    <c:if test="${previousLesson != null}">
                        <a href="lesson-demo?courseId=${courseId}&lessonId=${previousLesson.lessonID}" 
                           class="nav-button">
                            <i class="fas fa-arrow-left"></i>
                            Previous Lesson
                        </a>
                    </c:if>
                    <c:if test="${previousLesson == null}">
                        <span class="nav-button disabled">
                            <i class="fas fa-arrow-left"></i>
                            Previous Lesson
                        </span>
                    </c:if>

                    <c:if test="${nextLesson != null}">
                        <a href="lesson-demo?courseId=${courseId}&lessonId=${nextLesson.lessonID}" 
                           class="nav-button">
                            Next Lesson
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </c:if>
                    <c:if test="${nextLesson == null}">
                        <span class="nav-button disabled">
                            Next Lesson
                            <i class="fas fa-arrow-right"></i>
                        </span>
                    </c:if>
                </div>
            </div>
        </div>
        <!-- Debug information -->
        <div class="debug-info" style="margin-top: 20px; padding: 15px; background: #f3f4f6; border-radius: 8px;">
            <h3 style="margin-bottom: 10px; color: #374151;">Debug Information:</h3>
            <p>Course ID: ${courseId}</p>
            <p>Total Lessons: ${fn:length(lessonList)}</p>
            <p>Current Lesson ID: ${currentLesson.lessonID}</p>
            <h4 style="margin: 10px 0;">All Lessons:</h4>
            <c:forEach items="${lessonList}" var="lesson">
                <p>Lesson ID: ${lesson.lessonID}, Title: ${lesson.title}</p>
            </c:forEach>
        </div>
        <%@include file="/common/footer.jsp" %>
    </body>
</html>
