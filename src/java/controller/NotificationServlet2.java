/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CourseDAO;
import DAO.LoginDAO;
import DAO.NotificationDAO;
import DAO.PaymentDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Course;
import model.Notification;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "NotificationServlet2", urlPatterns = {"/adminNotify"})
public class NotificationServlet2 extends HttpServlet {

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
        CourseDAO d = new CourseDAO();
        List<Course> listcourses = d.findAll();
        request.setAttribute("expertCourses", listcourses);
        List<Account> listUser = dao.getAllAccounts();
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
                request.getRequestDispatcher("/admin_notification.jsp").forward(request, response);
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
        NotificationDAO notificationDAO = new NotificationDAO();

        CourseDAO d = new CourseDAO();
        List<Course> listcourses = d.findAll();
        request.setAttribute("expertCourses", listcourses);
        List<Account> listUser = dao.getAllAccounts();
        request.setAttribute("courseUsers", listUser);
        List<Notification> allNotifications = notificationDAO.getAllNotifications(account.getUserID());
        request.setAttribute("notifications", allNotifications);

        String action = request.getParameter("action");
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
                if (account == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                handleCreateNotification(request, response, account);
                break;
        }
    }

    private void handleCreateNotification(HttpServletRequest request, HttpServletResponse response, Account sender)
            throws IOException, ServletException {
        try {
            String notificationScope = request.getParameter("notificationScope");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String link = request.getParameter("link");

            // Enhanced validation
            if (notificationScope == null || title == null || content == null || link == null || link.trim().isEmpty() || title.trim().isEmpty() || content.trim().isEmpty()) {
                response.sendRedirect("notifications?error=All fields are required. Please fill in all information.");
                return;
            }
            if (!link.startsWith("http://localhost:8080/SWP_OLSver1/")) {
                response.sendRedirect("adminNotify?error=The notification link is not reasonable");
                return;
            }
            String realLink = link.substring(0, 38);
            // Validate title and content length
            if (title.length() > 10) {
                response.sendRedirect("adminNotify?error=Title must be 100 characters or less.");
                return;
            }

            if (content.length() > 500) {
                response.sendRedirect("adminNotify?error=Content must be 500 characters or less.");
                return;
            }

            int result = 0;
            try {
                switch (notificationScope) {
                    case "all-users":
                        result = notificationService.sendToAllUsers(
                                title,
                                content,
                                "course",
                                0,
                                realLink
                        );

                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;

                    case "sales":
                        result = notificationService.sendToUsersByRole(title, content, "system", 0, 5, realLink);
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;

                    case "marketing":
                        result = notificationService.sendToUsersByRole(title, content, "system", 0, 4, realLink);
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;
                    case "experts":
                        result = notificationService.sendToUsersByRole(title, content, "system", 0, 2, realLink);
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;
                    case "student":
                        result = notificationService.sendToUsersByRole(title, content, "system", 0, 3, realLink);
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;
                    case "specific-course":
                        String courseId = request.getParameter("courseId");
                        if (courseId == null || courseId.isEmpty()) {
                            request.setAttribute("error", "Please select a specific course.");
                            request.getRequestDispatcher("adminNotify").forward(request, response);
                            return;
                        }

                        int courseID = Integer.parseInt(courseId);
                        result = notificationService.sendToCourseEnrollees(
                                courseID,
                                title,
                                content,
                                "course",
                                courseID,
                                null
                        );
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications No Student register courses !");
                        }
                        break;

                    case "specific-user":
                        String userId = request.getParameter("specificUserId");
                        if (userId == null || userId.isEmpty()) {
                            request.setAttribute("error", "Please select a specific user.");
                            request.getRequestDispatcher("adminNotify").forward(request, response);
                            return;
                        }

                        notificationService.sendToUser(
                                Integer.parseInt(userId),
                                title,
                                content,
                                "course",
                                0,
                                "notifications"
                        );
                        result = 1;
                        if (result > 0) {
                            request.setAttribute("success", "Notification sent successfully !");
                        } else {
                            request.setAttribute("error", "Failed to send notifications please try agian !");
                        }
                        break;

                    default:
                        request.setAttribute("error", "Invalid notification scope selected.");
                        request.getRequestDispatcher("admin_notification.jsp").forward(request, response);
                        return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid user or course ID format.");
            } catch (Exception e) {
                // Log the full exception for server-side debugging
                e.printStackTrace();
                request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            }
            request.getRequestDispatcher("admin_notification.jsp").forward(request, response);
        } catch (Exception e) {
            // Catch any unexpected exceptions
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred during notification creation.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

}
