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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Category;


public class CategoryDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Category> categories;

    public CategoryDAO() {
        categories = new ArrayList<>();
    }
    
    public static void main(String[] args) {
        CategoryDAO courseDAO = new CategoryDAO();

        List<Category> l = courseDAO.findALl();

        for (Category course : l) {
            System.out.println(course);
        }

    }

    public List<Category> findALl() {
        String sql = "select * from Category";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {

                int categoryId = rs.getInt("CategoryID");
                String name = rs.getString("Name");
                String description = rs.getString("Description");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");

                Category category = new Category(categoryId, name, description, createdAt);

                categories.add(category);

            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return categories;
    }
}
