package DAO;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import DBContext.DBContext;
import java.security.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CategoryDAO extends DBContext {

    public List<Category> getAll() {
        List<Category> listFound = new ArrayList<>();
        String sql = "Select *\n"
                + "From Category";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("CategoryID");
                String name = rs.getString("Name");
                String des = rs.getString("Description");
                 java.sql.Timestamp date = rs.getTimestamp("CreatedAt");
                Category categories = new Category(id, name, des, date);

                listFound.add(categories);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return listFound;
    }
    
    public static void main(String[] args) {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAll();
        for (Category category : categories) {
            System.out.println(category.getName() + category.getDescription() + category.getCreatedAt());
        }
    }
}
