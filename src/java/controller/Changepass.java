/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.LoginDAO;
import config.OTP;
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
@WebServlet(name = "Changepass", urlPatterns = {"/changepass"})
public class Changepass extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        request.setAttribute("email", email);
        request.getRequestDispatcher("changepass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email != null) {
            String pass = request.getParameter("pass");
            String repass = request.getParameter("re-pass");
            if (pass == null && repass == null) {
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (pass == null || repass == null) {
                request.setAttribute("errorchangepass", "You must enter full field password and rel-password");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (pass.length() < 8) {
                request.setAttribute("errorchangepass", "Password must be at least 8 character ");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (!pass.matches(".*[A-Z].*")) {
                request.setAttribute("errorchangepass", "Password must be contain an uppercase letter");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (!pass.matches(".*\\d.*")) {
                request.setAttribute("errorchangepass", "Password must be has number");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (!pass.matches(".*[@#$%^&+=!].*")) {
                request.setAttribute("errorchangepass", "Password must be has a special character");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            if (!repass.equals(pass)) {
                request.setAttribute("errorchangepass", "You re-enter a password that doesn't match");
                request.setAttribute("email", email);
                request.getRequestDispatcher("changepass.jsp").forward(request, response);
                return;
            }
            String sessionActive = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("SessionID_User".equals(cookie.getName())) {
                        sessionActive = cookie.getValue();
                        break;
                    }
                }
            }
            if (sessionActive == null) {
                request.setAttribute("errorforget", "You session has expired");
                request.getRequestDispatcher("forgetpassword.jsp").forward(request, response);
                return;
            }
            LoginDAO dao = new LoginDAO();
            dao.changePassword(email, pass);
            Cookie newSessionCookie = new Cookie("SessionID_User", sessionActive);
            newSessionCookie.setMaxAge(0);
            newSessionCookie.setHttpOnly(true);
            response.addCookie(newSessionCookie);
            request.setAttribute("success", "Password changed successfully!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        response.sendRedirect("changepass.jsp");
    }

}
