package DAO;

import DBContext.DBContext;
import config.Security;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Account;
import model.Role;

public class LoginDAO extends DBContext {
//Done
    // Done

    public boolean createAccount(String fullname, String email, String pass, String role) {
        int roleId;
        if (role.equals("Expert")) {
            roleId = 2;
        } else {
            roleId = 3;
        }
        String sql = "INSERT INTO [dbo].[Account] ([FullName], [Password], [Email], [Phone], [Image], [Address], [GenderID], [DOB], [RoleID], [SubScriptionType], [SubScriptionExpiry], [Status], [CreatedAt], [UpdatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullname);
            st.setString(2, pass);
            st.setString(3, email);
            st.setString(4, null);
            st.setString(5, null);
            st.setString(6, null);
            st.setString(7, null);
            st.setDate(8, null);
            st.setInt(9, roleId);
            st.setString(10, "free");
            st.setDate(11, null);
            st.setBoolean(12, true);

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.getMessage(); // Log the error
        }
        return false;
    }

    // Done
    public Account getAccountByEmail(String email) {
        String query = "SELECT a.UserID, a.FullName, r.RoleName, a.SubScriptionType "
                + "FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "WHERE a.Email = ?";
        Account account = null;
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setFullName(rs.getString("FullName"));
                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    account.setRole(role);

                    account.setSubScriptionType(rs.getString("SubScriptionType"));
                }
            }
            return account;
        } catch (SQLException e) {
            e.getMessage(); // Log the error
        }
        return account;
    }
//Done

    public boolean check(String email) {
        boolean exist = false;
        String sql = "SELECT Email FROM [Account] WHERE Email = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, email);
            ResultSet rs = pre.executeQuery();
            exist = rs.next();
        } catch (SQLException e) {
            e.getMessage();
        }
        return exist;
    }
//Done

    public int getLastUserID() {
        int userID = -1;
        String sql = "SELECT MAX(userID) AS lastUserID FROM Users";
        try (PreparedStatement pre = connection.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                userID = rs.getInt("lastUserID");
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return userID;
    }

    //Done    
    public boolean checkUserLogin(String email, String pass) {
        boolean exists = false;
        try {
            String sqlQuery = "SELECT password FROM Account  WHERE email = ?";
            PreparedStatement pre = connection.prepareStatement(sqlQuery);
            pre.setString(1, email);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                // Mã hóa mật khẩu nhập vào để so sánh với mật khẩu trong DB
                String encodedInputPassword = Security.encode(pass);
                // So sánh chuỗi mã hóa
                return encodedInputPassword.equals(storedHashedPassword);
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return exists;
    }
    //Done

    public boolean checkStatusUser(String email) {
        boolean exists = false;
        try {
            String sqlQuery = "SELECT Status FROM Account  WHERE Email = ?";
            PreparedStatement pre = connection.prepareStatement(sqlQuery);
            pre.setString(1, email);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("Status");
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return exists;
    }

    public boolean changePassword(String email, String passChange) {
    String sql = "UPDATE Account SET Password = ?, UpdatedAt = GETDATE() WHERE Email = ?";
    try {
        String hashedPassword = Security.encode(passChange);      
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, hashedPassword);
        st.setString(2, email);
        
        int rowsUpdated = st.executeUpdate();
        return rowsUpdated > 0;
    } catch (SQLException e) {
        e.printStackTrace(); // Log lỗi để debug
    }
    return false;
}
}
