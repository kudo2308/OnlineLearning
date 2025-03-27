/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import model.Course;

/**
 *
 * @author ASUS
 */
public class CartItemDAO extends DBContext {

    public List<CartItem> getItemsByCartId(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT CourseID FROM Cart c \n"
                + "JOIN CartDetail cd ON c.CartID = cd.CartID\n"
                + "WHERE c.AccountID = ?";

        List<Integer> courseIds = new ArrayList<>();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                courseIds.add(rs.getInt("CourseID"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        CourseDAO courseDAO = new CourseDAO();
        for (int i = 0; i < courseIds.size(); i++) {
            Course course = courseDAO.getCourseById(courseIds.get(i));
            CartItem item = new CartItem();
            item.setCourse(course);
            cartItems.add(item);
        }

        return cartItems;
    }

    public int countItemsByCartId(int userId) {
        int totalCourse = 0;
        String sql = "SELECT COUNT(cd.CourseID) as totalOfCourse FROM Cart c \n"
                + "JOIN CartDetail cd ON c.CartID = cd.CartID\n"
                + "WHERE c.AccountID = ?";

        List<Integer> courseIds = new ArrayList<>();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalCourse = rs.getInt("totalOfCourse");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalCourse;
    }

    public void removePurchasedCoursesFromCart(int userId) {
        String sql = "DELETE FROM CartDetail "
                + "WHERE CourseID IN (SELECT CourseID FROM Registration WHERE UserID = ?) "
                + "AND CartID IN (SELECT CartID FROM Cart WHERE AccountID = ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            int rowsDeleted = stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        CartItemDAO cartDAO = new CartItemDAO();
        cartDAO.removePurchasedCoursesFromCart(2);
    }
}
