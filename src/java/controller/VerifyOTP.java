package controller;

import DAO.LoginDAO;
import config.Json;
import config.OTP;
import config.Security;
import enums.RedisEnum;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import model.Account;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "Verify_OTP", urlPatterns = {"/verifyOTP"})
public class VerifyOTP extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String forget = request.getParameter("forget");

        if (forget != null && !forget.isEmpty()) {
            request.setAttribute("forget", "true");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("verify-otp.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otp = request.getParameter("otp");

        Json json = new Json();

        if (otp == null || otp.length() != 6) {
            json.sendJsonResponse(response, "error", "Invalid OTP", -1);
            return;
        }
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
            json.sendJsonResponse(response, "redirect", "login?error=Your session has expired", -1);
            return;
        }
        OTP get = new OTP();
        String userData = get.getSessionId(sessionId);
        if (userData == null) {
            json.sendJsonResponse(response, "redirect", "login?error=Your session has expired", -1);
            return;
        }
        String[] userInfo = userData.split(":");
        String email = userInfo[0];
        String byteFullname = userInfo[1];
        String fullname = new String(byteFullname.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
        String passHash = userInfo[2];
        String role = userInfo[3];
        String process = userInfo[4];
        String emailHash = Security.encode(email);

        if (get.getLock(emailHash) != null) {
            json.sendJsonResponse(response, "error", "You have exceeded the number of resends ", RedisEnum.TTL_PREVENT_ENTER_OTP.getTime());
            return;
        }
        String otpRe = get.getOTP(emailHash);
        if (otpRe == null) {
            if (process.equals("register")) {
                json.sendJsonResponse(response, "redirect", "register?change=true&errorregister=Your OTP has expired", -1);
                return;
            } else {
                json.sendJsonResponse(response, "redirect", "forget?change=true&errorforget=Your OTP has expired", -1);
                return;
            }
        }
        if (otpRe.equals(otp)) {
            LoginDAO dao = new LoginDAO();
            get.deleteSesssionId(sessionId);
            get.deleteOTP(emailHash);
            get.deleteAttempts(emailHash);
            get.deleteResend(emailHash);
            // xóa cookie tạo cookie mới là "SessionID_User"          
            Cookie sessionCookie = new Cookie("Session_ID_Pending", "");
            sessionCookie.setMaxAge(0);
            sessionCookie.setHttpOnly(true);
            response.addCookie(sessionCookie);
            // Tạo cookie mới "SessionID_User"
            String newsessionId = UUID.randomUUID().toString();
            Cookie newSessionCookie = new Cookie("SessionID_User", newsessionId);
            newSessionCookie.setMaxAge(60 * 60 * 24);
            newSessionCookie.setHttpOnly(true);
            response.addCookie(newSessionCookie);
            if (process.equals("register")) {
                int userId = dao.getLastUserID() + 1;
                get.createSesssionIdApprove(sessionId, userId, fullname, role, "free");
                dao.createAccount(fullname, email, passHash, role);
                json.sendJsonResponse(response, "redirect", "login?success=You register success", -1);
            } else {
                json.sendJsonResponse(response, "redirect", "changepass?email=" + email, -1);
            }
        } else {
            json.sendJsonResponse(response, "error", "You enter otp not correct !", -1);
        }
    }
}
