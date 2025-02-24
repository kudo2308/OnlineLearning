package DAO;

import DBContext.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                    WHERE b.[Status] = 1
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
                blog.setStatus(rs.getBoolean("Status"));
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
                    WHERE cat.CategoryID = ?
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
                blog.setStatus(rs.getBoolean("Status"));
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
                WHERE cat.CategoryID = ?
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
                blog.setStatus(rs.getBoolean("Status"));
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
                blog.setStatus(rs.getBoolean("Status"));
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
            String query = "SELECT * FROM Blog b JOIN Account a ON b.AuthorID = a.UserID ORDER BY b.CreatedAt DESC";
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

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.getBlogByBlogId(3);
        List<Blog> blogs = blogDAO.getAllRecentBlogs();
        for (Blog blog1 : blogs) {
            System.out.println(blog1.getTitle());
        }
    }

}
