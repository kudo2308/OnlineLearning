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
        String code = request.getParameter("code");
        Google gg = new Google();
        OTP otp = new OTP();
        String accessToken = gg.getToken(code);
        GoogleAccount acc = gg.getUserInfo(accessToken);
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
            otp.createSesssionIdApprove(sessionId, account.getUserID(), account.getFullName(), account.getRole().getRoleName(), account.getSubScriptionType());
            response.sendRedirect("home");
        }
        String sessionId = UUID.randomUUID().toString();
        SecureRandom secureRandom = new SecureRandom();
        int random = 100000 + secureRandom.nextInt(900000);
        String pass = random + "";
        String passHash = Security.encode(pass);
        otp.createSesssionIdApprove(sessionId, dao.getLastUserID() + 1, acc.getName(), "Student", "free"); // Mặc định Student
        dao.createAccount(acc.getName(), acc.getEmail(), passHash, "Student");
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
