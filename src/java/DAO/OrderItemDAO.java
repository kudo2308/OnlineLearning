package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.OrderItem;

public class OrderItemDAO extends DBContext {

    private PreparedStatement ps = null;
    private ResultSet rs = null;

    // Get all order items for a specific order
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> orderItems = new ArrayList<>();

        try {
            String sql = "SELECT oi.*, c.Title as CourseTitle FROM OrderItem oi "
                    + "JOIN Course c ON oi.CourseID = c.CourseID "
                    + "WHERE oi.OrderID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("OrderItemID"));
                item.setOrderId(rs.getInt("OrderID"));
                item.setCourseId(rs.getInt("CourseID"));
                item.setExpertId(rs.getInt("ExpertID"));
                item.setOriginalPrice(rs.getBigDecimal("OriginalPrice"));
                item.setCommissionRate(rs.getBigDecimal("CommissionRate"));
                item.setFinalAmount(rs.getBigDecimal("FinalAmount"));
                item.setCreatedAt(rs.getTimestamp("CreatedAt"));
                item.setCourseTitle(rs.getString("CourseTitle")); // Set the course title
                orderItems.add(item);
            }
        } catch (SQLException e) {
            throw new SQLException("Error getting order items: " + e.getMessage());
        } 

        return orderItems;
    }

    // Create new order item
    public boolean createOrderItem(OrderItem item) throws SQLException {
        boolean success = false;

        try {
            String sql = "INSERT INTO OrderItem (OrderID, CourseID, ExpertID, OriginalPrice, CommissionRate, FinalAmount) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getCourseId());
            ps.setInt(3, item.getExpertId());
            ps.setBigDecimal(4, item.getOriginalPrice());
            ps.setBigDecimal(5, item.getCommissionRate());
            ps.setBigDecimal(6, item.getFinalAmount());

            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            throw new SQLException("Error creating order item: " + e.getMessage());
        } 
        return success;
    }

    // Get order items with course details
    public List<OrderItem> getOrderItemsWithCourseDetails(int orderId) throws SQLException {
        List<OrderItem> orderItems = new ArrayList<>();
        try {
            String sql = "SELECT oi.*, c.Title as CourseTitle, c.ImageUrl, "
                    + "a.FullName as ExpertName "
                    + "FROM OrderItem oi "
                    + "JOIN Course c ON oi.CourseID = c.CourseID "
                    + "JOIN Account a ON oi.ExpertID = a.UserID "
                    + "WHERE oi.OrderID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("OrderItemID"));
                item.setOrderId(rs.getInt("OrderID"));
                item.setCourseId(rs.getInt("CourseID"));
                item.setExpertId(rs.getInt("ExpertID"));
                item.setOriginalPrice(rs.getBigDecimal("OriginalPrice"));
                item.setCommissionRate(rs.getBigDecimal("CommissionRate"));
                item.setFinalAmount(rs.getBigDecimal("FinalAmount"));
                item.setCreatedAt(rs.getTimestamp("CreatedAt"));
                item.setCourseTitle(rs.getString("CourseTitle"));
                item.setImageUrl(rs.getString("ImageUrl"));
                item.setExpertName(rs.getString("ExpertName"));
                orderItems.add(item);
            }
        } catch (SQLException e) {
            throw new SQLException("Error getting order items with details: " + e.getMessage());
        }
        return orderItems;
    }

    // Get course purchases by user
    public List<OrderItem> getUserPurchasedCourses(int userId) throws SQLException {
        List<OrderItem> purchasedCourses = new ArrayList<>();

        try {
            String sql = "SELECT oi.*, c.Title as CourseTitle, c.ImageUrl, o.PaymentStatus "
                    + "FROM OrderItem oi "
                    + "JOIN Course c ON oi.CourseID = c.CourseID "
                    + "JOIN [Order] o ON oi.OrderID = o.OrderID "
                    + "WHERE o.AccountID = ? AND o.PaymentStatus = 'paid' "
                    + "ORDER BY oi.CreatedAt DESC";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("OrderItemID"));
                item.setOrderId(rs.getInt("OrderID"));
                item.setCourseId(rs.getInt("CourseID"));
                item.setExpertId(rs.getInt("ExpertID"));
                item.setOriginalPrice(rs.getBigDecimal("OriginalPrice"));
                item.setCommissionRate(rs.getBigDecimal("CommissionRate"));
                item.setFinalAmount(rs.getBigDecimal("FinalAmount"));
                item.setCreatedAt(rs.getTimestamp("CreatedAt"));
                item.setCourseTitle(rs.getString("CourseTitle"));
                item.setImageUrl(rs.getString("ImageUrl"));
                purchasedCourses.add(item);
            }
        } catch (SQLException e) {
            throw new SQLException("Error getting user purchased courses: " + e.getMessage());
        }

        return purchasedCourses;
    }

    // Close database resources

}