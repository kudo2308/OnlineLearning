package controller;

import DAO.ExpertWalletDAO;
import DAO.WalletTransactionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Map;
import model.WalletTransaction;

@WebServlet(name = "TransactionActionServlet", urlPatterns = {
    "/approve-transaction",
    "/reject-transaction",
    "/save-transaction"
})
public class TransactionActionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get the current user from session
            HttpSession session = request.getSession();
            Object accountObj = session.getAttribute("account");

            if (accountObj == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String userID = null;
            if (accountObj instanceof Map) {
                Map<String, String> accountData = (Map<String, String>) accountObj;
                userID = accountData.get("userId");
            }
            int userId = Integer.parseInt(userID);

            // Get transaction ID from request
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("error", "Transaction ID is required");
                request.getRequestDispatcher("transaction-history").forward(request, response);
                return;
            }

            int transactionId;
            try {
                transactionId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid Transaction ID");
                request.getRequestDispatcher("transaction-history").forward(request, response);
                return;
            }

            // Determine action based on servlet path
            String servletPath = request.getServletPath();
            String status;
            String message;
            // Update transaction status
            WalletTransactionDAO transactionDAO = new WalletTransactionDAO();
            ExpertWalletDAO dao = new ExpertWalletDAO();
            WalletTransaction wt = transactionDAO.getTransactionById(transactionId);
            int recieve = wt.getReceiver().getUserID();
            int payoutid = dao.getPendingPayoutId(recieve);

            switch (servletPath) {
                case "/approve-transaction" -> {
                    // Redirect to a page where user can enter bank transaction details
                    request.setAttribute("transactionId", transactionId);
                    request.getRequestDispatcher("detail-transaction.jsp").forward(request, response);
                    return;
                }

                case "/reject-transaction" -> {
                    status = "cancelled";
                    message = "Transaction rejected";
                }

                default -> {
                    status = null;
                    message = null;
                }
            }

            boolean updated = transactionDAO.updateTransactionStatus(transactionId, status, userId);
            dao.updatePayoutStatus(payoutid, "failed");
            dao.addToWalletBalance(recieve, wt.getAmount().doubleValue());
            if (!updated) {
                request.setAttribute("error", "Failed to update transaction status");
                request.getRequestDispatcher("transaction-history").forward(request, response);
                return;
            }

            // Set success message
            request.setAttribute("success", message);

            // Redirect back to transaction list
            response.sendRedirect("transaction-history");

        } catch (ServletException | IOException | NumberFormatException ex) {
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get the current user from session
            HttpSession session = request.getSession();
            Object accountObj = session.getAttribute("account");

            if (accountObj == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String userID = null;
            if (accountObj instanceof Map) {
                Map<String, String> accountData = (Map<String, String>) accountObj;
                userID = accountData.get("userId");
            }
            int userId = Integer.parseInt(userID);

            // Get transaction details from request
            String idParam = request.getParameter("transactionId");
            String bankTransactionId = request.getParameter("bankTransactionId");
            String description = request.getParameter("description");
            String action = request.getParameter("action");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("error", "Transaction ID is required");
                request.getRequestDispatcher("transaction-history").forward(request, response);
                return;
            }

            int transactionId = Integer.parseInt(idParam);
            WalletTransactionDAO transactionDAO = new WalletTransactionDAO();
            ExpertWalletDAO dao = new ExpertWalletDAO();
            WalletTransaction wt = transactionDAO.getTransactionById(transactionId);
            int recieve = wt.getReceiver().getUserID();
            int payoutid = dao.getPendingPayoutId(recieve);
            String status;
            String message;

            if ("save".equals(action)) {
                status = "completed";
                message = "Transaction completed successfully";

                // Update transaction with bank transaction ID and description
                boolean updated = transactionDAO.updateTransactionDetails(transactionId, bankTransactionId, description, status, userId, userId, recieve);
                dao.updatePayoutStatus(payoutid, "successful");
                if (!updated) {
                    request.setAttribute("error", "Failed to update transaction details");
                    request.getRequestDispatcher("detail-transaction.jsp").forward(request, response);
                    return;
                }
            } else {
                status = "failed";
                message = "Transaction failed";
                dao.updatePayoutStatus(payoutid, "failed");
                dao.addToWalletBalance(recieve, wt.getAmount().doubleValue());
                boolean updated = transactionDAO.updateTransactionStatus(transactionId, status, userId);

                if (!updated) {
                    request.setAttribute("error", "Failed to update transaction status");
                    request.getRequestDispatcher("transaction-history").forward(request, response);
                    return;
                }
            }

            // Set success message
            request.setAttribute("success", message);

            // Redirect back to transaction list
            response.sendRedirect("transaction-history");

        } catch (ServletException | IOException | NumberFormatException ex) {
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
