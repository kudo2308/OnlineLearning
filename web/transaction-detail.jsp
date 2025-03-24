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
        <title>Transaction Details</title>

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
        <link rel="stylesheet" type="text/css" href="assets/admin/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/admin/assets/css/color/color-1.css">
        <style>
            .transaction-card {
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
            }
            
            .transaction-header {
                padding: 20px;
                border-bottom: 1px solid #eee;
            }
            
            .transaction-body {
                padding: 20px;
            }
            
            .transaction-field {
                margin-bottom: 15px;
            }
            
            .label {
                font-weight: bold;
                color: #555;
            }
            
            .status-badge {
                padding: 5px 10px;
                border-radius: 20px;
                display: inline-block;
                color: white;
                font-weight: bold;
            }
            
            .status-completed {
                background-color: #28a745;
            }
            
            .status-pending {
                background-color: #ffc107;
                color: #212529;
            }
            
            .status-failed {
                background-color: #dc3545;
            }
            
            .status-cancelled {
                background-color: #6c757d;
            }
            
            .action-buttons {
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #eee;
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
                    <h4 class="breadcrumb-title">Transaction Details</h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/transaction-history">Transaction History</a></li>
                        <li>Transaction Details</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box transaction-card">
                            <div class="transaction-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4>Transaction #${transaction.transactionID}</h4>
                                    <span class="status-badge status-${transaction.status}">${transaction.status}</span>
                                </div>
                            </div>
                            <div class="transaction-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="transaction-field">
                                            <div class="label">Amount</div>
                                            <div class="value">${transaction.amount}</div>
                                        </div>
                                        
                                        <div class="transaction-field">
                                            <div class="label">Transaction Type</div>
                                            <div class="value">${transaction.transactionType}</div>
                                        </div>
                                        
                                        <c:if test="${not empty transaction.bankTransactionID}">
                                            <div class="transaction-field">
                                                <div class="label">Bank Transaction ID</div>
                                                <div class="value">${transaction.bankTransactionID}</div>
                                            </div>
                                        </c:if>
                                        
                                        <div class="transaction-field">
                                            <div class="label">Created At</div>
                                            <div class="value">${transaction.createdAt}</div>
                                        </div>
                                        
                                        <c:if test="${not empty transaction.processedAt}">
                                            <div class="transaction-field">
                                                <div class="label">Processed At</div>
                                                <div class="value">${transaction.processedAt}</div>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <c:if test="${not empty transaction.sender}">
                                            <div class="transaction-field">
                                                <div class="label">Sender</div>
                                                <div class="value">${transaction.sender.fullName} (ID: ${transaction.sender.userID})</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty transaction.receiver}">
                                            <div class="transaction-field">
                                                <div class="label">Receiver</div>
                                                <div class="value">${transaction.receiver.fullName} (ID: ${transaction.receiver.userID})</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${transaction.relatedOrderID > 0}">
                                            <div class="transaction-field">
                                                <div class="label">Related Order ID</div>
                                                <div class="value">
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${transaction.relatedOrderID}" class="btn-link">
                                                        #${transaction.relatedOrderID}
                                                    </a>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${transaction.relatedPayoutID > 0}">
                                            <div class="transaction-field">
                                                <div class="label">Related Payout ID</div>
                                                <div class="value">
                                                    <a href="${pageContext.request.contextPath}/payout-detail?id=${transaction.relatedPayoutID}" class="btn-link">
                                                        #${transaction.relatedPayoutID}
                                                    </a>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <div class="transaction-field">
                                            <div class="label">Description</div>
                                            <div class="value">${not empty transaction.description ? transaction.description : 'N/A'}</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <c:if test="${transaction.status eq 'pending'}">
                                    <div class="action-buttons">
                                        <a href="approve-transaction?id=${transaction.transactionID}" class="btn btn-success">Approve Transaction</a>
                                        <a href="reject-transaction?id=${transaction.transactionID}" class="btn btn-danger">Reject Transaction</a>
                                    </div>
                                </c:if>
                                
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/transaction-history" class="btn btn-secondary">Back to List</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>
        
        <!-- JavaScript files -->
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
            $(document).ready(function() {
                // Add any JavaScript functionality needed for the transaction detail page
            });
        </script>
    </body>
</html>