/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author dohie
 */
import DBContext.DBContext;
import static constant.Constant.RECORD_PER_PAGE;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Account;
import model.Category;
import model.Feedback;

public class CourseDAO extends DBContext{

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Course> courses;

    public CourseDAO() {
        courses = new ArrayList<>();
    }

    public static void main(String[] args) {
        CourseDAO courseDAO = new CourseDAO();

        int a = courseDAO.findTotalRecord();
        
        System.out.println(a);

    }

    public int findTotalRecord() {
        String sql = "select count(c.CourseID) from Course c";
        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return -1;
    }

    public List<Course> findByPage(int page) {

        String sql = "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "Order by co.CourseID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            ps.setInt(1, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(2, RECORD_PER_PAGE);

            rs = ps.executeQuery();

            while (rs.next()) {

                int courseId = rs.getInt("CourseID");
                String title = rs.getString("Title");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageUrl");
                int totalLesson = rs.getInt("TotalLesson");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp ureatedAt = rs.getTimestamp("UpdatedAt");

                int userId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                int roleId = rs.getInt("RoleID");

                int categoryId = rs.getInt("CategoryID");
                String categoryName = rs.getString("Name");

                Account expert = new Account(userId, fullName, roleId);

                Category category = new Category(categoryId, categoryName);

                Course course = new Course(courseId, title, description, userId, 0,
                        categoryId, imageUrl, totalLesson, status, createdAt, ureatedAt, expert, category);

                courses.add(course);

            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return courses;
    }

    public boolean AddCourse(Course course) {
        String sql = "INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getExpertID());
            ps.setInt(4, course.getCategoryID());
            ps.setString(5, course.getImageUrl());
            ps.setInt(6, course.getTotalLesson());
            ps.setBoolean(7, course.isStatus());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public List<Course> getAllCourses(int offset, int recordsPerPage) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[Status] = 1
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, offset);
            st.setInt(2, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPrice(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                courseList.add(course);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return courseList;
    }

    public List<Course> getCoursesByCategory(int categoryId, int offset, int recordsPerPage) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[CategoryID] = ? AND c.[Status] = 1
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            st.setInt(2, offset);
            st.setInt(3, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                courseList.add(course);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return courseList;
    }

    public Course getCourseById(int courseId) {
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[CourseID] = ? AND c.[Status] = 1
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                return course;
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }

    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM [dbo].[Course] WHERE [Status] = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return 0;
    }

    public int getTotalCoursesByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM [dbo].[Course] WHERE [CategoryID] = ? AND [Status] = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return 0;
    }

    public List<Course> searchCourses(String keyword, int offset, int recordsPerPage) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE (c.[Title] LIKE ? OR c.[Description] LIKE ?) AND c.[Status] = 1
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            st.setInt(3, offset);
            st.setInt(4, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                courseList.add(course);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return courseList;
    }

    public List<Course> getRecentCourses(int limit) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT TOP (?) c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[Status] = 1
                    ORDER BY c.[CreatedAt] DESC;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                courseList.add(course);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return courseList;
    }

    public List<Course> getCoursesByExpert(int expertId, int offset, int recordsPerPage) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[ExpertID] = ? AND c.[Status] = 1
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, expertId);
            st.setInt(2, offset);
            st.setInt(3, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getBoolean("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                courseList.add(course);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return courseList;
    }

    public double getAverageRating(int courseId) {
        String sql = """
                    SELECT AVG(CAST(Rating AS FLOAT)) as AvgRating
                    FROM [dbo].[Feedback]
                    WHERE [CourseID] = ? AND [Status] = 1
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getDouble("AvgRating");
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return 0.0;
    }

    public List<Feedback> getCourseFeedback(int courseId) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = """
                    SELECT f.[FeedbackID]
                          ,f.[UserID]
                          ,f.[CourseID]
                          ,f.[Content]
                          ,f.[Rating]
                          ,f.[Status]
                          ,f.[CreatedAt]
                          ,a.FullName
                          ,a.Username
                    FROM [dbo].[Feedback] f
                    JOIN [dbo].[Account] a ON f.UserID = a.UserID
                    WHERE f.[CourseID] = ? AND f.[Status] = 1
                    ORDER BY f.[CreatedAt] DESC;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackID(rs.getInt("FeedbackID"));
                feedback.setUserID(rs.getInt("UserID"));
                feedback.setCourseID(rs.getInt("CourseID"));
                feedback.setContent(rs.getString("Content"));
                feedback.setRating(rs.getInt("Rating"));
                feedback.setStatus(rs.getBoolean("Status"));
                feedback.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Account user = new Account();
                user.setFullName(rs.getString("FullName"));
                user.setUsername(rs.getString("Username"));
                feedback.setUser(user);

                feedbackList.add(feedback);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return feedbackList;
    }

    public List<Course> findByPageFilterCategoryAndStatus(int page, int categoryIdRequest, String statusRequest) {

        String sql = categoryIdRequest == 0 ? "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "where co.[Status] like ? \n"
                + "Order by co.CourseID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY" : "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "where co.[Status] like ? and co.CategoryID = ?\n"
                + "Order by co.CourseID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            if (categoryIdRequest == 0) {
                ps.setString(1, "%" + statusRequest + "%");
                ps.setInt(2, (page - 1) * RECORD_PER_PAGE);
                ps.setInt(3, RECORD_PER_PAGE);
            } else {
                ps.setString(1, "%" + statusRequest + "%");
                ps.setInt(2, categoryIdRequest);

                ps.setInt(3, (page - 1) * RECORD_PER_PAGE);
                ps.setInt(4, RECORD_PER_PAGE);
            }

            rs = ps.executeQuery();

            while (rs.next()) {

                int courseId = rs.getInt("CourseID");
                String title = rs.getString("Title");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageUrl");
                int totalLesson = rs.getInt("TotalLesson");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp ureatedAt = rs.getTimestamp("UpdatedAt");

                int userId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                int roleId = rs.getInt("RoleID");

                int categoryId = rs.getInt("CategoryID");
                String categoryName = rs.getString("Name");

                Account expert = new Account(userId, fullName, roleId);

                Category category = new Category(categoryId, categoryName);

                Course course = new Course(courseId, title, description, userId, 0,
                        categoryId, imageUrl, totalLesson, status, createdAt, ureatedAt, expert, category);

                courses.add(course);

            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return courses;
    }

    public List<Course> searchCourseByName(int page, String nameRequest) {

        String sql = "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "where co.Title like ? \n"
                + "Order by co.CourseID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            ps.setString(1, "%" + nameRequest + "%");
            ps.setInt(2, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(3, RECORD_PER_PAGE);

            rs = ps.executeQuery();

            while (rs.next()) {

                int courseId = rs.getInt("CourseID");
                String title = rs.getString("Title");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageUrl");
                int totalLesson = rs.getInt("TotalLesson");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp ureatedAt = rs.getTimestamp("UpdatedAt");

                int userId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                int roleId = rs.getInt("RoleID");

                int categoryId = rs.getInt("CategoryID");
                String categoryName = rs.getString("Name");

                Account expert = new Account(userId, fullName, roleId);

                Category category = new Category(categoryId, categoryName);

                Course course = new Course(courseId, title, description, userId, 0,
                        categoryId, imageUrl, totalLesson, status, createdAt, ureatedAt, expert, category);

                courses.add(course);

            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return courses;
    }
}
