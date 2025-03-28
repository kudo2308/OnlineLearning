<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transaction Details</title>
    <link rel="stylesheet" href="assets/admin/assets/vendors/bootstrap/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h4>Transaction Details</h4>
            </div>
            <div class="card-body">
                <form action="save-transaction" method="post">
                    <input type="hidden" name="transactionId" value="${transactionId}">
                    
                    <div class="form-group mb-3">
                        <label for="bankTransactionId" class="form-label">Bank Transaction ID</label>
                        <input type="text" class="form-control" id="bankTransactionId" name="bankTransactionId" >
                    </div>
                    
                    <div class="form-group mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" ></textarea>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" name="action" value="save" class="btn btn-success me-2">Save</button>
                        <button type="submit" name="action" value="cancel" class="btn btn-danger">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>