<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Course List</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="${pageContext.request.contextPath}/css/custom.css" rel="stylesheet">
    <%@include file="/common/header.jsp" %>
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-light: #818cf8;
            --secondary-color: #3730a3;
            --accent-color: #f472b6;
            --text-color: #1f2937;
            --light-gray: #f3f4f6;
            --border-color: #e5e7eb;
            --gradient-start: #4f46e5;
            --gradient-end: #818cf8;
        }

        body {
            background-color: #f8fafc;
        }

        .page-layout {
            display: flex;
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 20px;
            gap: 40px;
        }

        .sidebar {
            width: 300px;
            flex-shrink: 0;
        }

        .main-content {
            flex-grow: 1;
        }

        /* Search Box Styles */
        .search-box {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            margin-bottom: 25px;
            border: 1px solid rgba(79, 70, 229, 0.1);
        }

        .search-container {
            position: relative;
            margin-bottom: 15px;
        }

        .search-input {
            width: 100%;
            padding: 12px 40px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            transition: all 0.3s ease;
            font-size: 15px;
            background-color: #f8fafc;
        }

        .search-input:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.15);
        }

        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            transition: color 0.3s ease;
        }

        .search-input:focus + .search-icon {
            color: var(--primary-color);
        }

        .clear-search {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
            color: #6b7280;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .clear-search:hover {
            color: #ef4444;
        }

        .search-input:not(:placeholder-shown) + .search-icon + .clear-search {
            opacity: 1;
            visibility: visible;
        }

        .search-loading {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            border: 2px solid var(--border-color);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: search-loading 0.8s linear infinite;
            opacity: 0;
            visibility: hidden;
        }

        .search-loading.active {
            opacity: 1;
            visibility: visible;
        }

        @keyframes search-loading {
            to {
                transform: translateY(-50%) rotate(360deg);
            }
        }

        .search-results-info {
            font-size: 14px;
            color: #6b7280;
            margin-top: 10px;
            display: none;
        }

        .search-results-info.active {
            display: block;
        }

        .sidebar-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
            padding-left: 15px;
        }

        .sidebar-title::before {
            content: '';
            position: absolute;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(to bottom, var(--gradient-start), var(--gradient-end));
            border-radius: 2px;
        }

        .category-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .category-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .category-item input[type="radio"] {
            margin: 0;
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
        }

        .category-item label {
            flex-grow: 1;
            font-size: 15px;
            color: var(--text-color);
            cursor: pointer;
            padding: 12px 15px;
            border-radius: 12px;
            transition: all 0.3s ease;
            background: white;
            border: 1px solid transparent;
        }

        .category-item:hover label {
            color: var(--primary-color);
            background: linear-gradient(white, white) padding-box,
                        linear-gradient(45deg, var(--gradient-start), var(--gradient-end)) border-box;
            border: 1px solid transparent;
            transform: translateX(5px);
        }

        .category-item input[type="radio"]:checked + label {
            color: white;
            font-weight: 500;
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2);
        }

        /* Course List Styles */
        .course-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
        }

        .course-item {
            display: flex;
            flex-direction: column;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.4s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            height: 100%;
            border: 1px solid rgba(79, 70, 229, 0.1);
            position: relative;
        }

        .course-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gradient-start), var(--gradient-end));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .course-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .course-item:hover::before {
            opacity: 1;
        }

        .course-image {
            width: 100%;
            height: 220px;
            position: relative;
            overflow: hidden;
        }

        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .course-item:hover .course-image img {
            transform: scale(1.1);
        }

        .course-category {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(79, 70, 229, 0.9);
            color: white;
            padding: 8px 18px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 500;
            backdrop-filter: blur(4px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .course-info {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .course-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-color);
            margin: 0 0 15px 0;
            line-height: 1.4;
        }

        .course-desc {
            color: #4b5563;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

        .lesson-count {
            color: #4b5563;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            background: #f8fafc;
            border-radius: 20px;
        }

        .lesson-count i {
            color: var(--primary-color);
        }

        .view-btn {
            padding: 10px 24px;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            border: none;
            position: relative;
            overflow: hidden;
        }

        .view-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, var(--gradient-end), var(--gradient-start));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .view-btn:hover::before {
            opacity: 1;
        }

        .view-btn span {
            position: relative;
            z-index: 1;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 50px;
            align-items: center;
        }

        .pagination a {
            padding: 12px 20px;
            border: 2px solid transparent;
            border-radius: 25px;
            color: var(--text-color);
            font-weight: 500;
            transition: all 0.3s ease;
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .pagination a:hover {
            background: linear-gradient(white, white) padding-box,
                        linear-gradient(45deg, var(--gradient-start), var(--gradient-end)) border-box;
            border: 2px solid transparent;
            transform: translateY(-2px);
        }

        .pagination a.active {
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            color: white;
            box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2);
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .page-layout {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
            }
            
            .category-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }
        }

        @media (max-width: 640px) {
            .course-list {
                grid-template-columns: 1fr;
            }
            
            .category-list {
                grid-template-columns: 1fr;
            }
            
            .course-meta {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .view-btn {
                width: 100%;
                text-align: center;
            }
        }

        .course-header {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(rgba(79, 70, 229, 0.05), rgba(129, 140, 248, 0.05));
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .course-header::before,
        .course-header::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            opacity: 0.1;
            z-index: 0;
        }

        .course-header::before {
            top: -150px;
            left: -150px;
        }

        .course-header::after {
            bottom: -150px;
            right: -150px;
        }

        .course-header-content {
            position: relative;
            z-index: 1;
        }

        .course-title-main {
            font-size: 48px;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 15px;
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        .course-subtitle {
            font-size: 18px;
            color: #6b7280;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="course-header">
        <div class="course-header-content">
            <h1 class="course-title-main">Our Courses</h1>
            <p class="course-subtitle">Explore our wide range of courses designed to help you achieve your learning goals</p>
        </div>
    </div>

    <div class="page-layout">
        <!-- Left Sidebar -->
        <div class="sidebar">
            <div class="search-box">
                <div class="sidebar-title">
                    <i class="fas fa-search"></i>
                    <span>Search Courses</span>
                </div>
                <div class="search-container">
                    <input type="text" 
                           class="search-input" 
                           placeholder="Search courses..."
                           value="${searchQuery}"
                           onkeyup="handleSearch(this.value)"
                           id="courseSearch">
                    <i class="fas fa-search search-icon"></i>
                    <button type="button" 
                            class="clear-search" 
                            onclick="clearSearch()"
                            aria-label="Clear search">
                        <i class="fas fa-times"></i>
                    </button>
                    <div class="search-loading"></div>
                </div>
                <div class="search-results-info">
                    Showing results for "<span id="searchTerm"></span>"
                </div>
            </div>

            <div class="search-box">
                <div class="sidebar-title">
                    <i class="fas fa-th-list"></i>
                    <span>ALL COURSES</span>
                </div>
                <form id="categoryForm" action="${pageContext.request.contextPath}/course" method="GET" class="category-list">
                    <div class="category-item">
                        <input type="radio" 
                               id="all" 
                               name="category" 
                               value="" 
                               ${empty categoryFilter ? 'checked' : ''}
                               onchange="this.form.submit()">
                        <label for="all">All Categories</label>
                    </div>
                    <c:forEach items="${listallcategory}" var="category">
                        <div class="category-item">
                            <input type="radio" 
                                   id="category${category.categoryID}" 
                                   name="category" 
                                   value="${category.categoryID}"
                                   ${categoryFilter == category.categoryID ? 'checked' : ''}
                                   onchange="this.form.submit()">
                            <label for="category${category.categoryID}">${category.name}</label>
                        </div>
                    </c:forEach>
                    <input type="hidden" name="search" id="searchInput" value="${searchQuery}">
                </form>
            </div>

            <div class="search-box">
<!--                <div class="sidebar-title">
                    <i class="fas fa-user"></i>
                    <span>My Courses</span>
                </div>-->
                <div class="course-list">
                    <c:forEach items="${userCourses}" var="course">
                        <div class="course-item">
                            <div class="course-image">
                                <img src="${pageContext.request.contextPath}${course.imageUrl}" 
                                     alt="${course.title}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-course.jpg'">
                                <div class="course-category">${course.category.name}</div>
                            </div>
                            <div class="course-info">
                                <div>
                                    <h3 class="course-title">${course.title}</h3>
                                    <p class="course-desc">${course.description}</p>
                                </div>
                                <div class="course-meta">
                                    <span class="lesson-count">
                                        <i class="fas fa-book-open"></i>
                                        ${course.totalLesson} lessons
                                    </span>
                                    <a href="${pageContext.request.contextPath}/lesson?courseId=${course.courseID}" 
                                       class="view-btn">
                                        <i class="fas fa-play-circle"></i>
                                        Start Learning
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="course-list">
                <c:forEach items="${listcourse}" var="course">
                    <div class="course-item">
                        <div class="course-image">
                            <img src="${pageContext.request.contextPath}${course.course.imageUrl}" 
                                 alt="${course.course.title}"
                                 onerror="this.src='${pageContext.request.contextPath}${course.course.imageUrl}'">
                            <div class="course-category">${course.category.name}</div>
                        </div>
                        <div class="course-info">
                            <div>
                                <h3 class="course-title">${course.course.title}</h3>
                                <p class="course-desc">${course.course.description}</p>
                            </div>
                            <div class="course-meta">
                                <span class="lesson-count">
                                    <i class="fas fa-book-open"></i>
                                    ${course.course.totalLesson} lessons
                                </span>
                                <a href="${pageContext.request.contextPath}/lesson?courseId=${course.course.courseID}" 
                                   class="view-btn">
                                    <i class="fas fa-play-circle"></i>
                                    Start Learning
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/course?page=${currentPage - 1}
                           ${not empty searchQuery ? '&search=' : ''}${searchQuery}
                           ${not empty categoryFilter ? '&category=' : ''}${categoryFilter}
                           ${not empty sortBy ? '&sort=' : ''}${sortBy}">←</a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/course?page=${i}
                           ${not empty searchQuery ? '&search=' : ''}${searchQuery}
                           ${not empty categoryFilter ? '&category=' : ''}${categoryFilter}
                           ${not empty sortBy ? '&sort=' : ''}${sortBy}"
                       class="${currentPage == i ? 'active' : ''}">${i}</a>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/course?page=${currentPage + 1}
                           ${not empty searchQuery ? '&search=' : ''}${searchQuery}
                           ${not empty categoryFilter ? '&category=' : ''}${categoryFilter}
                           ${not empty sortBy ? '&sort=' : ''}${sortBy}">→</a>
                </c:if>
            </div>
        </div>
    </div>

    <%@include file="/common/footer.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script>
        let searchTimeout;
        const searchInput = document.getElementById('courseSearch');
        const searchLoading = document.querySelector('.search-loading');
        const searchResultsInfo = document.querySelector('.search-results-info');
        const searchTermSpan = document.getElementById('searchTerm');
        
        function handleSearch(value) {
            clearTimeout(searchTimeout);
            
            if (value.trim()) {
                searchLoading.classList.add('active');
                searchResultsInfo.classList.remove('active');
            }
            
            searchTimeout = setTimeout(() => {
                document.getElementById('searchInput').value = value;
                if (value.trim()) {
                    searchTermSpan.textContent = value;
                    searchResultsInfo.classList.add('active');
                } else {
                    searchResultsInfo.classList.remove('active');
                }
                document.getElementById('categoryForm').submit();
            }, 500);
        }
        
        function clearSearch() {
            searchInput.value = '';
            document.getElementById('searchInput').value = '';
            searchResultsInfo.classList.remove('active');
            document.getElementById('categoryForm').submit();
        }
        
        // Handle loading state
        document.getElementById('categoryForm').addEventListener('submit', () => {
            searchLoading.classList.add('active');
        });
        
        // Show current search term if exists
        if (searchInput.value.trim()) {
            searchTermSpan.textContent = searchInput.value;
            searchResultsInfo.classList.add('active');
        }
    </script>
</body>
</html>
