package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import DAO.WalletTransactionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.WalletTransaction;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "TransactionDetailServlet", urlPatterns = {"/transaction-details"})
public class TransactionDetailServlet extends HttpServlet {

 @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get transaction ID from request
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("errorMessage", "ID is required");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            int transactionId;
            try {
                transactionId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid ID");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Get transaction details from DAO
            WalletTransactionDAO transactionDAO = new WalletTransactionDAO();
            WalletTransaction transaction = transactionDAO.getTransactionById(transactionId);
            
            if (transaction == null) {
                request.setAttribute("errorMessage", "Transaction not found");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Set transaction as request attribute
            request.setAttribute("transaction", transaction);
            
            // Forward to detail page
            request.getRequestDispatcher("transaction-detail.jsp").forward(request, response);
            
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
        return "Displays details for a specific transaction";
    }
}
