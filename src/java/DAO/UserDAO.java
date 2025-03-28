/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import config.Security;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.Account;
import model.Role;
import java.util.Date;

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
                        rs.getString("password"),
                        rs.getString("email")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching users: " + e.getMessage());
        }
        return list;
    }
    
    public List<User> getAllExpert() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Account a JOIN Role r ON a.RoleID = r.RoleID Where r.RoleName = 'Expert' ORDER BY a.roleID ASC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("UserID"),
                        rs.getInt("RoleID"),
                        rs.getInt("Status"),
                        rs.getString("FullName"),
                        rs.getString("Password"),
                        rs.getString("Email")
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

    public void updateStatus(String email, boolean status) {
        String sql = "UPDATE Account SET Status = ? WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            if (status) {
                st.setBoolean(1, false);
            } else {
                st.setBoolean(1, true);
            }
            st.setString(2, email);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi để debug
        }
    }
    
    // Lấy thông tin người dùng theo ID
    public User getUserByID(int userID) {
        String sql = "SELECT * FROM Account WHERE UserID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("UserID"),
                    rs.getInt("RoleID"),
                    rs.getInt("Status"),
                    rs.getString("FullName"),
                    rs.getString("Password"),
                    rs.getString("Email")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error fetching user by ID: " + e.getMessage());
        }
        return null;
    }
    
    // Cập nhật trạng thái người dùng theo ID
    public boolean updateStatus(int userID, int newStatus) {
        String sql = "UPDATE Account SET Status = ? WHERE UserID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, newStatus);
            st.setInt(2, userID);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user status: " + e.getMessage());
            return false;
        }
    }

    // Xóa người dùng
    public void deleteUser(String email) {
        String sqlDeleteRelated = "DELETE FROM SocialLink WHERE UserID = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM Course WHERE ExpertID = (SELECT UserID FROM Account WHERE Email = ?) OR UserId = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM Cart WHERE AccountID = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM Registration WHERE UserID = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM LessonProgress WHERE UserID = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM Feedback WHERE UserID = (SELECT UserID FROM Account WHERE Email = ?);"
                + "DELETE FROM Blog WHERE AuthorID = (SELECT UserID FROM Account WHERE Email = ?);";

        String sqlDeleteUser = "DELETE FROM Account WHERE Email = ?";

        try (PreparedStatement st1 = connection.prepareStatement(sqlDeleteRelated); PreparedStatement st2 = connection.prepareStatement(sqlDeleteUser)) {

            // Gán giá trị cho từng tham số ? chính xác
            st1.setString(1, email);
            st1.setString(2, email);
            st1.setString(3, email);
            st1.setString(4, email);
            st1.setString(5, email);
            st1.setString(6, email);
            st1.setString(7, email);
            st1.setString(8, email);

            st1.executeUpdate(); // Xóa dữ liệu liên quan trước

            st2.setString(1, email);
            st2.executeUpdate(); // Xóa tài khoản           
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public List<Account> getUsersBySearchName(String searchValue, String roleName) {
        List<Account> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT a.UserID, a.FullName, a.Image, r.RoleName, a.Email, a.Password ,a.Status, a.UpdatedAt "
                + "FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND a.FullName LIKE ?");
            params.add("%" + searchValue.trim() + "%");
        }
        if (roleName != null && !roleName.trim().isEmpty()) {
            sql.append(" AND r.RoleName = ?");
            params.add(roleName.trim());
        }
        sql.append(" ORDER BY a.RoleID ASC");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            // Gán tham số vào query
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) {
                    st.setInt(i + 1, (Integer) params.get(i));
                } else {
                    st.setString(i + 1, (String) params.get(i));
                }
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setFullName(rs.getString("FullName").trim());
                    account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    account.setImage(Optional.ofNullable(rs.getString("Image")).map(String::trim).orElse(null));
                    account.setEmail(rs.getString("Email").trim());
                    account.setPassword(Security.decode(rs.getString("password")));
                    account.setStatus(rs.getBoolean("Status"));

                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName").trim());
                    account.setRole(role);

                    list.add(account);
                }
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return list;
    }

    // Phương thức tìm kiếm người dùng với nhiều tiêu chí bao gồm status
    public List<Account> getUsersBySearchCriteria(String searchValue, String roleName, String status) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.*, r.RoleName FROM Account a JOIN Role r ON a.RoleID = r.RoleID WHERE 1=1";
        
        if (searchValue != null && !searchValue.isEmpty()) {
            sql += " AND a.FullName LIKE ?";
        }
        
        if (roleName != null && !roleName.isEmpty()) {
            sql += " AND r.RoleName = ?";
        }
        
        if (status != null && !status.isEmpty()) {
            sql += " AND a.Status = ?";
        }
        
        sql += " ORDER BY a.UserID ASC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int paramIndex = 1;
            
            if (searchValue != null && !searchValue.isEmpty()) {
                st.setString(paramIndex++, "%" + searchValue + "%");
            }
            
            if (roleName != null && !roleName.isEmpty()) {
                st.setString(paramIndex++, roleName);
            }
            
            if (status != null && !status.isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(status));
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Account account = new Account();
                account.setUserID(rs.getInt("UserID"));
                
                // Tạo đối tượng Role và thiết lập cho Account
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                account.setRole(role);
                
                // Thiết lập status dướidạng boolean
                account.setStatus(rs.getInt("Status") == 1);
                
                account.setFullName(rs.getString("FullName"));
                account.setPassword(rs.getString("Password"));
                account.setEmail(rs.getString("Email"));
                account.setPhone(rs.getString("Phone"));
                account.setAddress(rs.getString("Address"));
                account.setImage(rs.getString("Image"));
                account.setDescription(rs.getString("Description"));
                account.setDob(rs.getDate("DOB"));
                account.setGenderID(rs.getString("GenderID"));
                account.setSubScriptionType(rs.getString("SubScriptionType"));
                account.setSubScriptionExpiry(rs.getTimestamp("SubScriptionExpiry"));
                account.setCreatedAt(rs.getTimestamp("CreatedAt"));
                account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                list.add(account);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching users by search criteria: " + e.getMessage());
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

    public int getNewUsersCount(Date startDate, Date endDate) {
        int newUsers = 0;
        String query = "SELECT COUNT(*) FROM Account WHERE createdAt BETWEEN ? AND ?";
        try (PreparedStatement st = connection.prepareStatement(query)) {
            st.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            st.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                newUsers = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching new users: " + e.getMessage());
        }
        return newUsers;
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

    public List<Account> pagingAccount(int index, int pageSize) {
        List<Account> list = new ArrayList<>();

        String sql = "SELECT a.UserID, a.FullName, a.Image, r.RoleName, a.Email, a.Password ,a.Status, a.UpdatedAt"
                + " FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "ORDER BY a.RoleID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, (index - 1) * pageSize);
            st.setInt(2, pageSize);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setFullName(rs.getString("FullName").trim());
                    account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    account.setImage(Optional.ofNullable(rs.getString("Image")).map(String::trim).orElse(null));
                    account.setEmail(rs.getString("Email").trim());
                    account.setPassword(Security.decode(rs.getString("password")));
                    account.setStatus(rs.getBoolean("Status"));

                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName").trim());
                    account.setRole(role);

                    list.add(account);
                }
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return list;
    }

    public Account getAccountByID(int userID) {
        Account account = null;
        String sql = "SELECT a.UserID, a.FullName, a.Image, a.Description, a.Phone, a.Address, a.GenderID, a.DOB, "
                + "r.RoleID, r.RoleName, a.Email, a.Password, a.Status, a.CreatedAt, a.UpdatedAt "
                + "FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "WHERE a.UserID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userID);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setFullName(rs.getString("FullName"));
                    account.setImage(rs.getString("Image"));
                    account.setDescription(rs.getString("Description"));
                    account.setPhone(rs.getString("Phone"));
                    account.setAddress(rs.getString("Address"));
                    account.setGenderID(String.valueOf(rs.getInt("GenderID")));
                    account.setDob(rs.getDate("DOB"));
                    account.setEmail(rs.getString("Email"));
                    account.setPassword(Security.decode(rs.getString("Password")));
                    account.setStatus(rs.getBoolean("Status"));
                    account.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    account.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    
                    Role role = new Role();
                    role.setRoleID(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    account.setRole(role);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getAccountByID: " + e.getMessage());
        }
        
        return account;
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        List<User> user = dao.getAllExpert();
        for (User user1 : user) {
            System.out.println(user1.getFullName());
        }

    }
}
