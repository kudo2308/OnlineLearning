/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Packages;
import model.Quiz;
import DBContext.DBContext;

/**
 *
 * @author dohie
 */
public class QuizDAO extends DBContext{
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    public List<Quiz> getAllQuizzes() {
        List<Quiz> list = new ArrayList<>();
        String query = "SELECT * FROM Quiz WHERE status = 1";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizID(rs.getInt("quizID"));
                quiz.setName(rs.getString("name"));
                quiz.setDescription(rs.getString("description"));
                quiz.setDuration(rs.getInt("duration"));
                quiz.setPassRate(rs.getDouble("passRate"));
                quiz.setTotalQuestion(rs.getInt("totalQuestion"));
                quiz.setCourseID(rs.getInt("courseID"));
                quiz.setPackageID(rs.getInt("packageID"));
                quiz.setStatus(rs.getBoolean("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                quiz.setUpdatedAt(rs.getTimestamp("updatedAt"));
                list.add(quiz);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            closeResources();
        }
        return list;
    }
    
    public Quiz getQuizById(int quizId) {
        try {
            String sql = "SELECT * FROM Quiz WHERE quizID = ?";
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quizId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizID(rs.getInt("quizID"));
                quiz.setName(rs.getString("name"));
                quiz.setDescription(rs.getString("description"));
                quiz.setDuration(rs.getInt("duration")); 
                quiz.setTimeLimit(rs.getInt("duration")); 
                quiz.setPassRate(rs.getDouble("passRate"));
                quiz.setTotalQuestion(rs.getInt("totalQuestion"));
                quiz.setCourseID(rs.getInt("courseID"));
                quiz.setPackageID(rs.getInt("packageID"));
                quiz.setStatus(rs.getBoolean("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                quiz.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return quiz;
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuizById: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    public Quiz getQuizByPackageId(int packageId) {
        String query = "SELECT * FROM Quiz WHERE packageID = ? AND status = 1";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, packageId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizID(rs.getInt("quizID"));
                quiz.setName(rs.getString("name"));
                quiz.setDescription(rs.getString("description"));
                quiz.setDuration(rs.getInt("duration"));
                quiz.setPassRate(rs.getDouble("passRate"));
                quiz.setTotalQuestion(rs.getInt("totalQuestion"));
                quiz.setCourseID(rs.getInt("courseID"));
                quiz.setPackageID(rs.getInt("packageID"));
                quiz.setStatus(rs.getBoolean("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                quiz.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return quiz;
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuizByPackageId: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get all quizzes for a specific course
     * 
     * @param courseId The course ID
     * @return List of quizzes for the course
     */
    public List<Quiz> getQuizzesByCourseId(int courseId) {
        List<Quiz> quizList = new ArrayList<>();
        String query = "SELECT * FROM Quiz WHERE courseID = ? AND status = 1";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizID(rs.getInt("quizID"));
                quiz.setName(rs.getString("name"));
                quiz.setDescription(rs.getString("description"));
                quiz.setDuration(rs.getInt("duration"));
                quiz.setPassRate(rs.getDouble("passRate"));
                quiz.setTotalQuestion(rs.getInt("totalQuestion"));
                quiz.setCourseID(rs.getInt("courseID"));
                quiz.setPackageID(rs.getInt("packageID"));
                quiz.setStatus(rs.getBoolean("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                quiz.setUpdatedAt(rs.getTimestamp("updatedAt"));
                quizList.add(quiz);
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuizzesByCourseId: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return quizList;
    }
    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
    
    public boolean addQuiz(Quiz quiz) {
        String sql = "INSERT INTO Quiz (name, description, duration, passRate, totalQuestion, courseID, packageID, status, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, quiz.getName());
            ps.setString(2, quiz.getDescription());
            ps.setInt(3, quiz.getDuration());
            ps.setDouble(4, quiz.getPassRate());
            ps.setInt(5, quiz.getTotalQuestion());
            ps.setInt(6, quiz.getCourseID());
            ps.setInt(7, quiz.getPackageID());
            ps.setBoolean(8, quiz.isStatus());
            ps.setTimestamp(9, quiz.getCreatedAt());
            ps.setTimestamp(10, quiz.getUpdatedAt());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error in addQuiz: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public int getLatestQuizId() {
        String sql = "SELECT TOP 1 quizID FROM Quiz ORDER BY quizID DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("quizID");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    
    public int countQuizByCourseId(int courseId) {
        String sql = "SELECT COUNT(Q.QuizID) AS QuizCount FROM Quiz Q WHERE Q.CourseID = ?";
        int quizCount = 0;

        try{
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet resultSet = st.executeQuery();

            if (resultSet.next()) {
                quizCount = resultSet.getInt("QuizCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizCount;
    }
    
    public List<Quiz> getFilteredQuizzes(int courseId, int packageId, Boolean status) {
        List<Quiz> quizzes = new ArrayList<>();
        
        try {
            StringBuilder sql = new StringBuilder("SELECT q.*, c.Title as CourseTitle, p.Name as PackageName FROM Quiz q ");
            sql.append("LEFT JOIN Course c ON q.CourseID = c.CourseID ");
            sql.append("LEFT JOIN Packages p ON q.PackageID = p.PackageID ");
            sql.append("WHERE 1=1 ");
            
            if (courseId > 0) {
                sql.append("AND q.CourseID = ? ");
            }
            
            if (packageId > 0) {
                sql.append("AND q.PackageID = ? ");
            }
            
            if (status != null) {
                sql.append("AND q.Status = ? ");
            }
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            if (courseId > 0) {
                statement.setInt(paramIndex++, courseId);
            }
            
            if (packageId > 0) {
                statement.setInt(paramIndex++, packageId);
            }
            
            if (status != null) {
                statement.setBoolean(paramIndex++, status);
            }
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = Quiz.builder()
                        .quizID(rs.getInt("QuizID"))
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .duration(rs.getInt("Duration"))
                        .passRate(rs.getDouble("PassRate"))
                        .totalQuestion(rs.getInt("TotalQuestion"))
                        .courseID(rs.getInt("CourseID"))
                        .packageID(rs.getInt("PackageID"))
                        .status(rs.getBoolean("Status"))
                        .build();
                
                // Set course and package
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("CourseTitle"));
                quiz.setCourse(course);
                
                Packages packages = new Packages();
                packages.setPackageID(rs.getInt("PackageID"));
                packages.setName(rs.getString("PackageName"));
                quiz.setPackages(packages);
                
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            System.out.println("Error getting filtered quizzes: " + e.getMessage());
        }
        
        return quizzes;
    }
    
    // Phương thức mới để lấy tổng số quiz theo bộ lọc
    public int getTotalFilteredQuizzes(int courseId, int packageId, Boolean status) {
        int total = 0;
        
        try {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM Quiz q ");
            sql.append("WHERE 1=1 ");
            
            if (courseId > 0) {
                sql.append("AND q.CourseID = ? ");
            }
            
            if (packageId > 0) {
                sql.append("AND q.PackageID = ? ");
            }
            
            if (status != null) {
                sql.append("AND q.Status = ? ");
            }
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            if (courseId > 0) {
                statement.setInt(paramIndex++, courseId);
            }
            
            if (packageId > 0) {
                statement.setInt(paramIndex++, packageId);
            }
            
            if (status != null) {
                statement.setBoolean(paramIndex++, status);
            }
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total filtered quizzes: " + e.getMessage());
        }
        
        return total;
    }
    
    // Phương thức mới để lấy quiz theo phân trang và bộ lọc
    public List<Quiz> getFilteredQuizzesWithPaging(int courseId, int packageId, Boolean status, int page, int pageSize) {
        List<Quiz> quizzes = new ArrayList<>();
        
        try {
            StringBuilder sql = new StringBuilder("SELECT q.*, c.Title as CourseTitle, p.Name as PackageName FROM Quiz q ");
            sql.append("LEFT JOIN Course c ON q.CourseID = c.CourseID ");
            sql.append("LEFT JOIN Packages p ON q.PackageID = p.PackageID ");
            sql.append("WHERE 1=1 ");
            
            if (courseId > 0) {
                sql.append("AND q.CourseID = ? ");
            }
            
            if (packageId > 0) {
                sql.append("AND q.PackageID = ? ");
            }
            
            if (status != null) {
                sql.append("AND q.Status = ? ");
            }
            
            // Thêm phân trang
            sql.append("ORDER BY q.QuizID DESC ");
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            if (courseId > 0) {
                statement.setInt(paramIndex++, courseId);
            }
            
            if (packageId > 0) {
                statement.setInt(paramIndex++, packageId);
            }
            
            if (status != null) {
                statement.setBoolean(paramIndex++, status);
            }
            
            // Thiết lập tham số phân trang
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex++, pageSize);
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = Quiz.builder()
                        .quizID(rs.getInt("QuizID"))
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .duration(rs.getInt("Duration"))
                        .passRate(rs.getDouble("PassRate"))
                        .totalQuestion(rs.getInt("TotalQuestion"))
                        .courseID(rs.getInt("CourseID"))
                        .packageID(rs.getInt("PackageID"))
                        .status(rs.getBoolean("Status"))
                        .build();
                
                // Set course and package
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("CourseTitle"));
                quiz.setCourse(course);
                
                Packages packages = new Packages();
                packages.setPackageID(rs.getInt("PackageID"));
                packages.setName(rs.getString("PackageName"));
                quiz.setPackages(packages);
                
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            System.out.println("Error getting filtered quizzes with paging: " + e.getMessage());
        }
        
        return quizzes;
    }
    
    public boolean updateQuiz(Quiz quiz) {
        String sql = "UPDATE Quiz SET Name = ?, Description = ?, Duration = ?, "
                + "PassRate = ?, TotalQuestion = ?, Status = ?, "
                + "updatedAt = ?, CourseID = ?, PackageID = ? "
                + "WHERE QuizID = ?";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, quiz.getName());
            ps.setString(2, quiz.getDescription());
            ps.setInt(3, quiz.getDuration());
            ps.setDouble(4, quiz.getPassRate());
            ps.setInt(5, quiz.getTotalQuestion());
            ps.setBoolean(6, quiz.isStatus());
            ps.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
            ps.setInt(8, quiz.getCourseID());
            ps.setInt(9, quiz.getPackageID());
            ps.setInt(10, quiz.getQuizID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public boolean deleteQuiz(int quizID) {
        String sql = "DELETE FROM Quiz WHERE QuizID = ?";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quizID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public static void main(String[] args) {
        QuizDAO quizDAO = new QuizDAO();
        int quiz = quizDAO.countQuizByCourseId(1);
        System.out.println(quiz);
    }
}
