package DAO;

import DBContext.DBContext;
import java.beans.Statement;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Order;

/**
 *
 * @author VICTUS
 */
public class PaymentDAO extends DBContext {

    public Order createOrder(int accountId, BigDecimal totalAmount) {
        String sql = "INSERT INTO [Order] (AccountID, TotalAmount, PaymentMethod, PaymentStatus, VNPayTransactionID, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql)){           
            st.setInt(1, accountId);
            st.setBigDecimal(2, totalAmount);
            st.setString(3, "VNPay");
            st.setString(4, "pending");
            st.setString(5, null);

            int rowsInserted = st.executeUpdate();
            if (rowsInserted > 0) {
                // Lấy orderId bằng cách sử dụng SCOPE_IDENTITY()
                String identitySql = "SELECT SCOPE_IDENTITY() AS orderId";
                PreparedStatement ps = connection.prepareStatement(identitySql);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int orderId = rs.getInt("orderId");
                        Order order = new Order();
                        order.setOrderID(orderId);
                        order.setAccountID(accountId);
                        order.setTotalAmount(totalAmount);
                        order.setPaymentMethod("VNPay");
                        order.setPaymentStatus("pending");
                        order.setVnpayTransactionID(null);
                        return order;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
        }
        return null;
    }

    // Hàm cập nhật Order, trả về true nếu cập nhật thành công
    public boolean updateOrder(int orderId, int accountId, BigDecimal totalAmount, String paymentMethod, String paymentStatus, String vnpayTransactionId) {
        String sql = "UPDATE [Order] SET AccountID = ?, TotalAmount = ?, PaymentMethod = ?, PaymentStatus = ?, VNPayTransactionID = ?, UpdatedAt = GETDATE() "
                + "WHERE OrderID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, accountId);
            st.setBigDecimal(2, totalAmount);
            st.setString(3, paymentMethod);
            st.setString(4, paymentStatus);
            st.setString(5, vnpayTransactionId);
            st.setInt(6, orderId);

            int rowsUpdated = st.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.getMessage(); // Log lỗi
        }
        return false;
    }

    public boolean createOrderItem(int orderId, int courseId, int expertId, BigDecimal originalPrice) {
        String sql = "INSERT INTO OrderItem (OrderID, CourseID, ExpertID, OriginalPrice, CommissionRate, FinalAmount, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            st.setInt(2, courseId);
            st.setInt(3, expertId);
            st.setBigDecimal(4, originalPrice);
            st.setBigDecimal(5, BigDecimal.valueOf(0.2));
            st.setBigDecimal(6, originalPrice.multiply(BigDecimal.valueOf(0.8)));

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
        }
        return false;
    }
}
