package controller;

import DAO.CourseDAO;
import DAO.DashboardDAO;
import DAO.LoginDAO;
import DAO.RegistrationDAO;
import DAO.TransactionDAO;
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
import model.Course;
import model.Registration;
import model.Transaction;

@WebServlet(name = "ExpertDashboardController", urlPatterns = {"/expert-dashboard"})
public class ExpertDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user has expert access
        if (!hasExpertAccess(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get expert ID from session
        int expertId = getExpertIdFromSession(session);
        if (expertId == 0) {
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
        CourseDAO courseDAO = new CourseDAO();
        RegistrationDAO registrationDAO = new RegistrationDAO();
        TransactionDAO transactionDAO = new TransactionDAO();
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Get expert-specific statistics
        int totalCourses = courseDAO.getTotalCoursesByExpert(expertId);
        int totalStudents = registrationDAO.getTotalStudentsByExpert(expertId);
        double totalRevenue = transactionDAO.getTotalRevenueByExpert(expertId);
        int totalLessons = courseDAO.getTotalLessonsByExpert(expertId);
        
        // Get period-specific statistics
        int newCourses = courseDAO.getNewCoursesByExpert(expertId, startDate, endDate);
        int newStudents = registrationDAO.getNewStudentsByExpert(expertId, startDate, endDate);
        double periodRevenue = transactionDAO.getRevenueByExpertInPeriod(expertId, startDate, endDate);
        
        // Get registration status counts for expert's courses
        int pendingRegistrations = registrationDAO.getTotalRegistrationsByExpertAndStatus(expertId, "pending");
        int activeRegistrations = registrationDAO.getTotalRegistrationsByExpertAndStatus(expertId, "active");
        int completedRegistrations = registrationDAO.getTotalRegistrationsByExpertAndStatus(expertId, "completed");
        int cancelledRegistrations = registrationDAO.getTotalRegistrationsByExpertAndStatus(expertId, "cancelled");
        
        // Get recent registrations for expert's courses
        List<Registration> recentRegistrations = registrationDAO.getRecentRegistrationsByExpert(expertId, 10);
        
        // Get recent transactions for expert
        List<Transaction> recentTransactions = transactionDAO.getRecentTransactionsByExpert(expertId, 10);
        
        // Get monthly registration data for chart
        Map<String, Integer> monthlyRegistrations = registrationDAO.getMonthlyRegistrationCountsByExpert(expertId);
        
        // Get monthly revenue data for chart
        Map<String, Double> monthlyRevenue = transactionDAO.getMonthlyRevenueByExpert(expertId);
        
        // Get course status distribution
        Map<String, Integer> courseStatusDistribution = dashboardDAO.getCourseStatusDistributionByExpert(expertId);
        
        // Get recent courses by expert
        List<Course> recentCourses = courseDAO.getRecentCoursesByExpert(expertId, 5);
        
        // Set attributes for the view
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalLessons", totalLessons);
        request.setAttribute("newCourses", newCourses);
        request.setAttribute("newStudents", newStudents);
        request.setAttribute("periodRevenue", periodRevenue);
        request.setAttribute("pendingRegistrations", pendingRegistrations);
        request.setAttribute("activeRegistrations", activeRegistrations);
        request.setAttribute("completedRegistrations", completedRegistrations);
        request.setAttribute("cancelledRegistrations", cancelledRegistrations);
        request.setAttribute("recentRegistrations", recentRegistrations);
        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("monthlyRegistrations", monthlyRegistrations);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("courseStatusDistribution", courseStatusDistribution);
        request.setAttribute("recentCourses", recentCourses);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        // Forward to the expert dashboard page
        request.getRequestDispatcher("/expert-dashboard.jsp").forward(request, response);
    }
    
    private boolean hasExpertAccess(HttpSession session) {
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
            return "Expert".equals(acc.getRole().getRoleName());
        }
        return false;
    }
    
    private int getExpertIdFromSession(HttpSession session) {
        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            return 0;
        }

        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            String userID = accountData.get("userId");
            if (userID != null && !userID.isEmpty()) {
                try {
                    return Integer.parseInt(userID);
                } catch (NumberFormatException e) {
                    return 0;
                }
            }
        }
        
        return 0;
    }
}
