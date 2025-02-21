package controller;

import DAO.LoginDAO;
import config.OTP;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import model.Account;

@WebServlet(name = "Login", urlPatterns = {"/login"})
public class Login extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorlogin = request.getParameter("error");
        String success = request.getParameter("success");
        if (errorlogin != null && !errorlogin.isEmpty()) {
            request.setAttribute("errorlogin", errorlogin);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        if (success != null && !success.isEmpty()) {
            request.setAttribute("success", success);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String rem = request.getParameter("remember");

        request.setAttribute("email", email);
        LoginDAO d = new LoginDAO();
        OTP otp = new OTP();
        Cookie us = new Cookie("email", email);
        Cookie pas = new Cookie("pass", pass);
        Cookie re = new Cookie("remember", rem);
        if (rem == null) {
            us.setMaxAge(0);
            pas.setMaxAge(0);
            re.setMaxAge(0);
        } else {
            us.setMaxAge(60 * 60 * 24);
            us.setHttpOnly(true);
            pas.setMaxAge(60 * 60 * 24);
            pas.setHttpOnly(true);
            re.setMaxAge(60 * 60 * 24);
            re.setHttpOnly(true);
        }
        response.addCookie(us);
        response.addCookie(pas);
        response.addCookie(re);
        if (!d.checkUserLogin(email, pass)) {
            request.setAttribute("errorlogin", "Incorrect password or email");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        if (!d.checkStatusUser(email)) {
            request.setAttribute("errorlogin", "You blocked by Admin");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
        if (sessionActive != null) {
            if (otp.checkSessionUserExists(sessionActive)) {
                response.sendRedirect("home");
                return;
            } else {
                Cookie newSessionCookie = new Cookie("SessionID_User", sessionActive);
                newSessionCookie.setMaxAge(0);
                newSessionCookie.setHttpOnly(true);
                response.addCookie(newSessionCookie);
            }
        }
        String sessionId = UUID.randomUUID().toString();
        Cookie newSessionCookie = new Cookie("SessionID_User", sessionId);
        newSessionCookie.setMaxAge(60 * 60 * 24);
        newSessionCookie.setHttpOnly(true);
        response.addCookie(newSessionCookie);
        Account acc = d.getAccountByEmail(email);
        otp.createSesssionIdApprove(sessionId, acc.getUserID(), acc.getFullName(), acc.getRole().getRoleName(), acc.getSubScriptionType());
        response.sendRedirect("home");
    }
}
