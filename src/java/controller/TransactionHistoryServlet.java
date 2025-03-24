package controller;

import DAO.WalletTransactionDAO;
import model.Account;
import model.WalletTransaction;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "TransactionHistoryServlet", urlPatterns = {"/transaction-history"})
public class TransactionHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Initialize DAO
            WalletTransactionDAO transactionDAO = new WalletTransactionDAO();
            
            // Get action parameter to determine operation
            String action = request.getParameter("action");
            
            // Get filter parameters
            String bankTrxId = request.getParameter("bankTrxId");
            
            // Parse sender ID
            int senderId = 0;
            String senderParam = request.getParameter("senderId");
            if (senderParam != null && !senderParam.isEmpty()) {
                try {
                    senderId = Integer.parseInt(senderParam);
                } catch (NumberFormatException e) {
                    // Invalid format, keep senderId as 0
                }
            }
            
            // Parse receiver ID
            int receiverId = 0;
            String receiverParam = request.getParameter("receiverId");
            if (receiverParam != null && !receiverParam.isEmpty()) {
                try {
                    receiverId = Integer.parseInt(receiverParam);
                } catch (NumberFormatException e) {
                    // Invalid format, keep receiverId as 0
                }
            }
            
            // Get transaction type
            String trxType = request.getParameter("trxType");
            
            // Clear all filters if requested
            if ("clearFilters".equals(action)) {
                bankTrxId = null;
                senderId = 0;
                receiverId = 0;
                trxType = null;
            }
            
            // Pagination parameters
            int pageSize = 10; // Number of records per page
            int pageIndex = 1; // Default to first page
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    pageIndex = Integer.parseInt(pageParam);
                    if (pageIndex < 1) {
                        pageIndex = 1;
                    }
                } catch (NumberFormatException e) {
                    // Invalid format, keep pageIndex as 1
                }
            }
            
            // Get transactions with filters and pagination
            List<WalletTransaction> transactions = transactionDAO.getTransactions(
                    bankTrxId, senderId, receiverId, trxType, pageIndex, pageSize);
            
            // Get total count for pagination
            int totalTransactions = transactionDAO.countTransactions(
                    bankTrxId, senderId, receiverId, trxType);
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalTransactions / pageSize);
            
            // Get unique senders and receivers for dropdown filters
            List<Account> senders = transactionDAO.getAllSenders();
            List<Account> receivers = transactionDAO.getAllReceivers();
            
            // Set attributes for the view
            request.setAttribute("transactions", transactions);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalRecords", totalTransactions);
            request.setAttribute("senders", senders);
            request.setAttribute("receivers", receivers);
            
            // Set filter parameters for maintaining state
            request.setAttribute("bankTrxId", bankTrxId);
            request.setAttribute("senderId", senderId);
            request.setAttribute("receiverId", receiverId);
            request.setAttribute("trxType", trxType);
            
            // Forward to the JSP page
            request.getRequestDispatcher("transaction-history.jsp").forward(request, response);
            
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests if needed (for complex filters or form submissions)
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Displays transaction history with filtering options";
    }
}