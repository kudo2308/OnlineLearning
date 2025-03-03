<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="./assets/css/userprofile.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
        <title>Online Learning</title>
    </head>
    <jsp:include page="common/header.jsp"></jsp:include>
        <hr>
        <body>
            <div class="container mt-5">
                <div class="d-flex">
                    <div class="sidebar p-3 border rounded bg-white">

                    <c:choose>
                        <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/avatar/unknow.jpg'}">
                            <img src="assets/images/avatar/unknow.jpg" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:when>
                        <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                            <img src="${sessionScope.account.img}" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <img src=".${sessionScope.account.img}" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        </c:otherwise>
                    </c:choose>
                    <h5 class="text-center">${sessionScope.account.username}</h5>
                    <a href="#">View Profile</a>
                    <a href="userprofile">Profile Public</a>
                    <a href="photo">Photo</a>
                    <a href="changepassuser">Change Password</a>
                    <a href="#">Subscriptions</a>
                    <br>
                    <br>
                </div>
                <div style="margin:0 " class="profile-container ms-4 flex-grow-1">
                    <div class="header-profile">
                        <h1>Photo</h1>
                        <p class="text-muted">Add a nice photo of yourself for your profile.</p>
                    </div>
                    <hr>
                    <form action="photo" method="post"  enctype="multipart/form-data">
                        <div class="mb-3 text-center">
                            <label class="form-label d-block">Image Preview</label>

                            <c:choose>
                                <c:when test="${empty sessionScope.account.img || sessionScope.account.img == '/assets/images/avatar/unknow.jpg'}">
                                    <img id="imagePreview" src="assets/images/avatar/unknow.jpg" class="img-fluid border rounded" style="max-width: 250px; display:block; margin:auto;" />
                                </c:when>
                                <c:when test="${fn:startsWith(sessionScope.account.img, 'https://')}">
                                    <img src="${sessionScope.account.img}" id="imagePreview" class="img-fluid border rounded" style="max-width: 250px; display:block; margin:auto;" >
                                </c:when>
                                <c:otherwise>
                                    <img id="imagePreview" src=".${sessionScope.account.img}" class="img-fluid border rounded" style="max-width: 250px; display:block; margin:auto;" />
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Add / Change Image</label>
                            <input type="file" name="file" lang="en" class="form-control" accept="image/*" onchange="previewImage(event)">
                        </div>
                        <input type="hidden" name="croppedImage" id="croppedImage">
                        <button id="cropBtn" type="button" class="btn btn-secondary mt-2" style="display: none;">Crop Image</button>
                        <button type="submit" class="btn btn-primary mt-3">Save</button>
                    </form>
                </div>
            </div>
        </div>

        <c:set var="error" value="${requestScope.errorprofile}" />
        <c:if test="${not empty error}">
            <div id="error-message" class="error-message">
                <i class="bx bxs-error"></i> ${error}
            </div>
        </c:if>
        <c:set var="success" value="${requestScope.success}" />
        <c:if test="${not empty success}">
            <div id="success" class="success">
                <i class="bx bxs-error"></i> ${success}
            </div>
        </c:if>
    </body>
    <jsp:include page="common/footer.jsp"></jsp:include> 
    <script src="${pageContext.request.contextPath}/assets/js/js.js"></script>
    <script>
                                function showMessage() {
                                    var errorMessage = document.getElementById("error-message");
                                    var successMessage = document.getElementById("success");

                                    // Hiển thị thông báo lỗi nếu có
                                    if (errorMessage) {
                                        errorMessage.style.display = "block";
                                        setTimeout(function () {
                                            errorMessage.style.display = "none";
                                        }, 3000);
                                    }

                                    // Hiển thị thông báo thành công nếu có
                                    if (successMessage) {
                                        successMessage.style.display = "block";
                                        setTimeout(function () {
                                            successMessage.style.display = "none";
                                        }, 3000);
                                    }
                                }

                                // Gọi hàm khi trang đã tải xong
                                window.onload = function () {
                                    showMessage();
                                };
                                let cropper;
                                function previewImage(event) {
                                    let reader = new FileReader();
                                    reader.onload = function () {
                                        let image = document.getElementById('imagePreview');
                                        image.src = reader.result;
                                        document.getElementById('cropBtn').style.display = 'block';

                                        // Hủy cropper cũ nếu có
                                        if (cropper) {
                                            cropper.destroy();
                                        }

                                        // Khởi tạo Cropper.js
                                        cropper = new Cropper(image, {
                                            aspectRatio: 1, // Crop hình vuông
                                            viewMode: 2,
                                            autoCropArea: 1
                                        });
                                    };
                                    reader.readAsDataURL(event.target.files[0]);
                                }
                                document.getElementById('cropBtn').addEventListener('click', function () {
                                    if (!cropper) {
                                        console.error("Cropper is not initialized.");
                                        return;
                                    }

                                    let croppedCanvas = cropper.getCroppedCanvas();
                                    if (!croppedCanvas) {
                                        console.error("Cropped canvas is null.");
                                        return;
                                    }

                                    let croppedImage = croppedCanvas.toDataURL('image/png'); // Chuyển thành base64

                                    // Hiển thị ảnh đã cắt
                                    document.getElementById('imagePreview').src = croppedImage;

                                    // Gán ảnh đã crop vào input hidden để gửi lên server
                                    document.getElementById('croppedImage').value = croppedImage;

                                    // Ẩn nút crop sau khi cắt xong
                                    this.style.display = 'none';

                                    // Hủy cropper sau khi crop xong
                                    cropper.destroy();
                                });

    </script>
</html>
