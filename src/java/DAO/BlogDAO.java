package DAO;

import DBContext.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Blog;
import model.Category;
import model.Course;

public class BlogDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Blog> categories;

    public BlogDAO() {
        categories = new ArrayList<>();
    }

    public List<Blog> getAllBlogs(int offset, int recordsPerPage) {
        List<Blog> blogList = new ArrayList<>();
        String sql = """
                    SELECT b.[BlogID]
                          ,b.[Title]
                          ,b.[Content]
                          ,b.[AuthorID]
                          ,b.[CategoryID]
                          ,b.[ImageUrl]
                          ,b.[Status]
                          ,b.[CreatedAt]
                          ,b.[UpdatedAt]
                          ,a.FullName as AuthorName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Blog] b
                    JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                    JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                    WHERE b.Status = 'Public'
                    ORDER BY b.[BlogID]
                    OFFSET ? ROWS
                    FETCH NEXT ? ROWS ONLY;
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, offset);
            st.setInt(2, recordsPerPage);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                blogList.add(blog);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return blogList;
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
                expert.setFullName(rs.getString("AuthorName"));
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

    public int getTotalBlogs() {
        String sql = "SELECT COUNT(*) FROM [dbo].[Blog] WHERE [Status] = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return 0; // Nếu có lỗi thì trả về 0
    }

    public List<Blog> getBlogByCategoryId(int categoryId) {
        List<Blog> blogList = new ArrayList<>();
        String sql = """
                    SELECT b.[BlogID]
                          ,b.[Title]
                          ,b.[Content]
                          ,b.[AuthorID]
                          ,b.[CategoryID]
                          ,b.[ImageUrl]
                          ,b.[Status]
                          ,b.[CreatedAt]
                          ,b.[UpdatedAt]
                          ,a.FullName as AuthorName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Blog] b
                    JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                    JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                    WHERE cat.CategoryID = ? and b.Status = 'Public'
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                blogList.add(blog);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return blogList;
    }

    public List<Blog> getBlogsByCategoryId(int categoryId, int offset, int limit) {
        List<Blog> blogList = new ArrayList<>();
        String sql = """
                SELECT b.[BlogID], b.[Title], b.[Content], b.[AuthorID], b.[CategoryID],
                       b.[ImageUrl], b.[Status], b.[CreatedAt], b.[UpdatedAt],
                       a.FullName AS AuthorName, cat.Name AS CategoryName
                FROM [dbo].[Blog] b
                JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                WHERE cat.CategoryID = ? and b.Status = 'Public'
                ORDER BY b.[CreatedAt] DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            st.setInt(2, offset);
            st.setInt(3, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);

                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                blogList.add(blog);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return blogList;
    }

    public Blog getBlogByBlogId(int blogId) {
        String sql = """
                    SELECT b.[BlogID]
                                              ,b.[Title]
                                              ,b.[Content]
                                              ,b.[AuthorID]
                                              ,b.[CategoryID]
                                              ,b.[ImageUrl]
                                              ,b.[Status]
                                              ,b.[CreatedAt]
                                              ,b.[UpdatedAt]
                                              ,a.FullName as AuthorName
                                              ,cat.Name as CategoryName
                                        FROM [dbo].[Blog] b
                                        JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                                        JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                                        WHERE b.BlogID = ?
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, blogId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                return blog;
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }

    public List<Blog> getAllRecentBlogs() {
        List<Blog> blogs = new ArrayList<>();
        try {
            String query = "SELECT * FROM Blog b JOIN Account a ON b.AuthorID = a.UserID Where b.Status = 'public' ORDER BY b.CreatedAt DESC";
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setCategoryID(rs.getInt("CategoryID"));

                Account author = new Account();
                author.setFullName(rs.getString("FullName"));
                blog.setAuthor(author);
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }

    public boolean addBlog(Blog blog) {
        String sql = """
                INSERT INTO [dbo].[Blog] 
                ([Title], [Content], [AuthorID], [CategoryID], [ImageUrl], [Status], [CreatedAt], [UpdatedAt])
                VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE());
                """;

        try (Connection conn = connection; PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setInt(3, blog.getAuthorId());
            ps.setInt(4, blog.getCategoryID());
            ps.setString(5, blog.getImgUrl());
            ps.setString(6, blog.getStatus());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Lấy khóa tự động (BlogID) sau khi thêm bản ghi thành công
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        blog.setBlogId(generatedKeys.getInt(1));  // Lấy BlogID và gán cho đối tượng blog
                        return true;  // Trả về true nếu thành công
                    }
                }
            }
        } catch (SQLException ex) {
            System.out.println("Lỗi khi thêm blog: " + ex.getMessage());
        }
        return false; // Trả về false nếu có lỗi xảy ra
    }

    public List<Blog> getBlogByUserId(int userId) {
        List<Blog> blogList = new ArrayList<>();
        String sql = """
                    SELECT b.[BlogID]
                          ,b.[Title]
                          ,b.[Content]
                          ,b.[AuthorID]
                          ,b.[CategoryID]
                          ,b.[ImageUrl]
                          ,b.[Status]
                          ,b.[CreatedAt]
                          ,b.[UpdatedAt]
                          ,a.FullName as AuthorName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Blog] b
                    JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                    JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                    WHERE a.UserID = ?
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                blogList.add(blog);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return blogList;
    }

    public boolean deleteBlog(int blogId) {
        String sql = "DELETE FROM Blog WHERE BlogID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, blogId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0; // Trả về true nếu có ít nhất 1 dòng bị xóa
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi xảy ra
        }
    }

    public void updateBlog(Blog blog) {
        String sql = "UPDATE Blog SET Title = ?, Content = ?, ImageUrl = ?, CategoryID = ?, Status = ?, UpdatedAt = GETDATE() WHERE BlogID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getImgUrl());
            stmt.setInt(4, blog.getCategoryID());
            stmt.setString(5, blog.getStatus());
            stmt.setInt(6, blog.getBlogId());

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Blog updated successfully.");
            } else {
                System.out.println("No blog updated. Check permissions.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Blog> getAllBlogsAdmin() {
        List<Blog> blogList = new ArrayList<>();
        String sql = """
                    SELECT b.[BlogID]
                          ,b.[Title]
                          ,b.[Content]
                          ,b.[AuthorID]
                          ,b.[CategoryID]
                          ,b.[ImageUrl]
                          ,b.[Status]
                          ,b.[CreatedAt]
                          ,b.[UpdatedAt]
                          ,a.FullName as AuthorName
                          ,cat.Name as CategoryName
                    FROM [dbo].[Blog] b
                    JOIN [dbo].[Account] a ON b.AuthorID = a.UserID
                    JOIN [dbo].[Category] cat ON b.CategoryID = cat.CategoryID
                    ORDER BY b.[BlogID]

                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setContent(rs.getString("Content"));
                blog.setAuthorId(rs.getInt("AuthorID"));
                blog.setCategoryID(rs.getInt("CategoryID"));
                blog.setImgUrl(rs.getString("ImageUrl"));
                blog.setStatus(rs.getString("Status"));
                blog.setCreateAt(rs.getDate("CreatedAt"));
                blog.setUpdateAt(rs.getDate("UpdatedAt"));

                Account author = new Account();
                author.setFullName(rs.getString("AuthorName"));
                blog.setAuthor(author);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                blog.setCategory(category);

                blogList.add(blog);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return blogList;
    }

    public boolean updateBlogStatus(int blogId, String status) {
        String sql = "UPDATE [dbo].[Blog] SET [Status] = ? WHERE [BlogID] = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, blogId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;  // Nếu có dòng nào được cập nhật, trả về true
        } catch (SQLException ex) {
            System.out.println("Lỗi khi cập nhật trạng thái blog: " + ex.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();

        // Chọn Blog ID để cập nhật
        // Lấy blog từ database
        Blog blog = blogDAO.getBlogByBlogId(9);

        System.out.println(blog);

        if (blog != null) {
            // Cập nhật thông tin mới cho blog
            blog.setTitle("Updated Blog Title");
            blog.setContent("This is the updated content of the blog.");
            blog.setCategoryID(2); // Giả sử category ID mới là 2
            blog.setStatus("public"); // Hoặc "private"

            // Nếu cần cập nhật ảnh mới (giữ nguyên nếu không có ảnh mới)
            String newImageUrl = "/assets/images/blog/new-image.jpg"; // Giả sử có ảnh mới
            blog.setImgUrl(newImageUrl);

            // Gọi phương thức update
            blogDAO.updateBlog(blog);
        }
    }
}
