package controller;

import DAO.LoginDAO;
import DAO.ProfileDAO;
import config.OTP;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import model.Account;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "ChangRole", urlPatterns = {"/instructor"})
public class ChangRole extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        // Log: Kiểm tra xem tài khoản có tồn tại trong session không
        if (accountObj == null) {
            System.out.println("Tài khoản không tồn tại trong session, chuyển hướng đến login.jsp.");
            response.sendRedirect("login.jsp");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
            // Log: In ra userID
            System.out.println("Tìm thấy userID trong session: " + userID);
        } else {
            System.out.println("Không thể lấy được userID từ session, chuyển hướng đến login.jsp.");
            response.sendRedirect("login.jsp");
            return;
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserIDPass(userID);

        // Log: In ra thông tin tài khoản
        System.out.println("Thông tin tài khoản: " + acc.getUserID());

        ProfileDAO dao1 = new ProfileDAO();
        dao1.updateUserRole(acc.getUserID(), 2);

        // Log: Cập nhật quyền người dùng thành instructor
        System.out.println("Cập nhật quyền người dùng " + acc.getUserID() + " thành instructor.");

        OTP otp = new OTP();
        String sessionId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("SessionID_User".equals(cookie.getName())) {
                    sessionId = cookie.getValue();
                    break;
                }
            }
        }

        // Log: Cập nhật session với quyền mới
        otp.updateSessionField(sessionId, "roles", "Expert");
        System.out.println("Cập nhật session với quyền mới: " + acc.getRole().getRoleName());

        request.getRequestDispatcher("courses").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
