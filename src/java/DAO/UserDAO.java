/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    // Lấy danh sách tất cả người dùng
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Account ORDER BY roleID ASC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("fullName"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching users: " + e.getMessage());
        }
        return list;
    }

    // Lấy thông tin một user theo username
    public User getUserByUserName(String userName) {
        String sql = "SELECT * FROM Account WHERE Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userName);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("fullName"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error fetching user: " + e.getMessage());
        }
        return null;
    }

    public void addUser(User user) {
        String sql = "INSERT INTO Account (FullName, Username, Password, Email, RoleID, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getFullName());
            st.setString(2, user.getUserName());
            st.setString(3, user.getPassword());
            st.setString(4, user.getEmail());
            st.setInt(5, user.getRoleID());
            st.setInt(6, user.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error adding user: " + e.getMessage());
        }
    }

    // Cập nhật thông tin người dùng
    public void updateUser(String fullName, String userName, String email, int roleID) {
        String sql = "UPDATE Account SET FullName = ?, Email = ?, RoleID = ? WHERE Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullName);
            st.setString(2, email);
            st.setInt(3, roleID);
            st.setString(4, userName);
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Updated user: " + userName);
            } else {
                System.out.println("Update failed! No user found with username: " + userName);
            }
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
        }
    }

  
    public void updateStatus(User user, int newStatus) {
        String sql = "UPDATE Account SET Status = ? WHERE Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newStatus);
            st.setString(2, user.getUserName());
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User " + user.getUserName() + " status updated to: " + newStatus);
            } else {
                System.out.println("Update failed! No user found with username: " + user.getUserName());
            }
        } catch (SQLException e) {
            System.out.println("Error updating user status: " + e.getMessage());
        }
    }

    // Xóa người dùng
    public void deleteUser(String userName) {
        String sql = "DELETE FROM Account WHERE Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userName);
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User " + userName + " deleted.");
            } else {
                System.out.println("Delete failed! No user found with username: " + userName);
            }
        } catch (SQLException e) {
            System.out.println("Error deleting user: " + e.getMessage());
        }
    }

    public List<User> getUsersByName(String searchValue) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE FullName LIKE ? ORDER BY RoleID ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "%" + searchValue + "%"); 
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("fullName"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error executing getUsersByName: " + e.getMessage());
        }

        return list;
    }

    public boolean isUsernameExists(String userName) {
        String sql = "SELECT COUNT(*) FROM Account WHERE Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userName);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking username existence: " + e.getMessage());
        }
        return false;
    }

    public boolean checkIsDuplicateEmail(String email) {
        String sql = "SELECT COUNT(*) FROM Account WHERE Email = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking email existence: " + e.getMessage());
        }
        return false;
    }

    public List<User> getUsersBySearchName(String searchValue) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE fullName LIKE ? ORDER BY roleId ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + searchValue + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("fullName"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalUsers() {
        int totalUsers = 0;
        String query = "SELECT COUNT(*) FROM Account";
        try (PreparedStatement st = connection.prepareStatement(query); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                totalUsers = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching total users: " + e.getMessage());
        }
        return totalUsers;
    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        List<User> list = userDAO.pagingAccount(1,3);
        for(User o : list){
            System.out.println(o);
        }
       
    }

    public int countAllAdmin() {
        int totalUser = 0;
        String sql = "SELECT COUNT(*) FROM Account WHERE RoleID = 1";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                totalUser = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return totalUser;
    }

    public int countAllExpert() {
        int totalUser = 0;
        String sql = "SELECT COUNT(*) FROM Account WHERE RoleID = 2";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                totalUser = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return totalUser;
    }

    public int countAllEmployee() {
        int totalUser = 0;
        String sql = "SELECT COUNT(*) FROM Account WHERE RoleID IN (3, 4)";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                totalUser = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return totalUser;
    }

    public List<User> pagingAccount(int index,int pagesize) {
        List<User> list = new ArrayList<>();
        String sql = "select * from Account\n"
                + "order by RoleID\n"
                + "offset ? rows fetch next ? rows only";
        try{
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, (index-1)*pagesize);
            st.setInt(2, pagesize);
            ResultSet rs = st.executeQuery();
            while(rs.next()){
                list.add(new User(
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("fullName"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email")
                ));
            }
            
            
        }catch(SQLException e){
        }
        return list;
    }
    public User getUserByEmail(String email) {
    String sql = "SELECT * FROM Account WHERE email = ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, email);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("fullName"));
                return user;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
}
