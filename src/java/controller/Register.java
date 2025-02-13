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
import java.net.URLEncoder;

@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String pass = request.getParameter("pass");
        // Kiểm tra nếu có trường nào bị bỏ trống
        if (pass == null || pass.isEmpty() || email == null || email.isEmpty() || fullname == null || fullname.isEmpty()) {
            request.setAttribute("errorregister", "All fields is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
         request.setAttribute("fullname", fullname);
        // Kiểm tra định dạng email hợp lệ
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errorregister", "Invalid email format");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        request.setAttribute("email", email);
        //Kiểm tra định dạng của passwword
        if (pass.length() < 8) {
            request.setAttribute("errorregister", "Password must be at least 8 character ");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (pass.matches(".*[A-Z].*")) {
            request.setAttribute("errorregister", "Password must be contain an uppercase letter");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (pass.matches(".*\\d.*")) {
            request.setAttribute("errorregister", "Password must be has number");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (pass.matches(".*[@#$%^&+=!].*")) {
            request.setAttribute("errorregister", "Password must be has a special character");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        //Hash Email    
        String emailHash = Security.encode(email);
        String passHash = Security.encode(pass);
        //kiểm tra đã đăng kí chưa
        LoginDAO dao = new LoginDAO();
        boolean checkUser = dao.check(email);
        if (checkUser) {
            response.sendRedirect("login");
        } else {
            //Tạo session và lưu sessionId pending và tạo otp , attempt
            OTP otp = new OTP();
            int otpValue = otp.createOTP(emailHash);
            if (otpValue == -1) {
                request.setAttribute("errorregister", "Error create OTP");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            String sessionId = otp.createSessionId(email, passHash, fullname);
            //Gửi otp Email
            EmailSender.sendOTP(email, fullname, otpValue);
            // Gửi SessionId lên Cookie
            Cookie sessionCoookie = new Cookie("Session_ID_Pending", sessionId);
            sessionCoookie.setMaxAge(30 * 60);
            sessionCoookie.setHttpOnly(true);
            response.addCookie(sessionCoookie);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for user registration";
    }
}
