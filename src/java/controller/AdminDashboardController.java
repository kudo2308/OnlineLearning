package controller;

import DAO.CourseDAO;
import DAO.DashboardDAO;
import DAO.LoginDAO;
import DAO.RegistrationDAO;
import DAO.TransactionDAO;
import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Registration;
import model.Transaction;
import model.User;
import java.math.BigDecimal;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user has admin access
        if (!hasAdminAccess(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get date range parameters
        String dateRange = request.getParameter("dateRange");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Set default date range to "last30Days" if not specified
        if (dateRange == null || dateRange.isEmpty()) {
            dateRange = "last30Days";
        }
        
        // Calculate start and end dates based on date range
        Date startDate = null;
        Date endDate = new Date(); // Current date as end date
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(endDate);
        
        if ("today".equals(dateRange)) {
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            startDate = cal.getTime();
        } else if ("yesterday".equals(dateRange)) {
            cal.add(Calendar.DAY_OF_MONTH, -1);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            startDate = cal.getTime();
            
            cal.add(Calendar.DAY_OF_MONTH, 1);
            cal.add(Calendar.SECOND, -1);
            endDate = cal.getTime();
        } else if ("last7Days".equals(dateRange)) {
            cal.add(Calendar.DAY_OF_MONTH, -7);
            startDate = cal.getTime();
        } else if ("last30Days".equals(dateRange)) {
            cal.add(Calendar.DAY_OF_MONTH, -30);
            startDate = cal.getTime();
        } else if ("thisMonth".equals(dateRange)) {
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = cal.getTime();
        } else if ("lastMonth".equals(dateRange)) {
            cal.set(Calendar.DAY_OF_MONTH, 1);
            cal.add(Calendar.MONTH, -1);
            startDate = cal.getTime();
            
            cal.add(Calendar.MONTH, 1);
            cal.add(Calendar.SECOND, -1);
            endDate = cal.getTime();
        } else if ("custom".equals(dateRange)) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                startDate = sdf.parse(startDateStr);
                endDate = sdf.parse(endDateStr);
                
                // Set end date to end of day
                cal.setTime(endDate);
                cal.set(Calendar.HOUR_OF_DAY, 23);
                cal.set(Calendar.MINUTE, 59);
                cal.set(Calendar.SECOND, 59);
                endDate = cal.getTime();
            } catch (Exception e) {
                // If parsing fails, default to last 30 days
                cal.setTime(endDate);
                cal.add(Calendar.DAY_OF_MONTH, -30);
                startDate = cal.getTime();
            }
        }
        
        // Initialize DAOs
        UserDAO userDAO = new UserDAO();
        CourseDAO courseDAO = new CourseDAO();
        RegistrationDAO registrationDAO = new RegistrationDAO();
        TransactionDAO transactionDAO = new TransactionDAO();
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Get statistics
        int totalUsers = userDAO.getTotalUsers();
        int totalCourses = courseDAO.getTotalCourses();
        int totalRegistrations = registrationDAO.getTotalRegistrations();
        double totalRevenue = transactionDAO.getTotalRevenue();
        
        // Get new users in date range
        int newUsers = userDAO.getNewUsersCount(startDate, endDate);
        
        // Get new registrations in date range
        int newRegistrations = registrationDAO.getNewRegistrationsCount(startDate, endDate);
        
        // Get revenue in date range
        double periodRevenue = transactionDAO.getRevenueInPeriod(startDate, endDate);
        
        // Get registration status counts
        int pendingRegistrations = registrationDAO.getTotalRegistrationsByStatus("pending");
        int activeRegistrations = registrationDAO.getTotalRegistrationsByStatus("active");
        int completedRegistrations = registrationDAO.getTotalRegistrationsByStatus("completed");
        int cancelledRegistrations = registrationDAO.getTotalRegistrationsByStatus("cancelled");
        
        // Get recent registrations
        List<Registration> recentRegistrations = registrationDAO.getRecentRegistrations(10);
        
        // Get recent transactions
        List<Transaction> recentTransactions = transactionDAO.getRecentTransactions(10);
        
        // Get monthly registration data for chart
        Map<String, Integer> monthlyRegistrations = dashboardDAO.getMonthlyRegistrationCounts();
        
        // Get monthly revenue data for chart
        Map<String, BigDecimal> monthlyRevenue = dashboardDAO.getMonthlyRevenue();
        
        // Set attributes for the view
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("newRegistrations", newRegistrations);
        request.setAttribute("periodRevenue", periodRevenue);
        request.setAttribute("pendingRegistrations", pendingRegistrations);
        request.setAttribute("activeRegistrations", activeRegistrations);
        request.setAttribute("completedRegistrations", completedRegistrations);
        request.setAttribute("cancelledRegistrations", cancelledRegistrations);
        request.setAttribute("recentRegistrations", recentRegistrations);
        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("monthlyRegistrations", monthlyRegistrations);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        // Forward to the dashboard page
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
    
    private boolean hasAdminAccess(HttpSession session) {
        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            return false;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        if (acc != null) {
            return "Admin".equals(acc.getRole().getRoleName());
        }
        return false;
    }
}
