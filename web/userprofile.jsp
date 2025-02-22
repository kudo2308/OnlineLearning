<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                        <img src="https://via.placeholder.com/100" class="rounded-circle d-block mx-auto mb-3" alt="Avatar">
                        <h5 class="text-center">Nguyễn Võ Thái Bảo</h5>
                        <a href="#">View Profile</a>
                        <a href="#">Profile Public</a>
                        <a href="#">Photo</a>
                        <a href="#">Change Password</a>
                        <a href="#">Subscriptions</a>
                        <a href="#">Payment methods</a>
                    </div>
                    <div class="profile-container ms-4 flex-grow-1">
                        <div class="header-profile">
                            <h1>Public profile</h1>
                            <p class="text-muted">Add information about yourself</p>
                        </div>
                        <hr>
                        <form>
                            <div class="mb-3">
                                <label class="form-label">Fullname</label>
                                <input type="text" name="fullname" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>                              
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Gender</label>
                                <select class="form-select">
                                    <option>Male</option>
                                    <option>Female</option>
                                    <option>Others</option>
                                </select>
                            </div>
                            <h5>Links</h5>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Website (http://..)">
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Twitter Profile">
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Facebook Profile">
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="LinkedIn Profile">
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Youtube Profile">
                            </div>
                            <button type="submit" class="btn save-btn w-100">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>
    <jsp:include page="common/footer.jsp"></jsp:include> 
    <script src="${pageContext.request.contextPath}/assets/js/js.js"></script>
</html>
