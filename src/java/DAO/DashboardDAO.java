package DAO;

import DBContext.DBContext;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Role;
import java.util.Date;

/**
 * Data Access Object for the Admin Dashboard
 */
public class DashboardDAO extends DBContext {

    /**
     * Get total profit from all orders
     * @return Total profit in dollars
     */
    public BigDecimal getTotalProfit() {
        BigDecimal totalProfit = BigDecimal.ZERO;
        String sql = "SELECT SUM(TotalAmount) AS TotalProfit FROM [Order] WHERE PaymentStatus = 'Completed'";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalProfit = rs.getBigDecimal("TotalProfit");
                if (totalProfit == null) {
                    totalProfit = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting total profit: " + e.getMessage());
        }
        
        return totalProfit;
    }
    
    /**
     * Get total number of feedbacks
     * @return Number of feedbacks
     */
    public int getTotalFeedbacks() {
        int totalFeedbacks = 0;
        String sql = "SELECT COUNT(*) AS TotalFeedbacks FROM Feedback";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalFeedbacks = rs.getInt("TotalFeedbacks");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total feedbacks: " + e.getMessage());
        }
        
        return totalFeedbacks;
    }
    
    /**
     * Get total number of orders
     * @return Number of orders
     */
    public int getTotalOrders() {
        int totalOrders = 0;
        String sql = "SELECT COUNT(*) AS TotalOrders FROM [Order]";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalOrders = rs.getInt("TotalOrders");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total orders: " + e.getMessage());
        }
        
        return totalOrders;
    }
    
    /**
     * Get total number of users
     * @return Number of users
     */
    public int getTotalUsers() {
        int totalUsers = 0;
        String sql = "SELECT COUNT(*) AS TotalUsers FROM Account";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalUsers = rs.getInt("TotalUsers");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total users: " + e.getMessage());
        }
        
        return totalUsers;
    }
    
    /**
     * Get total number of courses
     * @return Number of courses
     */
    public int getTotalCourses() {
        int totalCourses = 0;
        String sql = "SELECT COUNT(*) AS TotalCourses FROM Course WHERE Status = 'Public'";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalCourses = rs.getInt("TotalCourses");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total courses: " + e.getMessage());
        }
        
        return totalCourses;
    }
    
    /**
     * Get total number of blogs
     * @return Number of blogs
     */
    public int getTotalBlogs() {
        int totalBlogs = 0;
        String sql = "SELECT COUNT(*) AS TotalBlogs FROM Blog WHERE Status = 'Public'";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalBlogs = rs.getInt("TotalBlogs");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total blogs: " + e.getMessage());
        }
        
        return totalBlogs;
    }
    
    /**
     * Get monthly profile views for the past 6 months
     * @return Map of month to view count
     */
    public Map<String, Integer> getMonthlyProfileViews() {
        Map<String, Integer> monthlyViews = new HashMap<>();
        String sql = "SELECT FORMAT(ViewDate, 'MMMM') AS Month, COUNT(*) AS ViewCount " +
                     "FROM ProfileViews " +
                     "WHERE ViewDate >= DATEADD(month, -6, GETDATE()) " +
                     "GROUP BY FORMAT(ViewDate, 'MMMM') " +
                     "ORDER BY MIN(ViewDate)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                int viewCount = rs.getInt("ViewCount");
                monthlyViews.put(month, viewCount);
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly profile views: " + e.getMessage());
        }
        
        return monthlyViews;
    }
    
    /**
     * Get recent notifications
     * @param limit Number of notifications to retrieve
     * @return List of notifications
     */
    public List<Map<String, Object>> getRecentNotifications(int limit) {
        List<Map<String, Object>> notifications = new ArrayList<>();
        String sql = "SELECT TOP(?) n.Title, n.Content, n.Type, n.CreatedAt, a.FullName AS SenderName " +
                     "FROM Notification n " +
                     "LEFT JOIN Account a ON n.UserID = a.UserID " +
                     "ORDER BY n.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> notification = new HashMap<>();
                notification.put("title", rs.getString("Title"));
                notification.put("content", rs.getString("Content"));
                notification.put("type", rs.getString("Type"));
                notification.put("createdAt", rs.getTimestamp("CreatedAt"));
                notification.put("senderName", rs.getString("SenderName"));
                notifications.add(notification);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent notifications: " + e.getMessage());
        }
        
        return notifications;
    }
    
    /**
     * Get recent users
     * @param limit Number of users to retrieve
     * @return List of recent users
     */
    public List<Account> getRecentUsers(int limit) {
        List<Account> recentUsers = new ArrayList<>();
        String sql = "SELECT TOP(?) a.UserID, a.FullName, a.Email, a.Status, a.CreatedAt, r.RoleID, r.RoleName " +
                     "FROM Account a " +
                     "JOIN Role r ON a.RoleID = r.RoleID " +
                     "ORDER BY a.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Account user = new Account();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setStatus(rs.getBoolean("Status"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                user.setRole(role);
                
                recentUsers.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent users: " + e.getMessage());
        }
        
        return recentUsers;
    }
    
    /**
     * Get recent orders
     * @param limit Number of orders to retrieve
     * @return List of recent orders
     */
    public List<Map<String, Object>> getRecentOrders(int limit) {
        List<Map<String, Object>> recentOrders = new ArrayList<>();
        String sql = "SELECT TOP(?) o.OrderID, o.TotalAmount, o.PaymentStatus, o.CreatedAt, " +
                     "a.FullName AS CustomerName, c.Title AS CourseName " +
                     "FROM [Order] o " +
                     "JOIN Account a ON o.AccountID = a.UserID " +
                     "JOIN OrderItem oi ON o.OrderID = oi.OrderID " +
                     "JOIN Course c ON oi.CourseID = c.CourseID " +
                     "ORDER BY o.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderId", rs.getInt("OrderID"));
                order.put("totalAmount", rs.getBigDecimal("TotalAmount"));
                order.put("paymentStatus", rs.getString("PaymentStatus"));
                order.put("createdAt", rs.getTimestamp("CreatedAt"));
                order.put("customerName", rs.getString("CustomerName"));
                order.put("courseName", rs.getString("CourseName"));
                recentOrders.add(order);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent orders: " + e.getMessage());
        }
        
        return recentOrders;
    }
    
    /**
     * Get recent courses
     * @param limit Number of courses to retrieve
     * @return List of recent courses
     */
    public List<Map<String, Object>> getRecentCourses(int limit) {
        List<Map<String, Object>> recentCourses = new ArrayList<>();
        String sql = "SELECT TOP(?) c.CourseID, c.Title, c.Price, c.Status, c.CreatedAt, " +
                     "a.FullName AS InstructorName, cat.CategoryName " +
                     "FROM Course c " +
                     "JOIN Account a ON c.InstructorID = a.UserID " +
                     "JOIN Category cat ON c.CategoryID = cat.CategoryID " +
                     "ORDER BY c.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("courseId", rs.getInt("CourseID"));
                course.put("title", rs.getString("Title"));
                course.put("price", rs.getBigDecimal("Price"));
                course.put("status", rs.getString("Status"));
                course.put("createdAt", rs.getTimestamp("CreatedAt"));
                course.put("instructorName", rs.getString("InstructorName"));
                course.put("categoryName", rs.getString("CategoryName"));
                recentCourses.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent courses: " + e.getMessage());
        }
        
        return recentCourses;
    }
    
    /**
     * Get recent blogs
     * @param limit Number of blogs to retrieve
     * @return List of recent blogs
     */
    public List<Map<String, Object>> getRecentBlogs(int limit) {
        List<Map<String, Object>> recentBlogs = new ArrayList<>();
        String sql = "SELECT TOP(?) b.BlogID, b.Title, b.Status, b.CreatedAt, " +
                     "a.FullName AS AuthorName, bc.CategoryName " +
                     "FROM Blog b " +
                     "JOIN Account a ON b.AuthorID = a.UserID " +
                     "JOIN BlogCategory bc ON b.CategoryID = bc.CategoryID " +
                     "ORDER BY b.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> blog = new HashMap<>();
                blog.put("blogId", rs.getInt("BlogID"));
                blog.put("title", rs.getString("Title"));
                blog.put("status", rs.getString("Status"));
                blog.put("createdAt", rs.getTimestamp("CreatedAt"));
                blog.put("authorName", rs.getString("AuthorName"));
                blog.put("categoryName", rs.getString("CategoryName"));
                recentBlogs.add(blog);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent blogs: " + e.getMessage());
        }
        
        return recentBlogs;
    }
    
    /**
     * Get recent wallet transactions
     * @param limit Number of transactions to retrieve
     * @return List of recent wallet transactions
     */
    public List<Map<String, Object>> getRecentWalletTransactions(int limit) {
        List<Map<String, Object>> recentTransactions = new ArrayList<>();
        String sql = "SELECT TOP(?) t.TransactionID, t.Amount, t.Type, t.Status, t.CreatedAt, " +
                     "a.FullName AS UserName " +
                     "FROM WalletTransaction t " +
                     "JOIN Account a ON t.UserID = a.UserID " +
                     "ORDER BY t.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> transaction = new HashMap<>();
                transaction.put("transactionId", rs.getInt("TransactionID"));
                transaction.put("amount", rs.getBigDecimal("Amount"));
                transaction.put("type", rs.getString("Type"));
                transaction.put("status", rs.getString("Status"));
                transaction.put("createdAt", rs.getTimestamp("CreatedAt"));
                transaction.put("userName", rs.getString("UserName"));
                recentTransactions.add(transaction);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent wallet transactions: " + e.getMessage());
        }
        
        return recentTransactions;
    }
    
    /**
     * Get growth percentages for dashboard metrics
     * @return Map containing growth percentages for profit, feedbacks, orders, and users
     */
    public Map<String, Integer> getGrowthPercentages() {
        Map<String, Integer> growthPercentages = new HashMap<>();
        
        // Calculate growth percentages by comparing current month to previous month
        try (Connection connection = new DBContext().getConnection()) {
            // Profit growth
            String profitSql = "SELECT " +
                              "(SELECT COALESCE(SUM(TotalAmount), 0) FROM [Order] WHERE PaymentStatus = 'Completed' " +
                              "AND MONTH(CreatedAt) = MONTH(GETDATE()) AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthProfit, " +
                              "(SELECT COALESCE(SUM(TotalAmount), 0) FROM [Order] WHERE PaymentStatus = 'Completed' " +
                              "AND MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                              "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthProfit";
            
            try (PreparedStatement ps = connection.prepareStatement(profitSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    BigDecimal currentMonthProfit = rs.getBigDecimal("CurrentMonthProfit");
                    BigDecimal previousMonthProfit = rs.getBigDecimal("PreviousMonthProfit");
                    
                    int profitGrowth = calculateGrowthPercentage(previousMonthProfit, currentMonthProfit);
                    growthPercentages.put("profitGrowth", profitGrowth);
                }
            }
            
            // Feedback growth
            String feedbackSql = "SELECT " +
                               "(SELECT COUNT(*) FROM Feedback WHERE MONTH(CreatedAt) = MONTH(GETDATE()) " +
                               "AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthFeedbacks, " +
                               "(SELECT COUNT(*) FROM Feedback WHERE MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                               "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthFeedbacks";
            
            try (PreparedStatement ps = connection.prepareStatement(feedbackSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int currentMonthFeedbacks = rs.getInt("CurrentMonthFeedbacks");
                    int previousMonthFeedbacks = rs.getInt("PreviousMonthFeedbacks");
                    
                    int feedbackGrowth = calculateGrowthPercentage(previousMonthFeedbacks, currentMonthFeedbacks);
                    growthPercentages.put("feedbackGrowth", feedbackGrowth);
                }
            }
            
            // Order growth
            String orderSql = "SELECT " +
                            "(SELECT COUNT(*) FROM [Order] WHERE MONTH(CreatedAt) = MONTH(GETDATE()) " +
                            "AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthOrders, " +
                            "(SELECT COUNT(*) FROM [Order] WHERE MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                            "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthOrders";
            
            try (PreparedStatement ps = connection.prepareStatement(orderSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int currentMonthOrders = rs.getInt("CurrentMonthOrders");
                    int previousMonthOrders = rs.getInt("PreviousMonthOrders");
                    
                    int orderGrowth = calculateGrowthPercentage(previousMonthOrders, currentMonthOrders);
                    growthPercentages.put("orderGrowth", orderGrowth);
                }
            }
            
            // User growth
            String userSql = "SELECT " +
                           "(SELECT COUNT(*) FROM Account WHERE MONTH(CreatedAt) = MONTH(GETDATE()) " +
                           "AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthUsers, " +
                           "(SELECT COUNT(*) FROM Account WHERE MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                           "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthUsers";
            
            try (PreparedStatement ps = connection.prepareStatement(userSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int currentMonthUsers = rs.getInt("CurrentMonthUsers");
                    int previousMonthUsers = rs.getInt("PreviousMonthUsers");
                    
                    int userGrowth = calculateGrowthPercentage(previousMonthUsers, currentMonthUsers);
                    growthPercentages.put("userGrowth", userGrowth);
                }
            }
            
            // Course growth
            String courseSql = "SELECT " +
                             "(SELECT COUNT(*) FROM Course WHERE Status = 'Public' AND MONTH(CreatedAt) = MONTH(GETDATE()) " +
                             "AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthCourses, " +
                             "(SELECT COUNT(*) FROM Course WHERE Status = 'Public' AND MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                             "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthCourses";
            
            try (PreparedStatement ps = connection.prepareStatement(courseSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int currentMonthCourses = rs.getInt("CurrentMonthCourses");
                    int previousMonthCourses = rs.getInt("PreviousMonthCourses");
                    
                    int courseGrowth = calculateGrowthPercentage(previousMonthCourses, currentMonthCourses);
                    growthPercentages.put("courseGrowth", courseGrowth);
                }
            }
            
            // Blog growth
            String blogSql = "SELECT " +
                           "(SELECT COUNT(*) FROM Blog WHERE Status = 'Public' AND MONTH(CreatedAt) = MONTH(GETDATE()) " +
                           "AND YEAR(CreatedAt) = YEAR(GETDATE())) AS CurrentMonthBlogs, " +
                           "(SELECT COUNT(*) FROM Blog WHERE Status = 'Public' AND MONTH(CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE())) " +
                           "AND YEAR(CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS PreviousMonthBlogs";
            
            try (PreparedStatement ps = connection.prepareStatement(blogSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int currentMonthBlogs = rs.getInt("CurrentMonthBlogs");
                    int previousMonthBlogs = rs.getInt("PreviousMonthBlogs");
                    
                    int blogGrowth = calculateGrowthPercentage(previousMonthBlogs, currentMonthBlogs);
                    growthPercentages.put("blogGrowth", blogGrowth);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error calculating growth percentages: " + e.getMessage());
            // Fallback to default values if there's an error
            growthPercentages.put("profitGrowth", 75);
            growthPercentages.put("feedbackGrowth", 80);
            growthPercentages.put("orderGrowth", 65);
            growthPercentages.put("userGrowth", 90);
            growthPercentages.put("courseGrowth", 70);
            growthPercentages.put("blogGrowth", 85);
        }
        
        return growthPercentages;
    }
    
    /**
     * Get total profit from all orders within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Total profit in dollars for the specified date range
     */
    public BigDecimal getTotalProfitByDateRange(String startDate, String endDate) {
        BigDecimal totalProfit = BigDecimal.ZERO;
        String sql = "SELECT SUM(TotalAmount) AS TotalProfit FROM [Order] WHERE PaymentStatus = 'Completed' " +
                     "AND CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalProfit = rs.getBigDecimal("TotalProfit");
                if (totalProfit == null) {
                    totalProfit = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting total profit by date range: " + e.getMessage());
        }
        
        return totalProfit;
    }
    
    /**
     * Get total number of feedbacks within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Number of feedbacks for the specified date range
     */
    public int getTotalFeedbacksByDateRange(String startDate, String endDate) {
        int totalFeedbacks = 0;
        String sql = "SELECT COUNT(*) AS TotalFeedbacks FROM Feedback " +
                     "WHERE CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalFeedbacks = rs.getInt("TotalFeedbacks");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total feedbacks by date range: " + e.getMessage());
        }
        
        return totalFeedbacks;
    }
    
    /**
     * Get total number of orders within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Number of orders for the specified date range
     */
    public int getTotalOrdersByDateRange(String startDate, String endDate) {
        int totalOrders = 0;
        String sql = "SELECT COUNT(*) AS TotalOrders FROM [Order] " +
                     "WHERE CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalOrders = rs.getInt("TotalOrders");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total orders by date range: " + e.getMessage());
        }
        
        return totalOrders;
    }
    
    /**
     * Get total number of users within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Number of users for the specified date range
     */
    public int getTotalUsersByDateRange(String startDate, String endDate) {
        int totalUsers = 0;
        String sql = "SELECT COUNT(*) AS TotalUsers FROM Account " +
                     "WHERE CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalUsers = rs.getInt("TotalUsers");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total users by date range: " + e.getMessage());
        }
        
        return totalUsers;
    }
    
    /**
     * Get total number of courses within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Number of courses for the specified date range
     */
    public int getTotalCoursesByDateRange(String startDate, String endDate) {
        int totalCourses = 0;
        String sql = "SELECT COUNT(*) AS TotalCourses FROM Course " +
                     "WHERE Status = 'Public' AND CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalCourses = rs.getInt("TotalCourses");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total courses by date range: " + e.getMessage());
        }
        
        return totalCourses;
    }
    
    /**
     * Get total number of blogs within a date range
     * @param startDate Start date in yyyy-MM-dd format
     * @param endDate End date in yyyy-MM-dd format
     * @return Number of blogs for the specified date range
     */
    public int getTotalBlogsByDateRange(String startDate, String endDate) {
        int totalBlogs = 0;
        String sql = "SELECT COUNT(*) AS TotalBlogs FROM Blog " +
                     "WHERE Status = 'Public' AND CreatedAt >= ? AND CreatedAt <= ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalBlogs = rs.getInt("TotalBlogs");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total blogs by date range: " + e.getMessage());
        }
        
        return totalBlogs;
    }
    
    /**
     * Get course status distribution
     * @return Map containing course status distribution data
     */
    public Map<String, Integer> getCourseStatusDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT Status, COUNT(*) AS Count FROM Course GROUP BY Status";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("Status");
                int count = rs.getInt("Count");
                distribution.put(status, count);
            }
        } catch (SQLException e) {
            System.out.println("Error getting course status distribution: " + e.getMessage());
        }
        
        return distribution;
    }

    /**
     * Get course status distribution for a specific expert
     * @param expertId The ID of the expert
     * @return Map containing course status distribution data
     */
    public Map<String, Integer> getCourseStatusDistributionByExpert(int expertId) {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT Status, COUNT(*) AS Count FROM Course WHERE ExpertID = ? GROUP BY Status";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("Status");
                int count = rs.getInt("Count");
                distribution.put(status, count);
            }
        } catch (SQLException e) {
            System.out.println("Error getting course status distribution by expert: " + e.getMessage());
        }
        
        return distribution;
    }
    
    /**
     * Get total number of students enrolled in an expert's courses
     * @param expertId The ID of the expert
     * @return Number of students
     */
    public int getTotalStudentsByExpert(int expertId) {
        int totalStudents = 0;
        String sql = "SELECT COUNT(DISTINCT r.UserID) AS TotalStudents " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalStudents = rs.getInt("TotalStudents");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total students by expert: " + e.getMessage());
        }
        
        return totalStudents;
    }
    
    /**
     * Get new students enrolled in an expert's courses within a date range
     * @param expertId The ID of the expert
     * @param startDate Start date
     * @param endDate End date
     * @return Number of new students
     */
    public int getNewStudentsByExpert(int expertId, Date startDate, Date endDate) {
        int newStudents = 0;
        String sql = "SELECT COUNT(DISTINCT r.UserID) AS NewStudents " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt BETWEEN ? AND ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ps.setTimestamp(2, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(3, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                newStudents = rs.getInt("NewStudents");
            }
        } catch (SQLException e) {
            System.out.println("Error getting new students by expert: " + e.getMessage());
        }
        
        return newStudents;
    }
    
    /**
     * Get total revenue for an expert
     * @param expertId The ID of the expert
     * @return Total revenue
     */
    public BigDecimal getTotalRevenueByExpert(int expertId) {
        BigDecimal totalRevenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(r.Price) AS TotalRevenue " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("TotalRevenue");
                if (totalRevenue == null) {
                    totalRevenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting total revenue by expert: " + e.getMessage());
        }
        
        return totalRevenue;
    }
    
    /**
     * Get revenue for an expert within a date range
     * @param expertId The ID of the expert
     * @param startDate Start date
     * @param endDate End date
     * @return Revenue in the period
     */
    public BigDecimal getRevenueByExpertInPeriod(int expertId, Date startDate, Date endDate) {
        BigDecimal periodRevenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(r.Price) AS PeriodRevenue " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt BETWEEN ? AND ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ps.setTimestamp(2, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(3, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                periodRevenue = rs.getBigDecimal("PeriodRevenue");
                if (periodRevenue == null) {
                    periodRevenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting period revenue by expert: " + e.getMessage());
        }
        
        return periodRevenue;
    }
    
    /**
     * Get monthly registration counts for an expert's courses
     * @param expertId The ID of the expert
     * @return Map of month to registration count
     */
    public Map<String, Integer> getMonthlyRegistrationCountsByExpert(int expertId) {
        Map<String, Integer> monthlyRegistrations = new HashMap<>();
        String sql = "SELECT FORMAT(r.CreatedAt, 'yyyy-MM') as Month, COUNT(*) AS RegistrationCount " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(r.CreatedAt, 'yyyy-MM') " +
                     "ORDER BY Month";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                int count = rs.getInt("RegistrationCount");
                monthlyRegistrations.put(month, count);
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly registration counts by expert: " + e.getMessage());
        }
        
        return monthlyRegistrations;
    }
    
    /**
     * Get monthly revenue for an expert
     * @param expertId The ID of the expert
     * @return Map of month to revenue
     */
    public Map<String, Double> getMonthlyRevenueByExpert(int expertId) {
        Map<String, Double> monthlyRevenue = new HashMap<>();
        String sql = "SELECT FORMAT(r.CreatedAt, 'yyyy-MM') as Month, SUM(CAST(r.Price AS FLOAT)) as Revenue " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(r.CreatedAt, 'yyyy-MM') " +
                     "ORDER BY Month";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                double revenue = rs.getDouble("Revenue");
                monthlyRevenue.put(month, revenue);
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly revenue by expert: " + e.getMessage());
        }
        
        return monthlyRevenue;
    }
    
    /**
     * Get recent registrations for an expert's courses
     * @param expertId The ID of the expert
     * @param limit Number of registrations to retrieve
     * @return List of recent registrations
     */
    public List<Map<String, Object>> getRecentRegistrationsByExpert(int expertId, int limit) {
        List<Map<String, Object>> recentRegistrations = new ArrayList<>();
        String sql = "SELECT TOP(?) r.RegistrationID, r.UserID, r.CourseID, r.Status, r.Progress, r.CreatedAt, " +
                     "a.FullName AS StudentName, c.Title AS CourseTitle " +
                     "FROM Registration r " +
                     "JOIN Account a ON r.UserID = a.UserID " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? " +
                     "ORDER BY r.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ps.setInt(2, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> registration = new HashMap<>();
                registration.put("registrationId", rs.getInt("RegistrationID"));
                registration.put("userId", rs.getInt("UserID"));
                registration.put("courseId", rs.getInt("CourseID"));
                registration.put("status", rs.getString("Status"));
                registration.put("progress", rs.getInt("Progress"));
                registration.put("createdAt", rs.getTimestamp("CreatedAt"));
                registration.put("studentName", rs.getString("StudentName"));
                registration.put("courseTitle", rs.getString("CourseTitle"));
                recentRegistrations.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent registrations by expert: " + e.getMessage());
        }
        
        return recentRegistrations;
    }
    
    /**
     * Get total registrations by status for an expert's courses
     * @param expertId The ID of the expert
     * @param status The registration status
     * @return Number of registrations with the specified status
     */
    public int getTotalRegistrationsByExpertAndStatus(int expertId, String status) {
        int totalRegistrations = 0;
        String sql = "SELECT COUNT(*) AS TotalRegistrations " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.Status = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalRegistrations = rs.getInt("TotalRegistrations");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total registrations by expert and status: " + e.getMessage());
        }
        
        return totalRegistrations;
    }
    
    /**
     * Get financial summary for the dashboard
     * @return Map containing financial summary data
     */
    public Map<String, Object> getFinancialSummary() {
        Map<String, Object> financialSummary = new HashMap<>();
        
        // Get total admin wallet balance
        String adminWalletSql = "SELECT SUM(Balance) AS TotalBalance FROM AdminWallet";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(adminWalletSql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal totalBalance = rs.getBigDecimal("TotalBalance");
                if (totalBalance == null) {
                    totalBalance = BigDecimal.ZERO;
                }
                financialSummary.put("adminWalletBalance", totalBalance);
            } else {
                financialSummary.put("adminWalletBalance", BigDecimal.ZERO);
            }
        } catch (SQLException e) {
            System.out.println("Error getting admin wallet balance: " + e.getMessage());
            financialSummary.put("adminWalletBalance", BigDecimal.ZERO);
        }
        
        // Get total expert wallet balance
        String expertWalletSql = "SELECT SUM(WalletBalance) AS TotalBalance FROM ExpertBankInfo";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(expertWalletSql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal totalBalance = rs.getBigDecimal("TotalBalance");
                if (totalBalance == null) {
                    totalBalance = BigDecimal.ZERO;
                }
                financialSummary.put("expertWalletBalance", totalBalance);
            } else {
                financialSummary.put("expertWalletBalance", BigDecimal.ZERO);
            }
        } catch (SQLException e) {
            System.out.println("Error getting expert wallet balance: " + e.getMessage());
            financialSummary.put("expertWalletBalance", BigDecimal.ZERO);
        }
        
        // Get total pending payouts
        String pendingPayoutsSql = "SELECT SUM(Amount) AS TotalPending FROM ExpertPayout WHERE Status = 'pending'";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(pendingPayoutsSql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal totalPending = rs.getBigDecimal("TotalPending");
                if (totalPending == null) {
                    totalPending = BigDecimal.ZERO;
                }
                financialSummary.put("pendingPayouts", totalPending);
            } else {
                financialSummary.put("pendingPayouts", BigDecimal.ZERO);
            }
        } catch (SQLException e) {
            System.out.println("Error getting pending payouts: " + e.getMessage());
            financialSummary.put("pendingPayouts", BigDecimal.ZERO);
        }
        
        return financialSummary;
    }
    
    /**
     * Get monthly revenue for the past 12 months
     * @return Map of month to revenue
     */
    public Map<String, BigDecimal> getMonthlyRevenue() {
        Map<String, BigDecimal> monthlyRevenue = new LinkedHashMap<>(); // Use LinkedHashMap to maintain order
        
        // First, create entries for the last 12 months to ensure chronological order
        Calendar cal = Calendar.getInstance();
        for (int i = 11; i >= 0; i--) {
            cal.setTime(new Date()); // Reset to current date
            cal.add(Calendar.MONTH, -i);
            String monthKey = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
            monthlyRevenue.put(monthKey, BigDecimal.ZERO);
        }
        
        // Now query the database for actual revenue data
        String sql = "SELECT FORMAT(o.CreatedAt, 'yyyy-MM') as Month, SUM(o.TotalAmount) as Revenue " +
                     "FROM [Order] o " +
                     "WHERE o.PaymentStatus = 'Completed' AND o.CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(o.CreatedAt, 'yyyy-MM')";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                if (revenue == null) {
                    revenue = BigDecimal.ZERO;
                }
                // Update the existing entry
                if (monthlyRevenue.containsKey(month)) {
                    monthlyRevenue.put(month, revenue);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly revenue: " + e.getMessage());
        }
        
        return monthlyRevenue;
    }
    
    /**
     * Get monthly registration counts for all courses in the past 12 months
     * @return Map of month to registration count
     */
    public Map<String, Integer> getMonthlyRegistrationCounts() {
        Map<String, Integer> monthlyRegistrations = new LinkedHashMap<>(); // Use LinkedHashMap to maintain order
        
        // First, create entries for the last 12 months to ensure chronological order
        Calendar cal = Calendar.getInstance();
        for (int i = 11; i >= 0; i--) {
            cal.setTime(new Date()); // Reset to current date
            cal.add(Calendar.MONTH, -i);
            String monthKey = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
            monthlyRegistrations.put(monthKey, 0);
        }
        
        // Now query the database for actual registration data
        String sql = "SELECT FORMAT(r.CreatedAt, 'yyyy-MM') as Month, COUNT(*) AS RegistrationCount " +
                     "FROM Registration r " +
                     "WHERE r.CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(r.CreatedAt, 'yyyy-MM')";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                int count = rs.getInt("RegistrationCount");
                // Update the existing entry
                if (monthlyRegistrations.containsKey(month)) {
                    monthlyRegistrations.put(month, count);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly registration counts: " + e.getMessage());
        }
        
        return monthlyRegistrations;
    }
    
    /**
     * Helper method to calculate growth percentage
     * @param previous Previous value
     * @param current Current value
     * @return Growth percentage
     */
    private int calculateGrowthPercentage(BigDecimal previous, BigDecimal current) {
        if (previous == null || previous.compareTo(BigDecimal.ZERO) == 0) {
            return current.compareTo(BigDecimal.ZERO) > 0 ? 100 : 0;
        }
        
        return previous.compareTo(BigDecimal.ZERO) == 0 ? 
               100 : 
               current.subtract(previous).multiply(new BigDecimal(100)).divide(previous, RoundingMode.HALF_UP).intValue();
    }
    
    /**
     * Helper method to calculate growth percentage
     * @param previous Previous value
     * @param current Current value
     * @return Growth percentage
     */
    private int calculateGrowthPercentage(int previous, int current) {
        if (previous == 0) {
            return current > 0 ? 100 : 0;
        }
        
        return (int) Math.round(((double) (current - previous) / previous) * 100);
    }
}
