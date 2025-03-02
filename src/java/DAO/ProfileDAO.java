/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import model.Account;

/**
 *
 * @author VICTUS
 */
public class ProfileDAO extends DBContext{
    public boolean updateUserProfile(Account account) {
        String sql = "UPDATE Account SET FullName = ?, Description = ?, Phone = ?, Address = ?, GenderID = ?, DOB = ?, UpdatedAt = GETDATE() WHERE UserID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, account.getFullName());
            stmt.setString(2, account.getDescription());
            stmt.setString(3, account.getPhone());
            stmt.setString(4, account.getAddress());
            stmt.setString(5, account.getGenderID());
            stmt.setDate(6, new java.sql.Date(account.getDob().getTime()));
            stmt.setInt(7, account.getUserID());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }
    public void updateUserImage(int userId, String imagePath) {
        String sql = "UPDATE Account SET Image = ? WHERE UserId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, imagePath);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (Exception e) {
               e.getMessage();
        }
    }
    
    public void updateUserRole(int userId, int Role) {
        String sql = "UPDATE Account SET RoleID = ? WHERE UserId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Role);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (Exception e) {
               e.getMessage();
        }
    }
    
     public static void main(String[] args) {
        ProfileDAO dao = new ProfileDAO();
        dao.updateUserRole(6, 2);
    }
    
}
