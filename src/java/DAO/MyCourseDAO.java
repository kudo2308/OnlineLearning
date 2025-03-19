/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import static constant.Constant.RECORD_PER_PAGE;
import java.sql.*;
import model.Account;
import model.Category;
import model.Registration;

/**
 *
 * @author VICTUS
 */
public class MyCourseDAO extends DBContext {

    public List<Course> searchCourse(String query, int userId, int offset, int limit) {
        List<Course> searchResults = new ArrayList<>();
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
                      ,r.Progress as Progress
                      ,r.Status as RegistrationStatus
                FROM [dbo].[Course] c
                JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                JOIN [dbo].[Registration] r ON c.CourseID = r.CourseID
                WHERE r.[UserID] = ? AND (c.[Title] LIKE ? OR c.[Description] LIKE ?) AND c.[Status] = 1
                ORDER BY r.[CreatedAt] DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setString(2, "%" + query + "%");
            st.setString(3, "%" + query + "%");
            st.setInt(4, offset);
            st.setInt(5, limit);
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

                // Set registration-related information
                Registration registration = new Registration();
                registration.setProgress(rs.getInt("Progress"));
                registration.setStatus(rs.getString("RegistrationStatus"));

                // Set expert and category information
                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                searchResults.add(course);
            }
        } catch (SQLException ex) {
            System.out.println("Error searching courses: " + ex.getMessage());
        }
        return searchResults;
    }

    public List<Course> getCoursesByCategories(int categoryId, int userId, int offset, int limit) {
        List<Course> categoryResults = new ArrayList<>();
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
                      ,r.Progress as Progress
                      ,r.Status as RegistrationStatus
                FROM [dbo].[Course] c
                JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                JOIN [dbo].[Registration] r ON c.CourseID = r.CourseID
                WHERE c.[CategoryID] = ? AND r.[UserID] = ? AND c.[Status] = 1
                ORDER BY r.[CreatedAt] DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            st.setInt(2, userId);
            st.setInt(3, offset);
            st.setInt(4, limit);
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

                // Set registration-related information
                Registration registration = new Registration();
                registration.setProgress(rs.getInt("Progress"));
                registration.setStatus(rs.getString("RegistrationStatus"));

                // Set expert and category information
                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                categoryResults.add(course);
            }
        } catch (SQLException ex) {
            System.out.println("Error in getCoursesByCategory: " + ex.getMessage());
        }
        return categoryResults;
    }

    public List<Course> getSortedCourses(String sortBy, int userId, int offset, int limit) {
        List<Course> sortedResults = new ArrayList<>();
        String orderBy;
        // Determine the ORDER BY clause based on sortBy parameter
        switch (sortBy.toLowerCase()) {
            case "title":
                orderBy = "c.[Title]";
                break;
            case "date":
                orderBy = "c.[CreatedAt] DESC";
                break;
            case "price":
                orderBy = "c.[Price]";
                break;
            case "lessons":
                orderBy = "c.[TotalLesson]";
                break;
            default:
                orderBy = "c.[CourseID]";
        }

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
                      ,r.Progress as Progress
                      ,r.Status as RegistrationStatus
                FROM [dbo].[Course] c
                JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                JOIN [dbo].[Registration] r ON c.CourseID = r.CourseID
                WHERE r.[UserID] = ? AND c.[Status] = 1
                ORDER BY """ + orderBy + """
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, offset);
            st.setInt(3, limit);
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

                // Set registration-related information
                Registration registration = new Registration();
                registration.setProgress(rs.getInt("Progress"));
                registration.setStatus(rs.getString("RegistrationStatus"));

                // Set expert and category information
                Account expert = new Account();
                expert.setFullName(rs.getString("ExpertName"));
                course.setExpert(expert);
                Category category = new Category();
                category.setName(rs.getString("CategoryName"));
                course.setCategory(category);

                sortedResults.add(course);
            }
        } catch (SQLException ex) {
            System.out.println("Error in getSortedCourses: " + ex.getMessage());
        }
        return sortedResults;
    }

    public List<Course> getCoursesByStudent(int studentId, int offset, int recordsPerPage) {
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
                      ,r.Progress as Progress
                      ,r.Status as RegistrationStatus
                FROM [dbo].[Course] c
                JOIN [dbo].[Account] a ON c.ExpertID = a.UserID
                JOIN [dbo].[Category] cat ON c.CategoryID = cat.CategoryID
                JOIN [dbo].[Registration] r ON c.CourseID = r.CourseID
                WHERE r.[UserID] = ? AND c.[Status] = 1
                ORDER BY r.[CreatedAt] DESC
                OFFSET ? ROWS
                FETCH NEXT ? ROWS ONLY
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
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
            System.out.println("Error in getCoursesByStudent: " + ex.getMessage());
        }
        return courseList;
    }
}
