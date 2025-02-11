package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Account;

public class LoginDAO extends DBContext {

    public boolean createAccount(String user, String pass, String fullname, String phone, String address, String email) {
        String sql = "INSERT INTO [dbo].[Account] ([Username], [Password], [FullName], [Email], [RoleID], [Status], [CreatedAt], [UpdatedAt]) "
                   + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            st.setString(3, fullname);
            st.setString(4, email);
            st.setInt(5, 3); // Giả sử role mặc định là Student
            st.setBoolean(6, true);

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.getMessage();
        }
        return false;
    }

    public Account check(String user) {
        String sql = "SELECT * FROM [Account] WHERE Username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setUserID(rs.getInt("UserID"));
                account.setUsername(rs.getString("Username"));
                account.setPassword(rs.getString("Password"));
                account.setFullName(rs.getString("FullName"));
                account.setEmail(rs.getString("Email"));
                account.setRoleID(rs.getInt("RoleID"));
                account.setStatus(rs.getBoolean("Status"));
                account.setCreatedAt(rs.getTimestamp("CreatedAt"));
                account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                return account;
            }
        } catch (SQLException e) {
             e.getMessage();
        }
        return null;
    }

    public Account check(String user, String pass) {
        String sql = "SELECT * FROM [Account] WHERE Username = ? AND Password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setUserID(rs.getInt("UserID"));
                account.setUsername(user);
                account.setPassword(pass);
                account.setFullName(rs.getString("FullName"));
                account.setEmail(rs.getString("Email"));
                account.setRoleID(rs.getInt("RoleID"));
                account.setStatus(rs.getBoolean("Status"));
                account.setCreatedAt(rs.getTimestamp("CreatedAt"));
                account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                return account;
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return null;
    }
}
