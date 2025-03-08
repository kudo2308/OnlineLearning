/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Course;

/**
 *
 * @author ASUS
 */
public class CartDAO extends DBContext {

    public Cart get(int userId) {
        String sql = "SELECT * FROM Cart WHERE AccountID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("CartID");

                CartItemDAO cartItemDAO = new CartItemDAO();
                List<CartItem> cartItems = cartItemDAO.getItemsByCartId(userId);

                return new Cart(id, cartItems);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void add(Course course, Cart cart) {
        String sql = "insert CartDetail (CartID, CourseID) values (?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cart.getId());
            ps.setInt(2, course.getCourseID());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(Course course, Cart cart) {
        String sql = "delete CartDetail where CourseID = ? and CartID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, course.getCourseID());
            ps.setInt(2, cart.getId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteAllItems(int cartId) {
        String sql = "DELETE CartDetail WHERE CartID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public void create(int userId) {
        String sql = "INSERT Cart VALUES (?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();

            System.out.println("Cart created successfully for userId: " + userId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        CartDAO cart = new CartDAO();
        CourseDAO course = new CourseDAO();
        cart.add(course.getCourseById(2), cart.get(2));
    }
}
