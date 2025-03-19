<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expert Wallet - Online Learning</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="assets/css/wallet.css"/>
        <style>
            .error-message {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top: 120px;
                left: 0;
                right: 0;
                background-color: rgba(208, 22, 39, 0.8);
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }

            .success {
                width: 25%;
                z-index: 1000;
                margin: auto;
                display: none;
                position: fixed;
                top:120px;
                left: 0;
                right: 0;
                background-color: #00CC00;
                color: white;
                padding: 12px;
                text-align: center;
                font-size: 14px;
                border-radius: 40px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
            <nav style="height: 0; border-bottom: 1px solid #ddd"></nav>

            <div class="wallet-flex" style="display: flex ;justify-content: center; gap: 4%;">

                <div class="wallet-container">
                    <div class="wallet-header">
                        <h1>Expert Wallet</h1>
                    <c:if test="${expertBank != null}">
                        <span>Last updated: ${expertBank.updatedAt}</span>
                    </c:if>
                </div>

                <!-- Wallet Balance Section -->
                <div class="wallet-balance">
                    <p>Available Balance</p>
                    <div class="balance-amount">
                        <c:choose>
                            <c:when test="${expertBank != null}">
                                ${expertBank.walletBalance} đ
                            </c:when>
                            <c:otherwise>
                                0.00 đ
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="help-text">Earnings from course sales after platform fees</p>
                </div>

            </div>

            <!-- Bank Account Information Section -->

            <div class="wallet-section" style="background-color: #fff;border-radius: 16px;box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06); padding: 32px;flex: 1;max-width: 520px;transition: transform 0.3s ease, box-shadow 0.3s ease;">
                <h2 class="section-title">Bank Account Information</h2>

                <c:choose>
                    <c:when test="${expertBank != null && not empty expertBank.bankAccountNumber}">
                        <!-- Existing Bank Information Display -->
                        <div class="wallet-info">
                            <div class="wallet-info-card">
                                <h3>Bank Name</h3>
                                <p>${expertBank.bankName}</p>
                            </div>
                            <div class="wallet-info-card">
                                <h3>Account Number</h3>
                                <p>${expertBank.bankAccountNumber}</p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/wallet?action=updateBankInfo" method="post" style="margin-top: 20px;">
                            <div class="form-group">
                                <label for="bankName">Bank Name</label>
                                <input type="text" id="bankName" name="bankName" class="form-control" value="${expertBank.bankName}" required>
                            </div>
                            <div class="form-group">
                                <label for="bankAccountNumber">Account Number</label>
                                <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-control" value="${expertBank.bankAccountNumber}" required>
                            </div>
                            <button type="submit" class="btn-primary">Update Bank Information</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <!-- New Bank Account Form -->
                        <p>You haven't set up your bank account information yet. Please add your details to withdraw funds.</p>
                        <form action="${pageContext.request.contextPath}/wallet?action=createBankInfo" method="post">
                            <div class="form-group">
                                <label for="bankName">Bank Name</label>
                                <input type="text" id="bankName" name="bankName" class="form-control" required>
                                <p class="help-text">Enter the full name of your bank (e.g., Vietcombank, BIDV)</p>
                            </div>
                            <div class="form-group">
                                <label for="bankAccountNumber">Account Number</label>
                                <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-control" required>
                                <p class="help-text">Enter your bank account number without spaces</p>
                            </div>
                            <button type="submit" class="btn-primary">Save Bank Information</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
            
             <!-- Withdrawal Section (Only visible if bank info exists) -->
        <c:if test="${expertBank != null && not empty expertBank.bankAccountNumber}">
            <div class="wallet-section" style="background-color: #fff;border-radius: 16px;box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06); padding: 32px;flex: 1;max-width: 520px;transition: transform 0.3s ease, box-shadow 0.3s ease;">
                <h2 class="section-title">Withdraw Funds</h2>

                <form action="${pageContext.request.contextPath}/wallet?action=requestPayout" method="post">
                    <div class="form-group">
                        <label for="amount">Amount (đ)</label>
                        <input type="number" id="amount" name="amount" class="form-control" min="100000" max="${expertBank.walletBalance}" step="10000" required>
                        <p class="help-text">Minimum withdrawal: 100,000 đ. Maximum: Your current balance</p>
                    </div>
                    <button type="submit" class="btn-primary" ${expertBank.walletBalance < 100000 ? 'disabled' : ''}>
                        Request Withdrawal
                    </button>
                    <c:if test="${expertBank.walletBalance < 100000}">
                        <p class="warning-text">Minimum withdrawal amount is 100,000 đ</p>
                    </c:if>
                </form>
            </div>
            
        </div> 
            <!-- Withdrawal History Section -->
            <div class ="wallet-history" >
                <div class="wallet-section" >
                <h2 class="section-title">Wallet History</h2>

                <c:choose>
                    <c:when test="${not empty payoutHistory}">
                        <table class="payout-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Bank</th>
                                    <th>Account</th>
                                    <th>Status</th>
                                    <th>Processed Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="payout" items="${payoutHistory}">
                                    <tr>
                                        <td>${payout.requestedAt}</td>
                                        <td>${payout.amount} đ</td>
                                        <td>${payout.bankName}</td>
                                        <td>${payout.bankAccountNumber}</td>
                                        <td>
                                            <span class="status-${payout.status}">
                                                ${payout.status}
                                            </span>
                                        </td>
                                        <td>${payout.processedAt != null ? payout.processedAt : '-'}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p>No withdrawal history available.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            </div>
        </c:if>
    </div>
    <c:set var="error" value="${requestScope.error}" />
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
</script>
</html>