
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- pagination -->
<section id="page-navigation" class="d-flex justify-content-center">
    <ul class="pagination">
        <!--Home-->
        <c:if test="${pageControl.page > 1}">
            <li class="page-item">
                <a class="page-link" href="${pageControl.urlPattern}page=1">Home</a>
            </li>
        </c:if>

        <!--Previous-->
        <c:choose>
            <c:when test="${pageControl.page == 1}">
                <li class="page-item disabled">
                    <a class="page-link" >Previous</a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="page-item">
                    <a class="page-link" href="${pageControl.urlPattern}page=${pageControl.page - 1}">Previous</a>
                </li>
            </c:otherwise>
        </c:choose>

        <!--Pages-->
        <c:forEach begin="1" end="${pageControl.totalPage}" var="pageNumber">
            <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                <a class="page-link" href="${pageControl.urlPattern}page=${pageNumber}">${pageNumber}</a>
            </li>
        </c:forEach>

        <!--Next-->
        <c:choose>
            <c:when test="${pageControl.page == pageControl.totalPage}">
                <li class="page-item disabled">
                    <a class="page-link">Next</a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="page-item">
                    <a class="page-link" href="${pageControl.urlPattern}page=${pageControl.page + 1}">Next</a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</section>
<!-- pagination -->
