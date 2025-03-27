package DAO;

import DBContext.DBContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import model.Registration;

/**
 *
 * @author VICTUS
 */
public class PaymentDAO extends DBContext {

    public Order createOrder(int accountId, BigDecimal totalAmount) {
        String sql = "INSERT INTO [Order] (AccountID, TotalAmount, PaymentMethod, PaymentStatus, VNPayTransactionID, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE()); SELECT SCOPE_IDENTITY() AS orderId;";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.setBigDecimal(2, totalAmount);
            st.setString(3, "VNPay");
            st.setString(4, "pending");
            st.setString(5, null);

            boolean hasResultSet = st.execute();
            if (hasResultSet) {
                try (ResultSet rs = st.getResultSet()) {
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
            e.printStackTrace();
        }
        return null;
    }

    // Hàm cập nhật Order, trả về true nếu cập nhật thành công
    public boolean updateOrder(int orderId, String paymentStatus, String vnpayTransactionId) {
        String sql = "UPDATE [Order] SET PaymentStatus = ?, VNPayTransactionID = ?, UpdatedAt = GETDATE() "
                + "WHERE OrderID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, paymentStatus);
            st.setString(2, vnpayTransactionId);
            st.setInt(3, orderId);

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

    public int getMaxOrderId() {
        String sql = "SELECT MAX(OrderID) AS maxOrderId FROM [Order]";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("maxOrderId");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
        }
        return -1;
    }
//    

    public boolean createRegistration(int userId, int courseId, BigDecimal price) {
        String sql = "INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), ?, GETDATE(), GETDATE())";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, courseId);
            st.setBigDecimal(3, price);
            st.setString(4, "pending");
            st.setInt(5, 0);
            st.setTimestamp(6, null);

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
        }
        return false;
    }

    public List<Registration> getRegistrationsByCourseID(int courseID) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT * FROM Registration WHERE CourseID = ? AND Status = 'active'";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setInt(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistration(rs);
                    registrations.add(registration);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return registrations;
    }
    
    
     public List<Registration> getRegistrationsByCourse(int courseID) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT * FROM Registration WHERE CourseID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setInt(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistration(rs);
                    registrations.add(registration);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return registrations;
    }

    /**
     * Get all registrations for a specific user
     *
     * @param userID User ID
     * @return List of registrations
     */
    public List<Registration> getRegistrationsByUserID(int userID) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT * FROM Registration WHERE UserID = ? AND Status != 'cancelled'";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setInt(1, userID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistration(rs);
                    registrations.add(registration);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return registrations;
    }

    public List<String> getOrderNamesByOrderId(int orderId) {
        List<String> orderNames = new ArrayList<>();
        String sql = "SELECT c.Title "
                + "FROM OrderItem oi "
                + "JOIN Course c ON oi.CourseID = c.CourseID "
                + "WHERE oi.OrderID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    String courseName = rs.getString("Title");
                    orderNames.add(courseName);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
        }

        return orderNames;
    }

    public List<OrderItem> getCourseItem(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT OrderItemID, OrderID, CourseID, ExpertID, OriginalPrice, CommissionRate, FinalAmount, CreatedAt "
                + "FROM OrderItem "
                + "WHERE OrderID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderItemId(rs.getInt("OrderItemID"));
                    orderItem.setOrderId(rs.getInt("OrderID"));
                    orderItem.setCourseId(rs.getInt("CourseID"));
                    orderItem.setExpertId(rs.getInt("ExpertID"));
                    orderItem.setOriginalPrice(rs.getBigDecimal("OriginalPrice"));
                    orderItem.setCommissionRate(rs.getBigDecimal("CommissionRate"));
                    orderItem.setFinalAmount(rs.getBigDecimal("FinalAmount"));
                    orderItem.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    orderItems.add(orderItem);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
        }

        return orderItems;
    }

    public List<Integer> getOrderItemExpertId(int orderId) {
        List<Integer> expertId = new ArrayList<>();
        String sql = "SELECT c.ExpertID "
                + "FROM OrderItem oi "
                + "JOIN Course c ON oi.CourseID = c.CourseID "
                + "WHERE oi.OrderID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int ExpertId = rs.getInt("ExpertID");
                    expertId.add(ExpertId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
        }

        return expertId;
    }

    public List<BigDecimal> getMoneyPayExpert(int orderId) {
        List<BigDecimal> moneyPay = new ArrayList<>();
        String sql = "SELECT oi.FinalAmount "
                + "FROM OrderItem oi "
                + "JOIN Course c ON oi.CourseID = c.CourseID "
                + "WHERE oi.OrderID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    BigDecimal a = rs.getBigDecimal("FinalAmount");
                    moneyPay.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
        }

        return moneyPay;
    }

    public boolean hasRegisteredBankAccount(int expertId) {
        String sql = "SELECT COUNT(*) FROM ExpertBankInfo WHERE ExpertID = ? AND BankAccountNumber IS NOT NULL AND BankName IS NOT NULL";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
        }

        return false;
    }

    private Registration mapRegistration(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        registration.setRegistrationID(rs.getInt("RegistrationID"));
        registration.setUserID(rs.getInt("UserID"));
        registration.setCourseID(rs.getInt("CourseID"));
        registration.setPrice(rs.getDouble("Price"));
        registration.setStatus(rs.getString("Status"));
        registration.setProgress(rs.getInt("Progress"));
        registration.setValidFrom(rs.getTimestamp("ValidFrom"));
        registration.setValidTo(rs.getTimestamp("ValidTo"));
        registration.setCreatedAt(rs.getTimestamp("CreatedAt"));
        registration.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

        return registration;
    }

}
