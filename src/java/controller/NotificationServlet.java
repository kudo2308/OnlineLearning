package controller;

import DAO.LoginDAO;
import DAO.NotificationDAO;
import DAO.CourseDAO;
import DAO.PaymentDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.Account;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Course;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        LoginDAO loginDAO = new LoginDAO();
        NotificationDAO notificationDAO = new NotificationDAO();
        CourseDAO courseDAO = new CourseDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        notificationService = new NotificationService(notificationDAO, loginDAO, paymentDAO, courseDAO);
    }

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
        List<Course> listcourses = dao.getCoursesByExpert(Integer.parseInt(userID));
        request.setAttribute("expertCourses", listcourses);
        List<Account> listUser = dao.getRegisteredUsersForExpert(Integer.parseInt(userID));
        request.setAttribute("courseUsers", listUser);
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        NotificationDAO notificationDAO = new NotificationDAO();

        switch (action) {
            case "getUnread":
                List<Notification> unreadNotifications = notificationDAO.getUnreadNotifications(account.getUserID());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(unreadNotifications));
                break;

            case "list":
                List<Notification> allNotifications = notificationDAO.getAllNotifications(account.getUserID());
                request.setAttribute("notifications", allNotifications);
                request.getRequestDispatcher("/notifications.jsp").forward(request, response);
                break;

            case "count":
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
                int notificationID = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsRead(notificationID);
                response.setStatus(HttpServletResponse.SC_OK);
                break;

            case "markAllRead":
                notificationDAO.markAllAsRead(account.getUserID());
                response.setStatus(HttpServletResponse.SC_OK);
                break;

            case "createNotification":
                
                handleCreateNotification(request, response, account);
                break;
        }
    }

    private void handleCreateNotification(HttpServletRequest request, HttpServletResponse response, Account sender)
            throws IOException {
        JsonObject jsonResponse = new JsonObject();
        try {
            String notificationScope = request.getParameter("notificationScope");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            int result = 0;

            // Validate input
            if (title == null || content == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Missing required parameters");
                sendJsonResponse(response, jsonResponse);
                return;
            }

            switch (notificationScope) {
                case "all-courses":
                    // Send to all users in all expert's courses
                    result = notificationService.sendToAllExpertCourseUsers(
                            sender.getUserID(),
                            title,
                            content,
                            "course",
                            0,
                            "notifications"
                    );
                    break;

                case "specific-course":
                    // Send to all users in a specific course
                    String courseId = request.getParameter("courseId");
                    if (courseId != null && !courseId.isEmpty()) {
                        result = notificationService.sendToCourseEnrollees(
                                Integer.parseInt(courseId),
                                title,
                                content,
                                "course",
                                Integer.parseInt(courseId),
                                null
                        );
                    }
                    break;

                case "specific-user":
                    String userId = request.getParameter("specificUserId");
                    if (userId != null && !userId.isEmpty()) {
                        notificationService.sendToUser(
                                Integer.parseInt(userId),
                                title,
                                content,
                                "course",
                                0,
                                "notifications"
                        );
                        result = 1;
                    }
                    break;
            }

            // Prepare response
            if (result > 0) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", result + " notification(s) sent");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to send notifications");
            }

            sendJsonResponse(response, jsonResponse);

        } catch (IOException | NumberFormatException e) {
            // In ra toàn bộ thông tin lỗi
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Server error: " + e.getMessage());
            e.printStackTrace(); // Log the full error on the server side
            System.out.println(e.getMessage());
            sendJsonResponse(response, jsonResponse);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, JsonObject jsonResponse) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }
}