package controller;

import DAO.ExpertWalletDAO;
import DAO.LoginDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Account;
import model.ExpertBankInfo;
import model.ExpertPayout;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/wallet"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account account = dao.getAccountByUserID(userID);
        
        // Check if user is logged in and is an expert
        if (account == null || !"Expert".equals(account.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get expert's wallet information
        ExpertWalletDAO walletDAO = new ExpertWalletDAO();
        ExpertBankInfo expertBank = walletDAO.getExpertBankInfo(account.getUserID());
        
        // Get payout history if bank information exists
        if (expertBank != null && expertBank.getBankAccountNumber() != null) {
            List<ExpertPayout> payoutHistory = walletDAO.getExpertPayouts(account.getUserID());
            request.setAttribute("payoutHistory", payoutHistory);
        }
        
        request.setAttribute("expertBank", expertBank);
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account account = dao.getAccountByUserID(userID);
        
        // Check if user is logged in and is an expert
        if (account == null || !"Expert".equals(account.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        ExpertWalletDAO walletDAO = new ExpertWalletDAO();
        
        if (null != action) switch (action) {
            case "createBankInfo" -> {
                // Create new bank account info
                String bankName = request.getParameter("bankName");
                String bankAccountNumber = request.getParameter("bankAccountNumber");
                ExpertBankInfo bankInfo = new ExpertBankInfo(account.getUserID(), bankAccountNumber, bankName);
                boolean success = walletDAO.createExpertBankInfo(bankInfo);
                if (success) {
                    request.setAttribute("message", "Bank account information saved successfully.");
                } else {
                    request.setAttribute("error", "Failed to save bank account information.");
                }                      }
            case "updateBankInfo" -> {
                // Update existing bank info
                String bankName = request.getParameter("bankName");
                String bankAccountNumber = request.getParameter("bankAccountNumber");
                ExpertBankInfo bankInfo = walletDAO.getExpertBankInfo(account.getUserID());
                if (bankInfo != null) {
                    bankInfo.setBankName(bankName);
                    bankInfo.setBankAccountNumber(bankAccountNumber);
                    
                    boolean success = walletDAO.updateExpertBankInfo(bankInfo);
                    
                    if (success) {
                        request.setAttribute("message", "Bank account information updated successfully.");
                    } else {
                        request.setAttribute("error", "Failed to update bank account information.");
                    }
                }                      }
            case "requestPayout" -> {
                // Process withdrawal request
                try {
                    double amount = Double.parseDouble(request.getParameter("amount"));
                    ExpertBankInfo bankInfo = walletDAO.getExpertBankInfo(account.getUserID());
                    
                    if (bankInfo != null && amount >= 100000 && amount <= bankInfo.getWalletBalance()) {
                        ExpertPayout payout = new ExpertPayout( account.getUserID(), amount, bankInfo.getBankAccountNumber(), bankInfo.getBankName());
                        
                        boolean success = walletDAO.createPayoutRequest(payout);
                        
                        if (success) {
                            request.setAttribute("message", "Withdrawal request submitted successfully.");
                        } else {
                            request.setAttribute("error", "Failed to submit withdrawal request.");
                        }
                    } else {
                        request.setAttribute("error", "Invalid withdrawal amount.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid amount format.");
                }
            }
        }
        
        // Reload expert's wallet information
        ExpertBankInfo expertBank = walletDAO.getExpertBankInfo(account.getUserID());
        
        // Get payout history if bank information exists
        if (expertBank != null && expertBank.getBankAccountNumber() != null) {
            List<ExpertPayout> payoutHistory = walletDAO.getExpertPayouts(account.getUserID());
            request.setAttribute("payoutHistory", payoutHistory);
        }
        
        request.setAttribute("expertBank", expertBank);
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }
}