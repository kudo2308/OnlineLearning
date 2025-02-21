package controller;

import DAO.LoginDAO;
import config.EmailSender;
import config.OTP;
import config.Security;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

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
            if(sessionId == null){
             response.sendRedirect("register.jsp");
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
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String pass = request.getParameter("pass");
        String role = request.getParameter("role");
        // Kiểm tra nếu có trường nào bị bỏ trống
        if (email == null || email.isEmpty()) {
            request.setAttribute("errorregister", "Please enter Email field");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        // Kiểm tra định dạng email hợp lệ
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errorregister", "The email does not exist , check format or domain");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        request.setAttribute("email", email);
        if (fullname == null || fullname.isEmpty()) {
            request.setAttribute("errorregister", "Please enter Fullname field");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        request.setAttribute("fullname", fullname);
        if (pass == null || pass.isEmpty()) {
            request.setAttribute("errorregister", "Please enter Password field");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        //Kiểm tra định dạng của passwword
        if (pass.length() < 8) {
            request.setAttribute("errorregister", "Password must be at least 8 character ");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*[A-Z].*")) {
            request.setAttribute("errorregister", "Password must be contain an uppercase letter");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*\\d.*")) {
            request.setAttribute("errorregister", "Password must be has number");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*[@#$%^&+=!].*")) {
            request.setAttribute("errorregister", "Password must be has a special character");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (role == null || role.isEmpty()) {
            request.setAttribute("errorregister", "Please choose role field");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        //Hash Email    
        String emailHash = Security.encode(email);
        String passHash = Security.encode(pass);
        //Kiểm tra có bị chặn không

        //kiểm tra đã đăng kí chưa
        LoginDAO dao = new LoginDAO();
        boolean checkUser = dao.check(email);
        if (checkUser) {
            response.sendRedirect("login");
        } else {
            OTP otp = new OTP();
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
            if (sessionId != null) {
                response.sendRedirect("verifyOTP");
            } //Tạo session và lưu sessionId pending và tạo otp , attempt     
            else {
                int otpValue = otp.createOTP(emailHash);
                if (otpValue == -1) {
                    request.setAttribute("errorregister", "Error create OTP");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
                sessionId = otp.createSessionId(email, passHash, fullname, role ,"register");
                //Gửi otp Email
                EmailSender.sendOTP(email, fullname, otpValue);
                // Gửi SessionId lên Cookie
                Cookie sessionCoookie = new Cookie("Session_ID_Pending", sessionId);
                sessionCoookie.setMaxAge(30 * 60);
                sessionCoookie.setHttpOnly(true);
                response.addCookie(sessionCoookie);
                response.sendRedirect("verifyOTP");
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for user registration";
    }
}
