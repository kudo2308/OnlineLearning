<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="EduChamp : Education HTML Template" />

        <!-- OG -->
        <meta property="og:title" content="EduChamp : Education HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>${slider != null ? 'Edit' : 'Add New'} Slider</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/admin/assets/css/color/color-1.css">
        
        <style>
            .preview-image {
                max-width: 300px;
                max-height: 200px;
                margin-top: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 5px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .btn-container {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 30px;
            }
            
            .error-message {
                color: #dc3545;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 20px;
                display: none;
            }
            
            .success-message {
                color: #28a745;
                background-color: #d4edda;
                border: 1px solid #c3e6cb;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 20px;
                display: none;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="/public/header-admin.jsp"></jsp:include>
        <jsp:include page="/public/sidebar-admin.jsp"></jsp:include>

        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Slider Management</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/slider">Slider List</a></li>
                        <li>${slider != null ? 'Edit' : 'Add New'} Slider</li>
                    </ul>
                </div>

                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>${slider != null ? 'Edit' : 'Add New'} Slider</h4>
                            </div>
                            <div class="widget-inner">
                                <c:if test="${error != null}">
                                    <div id="error-message" class="error-message">${error}</div>
                                </c:if>
                                
                                <c:if test="${success != null}">
                                    <div id="success-message" class="success-message">${success}</div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/slider?action=${slider != null ? 'edit' : 'add'}" 
                                      method="post" 
                                      enctype="multipart/form-data"
                                      class="edit-profile m-b30">
                                    
                                    <input type="hidden" name="sliderId" value="${slider.sliderId}">
                                    
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="ml-auto">
                                                <h3>Slider Information</h3>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Title <span class="text-danger">*</span></label>
                                            <div>
                                                <input type="text" id="title" name="title" 
                                                       value="${slider.title}" 
                                                       class="form-control" required>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Image <span class="text-danger">*</span></label>
                                            <div>
                                                <input type="file" id="imageUrl" name="imageUrl" 
                                                       class="form-control-file" 
                                                       ${slider == null ? 'required' : ''}>
                                                
                                                <c:if test="${slider != null && slider.imageUrl != null}">
                                                    <div class="mt-2">
                                                        <p>Current image:</p>
                                                        <img src="${pageContext.request.contextPath}${slider.imageUrl}" 
                                                             alt="Current Image" 
                                                             class="preview-image">
                                                    </div>
                                                </c:if>
                                                
                                                <div id="image-preview" class="mt-2" style="display: none;">
                                                    <p>New image preview:</p>
                                                    <img id="preview" class="preview-image">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Link URL</label>
                                            <div>
                                                <input type="url" id="linkUrl" name="linkUrl" 
                                                       value="${slider.linkUrl}" 
                                                       placeholder="https://example.com"
                                                       class="form-control">
                                            </div>
                                        </div>
                                        
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Status <span class="text-danger">*</span></label>
                                            <div>
                                                <select id="status" name="status" class="form-control" required>
                                                    <option value="1" ${slider != null && slider.status == 1 ? 'selected' : ''}>
                                                        Active
                                                    </option>
                                                    <option value="0" ${slider != null && slider.status == 0 ? 'selected' : ''}>
                                                        Inactive
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group col-12">
                                            <label class="col-form-label">Description</label>
                                            <div>
                                                <textarea id="description" name="description" 
                                                          class="form-control" rows="4">${slider.description}</textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="col-12">
                                            <div class="btn-container">
                                                <button type="submit" class="btn btn-primary">
                                                    ${slider != null ? 'Update' : 'Add'} Slider
                                                </button>
                                                <a href="${pageContext.request.contextPath}/slider" class="btn btn-secondary">Cancel</a>
                                            </div>
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
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/masonry.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/masonry/filter.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src='${pageContext.request.contextPath}/assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/assets/js/admin.js"></script>
        
        <script>
            // Show error or success message if present
            document.addEventListener('DOMContentLoaded', function() {
                var errorMessage = document.getElementById('error-message');
                var successMessage = document.getElementById('success-message');
                
                if (errorMessage) {
                    errorMessage.style.display = 'block';
                    setTimeout(function() {
                        errorMessage.style.display = 'none';
                    }, 5000);
                }
                
                if (successMessage) {
                    successMessage.style.display = 'block';
                    setTimeout(function() {
                        successMessage.style.display = 'none';
                    }, 5000);
                }
                
                // Image preview functionality
                document.getElementById('imageUrl').addEventListener('change', function(e) {
                    var preview = document.getElementById('preview');
                    var imagePreview = document.getElementById('image-preview');
                    var file = e.target.files[0];
                    
                    if (file) {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            preview.src = e.target.result;
                            imagePreview.style.display = 'block';
                        }
                        reader.readAsDataURL(file);
                    } else {
                        imagePreview.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>