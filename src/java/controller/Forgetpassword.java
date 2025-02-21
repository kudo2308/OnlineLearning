/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.LoginDAO;
import config.EmailSender;
import config.OTP;
import config.Security;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "Forgetpassword", urlPatterns = {"/forget"})
public class Forgetpassword extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String change = request.getParameter("change");
        // Kiểm tra nếu 'change' là true
        if ("true".equals(change)) {
            String sessionId = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("Session_ID_Pending".equals(cookie.getName())) {
                        sessionId = cookie.getValue();
                        break;
                    }
                }
            }
            if (sessionId == null) {
                response.sendRedirect("forgetpassword.jsp");
                return;
            }
            OTP get = new OTP();
            String userData = get.getSessionId(sessionId);
            String[] userInfo = userData.split(":");
            String email = userInfo[0];
            String emailHash = Security.encode(email);
            get.deleteSesssionId(sessionId);
            get.deleteOTP(emailHash);
            get.deleteAttempts(emailHash);
            get.deleteResend(emailHash);
            Cookie sessionCookie = new Cookie("Session_ID_Pending", "");
            sessionCookie.setMaxAge(0);
            sessionCookie.setHttpOnly(true);
            response.addCookie(sessionCookie);
            request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
        } else {
            response.sendRedirect("forgetpassword.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.isEmpty()) {
            request.setAttribute("errorforget", "Please enter Email field");
            request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
            return;
        }
        // Kiểm tra định dạng email hợp lệ
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errorforget", "The email does not exist , check format or domain");
            request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
            return;
        }
        LoginDAO dao = new LoginDAO();
        boolean checkUser = dao.check(email);
        if (!checkUser) {
            request.setAttribute("errorforget", "The email didn't exist ");
            request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
            return;
        }
        OTP otp = new OTP();
        String emailHash = Security.encode(email);
        Account a = dao.getAccountByEmail(email);
        int otpValue = otp.createOTP(emailHash);
        String sessionId = otp.createSessionId(email, a.getPassword(), a.getFullName(), a.getRole().getRoleName(), "foget");
        //Gửi otp Email
        EmailSender.sendOTP(email, a.getFullName(), otpValue);
        // Gửi SessionId lên Cookie
        Cookie sessionCoookie = new Cookie("Session_ID_Pending", sessionId);
        sessionCoookie.setMaxAge(30 * 60);
        sessionCoookie.setHttpOnly(true);
        response.addCookie(sessionCoookie);
        response.sendRedirect("verifyOTP?forget=true");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
