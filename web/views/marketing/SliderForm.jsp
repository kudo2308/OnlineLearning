<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${slider != null ? 'edit' : 'add'} Slider</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sliderStyle.css">
    </head>
    <body>
        <div class="container">
            <h1>${slider != null ? 'edit' : 'add'} Slider</h1>

            <c:if test="${error != null}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/slider?action=${slider != null ? 'edit' : 'add'}" 
                  method="post" 
                  enctype="multipart/form-data">

                <input type="hidden" name="sliderId" value="${slider.sliderId}">
                <div class="form-group">
                    <label for="title">Title:</label>
                    <input type="text" id="title" name="title" 
                           value="${slider.title}" 
                           class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="imageUrl">Image:</label>
                    <input type="file" id="imageUrl" name="imageUrl" 
                           class="form-control-file" 
                           ${slider == null ? 'required' : ''}>

                    <c:if test="${slider != null && slider.imageUrl != null}">
                        <img src="${pageContext.request.contextPath}${slider.imageUrl}" 
                             alt="Current Image" 
                             style="max-width: 200px; margin-top: 10px;">
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="linkUrl">Link:</label>
                    <input type="url" id="linkUrl" name="linkUrl" 
                           value="${slider.linkUrl}" 
                           class="form-control">
                </div>

                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="1" ${slider != null && slider.status == 1 ? 'selected' : ''}>
                            Active
                        </option>
                        <option value="0" ${slider != null && slider.status == 0 ? 'selected' : ''}>
                            Inactive
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" 
                              class="form-control">${slider.description}</textarea>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        ${slider != null ? 'edit' : 'add'}
                    </button>
                    <a href="${pageContext.request.contextPath}/slider" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </body>
</html>