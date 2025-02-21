package controller;

import config.EmailSender;
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

@WebServlet(name = "RefeshOTP", urlPatterns = {"/refeshOTP"})
public class RefeshOTP extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("verify-otp.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Json json = new Json();
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
            json.sendJsonResponse(response, "redirect", "Your registration has expired", -1);
            return;
        }
        OTP get = new OTP();
        String userData = get.getSessionId(sessionId);
        if (userData == null) {
            json.sendJsonResponse(response, "redirect", "Your registration has expired", -1);
            return;
        }
        String[] userInfo = userData.split(":");
        String email = userInfo[0];
        String byteFullname = userInfo[1];
        String fullname = new String(byteFullname.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
        String emailHash = Security.encode(email);

        if (get.getLock(emailHash) != null) {
            json.sendJsonResponse(response, "error", "Wait timeout Verify !", -1);
            return;
        }
        if (get.getLockResend(emailHash) != null) {
            json.sendJsonResponse(response, "error", "You have exceeded the number of resends", RedisEnum.TTL_PREVENT_RESEND.getTime());
            return;
        }
        OTP otp = new OTP();
        int otpValue = otp.createOTP(emailHash);
        if (otpValue == -1) {
            json.sendJsonResponse(response, "error", "Error refresh OTP", -1);
            return;
        }
        EmailSender.sendOTP(email, fullname, otpValue);
        otp.decreaseCount(emailHash);
        json.sendJsonResponse(response, "success", "Resend OTP successful", RedisEnum.TTL_SEND_RESEND.getTime());
    }
}
