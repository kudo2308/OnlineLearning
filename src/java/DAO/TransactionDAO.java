package DAO;

import DBContext.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Transaction;
import model.User;

public class TransactionDAO {
    private Connection connection;
    
    public TransactionDAO() {
        try {
            connection = new DBContext().getConnection();
        } catch (Exception e) {
            System.out.println("Error connecting to database: " + e.getMessage());
        }
    }
    
    public double getTotalRevenue() {
        String sql = "SELECT SUM(price) FROM Registration";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    public double getRevenueInPeriod(Date startDate, Date endDate) {
        String sql = "SELECT SUM(price) FROM Registration WHERE createdAt BETWEEN ? AND ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> monthlyData = new HashMap<>();
        String sql = "SELECT FORMAT(createdAt, 'yyyy-MM') as month, SUM(CAST(price AS FLOAT)) as revenue "
                + "FROM Registration "
                + "WHERE createdAt >= DATEADD(MONTH, -11, GETDATE()) "
                + "GROUP BY FORMAT(createdAt, 'yyyy-MM') "
                + "ORDER BY month";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String month = rs.getString("month");
                double revenue = rs.getDouble("revenue");
                monthlyData.put(month, revenue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return monthlyData;
    }
    
    public List<Transaction> getRecentTransactions(int limit) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, u.fullName, u.email FROM Transactions t "
                + "JOIN [User] u ON t.userId = u.userId "
                + "ORDER BY t.createdAt DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transactionId"));
                transaction.setOrderId(rs.getInt("orderId") == 0 ? null : rs.getInt("orderId"));
                transaction.setExpertId(rs.getInt("expertId") == 0 ? null : rs.getInt("expertId"));
                transaction.setAmount(rs.getBigDecimal("amount"));
                transaction.setTransactionType(rs.getString("transactionType"));
                transaction.setDescription(rs.getString("description"));
                transaction.setStatus(rs.getString("status"));
                transaction.setCreatedAt(rs.getTimestamp("createdAt"));
                
                // Add user details
                User user = new User();
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                transaction.setUser(user);
                
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
}
