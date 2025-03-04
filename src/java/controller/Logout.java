/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import config.OTP;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "logout", urlPatterns = {"/logout"})
public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            Cookie newSessionCookie = new Cookie("SessionID_User", sessionActive);
            newSessionCookie.setMaxAge(0);
            newSessionCookie.setHttpOnly(true);
            response.addCookie(newSessionCookie);
        }
        OTP otp = new OTP();
        otp.deleteSessionUser(sessionActive);
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        Cookie newSessionCookie = new Cookie("SessionID_User", sessionActive);
        newSessionCookie.setMaxAge(0);
        newSessionCookie.setHttpOnly(true);
        response.addCookie(newSessionCookie);
        response.sendRedirect("home");
    }

}
