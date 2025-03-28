package controller;

import DAO.LoginDAO;
import DTOs.GoogleAccount;
import config.Google;
import config.OTP;
import config.Security;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.SecureRandom;
import java.util.UUID;
import model.Account;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "Logingooglehandler", urlPatterns = {"/Logingooglehandler"})
public class Logingooglehandler extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String error = request.getParameter("error");
        if(error != null && !error.isEmpty()){
            request.setAttribute("errorlogin", "Login by Gmail Fail");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        String code = request.getParameter("code");
        OTP otp = new OTP();
        String accessToken = Google.getToken(code);
        GoogleAccount acc = Google.getUserInfo(accessToken);
        if (!acc.isVerified_email()) {
            request.setAttribute("errorlogin", "Authentication Gmail Fail");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        LoginDAO dao = new LoginDAO();
        if (!dao.checkStatusUser(acc.getEmail())) {
            request.setAttribute("errorlogin", "You blocked by Admin");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        if (dao.check(acc.getEmail())) {
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
            Account account = dao.getAccountByEmail(acc.getEmail());
            dao.updateUserUpdate(acc.getEmail());
            otp.createSesssionIdApprove(sessionId, account.getUserID(), account.getFullName(), account.getDescription(), account.getImage(), account.getRole().getRoleName(), account.getSubScriptionType(),acc.getEmail());
            response.sendRedirect("home");
            return;
        }
        String sessionId = UUID.randomUUID().toString();
        SecureRandom secureRandom = new SecureRandom();
        int random = 100000 + secureRandom.nextInt(900000);
        String pass = random + "";
        String passHash = Security.encode(pass);
        Cookie newSessionCookie = new Cookie("SessionID_User", sessionId);
        newSessionCookie.setMaxAge(60 * 60 * 24);
        newSessionCookie.setHttpOnly(true);
        response.addCookie(newSessionCookie);
        otp.createSesssionIdApprove(sessionId,dao.getLastUserID() + 1, acc.getName(), "", acc.getPicture(), "Student", "free" ,acc.getEmail()); // Mặc định Student
        dao.createAccountGg(acc.getName(), acc.getEmail(), acc.getPicture(), passHash, "Student");
        dao.createSocialLinks(dao.getLastUserID());
        response.sendRedirect("home");
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

}
