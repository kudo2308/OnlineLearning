package DAO;

import DBContext.DBContext;
import config.Security;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Course;
import model.Registration;
import model.Role;
import model.SocialLink;

public class LoginDAO extends DBContext {
//Done

    public boolean createAccount(String fullname, String email, String pass, String role) {
        int roleId;
        if (role.equalsIgnoreCase("Expert")) {
            roleId = 2;
        } else {
            roleId = 3;
        }
        String sql = "INSERT INTO [dbo].[Account] ([FullName],[Description], [Password], [Email], [Phone], [Image], "
                + "[Address], [GenderID], [DOB], [RoleID], [SubScriptionType], [SubScriptionExpiry], [Status], "
                + "[CreatedAt], [UpdatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullname);
            st.setString(2, null);
            st.setString(3, pass);
            st.setString(4, email);
            st.setString(5, null);
            st.setString(6, "/assets/images/avatar/unknow.jpg");
            st.setString(7, null);
            st.setString(8, null);
            st.setDate(9, null);
            st.setInt(10, roleId);
            st.setString(11, "free");
            st.setDate(12, null);
            st.setBoolean(13, true);
            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.getMessage(); // Log the error
        }
        return false;
    }

    public boolean createAccountAdmin(String fullname, String email, String pass, int role) {
        String sql = "INSERT INTO [dbo].[Account] ([FullName],[Description], [Password], [Email], [Phone], [Image], "
                + "[Address], [GenderID], [DOB], [RoleID], [SubScriptionType], [SubScriptionExpiry], [Status], "
                + "[CreatedAt], [UpdatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullname);
            st.setString(2, null);
            st.setString(3, pass);
            st.setString(4, email);
            st.setString(5, null);
            st.setString(6, "/assets/images/avatar/unknow.jpg");
            st.setString(7, null);
            st.setString(8, null);
            st.setDate(9, null);
            st.setInt(10, role);
            st.setString(11, "free");
            st.setDate(12, null);
            st.setBoolean(13, true);
            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.getMessage(); // Log the error
        }
        return false;
    }

    public boolean createAccountGg(String fullname, String email, String img, String pass, String role) {
        int roleId;
        if (role.equalsIgnoreCase("Expert")) {
            roleId = 2;
        } else {
            roleId = 3;
        }
        String sql = "INSERT INTO [dbo].[Account] ([FullName],[Description], [Password], [Email], [Phone],[Image], "
                + "[Address], [GenderID], [DOB], [RoleID], [SubScriptionType], [SubScriptionExpiry], [Status], "
                + "[CreatedAt], [UpdatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullname);
            st.setString(2, null);
            st.setString(3, pass);
            st.setString(4, email);
            st.setString(5, null);
            st.setString(6, img);
            st.setString(7, null);
            st.setString(8, null);
            st.setDate(9, null);
            st.setInt(10, roleId);
            st.setString(11, "free");
            st.setDate(12, null);
            st.setBoolean(13, true);

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.getMessage(); // Log the error
        }
        return false;
    }

    // Done
    public Account getAccountByEmail(String email) {
        String query = "SELECT a.UserID , a.FullName , a.Description , a.Image , r.RoleName, a.SubScriptionType "
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
                    account.setDescription(rs.getString("Description"));
                    account.setFullName(rs.getString("FullName"));
                    account.setImage(rs.getString("Image"));
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

    public Account getAccountByUserID(String userId) {
        String query = "SELECT a.UserID, a.Description, a.FullName, a.Email, a.Phone, a.Address, "
                + "a.Image, a.GenderID , a.DOB, r.RoleName, a.SubScriptionType "
                + "FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "WHERE a.UserID = ?";

        Account account = null;

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setDescription(rs.getString("Description"));
                    account.setFullName(rs.getString("FullName"));
                    account.setEmail(rs.getString("Email"));
                    account.setPhone(rs.getString("Phone"));
                    account.setAddress(rs.getString("Address"));
                    account.setImage(rs.getString("Image"));
                    account.setGenderID(rs.getString("GenderID"));
                    account.setDob(rs.getDate("DOB"));

                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    account.setRole(role);

                    account.setSubScriptionType(rs.getString("SubScriptionType"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log lỗi để debug
        }
        return account;
    }
    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT a.*, r.RoleName FROM Account a JOIN Role r ON a.RoleID = r.RoleID WHERE a.Status = 1 and a.RoleID != 1";

        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Account account = mapAccount(rs);
                accounts.add(account);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return accounts;
    }
    public static void main(String[] args) {
        LoginDAO dao =new LoginDAO();
         List<Account> accounts = dao.getAllAccounts();
         for (Account account : accounts) {
             System.out.println(account);
        }
    }
    public List<Account> getAccountsByRole(int roleID) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT a.*, r.RoleName FROM Account a JOIN Role r ON a.RoleID = r.RoleID WHERE a.RoleID = ? AND a.Status = 1";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, roleID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Account account = mapAccount(rs);
                    accounts.add(account);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return accounts;
    }
//Done

    public Account getAccountByUserIDPass(String userId) {
        String query = "SELECT a.UserID, a.Description, a.FullName, a.Password , a.Email, a.Phone, a.Address, "
                + "a.Image, a.GenderID , a.DOB, r.RoleName, a.SubScriptionType "
                + "FROM Account a "
                + "JOIN Role r ON a.RoleID = r.RoleID "
                + "WHERE a.UserID = ?";

        Account account = null;

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setDescription(rs.getString("Description"));
                    account.setFullName(rs.getString("FullName"));
                    account.setPassword(rs.getString("Password"));
                    account.setEmail(rs.getString("Email"));
                    account.setPhone(rs.getString("Phone"));
                    account.setAddress(rs.getString("Address"));
                    account.setImage(rs.getString("Image"));
                    account.setGenderID(rs.getString("GenderID"));
                    account.setDob(rs.getDate("DOB"));

                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    account.setRole(role);

                    account.setSubScriptionType(rs.getString("SubScriptionType"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log lỗi để debug
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
        String sql = "SELECT MAX(userID) AS lastUserID FROM Account";
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
            e.printStackTrace();
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
            } else {
                return true;
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

    public SocialLink getSocialLink(int userId) {
        String sql = "SELECT Xspace, Youtube, Facebook, Linkedin ,Private FROM SocialLink WHERE UserID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    SocialLink socialLink = new SocialLink();
                    socialLink.setUserId(userId);
                    socialLink.setXspace(rs.getString("Xspace"));
                    socialLink.setYoutube(rs.getString("Youtube"));
                    socialLink.setFacebook(rs.getString("Facebook"));
                    socialLink.setLinkedin(rs.getString("Linkedin"));
                    socialLink.setCheckPrivate(rs.getString("Private"));
                    return socialLink;
                }
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return null;
    }

    public List<Course> getRegisteredCoursesForUser(int userId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.CourseID,c.Title,c.Description, c.ExpertID, c.Price, c.CategoryID,  c.ImageUrl, c.TotalLesson, c.Status,  c.CreatedAt, c.UpdatedAt "
                + "FROM Registration r "
                + "JOIN Course c ON r.CourseID = c.CourseID "
                + "WHERE r.UserID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getInt("CourseID"));
                    course.setTitle(rs.getString("Title"));
                    course.setDescription(rs.getString("Description"));
                    course.setExpertID(rs.getInt("ExpertID"));
                    course.setPrice(rs.getFloat("Price"));
                    course.setCategoryID(rs.getInt("CategoryID"));
                    course.setImageUrl(rs.getString("ImageUrl"));
                    course.setTotalLesson(rs.getInt("TotalLesson"));
                    course.setStatus(rs.getString("Status"));
                    course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    courses.add(course);
                }
                return courses;
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        return null;
    }

    public List<Account> getRegisteredUsersForExpert(int expertId) {
        List<Account> registeredUsers = new ArrayList<>();
        String sql = "SELECT DISTINCT a.UserID, a.FullName, a.Email, a.Image, a.Phone "
                + "FROM Account a "
                + "INNER JOIN Registration r ON a.UserID = r.UserID "
                + "INNER JOIN Course c ON r.CourseID = c.CourseID "
                + "WHERE c.ExpertID = ? And a.UserID != ? "
                + "GROUP BY a.UserID, a.FullName, a.Email, a.Image, a.Phone";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, expertId);
            pstmt.setInt(2, expertId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setUserID(rs.getInt("UserID"));
                    account.setFullName(rs.getString("FullName"));
                    account.setEmail(rs.getString("Email"));
                    account.setImage(rs.getString("Image"));
                    account.setPhone(rs.getString("Phone"));
                    registeredUsers.add(account);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log lỗi
        }

        return registeredUsers;
    }

    public List<Course> getCoursesByExpert(int userId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT CourseID, Title, Description, Price, CategoryID, ImageUrl, TotalLesson, Status, CreatedAt, UpdatedAt "
                + "FROM Course "
                + "WHERE ExpertID = ? AND Status IN ('Public')";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getInt("CourseID"));
                    course.setTitle(rs.getString("Title"));
                    course.setDescription(rs.getString("Description"));
                    course.setPrice(rs.getFloat("Price"));
                    course.setCategoryID(rs.getInt("CategoryID"));
                    course.setImageUrl(rs.getString("ImageUrl"));
                    course.setTotalLesson(rs.getInt("TotalLesson"));
                    course.setStatus(rs.getString("Status"));
                    course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            // Properly log the exception
            e.getMessage();
        }

        return courses;
    }

    public boolean createSocialLinks(int userID) {
        boolean results = false;
        String sql = "INSERT INTO SocialLink (UserID, Xspace, Youtube, Facebook, Linkedin, Private) VALUES (?, ?, ?, ?, ?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userID);
            st.setString(2, null);
            st.setString(3, null);
            st.setString(4, null);
            st.setString(5, null);
            st.setString(6, "public");
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    public boolean updateSocialLinks(int userID, String xspace, String youtube, String facebook, String linkedin, String privacy) {
        String sql = "UPDATE SocialLink SET Xspace = ?, Youtube = ?, Facebook = ?, Linkedin = ?, Private = ? WHERE UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, xspace);
            st.setString(2, youtube);
            st.setString(3, facebook);
            st.setString(4, linkedin);
            st.setString(5, privacy);
            st.setInt(6, userID);

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateUserUpdate(String email) {
        String sql = "UPDATE Account SET UpdatedAt = ? WHERE Email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setString(2, email);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.getMessage();
        }
    }

    private Account mapAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setUserID(rs.getInt("UserID"));
        account.setFullName(rs.getString("FullName"));
        account.setEmail(rs.getString("Email"));
        account.setPhone(rs.getString("Phone"));
        account.setImage(rs.getString("Image"));
        account.setAddress(rs.getString("Address"));
        account.setGenderID(rs.getString("GenderID"));
        account.setDob(rs.getDate("DOB"));
        Role role = new Role();
        role.setRoleName(rs.getString("RoleName"));
        account.setRole(role);
        account.setStatus(rs.getBoolean("Status"));

        return account;
    }
}
