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
import model.Registration;
import model.Role;

public class CourseDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Course> courses;

    public CourseDAO() {
        courses = new ArrayList<>();
    }

    

    public Course findCourseById(int id) {
        String sql = "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "where co.CourseID = ?";
        try (Connection connection = new DBContext().getConnection()) {

            ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            rs = ps.executeQuery();

            if (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                return course;
            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return null;

    }

    public int findTotalRecord(int userId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(c.CourseID) FROM Course c ")
                .append("WHERE c.ExpertID = ?");

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return -1;
    }

    public List<Course> findByPage(int page, int userId) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Course co ")
                .append("JOIN Account a ON co.ExpertID = a.UserID ")
                .append("JOIN Category ca ON co.CategoryID = ca.CategoryID ")
                .append("WHERE co.ExpertID = ? ")
                .append("ORDER BY co.CourseID ")
                .append("OFFSET ? ROWS ")
                .append("FETCH NEXT ? ROWS ONLY");

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());

            ps.setInt(1, userId);
            ps.setInt(2, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(3, RECORD_PER_PAGE);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {

        int courseId = rs.getInt("CourseID");
        String title = rs.getString("Title");
        String description = rs.getString("Description");
        String imageUrl = rs.getString("ImageUrl");
        int totalLesson = rs.getInt("TotalLesson");
        String status = rs.getString("Status");
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        float price = rs.getFloat("Price");
        double discountPrice = rs.getDouble("DiscountPrice");
        int userId = rs.getInt("UserID");
        String fullName = rs.getString("FullName");
        int roleId = rs.getInt("RoleID");

        int categoryId = rs.getInt("CategoryID");
        String categoryName = rs.getString("Name");

        Account expert = new Account(userId, fullName, roleId);

        Category category = new Category(categoryId, categoryName);

        return new Course(courseId, title, description, userId, price, roleId, categoryId, imageUrl, totalLesson, status, createdAt, updatedAt, discountPrice, roleId, expert, category);
    }

    public List<Course> findAll() {
        String sql = "select * from Course co\n"
                + "join Account a\n"
                + "on co.ExpertID = a.UserID\n"
                + "join Category ca\n"
                + "on co.CategoryID = ca.CategoryID\n"
                + "Order by co.CourseID";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                courses.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return courses;
    }

    public List<Course> findByPageFilterCategoryAndStatus(Integer page, int categoryIdRequest,
            String statusRequest, Integer expertId, String nameRequest) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Course co ")
                .append("JOIN Account a ON co.ExpertID = a.UserID ")
                .append("JOIN Category ca ON co.CategoryID = ca.CategoryID ")
                .append("WHERE co.[Status] LIKE ? and co.Title LIKE ? ")
                .append("AND (? is null or co.ExpertID = ?) ");

        if (categoryIdRequest != 0) {
            sql.append("AND co.CategoryID = ? ");
        }
        sql.append("ORDER BY co.CourseID desc ");
        if (page != null) {
            sql.append("OFFSET ? ROWS ")
                    .append("FETCH NEXT ? ROWS ONLY");
        }

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());
            ps.setString(1, "%" + statusRequest + "%");
            ps.setString(2, "%" + nameRequest + "%");
            ps.setObject(3, expertId);
            ps.setObject(4, expertId);

            if (categoryIdRequest == 0) {
                if (page != null) {
                    ps.setInt(5, (page - 1) * RECORD_PER_PAGE);
                    ps.setInt(6, RECORD_PER_PAGE);
                }
            } else {
                ps.setInt(5, categoryIdRequest);
                if (page != null) {
                    ps.setInt(6, (page - 1) * RECORD_PER_PAGE);
                    ps.setInt(7, RECORD_PER_PAGE);
                }
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Course> searchCourseByName(Integer page, String nameRequest, int userId) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Course co ")
                .append("JOIN Account a ON co.ExpertID = a.UserID ")
                .append("JOIN Category ca ON co.CategoryID = ca.CategoryID ")
                .append("WHERE co.Title LIKE ? ")
                .append("AND co.ExpertID = ? ")
                .append("ORDER BY co.CourseID ");
        if (page != null) {
            sql.append("OFFSET ? ROWS ")
                    .append("FETCH NEXT ? ROWS ONLY");
        }

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());

            ps.setString(1, "%" + nameRequest + "%");
            ps.setInt(2, userId);
            if (page != null) {
                ps.setInt(3, (page - 1) * RECORD_PER_PAGE);
                ps.setInt(4, RECORD_PER_PAGE);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean AddCourse(Course course) {
        String sql = "INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Status, Price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getExpertID());
            ps.setInt(4, course.getCategoryID());
            ps.setString(5, course.getImageUrl());
            ps.setInt(6, course.getTotalLesson());
            ps.setString(7, course.getStatus());
            ps.setFloat(8, course.getPrice());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean UpdateCourse(Course course) {
        String sql = "UPDATE Course SET Title = ?, Description = ?, ExpertID = ?, CategoryID = ?, ImageUrl = ?, TotalLesson = ?, Status = ?, Price = ?, UpdatedAt = GETDATE() WHERE CourseID = ?";

        try (Connection connection = new DBContext().getConnection()) {

            ps = connection.prepareStatement(sql);

            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getExpertID());
            ps.setInt(4, course.getCategoryID());
            ps.setString(5, course.getImageUrl());
            ps.setInt(6, course.getTotalLesson());
            ps.setString(7, course.getStatus());
            ps.setFloat(8, course.getPrice());
            ps.setInt(9, course.getCourseID());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

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
                          ,c.[DiscountPrice]
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
                    WHERE c.[Status] = 'Public'
                    ORDER BY c.[Price]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """; //error todo
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, offset);
            st.setInt(2, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPrice(rs.getFloat("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
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
            System.out.println("Error in getAllCourses: " + ex.getMessage());
        }
        return courseList;
    }

    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM Course WHERE Status = 1";
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error in getTotalCourses: " + ex.getMessage());
        }
        return 0;
    }

    public Course getCourseById(int courseId) {
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[DiscountPrice]
                          ,c.[ExpertID]
                          ,c.[CategoryID]
                          ,c.[ImageUrl]
                          ,c.[TotalLesson]
                          ,c.[Status]
                          ,c.[CreatedAt]
                          ,c.[UpdatedAt]
                          ,a.FullName as ExpertName
                          ,a.Email as ExpertEmail
                          ,a.Image as ExpertAvatar
                          ,cat.Name as CategoryName
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    WHERE c.[CourseID] = ? AND c.[Status] = 'Public'
                    """;
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPrice(rs.getInt("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                expert.setImage(rs.getString("ExpertAvatar"));
                expert.setEmail(rs.getString("ExpertEmail"));
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
                    WHERE (c.[Title] LIKE ? OR c.[Description] LIKE ?) AND c.[Status] = 'Public'
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try (Connection connection = new DBContext().getConnection()) {
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
                course.setPrice(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
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
                    SELECT TOP (?)
                        c.[CourseID],
                        c.[Title],
                        c.[Description],
                        c.[Price],
                        c.[DiscountPrice],
                        c.[ExpertID],
                        c.[CategoryID],
                        c.[ImageUrl],
                        c.[TotalLesson],
                        c.[Status],
                        c.[CreatedAt],
                        c.[UpdatedAt],
                        a.FullName AS ExpertName,
                        cat.Name AS CategoryName,
                        COUNT(r.RegistrationID) AS NumOfRegister
                    FROM [dbo].[Course] c
                    JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                    JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                    LEFT JOIN [dbo].[Registration] r ON c.CourseID = r.CourseID
                    WHERE c.[Status] = 'Public'
                    GROUP BY 
                        c.[CourseID], c.[Title], c.[Description], c.[Price],c.[DiscountPrice], c.[ExpertID], 
                        c.[CategoryID], c.[ImageUrl], c.[TotalLesson], c.[Status], 
                        c.[CreatedAt], c.[UpdatedAt], a.FullName, cat.Name
                    ORDER BY c.[CreatedAt] DESC;
                    """;
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPrice(rs.getFloat("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                course.setRegister(rs.getInt("NumOfRegister"));

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
                    WHERE c.[ExpertID] = ? AND c.[Status] = 'Public'
                    ORDER BY c.[CourseID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try (Connection connection = new DBContext().getConnection()) {
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
                course.setPrice(rs.getInt("Price"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
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

    public List<Course> getCoursesByExperts(int expertId) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[DiscountPrice]
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
                    WHERE c.[ExpertID] = ? AND c.[Status] = 'Public'
                    ORDER BY c.[CourseID]
                    """;
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, expertId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPrice(rs.getInt("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
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
        try (Connection connection = new DBContext().getConnection()) {
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
        try (Connection connection = new DBContext().getConnection()) {
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

                feedback.setUser(user);

                feedbackList.add(feedback);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return feedbackList;
    }

    public int countSearchCourses(String keyword) {
        String query = "SELECT COUNT(*) FROM Course WHERE title LIKE ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Phương thức lấy các khóa học theo categoryId
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
                    WHERE c.[CategoryID] = ? AND c.[Status] = 'Public'
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
                course.setStatus(rs.getString("Status"));
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

    public List<Course> getCoursesByCategories(int categoryId) {
        List<Course> courseList = new ArrayList<>();
        String sql = """
                    SELECT c.[CourseID]
                          ,c.[Title]
                          ,c.[Description]
                          ,c.[Price]
                          ,c.[ExpertID]
                          ,c.[DiscountPrice]
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
                    WHERE c.[CategoryID] = ? AND c.[Status] = 'Public'
                    ORDER BY c.[CourseID]
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setPricePackageID(rs.getInt("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                course.setExpertID(rs.getInt("ExpertID"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
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

    public List<Course> searchCourse(String query, int offset, int limit) {
        List<Course> searchResults = new ArrayList<>();
        String sql = "SELECT * FROM Course WHERE   Title LIKE ? OR Description LIKE ? "
                + "ORDER BY CourseID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);

            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            ps.setInt(3, offset);
            ps.setInt(4, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setExpertID(rs.getInt("ExpertID"));
                searchResults.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Error in searchCourses: " + e.getMessage());
        }
        return searchResults;
    }

    public int getTotalSearchResults(String query) {
        String sql = "SELECT COUNT(*) FROM Course WHERE Title LIKE ? OR Description LIKE ?";
        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalSearchResults: " + e.getMessage());
        }
        return 0;
    }

    public List<Course> getCoursesByCategories(int categoryId, int offset, int limit) {
        List<Course> categoryResults = new ArrayList<>();
        String sql = "SELECT * FROM Course WHERE CategoryID = ? "
                + "ORDER BY CourseID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setExpertID(rs.getInt("ExpertID"));
                categoryResults.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Error in getCoursesByCategory: " + e.getMessage());
        }
        return categoryResults;
    }

    public int getTotalCoursesByCategories(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Course WHERE CategoryID = ?";
        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalCoursesByCategory: " + e.getMessage());
        }
        return 0;
    }

    public List<Course> getSortedCourses(String sortBy, int offset, int limit) {
        List<Course> sortedResults = new ArrayList<>();
        String orderBy;

        switch (sortBy.toLowerCase()) {
            case "title":
                orderBy = "Title";
                break;
            case "date":
                orderBy = "CreatedAt DESC";
                break;
            default:
                orderBy = "CourseID";
        }

        String sql = "SELECT * FROM Course ORDER BY " + orderBy
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setTotalLesson(rs.getInt("TotalLesson"));
                course.setStatus(rs.getString("Status"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setExpertID(rs.getInt("ExpertID"));
                sortedResults.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Error in getSortedCourses: " + e.getMessage());
        }
        return sortedResults;
    }

    public List<Course> getAllRecentCourses() {
        List<Course> courses = new ArrayList<>();
        try {
            String query = "SELECT * FROM Course where status = 1 ORDER BY CreatedAt DESC";
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setTitle(rs.getString("Description"));
                course.setPrice(rs.getFloat("Price"));
                course.setCategoryID(rs.getInt("CategoryID"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setCreatedAt(rs.getTimestamp("CreatedAt"));
                course.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                course.setStatus(rs.getString("Status"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Course";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setPrice(rs.getFloat("Price"));
                course.setDiscountPrice(rs.getDouble("DiscountPrice"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public Course getCourseById1(int courseID) {
        String sql = "SELECT * FROM Course WHERE courseID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getInt("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setPrice(rs.getFloat("price"));
                    return course;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Course> getCourseByEmail(String email) {
        List<Course> userCourses = new ArrayList<>();
        String sql = "select co.* from Course co\n"
                + "join Registration r\n"
                + "on co.CourseID = r.CourseID\n"
                + "join Account a\n"
                + "on r.UserID = a.UserID\n"
                + "where a.Email = ?";
        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                userCourses.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return userCourses;
    }

    public boolean checkSellCourse(int courseId) {
        boolean check = false;
        StringBuilder sql = new StringBuilder();
        sql.append("select * from Course c\n"
                + "join Packages p on c.CourseID = p.CourseID\n"
                + "join Lesson l on l.PackageID = p.PackageID\n"
                + "where c.CourseID = ?");

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());

            ps.setInt(1, courseId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                check = true;
                break;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return check;
    }

    public List<Course> findCouseByExpert(int userId) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Course co ")
                .append("JOIN Account a ON co.ExpertID = a.UserID ")
                .append("JOIN Category ca ON co.CategoryID = ca.CategoryID ")
                .append("WHERE co.ExpertID = ? ")
                .append("ORDER BY co.CourseID ");

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                int courseId = rs.getInt("CourseID");
                String title = rs.getString("Title");
                Course course = new Course();
                course.setCourseID(courseId);
                course.setTitle(title);
                courses.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return courses;
    }

    public boolean updateCoursePrice(int courseId, double originalPrice, double discountedPrice) {
        boolean success = false;
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = new DBContext().getConnection();
            String sql = "UPDATE Course SET Price = ?, DiscountPrice = ? WHERE CourseID = ?";
            statement = connection.prepareStatement(sql);
            statement.setDouble(1, originalPrice);
            statement.setDouble(2, discountedPrice);
            statement.setInt(3, courseId);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateCoursePrice: " + e.getMessage());
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }

        return success;
    }

    /**
     * Reset giá đã giảm của khóa học về NULL
     *
     * @param courseId ID của khóa học cần reset giá
     * @return true nếu reset thành công, ngược lại là false
     */
    public boolean resetDiscountedPrice(int courseId) {
        boolean success = false;
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = new DBContext().getConnection();
            String sql = "UPDATE Course SET DiscountPrice = Price WHERE CourseID = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error in resetDiscountedPrice: " + e.getMessage());
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }

        return success;
    }

    /**
     * Reset giá đã giảm về bằng giá gốc
     *
     * @param courseId ID của khóa học cần reset giá
     * @return true nếu reset thành công, ngược lại là false
     */
    public boolean resetDiscountedPriceToOriginal(int courseId) {
        boolean success = false;
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = new DBContext().getConnection();
            String sql = "UPDATE Course SET discounted_price = price WHERE CourseID = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error in resetDiscountedPriceToOriginal: " + e.getMessage());
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }

        return success;
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        boolean update = dao.updateCoursePrice(1, 150000, 100000);
      public List<Course> findByPageFilterCategoryAndAllStatusToConfirm(Integer page, int categoryIdRequest,Integer expertId, String nameRequest) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Course co ")
                .append("JOIN Account a ON co.ExpertID = a.UserID ")
                .append("JOIN Category ca ON co.CategoryID = ca.CategoryID ")
                .append("WHERE (co.[Status] = 'Pending' or co.[Status] = 'Public') and co.Title LIKE ? ")
                .append("AND (? is null or co.ExpertID = ?) ");

        if (categoryIdRequest != 0) {
            sql.append("AND co.CategoryID = ? ");
        }
        sql.append("ORDER BY co.CourseID ");
        if (page != null) {
            sql.append("OFFSET ? ROWS ")
                    .append("FETCH NEXT ? ROWS ONLY");
        }

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());
            ps.setString(1, "%" + nameRequest + "%");
            ps.setObject(2, expertId);
            ps.setObject(3, expertId);

            if (categoryIdRequest == 0) {
                if (page != null) {
                    ps.setInt(4, (page - 1) * RECORD_PER_PAGE);
                    ps.setInt(5, RECORD_PER_PAGE);
                }
            } else {
                ps.setInt(4, categoryIdRequest);
                if (page != null) {
                    ps.setInt(5, (page - 1) * RECORD_PER_PAGE);
                    ps.setInt(6, RECORD_PER_PAGE);
                }
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
