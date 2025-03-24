package controller;

import DAO.WalletTransactionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebServlet(name = "TransactionActionServlet", urlPatterns = {"/approve-transaction", "/reject-transaction"})
public class TransactionActionServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get the current user from session (for processedBy field)
           // Lấy thông tin user từ session
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
            
            if ("/approve-transaction".equals(servletPath)) {
                status = "completed";
                message = "Transaction approved successfully";
            } else {
                status = "failed";
                message = "Transaction rejected";
            }
            
            // Update transaction status
            WalletTransactionDAO transactionDAO = new WalletTransactionDAO();
            
            boolean updated = transactionDAO.updateTransactionStatus(transactionId, status, userId);
            
            if (!updated) {
                request.setAttribute("error", "Failed to update transaction status");
                request.getRequestDispatcher("transaction-history").forward(request, response);
                return;
            }
            
            // Set success message
            request.setAttribute("success", message);
            
            // Redirect back to transaction list
            response.sendRedirect("transaction-history");
            
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles transaction approval/rejection actions";
    }
}