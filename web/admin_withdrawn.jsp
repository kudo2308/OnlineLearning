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
        <title>Expert Payout Management</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

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

        <style>
            .admin-balance {
                background-color: #e9f7ef;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 5px solid #27ae60;
            }

            .admin-balance h3 {
                margin-top: 0;
                color: #2c3e50;
            }

            .admin-balance p {
                font-size: 18px;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <jsp:include page="./public/header-admin.jsp"></jsp:include>
        <jsp:include page="./public/sidebar-admin.jsp"></jsp:include>

        <!--Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title">Dashboard</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="dashboard.jsp"><i class="fa fa-home"></i>Dashboard</a></li>
                        <li>Expert Payout Management</li>
                    </ul>
                </div>

                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4>Expert Payout Management</h4>
                            </div>
                            <div class="widget-inner">
                                <div class="admin-balance mb-3">
                                    <h3>Admin Wallet Balance</h3>
                                    <h4 style="color: green">${adminWalletBalance} Đ</h4>
                                </div>

                                <div class="mb-3 d-flex align-items-center gap-3">
                                    <form action="ExpertPayoutList" method="get" class="d-flex align-items-center mx-3">
                                        <input type="hidden" name="page" value="1">
                                        <select name="status" class="form-control me-2">
                                            <option value="">All Status</option>
                                            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
                                            <option value="processed" ${status == 'processed' ? 'selected' : ''}>Processed</option>
                                            <option value="withdrawn" ${status == 'withdrawn' ? 'selected' : ''}>Withdrawn</option>
                                            <option value="failed" ${status == 'failed' ? 'selected' : ''}>Failed</option>
                                        </select>
                                        <input type="text" name="expertName" placeholder="Search by expert name" value="${expertName}" class="form-control me-2">
                                        <button type="submit" class="btn btn-secondary">Filter</button>
                                    </form>
                                </div>

                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Payout ID</th>
                                            <th>Expert Name</th>
                                            <th>Amount</th>
                                            <th>Bank Name</th>
                                            <th>Account Number</th>
                                            <th>Requested Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${payoutList}" var="payoutWithName">
                                            <tr>
                                                <td>${payoutWithName.payout.payoutId}</td>
                                                <td>${payoutWithName.expertName}</td>
                                                <td>$${payoutWithName.payout.amount}</td>
                                                <td>${payoutWithName.payout.bankName}</td>
                                                <td>${payoutWithName.payout.bankAccountNumber}</td>
                                                <td>${payoutWithName.payout.requestedAt}</td>
                                                <td>${payoutWithName.payout.status}</td>
                                                <td>
                                                    <c:if test="${payoutWithName.payout.status eq 'pending'}">
                                                        <button onclick="openModal('${payoutWithName.payout.payoutId}', '${payoutWithName.payout.amount}')" class="btn btn-success" style="background-color: green">Process</button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty payoutList}">
                                            <tr>
                                                <td colspan="8" style="text-align: center;">No payout requests found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                
                                <!-- Pagination -->
                                <div class="pagination-bx rounded-sm gray clearfix">
                                    <ul class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <li class="previous"><a href="ExpertPayoutList?page=${currentPage - 1}&status=${status}&expertName=${expertName}"><i class="ti-arrow-left"></i> Prev</a></li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="${i == currentPage ? 'active' : ''}">
                                                <a href="ExpertPayoutList?page=${i}&status=${status}&expertName=${expertName}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="next"><a href="ExpertPayoutList?page=${currentPage + 1}&status=${status}&expertName=${expertName}">Next <i class="ti-arrow-right"></i></a></li>
                                        </c:if>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal -->
        <div id="processingModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Process Withdrawal</h2>
                <form id="processForm" action="CompleteWithdrawalServlet" method="post">
                    <input type="hidden" id="payoutId" name="payoutId" value="">
                    <input type="hidden" id="amount" name="amount" value="">

                    <div class="form-group">
                        <label for="bankTransaction">Bank Transaction Number:</label>
                        <input type="text" class="form-control" id="bankTransaction" name="bankTransaction" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="displayAmount">Amount:</label>
                        <input type="text" class="form-control" id="displayAmount" disabled>
                    </div>

                    <div class="modal-buttons mt-3">
                        <button type="submit" name="action" value="save" class="btn btn-success">Complete Transfer</button>
                        <button type="submit" name="action" value="cancel" class="btn btn-danger">Cancel Transfer</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="ttr-overlay"></div>

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
        <script>
            // Modal functions
            var modal = document.getElementById("processingModal");
            var span = document.getElementsByClassName("close")[0];

            function openModal(payoutId, amount) {
                document.getElementById("payoutId").value = payoutId;
                document.getElementById("amount").value = amount;
                document.getElementById("displayAmount").value = "$" + amount;
                modal.style.display = "block";
            }

            span.onclick = function () {
                modal.style.display = "none";
            }

            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>
    </body>
</html>