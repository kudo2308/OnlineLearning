package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Order;

public class OrderDAO extends DBContext {
    
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    // Get all orders for a specific account with pagination
    public List<Order> getOrdersByAccountId(int accountId, int offset, int limit) throws SQLException {
        List<Order> orderList = new ArrayList<>();
        
        try {
            String sql = "SELECT * FROM [Order] WHERE AccountID = ? ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setAccountID(rs.getInt("AccountID"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
                order.setPaymentStatus(rs.getString("PaymentStatus"));
                order.setVnpayTransactionID(rs.getString("VNPayTransactionID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                order.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                orderList.add(order);
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching orders: " + e.getMessage());
        }
        
        return orderList;
    }
    
    // Get a specific order by ID
    public Order getOrderById(int orderId) throws SQLException {
        Order order = null;
        
        try {
            String sql = "SELECT * FROM [Order] WHERE OrderID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setAccountID(rs.getInt("AccountID"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
                order.setPaymentStatus(rs.getString("PaymentStatus"));
                order.setVnpayTransactionID(rs.getString("VNPayTransactionID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                order.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching order: " + e.getMessage());
        }
        return order;
    }
    
    // Count total orders for a specific account (for pagination)
    public int countOrdersByAccountId(int accountId) throws SQLException {
        int count = 0;
        
        try {
            String sql = "SELECT COUNT(*) FROM [Order] WHERE AccountID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new SQLException("Error counting orders: " + e.getMessage());
        }
        
        return count;
    }
    
    // Update order payment status
    public boolean updateOrderPaymentStatus(int orderId, String paymentStatus) throws SQLException {
        boolean success = false;
        
        try {
            String sql = "UPDATE [Order] SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE OrderID = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            
            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            throw new SQLException("Error updating order payment status: " + e.getMessage());
        }
        
        return success;
    }
    
    // Create new order
    public int createOrder(Order order) throws SQLException {
        int orderId = -1;
        
        try {
            String sql = "INSERT INTO [Order] (AccountID, TotalAmount, PaymentMethod, PaymentStatus, VNPayTransactionID) " +
                         "VALUES (?, ?, ?, ?, ?); SELECT SCOPE_IDENTITY()";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, order.getAccountID());
            ps.setBigDecimal(2, order.getTotalAmount());
            ps.setString(3, order.getPaymentMethod());
            ps.setString(4, order.getPaymentStatus());
            ps.setString(5, order.getVnpayTransactionID());
            
            rs = ps.executeQuery();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new SQLException("Error creating order: " + e.getMessage());
        }
        
        return orderId;
    }
    
    // Get orders by date range
    public List<Order> getOrdersByDateRange(int accountId, String startDate, String endDate) throws SQLException {
        List<Order> orderList = new ArrayList<>();
        
        try {
            String sql = "SELECT * FROM [Order] WHERE AccountID = ? AND CreatedAt >= ? AND CreatedAt <= ? ORDER BY CreatedAt DESC";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setString(2, startDate);
            ps.setString(3, endDate);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setAccountID(rs.getInt("AccountID"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
                order.setPaymentStatus(rs.getString("PaymentStatus"));
                order.setVnpayTransactionID(rs.getString("VNPayTransactionID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                order.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                orderList.add(order);
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching orders by date range: " + e.getMessage());
        }
        
        return orderList;
    }
    
    // Close database resources
}