/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Course;
import model.Feedback;
import model.Role;

/**
 *
 * @author ASUS
 */
public class FeedbackDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Feedback> feedbacks;

    public FeedbackDAO() {
        feedbacks = new ArrayList<>();
    }

    public List<Feedback> getFeedbacksByCourseID(int courseId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.FeedbackID, f.UserID, f.CourseID, f.[Content], f.Rating, f.Status, f.CreatedAt, a.Image, a.FullName, r.RoleName "
                + "FROM Feedback f join Account a on f.UserID = a.UserID join Role r on a.RoleID = r.RoleID WHERE CourseID = ?";

        try (Connection connection = new DBContext().getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackID(rs.getInt("FeedbackID"));
                fb.setUserID(rs.getInt("UserID"));
                fb.setCourseID(rs.getInt("CourseID"));
                fb.setContent(rs.getString("Content"));
                fb.setRating(rs.getInt("Rating"));
                fb.setStatus(rs.getBoolean("Status"));
                fb.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Role roleName = new Role();
                roleName.setRoleName(rs.getString("RoleName"));
                fb.setRole(roleName);

                Account user = new Account();
                user.setFullName(rs.getString("FullName"));
                user.setImage(rs.getString("Image"));
                fb.setUser(user);
                feedbacks.add(fb);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    public void insertFeedback(int userId, int courseId, String content, int rating) {
        String sql = "INSERT INTO Feedback (UserID, CourseID, [Content], Rating, Status, CreatedAt) "
                + "VALUES (?, ?, ?, ?, 1, GETDATE())";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.setString(3, content);
            ps.setInt(4, rating);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map<Integer, Integer> getRatingDistribution(int courseId) {
        Map<Integer, Integer> ratingMap = new HashMap<>();

        // Khởi tạo mặc định từ 1 đến 5 sao là 0
        for (int i = 1; i <= 5; i++) {
            ratingMap.put(i, 0);
        }

        String sql = "SELECT Rating, COUNT(*) as Count "
                + "FROM Feedback "
                + "WHERE CourseID = ? "
                + "GROUP BY Rating";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int rating = rs.getInt("Rating");
                int count = rs.getInt("Count");
                ratingMap.put(rating, count); // Ghi đè số lượng thực tế
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ratingMap;
    }

    public static void main(String[] args) {
        FeedbackDAO feedDAO = new FeedbackDAO();
        List<Feedback> feed = feedDAO.getFeedbacksByCourseID(3);
        for (Feedback feedback : feed) {
            System.out.println(feedback.toString());
        }
    }
}
