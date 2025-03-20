package DAO;

import DBContext.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.Notification;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author VICTUS
 */
public class NotificationDAO extends DBContext {

    public List<Notification> getUnreadNotifications(int userID) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserID = ? AND IsRead = 0 ORDER BY CreatedAt DESC";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                notifications.add(mapNotification(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    public List<Notification> getAllNotifications(int userID) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserID = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                notifications.add(mapNotification(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    public int getUnreadCount(int userID) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notification WHERE UserID = ? AND IsRead = 0";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public void markAsRead(int notificationID) {
        String sql = "UPDATE Notification SET IsRead = 1 WHERE NotificationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, notificationID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void markAllAsRead(int userID) {
        String sql = "UPDATE Notification SET IsRead = 1 WHERE UserID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean insertNotification(Notification notification) {
        String sql = "INSERT INTO Notification (UserID, Title, Content, Type, RelatedID, IsRead, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try ( PreparedStatement pstmt = connection.prepareStatement(sql)) {
            
            pstmt.setInt(1, notification.getUserID());
            pstmt.setString(2, notification.getTitle());
            pstmt.setString(3, notification.getContent());
            pstmt.setString(4, notification.getType());
            
            if (notification.getRelatedID() != null) {
                pstmt.setInt(5, notification.getRelatedID());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.setBoolean(6, notification.isIsRead());
            pstmt.setTimestamp(7, notification.getCreatedAt());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    

    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationID(rs.getInt("NotificationID"));
        notification.setUserID(rs.getInt("UserID"));
        notification.setTitle(rs.getString("Title"));
        notification.setContent(rs.getString("Content"));
        notification.setType(rs.getString("Type"));
        notification.setRelatedID(rs.getInt("RelatedID"));
        notification.setIsRead(rs.getBoolean("IsRead"));
        notification.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return notification;
    }
}
