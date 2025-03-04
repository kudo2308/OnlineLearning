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

            /* Video Container */
            .video-container {
                position: relative;
                padding-bottom: 56.25%;
                height: 0;
                overflow: hidden;
                border-radius: 0.75rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                margin-bottom: 2rem;
                background: #000;
            }

            .video-container iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
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
                color: var(--text-color);
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .video-update-form form {
                display: flex;
                gap: 1rem;
                align-items: flex-start;
            }

            .video-update-form input[type="text"] {
                flex: 1;
                padding: 0.75rem;
                border: 1px solid var(--border-color);
                border-radius: 0.5rem;
                font-size: 0.875rem;
                transition: border-color 0.2s;
            }

            .video-update-form input[type="text"]:focus {
                outline: none;
                border-color: var(--primary-light);
                box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.1);
            }

            .video-update-form button {
                padding: 0.75rem 1.5rem;
                background: var(--primary-color);
                color: white;
                border: none;
                border-radius: 0.5rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .video-update-form button:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
            }

            .video-update-form small {
                display: block;
                margin-top: 0.5rem;
                color: var(--text-light);
                font-size: 0.75rem;
            }

            .error-message {
                color: #dc2626;
                margin-top: 0.75rem;
                font-size: 0.875rem;
            }

            /* Navigation */
            .lesson-navigation {
                display: flex;
                justify-content: space-between;
                margin-top: 2rem;
                padding-top: 2rem;
                border-top: 1px solid var(--border-color);
            }

            .nav-button {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                background: white;
                border: 1px solid var(--border-color);
                border-radius: 0.5rem;
                color: var(--text-color);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.2s;
            }

            .nav-button:hover {
                background: var(--bg-light);
                border-color: var(--primary-light);
                transform: translateY(-1px);
            }

            .nav-button.disabled {
                opacity: 0.5;
                cursor: not-allowed;
                pointer-events: none;
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                :root {
                    --sidebar-width: 280px;
                }
            }

            @media (max-width: 768px) {
                .lesson-container {
                    flex-direction: column;
                }

                .lesson-sidebar {
                    position: fixed;
                    width: 100%;
                    height: auto;
                    top: 0;
                }

                .lesson-content {
                    margin-left: 0;
                    max-width: 100%;
                    padding: 1.5rem;
                }

                .video-update-form form {
                    flex-direction: column;
                }

                .video-update-form button {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="lesson-container">
            <!-- Sidebar -->
            <div class="lesson-sidebar">
                <div class="course-info">
                    <h2 class="course-title">${currentLesson.course.title}</h2>
                    <p class="course-progress">${fn:length(lessonList)} lessons</p>
                </div>
                <ul class="lesson-list">
                    <c:forEach items="${lessonList}" var="lesson" varStatus="status">
                        <li class="lesson-item">
                            <a href="${pageContext.request.contextPath}/lesson?courseId=${courseId}&lessonId=${lesson.lessonID}" 
                               class="lesson-link ${lesson.lessonID == currentLesson.lessonID ? 'active' : ''}">
                                <span class="lesson-number">${status.index + 1}</span>
                                <div class="lesson-info">
                                    <div class="lesson-name">${lesson.title}</div>
                                    <div class="lesson-duration">${lesson.duration} min</div>
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
                    <a href="${pageContext.request.contextPath}/coursedetail?courseId=${courseId}">${currentLesson.course.title}</a>
                    <span>/</span>
                    <span>${currentLesson.title}</span>
                </div>

                <!-- Lesson Header -->
                <div class="lesson-header">
                    <h1 class="lesson-title">${currentLesson.title}</h1>
                </div>
                
                <!-- Video Section -->
                <c:if test="${not empty currentLesson.videoUrl}">
                    <div class="video-container">
                        <c:set var="videoUrl" value="${currentLesson.videoUrl}" />
                        <c:choose>
                            <c:when test="${fn:contains(videoUrl, 'youtu.be/') || fn:contains(videoUrl, 'youtube.com/')}">
                                <!-- Handle YouTube URLs -->
                                <c:choose>
                                    <c:when test="${fn:contains(videoUrl, 'youtu.be/')}">
                                        <c:set var="videoId" value="${fn:substring(videoUrl, fn:indexOf(videoUrl, 'youtu.be/') + 9, fn:length(videoUrl))}" />
                                    </c:when>
                                    <c:when test="${fn:contains(videoUrl, 'watch?v=')}">
                                        <c:set var="videoId" value="${fn:substring(videoUrl, fn:indexOf(videoUrl, 'watch?v=') + 8, fn:indexOf(videoUrl, '&') > 0 ? fn:indexOf(videoUrl, '&') : fn:length(videoUrl))}" />
                                    </c:when>
                                </c:choose>
                                <iframe 
                                    src="https://www.youtube.com/embed/${videoId}"
                                    title="${currentLesson.title}"
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                    allowfullscreen>
                                </iframe>
                            </c:when>
                            <c:otherwise>
                                <!-- Handle local video files -->
                                <video controls width="100%">
                                    <source src="${pageContext.request.contextPath}${videoUrl}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Lesson Content -->
                <div class="lesson-text-content">
                    ${currentLesson.content}
                </div>

                <!-- Navigation Buttons -->
                <div class="lesson-navigation">
                    <c:if test="${not empty previousLesson}">
                        <a href="${pageContext.request.contextPath}/lesson?courseId=${courseId}&lessonId=${previousLesson.lessonID}" 
                           class="nav-button prev-button">
                            <i class="fas fa-arrow-left"></i>
                            <span>Previous: ${previousLesson.title}</span>
                        </a>
                    </c:if>
                    <c:if test="${not empty nextLesson}">
                        <a href="${pageContext.request.contextPath}/lesson?courseId=${courseId}&lessonId=${nextLesson.lessonID}" 
                           class="nav-button next-button">
                            <span>Next: ${nextLesson.title}</span>
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </c:if>
                </div>
                <style>
                    .lesson-navigation {
                        display: flex;
                        justify-content: space-between;
                        margin-top: 2rem;
                        gap: 1rem;
                    }

                    .nav-button {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.75rem 1.5rem;
                        background-color: var(--primary-color);
                        color: white;
                        text-decoration: none;
                        border-radius: 0.5rem;
                        transition: all 0.2s ease;
                    }

                    .nav-button:hover {
                        background-color: var(--primary-dark);
                        transform: translateY(-2px);
                    }

                    .prev-button {
                        margin-right: auto;
                    }

                    .next-button {
                        margin-left: auto;
                    }

                    .nav-button i {
                        font-size: 1.1rem;
                    }

                    @media (max-width: 640px) {
                        .lesson-navigation {
                            flex-direction: column;
                        }

                        .nav-button {
                            width: 100%;
                            justify-content: center;
                        }
                    }
                </style>
            </div>
        </div>
<!--         Debug information 
        <div class="debug-info" style="margin-top: 20px; padding: 15px; background: #f3f4f6; border-radius: 8px;">
            <h3 style="margin-bottom: 10px; color: #374151;">Debug Information:</h3>
            <p>Course ID: ${courseId}</p>
            <p>Total Lessons: ${fn:length(lessonList)}</p>
            <p>Current Lesson ID: ${currentLesson.lessonID}</p>
            <h4 style="margin: 10px 0;">All Lessons:</h4>
            <c:forEach items="${lessonList}" var="lesson">
                <p>Lesson ID: ${lesson.lessonID}, Title: ${lesson.title}</p>
            </c:forEach>
        </div>-->
        <%@include file="/common/footer.jsp" %>
    </body>
</html>
