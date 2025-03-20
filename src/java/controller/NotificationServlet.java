package controller;

import DAO.LoginDAO;
import DAO.NotificationDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Account;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account account = dao.getAccountByUserID(userID);

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        NotificationDAO notificationDAO = new NotificationDAO();

        switch (action) {
            case "getUnread":
                // Trả về danh sách thông báo chưa đọc dưới dạng JSON
                List<Notification> unreadNotifications = notificationDAO.getUnreadNotifications(account.getUserID());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(unreadNotifications));
                break;

            case "list":
                // Hiển thị trang danh sách thông báo
                List<Notification> allNotifications = notificationDAO.getAllNotifications(account.getUserID());
                request.setAttribute("notifications", allNotifications);
                request.getRequestDispatcher("/notifications.jsp").forward(request, response);
                break;

            case "count":
                // Trả về số lượng thông báo chưa đọc
                int count = notificationDAO.getUnreadCount(account.getUserID());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"count\":" + count + "}");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account account = dao.getAccountByUserID(userID);

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        NotificationDAO notificationDAO = new NotificationDAO();

        switch (action) {
            case "markRead":
                // Đánh dấu một thông báo đã đọc
                int notificationID = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsRead(notificationID);
                response.setStatus(HttpServletResponse.SC_OK);
                break;

            case "markAllRead":
                // Đánh dấu tất cả thông báo đã đọc
                notificationDAO.markAllAsRead(account.getUserID());
                response.setStatus(HttpServletResponse.SC_OK);
                break;
        }
    }
}
