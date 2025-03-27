package controller;

import DAO.DashboardDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 * Controller for the Admin Dashboard
 */
@WebServlet(name = "DashBoardController", urlPatterns = {"/admin/dashboard"})
public class DashBoardController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Retrieves dashboard data and forwards to the dashboard page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Check if user is logged in and is an admin
        if (account == null || account.getRole() == null || account.getRole().getRoleID() != 1) { // Assuming roleID 1 is for admin
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get date range from request parameters
        String dateRange = request.getParameter("dateRange");
        
        // If no specific date range is requested and we have cached data, use it
        if ((dateRange == null || dateRange.isEmpty() || dateRange.equals("current_month")) && 
            session.getAttribute("dashboardTotalProfit") != null && 
            session.getAttribute("dashboardLastRefreshed") != null) {
            
            // Check if the cached data is still fresh (less than 5 minutes old)
            Date lastRefreshed = (Date) session.getAttribute("dashboardLastRefreshed");
            Date now = new Date();
            long diffMinutes = (now.getTime() - lastRefreshed.getTime()) / (60 * 1000);
            
            if (diffMinutes < 5) {
                // Use cached data from session
                request.setAttribute("totalProfit", session.getAttribute("dashboardTotalProfit"));
                request.setAttribute("totalFeedbacks", session.getAttribute("dashboardTotalFeedbacks"));
                request.setAttribute("totalOrders", session.getAttribute("dashboardTotalOrders"));
                request.setAttribute("totalUsers", session.getAttribute("dashboardTotalUsers"));
                request.setAttribute("totalCourses", session.getAttribute("dashboardTotalCourses"));
                request.setAttribute("totalBlogs", session.getAttribute("dashboardTotalBlogs"));
                request.setAttribute("growthPercentages", session.getAttribute("dashboardGrowthPercentages"));
                request.setAttribute("dateInfo", session.getAttribute("dashboardDateInfo"));
                
                // We still need to fetch these other items that aren't cached
                DashboardDAO dashboardDAO = new DashboardDAO();
                
                // Get monthly profile views for chart
                Map<String, Integer> monthlyProfileViews = dashboardDAO.getMonthlyProfileViews();
                
                // Get recent notifications
                List<Map<String, Object>> recentNotifications = dashboardDAO.getRecentNotifications(5);
                
                // Get recent users
                List<Account> recentUsers = dashboardDAO.getRecentUsers(4);
                
                // Get recent orders
                List<Map<String, Object>> recentOrders = dashboardDAO.getRecentOrders(4);
                
                // Get recent courses
                List<Map<String, Object>> recentCourses = dashboardDAO.getRecentCourses(4);
                
                // Get recent blogs
                List<Map<String, Object>> recentBlogs = dashboardDAO.getRecentBlogs(4);
                
                // Get recent wallet transactions
                List<Map<String, Object>> recentTransactions = dashboardDAO.getRecentWalletTransactions(5);
                
                // Get financial summary
                Map<String, Object> financialSummary = dashboardDAO.getFinancialSummary();
                
                // Get course status distribution
                Map<String, Integer> courseStatusDistribution = dashboardDAO.getCourseStatusDistribution();
                
                // Set these attributes
                request.setAttribute("monthlyProfileViews", monthlyProfileViews);
                request.setAttribute("recentNotifications", recentNotifications);
                request.setAttribute("recentUsers", recentUsers);
                request.setAttribute("recentOrders", recentOrders);
                request.setAttribute("recentCourses", recentCourses);
                request.setAttribute("recentBlogs", recentBlogs);
                request.setAttribute("recentTransactions", recentTransactions);
                request.setAttribute("financialSummary", financialSummary);
                request.setAttribute("courseStatusDistribution", courseStatusDistribution);
                request.setAttribute("selectedDateRange", "current_month");
                
                // Forward to the dashboard page
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
                return;
            }
        }
        
        // If we get here, we need to fetch fresh data
        DashboardDAO dashboardDAO = new DashboardDAO();
        String startDate = null;
        String endDate = null;
        String dateRangeTitle = "Current Month"; // Default title
        
        // Format dates for SQL queries (yyyy-MM-dd)
        SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Date today = cal.getTime();
        
        // Default to current month if no date range specified
        if (dateRange == null || dateRange.isEmpty() || dateRange.equals("current_month")) {
            // Current month start date
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = sqlDateFormat.format(cal.getTime());
            
            // Current month end date
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            endDate = sqlDateFormat.format(cal.getTime());
            
            dateRangeTitle = "Current Month";
        } else if (dateRange.equals("previous_month")) {
            // Previous month
            cal.add(Calendar.MONTH, -1);
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = sqlDateFormat.format(cal.getTime());
            
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            endDate = sqlDateFormat.format(cal.getTime());
            
            dateRangeTitle = "Previous Month";
        } else if (dateRange.equals("last_30_days")) {
            // Last 30 days
            cal.setTime(today);
            endDate = sqlDateFormat.format(cal.getTime());
            
            cal.add(Calendar.DAY_OF_MONTH, -30);
            startDate = sqlDateFormat.format(cal.getTime());
            
            dateRangeTitle = "Last 30 Days";
        } else if (dateRange.equals("last_90_days")) {
            // Last 90 days
            cal.setTime(today);
            endDate = sqlDateFormat.format(cal.getTime());
            
            cal.add(Calendar.DAY_OF_MONTH, -90);
            startDate = sqlDateFormat.format(cal.getTime());
            
            dateRangeTitle = "Last 90 Days";
        } else if (dateRange.equals("year_to_date")) {
            // Year to date
            cal.setTime(today);
            cal.set(Calendar.DAY_OF_YEAR, 1);
            startDate = sqlDateFormat.format(cal.getTime());
            
            cal.setTime(today);
            endDate = sqlDateFormat.format(cal.getTime());
            
            dateRangeTitle = "Year to Date";
        } else if (dateRange.equals("custom")) {
            // Custom date range
            startDate = request.getParameter("startDate");
            endDate = request.getParameter("endDate");
            
            if (startDate == null || startDate.isEmpty() || endDate == null || endDate.isEmpty()) {
                // Default to current month if custom dates are invalid
                cal.setTime(today);
                cal.set(Calendar.DAY_OF_MONTH, 1);
                startDate = sqlDateFormat.format(cal.getTime());
                
                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                endDate = sqlDateFormat.format(cal.getTime());
                
                dateRangeTitle = "Current Month";
            } else {
                dateRangeTitle = "Custom Range";
            }
        }
        
        // Get date information for the dashboard
        Map<String, String> dateInfo = getDateInfo();
        dateInfo.put("selectedRangeTitle", dateRangeTitle);
        dateInfo.put("selectedRangeStart", startDate);
        dateInfo.put("selectedRangeEnd", endDate);
        
        // Get dashboard statistics for selected date range
        BigDecimal totalProfit = dashboardDAO.getTotalProfitByDateRange(startDate, endDate);
        int totalFeedbacks = dashboardDAO.getTotalFeedbacksByDateRange(startDate, endDate);
        int totalOrders = dashboardDAO.getTotalOrdersByDateRange(startDate, endDate);
        int totalUsers = dashboardDAO.getTotalUsersByDateRange(startDate, endDate);
        int totalCourses = dashboardDAO.getTotalCoursesByDateRange(startDate, endDate);
        int totalBlogs = dashboardDAO.getTotalBlogsByDateRange(startDate, endDate);
        
        // Get growth percentages
        Map<String, Integer> growthPercentages = dashboardDAO.getGrowthPercentages();
        
        // Get monthly profile views for chart
        Map<String, Integer> monthlyProfileViews = dashboardDAO.getMonthlyProfileViews();
        
        // Get recent notifications
        List<Map<String, Object>> recentNotifications = dashboardDAO.getRecentNotifications(5);
        
        // Get recent users
        List<Account> recentUsers = dashboardDAO.getRecentUsers(4);
        
        // Get recent orders
        List<Map<String, Object>> recentOrders = dashboardDAO.getRecentOrders(4);
        
        // Get recent courses
        List<Map<String, Object>> recentCourses = dashboardDAO.getRecentCourses(4);
        
        // Get recent blogs
        List<Map<String, Object>> recentBlogs = dashboardDAO.getRecentBlogs(4);
        
        // Get recent wallet transactions
        List<Map<String, Object>> recentTransactions = dashboardDAO.getRecentWalletTransactions(5);
        
        // Get financial summary
        Map<String, Object> financialSummary = dashboardDAO.getFinancialSummary();
        
        // Get course status distribution
        Map<String, Integer> courseStatusDistribution = dashboardDAO.getCourseStatusDistribution();
        
        // If this is current month data, cache it in the session
        if (dateRange == null || dateRange.isEmpty() || dateRange.equals("current_month")) {
            session.setAttribute("dashboardTotalProfit", totalProfit);
            session.setAttribute("dashboardTotalFeedbacks", totalFeedbacks);
            session.setAttribute("dashboardTotalOrders", totalOrders);
            session.setAttribute("dashboardTotalUsers", totalUsers);
            session.setAttribute("dashboardTotalCourses", totalCourses);
            session.setAttribute("dashboardTotalBlogs", totalBlogs);
            session.setAttribute("dashboardGrowthPercentages", growthPercentages);
            session.setAttribute("dashboardDateInfo", dateInfo);
            session.setAttribute("dashboardLastRefreshed", new Date());
        }
        
        // Set attributes for the JSP
        request.setAttribute("totalProfit", totalProfit);
        request.setAttribute("totalFeedbacks", totalFeedbacks);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("growthPercentages", growthPercentages);
        request.setAttribute("monthlyProfileViews", monthlyProfileViews);
        request.setAttribute("recentNotifications", recentNotifications);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("recentCourses", recentCourses);
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("financialSummary", financialSummary);
        request.setAttribute("courseStatusDistribution", courseStatusDistribution);
        request.setAttribute("dateInfo", dateInfo);
        request.setAttribute("selectedDateRange", dateRange != null ? dateRange : "current_month");
        
        // Forward to the dashboard page
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Currently not used, redirects to GET
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Dashboard Controller";
    }
    
    /**
     * Gets date information for the dashboard
     * @return Map containing date information
     */
    private static Map<String, String> getDateInfo() {
        Map<String, String> dateInfo = new java.util.HashMap<>();
        
        // Get current date
        Calendar cal = Calendar.getInstance();
        Date currentDate = cal.getTime();
        
        // Format for month display
        SimpleDateFormat monthFormat = new SimpleDateFormat("MMMM yyyy");
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM d, yyyy");
        
        // Current month info
        String currentMonth = monthFormat.format(currentDate);
        dateInfo.put("currentMonth", currentMonth);
        
        // First day of current month
        cal.set(Calendar.DAY_OF_MONTH, 1);
        Date firstDayOfMonth = cal.getTime();
        String firstDayStr = dateFormat.format(firstDayOfMonth);
        dateInfo.put("currentMonthStart", firstDayStr);
        
        // Last day of current month
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date lastDayOfMonth = cal.getTime();
        String lastDayStr = dateFormat.format(lastDayOfMonth);
        dateInfo.put("currentMonthEnd", lastDayStr);
        
        // Previous month info
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.add(Calendar.MONTH, -1);
        Date firstDayOfPrevMonth = cal.getTime();
        String prevMonth = monthFormat.format(firstDayOfPrevMonth);
        dateInfo.put("previousMonth", prevMonth);
        
        String prevMonthStart = dateFormat.format(firstDayOfPrevMonth);
        dateInfo.put("previousMonthStart", prevMonthStart);
        
        // Last day of previous month
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date lastDayOfPrevMonth = cal.getTime();
        String prevMonthEnd = dateFormat.format(lastDayOfPrevMonth);
        dateInfo.put("previousMonthEnd", prevMonthEnd);
        
        return dateInfo;
    }
    
    /**
     * Refreshes the dashboard data in the session
     * This method can be called from other controllers when data changes
     * @param session The HttpSession to update
     */
    public static void refreshDashboardData(HttpSession session) {
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Format dates for SQL queries (yyyy-MM-dd)
        SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        
        // Current month start date
        cal.set(Calendar.DAY_OF_MONTH, 1);
        String currentMonthStart = sqlDateFormat.format(cal.getTime());
        
        // Current month end date
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        String currentMonthEnd = sqlDateFormat.format(cal.getTime());
        
        // Get dashboard statistics for current month
        BigDecimal totalProfit = dashboardDAO.getTotalProfitByDateRange(currentMonthStart, currentMonthEnd);
        int totalFeedbacks = dashboardDAO.getTotalFeedbacksByDateRange(currentMonthStart, currentMonthEnd);
        int totalOrders = dashboardDAO.getTotalOrdersByDateRange(currentMonthStart, currentMonthEnd);
        int totalUsers = dashboardDAO.getTotalUsersByDateRange(currentMonthStart, currentMonthEnd);
        int totalCourses = dashboardDAO.getTotalCoursesByDateRange(currentMonthStart, currentMonthEnd);
        int totalBlogs = dashboardDAO.getTotalBlogsByDateRange(currentMonthStart, currentMonthEnd);
        
        // Get growth percentages
        Map<String, Integer> growthPercentages = dashboardDAO.getGrowthPercentages();
        
        // Get date information
        Map<String, String> dateInfo = getDateInfo();
        
        // Store in session for quick access
        session.setAttribute("dashboardTotalProfit", totalProfit);
        session.setAttribute("dashboardTotalFeedbacks", totalFeedbacks);
        session.setAttribute("dashboardTotalOrders", totalOrders);
        session.setAttribute("dashboardTotalUsers", totalUsers);
        session.setAttribute("dashboardTotalCourses", totalCourses);
        session.setAttribute("dashboardTotalBlogs", totalBlogs);
        session.setAttribute("dashboardGrowthPercentages", growthPercentages);
        session.setAttribute("dashboardDateInfo", dateInfo);
        session.setAttribute("dashboardLastRefreshed", new Date());
    }
}
