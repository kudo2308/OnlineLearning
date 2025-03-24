<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <link rel="icon" href="../error-404.html" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Transaction History</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/vendors/calendar/fullcalendar.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/userlist.css">
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Transaction History</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li>Transaction History</li>
                    </ul>
                </div>	
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Transaction List</h4>
                            </div>
                            <div class="widget-inner">
                                <div class="mb-3 d-flex align-items-center gap-3 flex-wrap">
                                    <!-- Search by Bank Transaction ID -->
                                    <form action="transaction-history" class="d-flex align-items-center mx-3">
                                        <input type="text" id="searchBankTransaction" name="bankTrxId" placeholder="Search by Bank Transaction ID" value="${bankTrxId}" class="form-control me-2">
                                        <button id="searchButton" name="action" value="searchByBankTrxId" class="btn btn-secondary">Search</button>
                                    </form>

                                    <!-- Filter by Sender ID -->
                                    <form action="transaction-history" class="d-flex align-items-center mx-3">
                                        <select id="filterSender" name="senderId" class="form-control me-2">
                                            <option value="0">All Senders</option>
                                            <c:forEach items="${senders}" var="sender">
                                                <option ${senderId == sender.userID ? 'selected' : ""} value="${sender.userID}">${sender.fullName}</option>
                                            </c:forEach>
                                        </select>
                                        <button id="filterSenderButton" name="action" value="filterBySender" class="btn btn-secondary">Filter</button>
                                    </form>

                                    <!-- Filter by Receiver ID -->
                                    <form action="transaction-history" class="d-flex align-items-center mx-3">
                                        <select id="filterReceiver" name="receiverId" class="form-control me-2">
                                            <option value="0">All Receivers</option>
                                            <c:forEach items="${receivers}" var="receiver">
                                                <option ${receiverId == receiver.userID ? 'selected' : ""} value="${receiver.userID}">${receiver.fullName}</option>
                                            </c:forEach>
                                        </select>
                                        <button id="filterReceiverButton" name="action" value="filterByReceiver" class="btn btn-secondary">Filter</button>
                                    </form>
                                    
                                    <!-- Filter by Transaction Type -->
                                    <form action="transaction-history" class="d-flex align-items-center mx-3">
                                        <select id="filterType" name="trxType" class="form-control me-2">
                                            <option value="">All Types</option>
                                            <option ${trxType eq 'deposit' ? 'selected' : ""} value="deposit">Deposit</option>
                                            <option ${trxType eq 'withdraw' ? 'selected' : ""} value="withdraw">Withdraw</option>
                                            <option ${trxType eq 'commission' ? 'selected' : ""} value="commission">Commission</option>
                                            <option ${trxType eq 'payout' ? 'selected' : ""} value="payout">Payout</option>
                                            <option ${trxType eq 'refund' ? 'selected' : ""} value="refund">Refund</option>
                                            <option ${trxType eq 'other' ? 'selected' : ""} value="other">Other</option>
                                        </select>
                                        <button id="filterTypeButton" name="action" value="filterByType" class="btn btn-secondary">Filter</button>
                                    </form>
                                    
                                    <!-- Combined Filter Form -->
                                    <form action="transaction-history" class="d-flex align-items-center mx-3">
                                        <button id="clearFiltersButton" name="action" value="clearFilters" class="btn btn-warning">Clear Filters</button>
                                    </form>
                                </div>

                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Transaction ID</th>
                                            <th>Amount</th>
                                            <th>Type</th>
                                            <th>Bank Transaction ID</th>
                                            <th>Sender</th>
                                            <th>Receiver</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="transactionTableBody">
                                        <c:forEach items="${transactions}" var="transaction">
                                            <tr>
                                                <td>${transaction.transactionID}</td>
                                                <td>${transaction.amount}</td>
                                                <td>${transaction.transactionType}</td>
                                                <td>${transaction.bankTransactionID}</td>
                                                <td>${transaction.sender.fullName}</td>
                                                <td>${transaction.receiver.fullName}</td>
                                                <td>${transaction.description}</td>
                                                <td>
                                                    <span class="badge ${transaction.status eq 'completed' ? 'bg-success' : 
                                                                      transaction.status eq 'pending' ? 'bg-warning' : 
                                                                      transaction.status eq 'failed' ? 'bg-danger' : 'bg-secondary'}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                                <td>${transaction.createdAt}</td>
                                                <td>
                                                    <a href="transaction-details?id=${transaction.transactionID}" class="btn btn-info btn-sm">View</a>
                                                    <c:if test="${transaction.status eq 'pending'}">
                                                        <a href="approve-transaction?id=${transaction.transactionID}" class="btn btn-success btn-sm">Approve</a>
                                                        <a href="reject-transaction?id=${transaction.transactionID}" class="btn btn-danger btn-sm">Reject</a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="common/pagination.jsp"></jsp:include>
        <div class="ttr-overlay"></div>      
    </body>
    <script src="assets/admin/assets/js/jquery.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="assets/admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="assets/admin/assets/vendors/counter/waypoints-min.js"></script>
    <script src="assets/admin/assets/vendors/counter/counterup.min.js"></script>
    <script src="assets/admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="assets/admin/assets/vendors/masonry/masonry.js"></script>
    <script src="assets/admin/assets/vendors/masonry/filter.js"></script>
    <script src="assets/admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src='assets/admin/assets/vendors/scroll/scrollbar.min.js'></script>
    <script src="assets/admin/assets/js/functions.js"></script>
    <script src="assets/admin/assets/js/admin.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/timeago.js/4.0.2/timeago.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Format timestamps to relative time
            const timeElements = document.querySelectorAll(".timeago");
            timeElements.forEach(el => {
                const timeString = el.getAttribute("data-time");
                if (timeString) {
                    const formattedTime = timeago.format(new Date(timeString));
                    el.textContent = formattedTime;
                }
            });
            
            // Add event listeners for combined filter form
            const combineFilters = () => {
                const bankTrxId = document.getElementById('searchBankTransaction').value;
                const senderId = document.getElementById('filterSender').value;
                const receiverId = document.getElementById('filterReceiver').value;
                const trxType = document.getElementById('filterType').value;
                
                window.location.href = `transaction-history?action=filterCombined&bankTrxId=${bankTrxId}&senderId=${senderId}&receiverId=${receiverId}&trxType=${trxType}`;
                return false;
            };
            
            // Optional: Add a combined filter button
            document.getElementById('combineFiltersButton')?.addEventListener('click', combineFilters);
        });
    </script>
</html>