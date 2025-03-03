package controller;

import DAO.LoginDAO;
import config.Security;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import model.Account;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "Changepassuser", urlPatterns = {"/changepassuser"})
public class Changepassuser extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String oldpass = request.getParameter("oldpass");
        String newpass = request.getParameter("newpass");
        String repass = request.getParameter("repass");

        if ((oldpass == null || oldpass.isEmpty()) && (newpass == null || newpass.isEmpty()) && (repass == null || repass.isEmpty())) {
           request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }


     if (oldpass == null || oldpass.isEmpty() || newpass == null || newpass.isEmpty() || repass == null || repass.isEmpty()) {
            request.setAttribute("errorchange", "Please fill in the remaining fields to make changes");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }

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

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserIDPass(userID);
        if(acc == null){
             request.setAttribute("errorchange", "Account not found");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        String passDB = acc.getPassword();
        if (Security.decode(passDB).equals(oldpass)) {
            request.setAttribute("errorchange", "You entered the old password incorrectly");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        request.setAttribute("oldpass", oldpass);
        request.setAttribute("newpass", newpass);
        if (newpass.length() < 8) {
            request.setAttribute("errorchangepass", "Password must be at least 8 character ");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        if (!newpass.matches(".*[A-Z].*")) {
            request.setAttribute("errorchangepass", "Password must be contain an uppercase letter");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        if (!newpass.matches(".*\\d.*")) {
            request.setAttribute("errorchangepass", "Password must be has number");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        if (!newpass.matches(".*[@#$%^&+=!].*")) {
            request.setAttribute("errorchangepass", "Password must be has a special character");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        if (!repass.equals(newpass)) {
            request.setAttribute("errorchangepass", "You re-enter a password that doesn't match");
            request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
            return;
        }
        
        dao.changePassword(acc.getEmail(),newpass);
        request.setAttribute("oldpass", "");
        request.setAttribute("newpass", "");
        request.setAttribute("success", "You changed password successfully ");
        request.getRequestDispatcher("userchangepass.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
