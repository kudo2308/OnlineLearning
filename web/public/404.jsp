<%-- 
    Document   : 404
    Created on : Feb 9, 2025, 4:27:17 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/404.css" />
        <title>404 Page</title>
    </head>
    <h1>404 Error</h1>
    <p class="zoom-area"><b>Not found</b>This page doesn't exist</p>
    <section class="error-container">
        <span class="four"><span class="screen-reader-text">4</span></span>
        <span class="zero"><span class="screen-reader-text">0</span></span>
        <span class="four"><span class="screen-reader-text">4</span></span>
    </section>
    <div class="link-container">
        <a target="_blank" href="${pageContext.request.contextPath}/home" class="more-link">Back to home page</a>
    </div>
</html>
