package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.LessonProgress;
import DBContext.DBContext;
/**
 * Data Access Object for LessonProgress
 */
public class LessonProgressDAO extends DBContext {
    
    /**
     * Get a lesson progress record by user and lesson IDs
     * 
     * @param userId The user ID
     * @param lessonId The lesson ID
     * @return LessonProgress object if found, null otherwise
     */
    public LessonProgress getLessonProgressByUserAndLesson(int userId, int lessonId) {
        String sql = "SELECT * FROM LessonProgress WHERE UserID = ? AND LessonID = ?";
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLessonProgress(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting lesson progress: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get all lesson progress records for a user in a course
     * 
     * @param userId The user ID
     * @param courseId The course ID
     * @return List of LessonProgress objects
     */
    public List<LessonProgress> getLessonProgressByCourse(int userId, int courseId) {
        List<LessonProgress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM LessonProgress WHERE UserID = ? AND CourseID = ?";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    progressList.add(mapResultSetToLessonProgress(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting course progress: " + e.getMessage());
        }
        return progressList;
    }
    
    /**
     * Create a new lesson progress record
     * 
     * @param progress The LessonProgress object to create
     * @return true if successful, false otherwise
     */
    public boolean createLessonProgress(LessonProgress progress) {
        String sql = "INSERT INTO LessonProgress (LessonID, UserID, CourseID, Completed, CompletedAt, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, progress.getLessonID());
            ps.setInt(2, progress.getUserID());
            ps.setInt(3, progress.getCourseID());
            ps.setBoolean(4, progress.isCompleted());
            ps.setTimestamp(5, progress.isCompleted() ? new Timestamp(System.currentTimeMillis()) : null);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error creating lesson progress: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update an existing lesson progress record
     * 
     * @param progress The LessonProgress object to update
     * @return true if successful, false otherwise
     */
    public boolean updateLessonProgress(LessonProgress progress) {
        String sql = "UPDATE LessonProgress SET Completed = ?, CompletedAt = ? " +
                     "WHERE UserID = ? AND LessonID = ?";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, progress.isCompleted());
            ps.setTimestamp(2, progress.isCompleted() ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(3, progress.getUserID());
            ps.setInt(4, progress.getLessonID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating lesson progress: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Calculate the overall progress percentage for a course
     * 
     * @param userId The user ID
     * @param courseId The course ID
     * @return Progress percentage (0-100)
     */
    public int calculateCourseProgress(int userId, int courseId) {
        String sql = "SELECT COUNT(l.LessonID) AS totalLessons, " +
                     "COUNT(CASE WHEN lp.Completed = 1 THEN 1 END) AS completedLessons " +
                     "FROM Lesson l " +
                     "LEFT JOIN LessonProgress lp ON l.LessonID = lp.LessonID AND lp.UserID = ? " +
                     "WHERE l.CourseID = ?";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalLessons = rs.getInt("totalLessons");
                    int completedLessons = rs.getInt("completedLessons");
                    
                    if (totalLessons > 0) {
                        return (int) Math.round((double) completedLessons / totalLessons * 100);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error calculating course progress: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Check if all lessons in a package are completed by a user
     * 
     * @param userId The user ID
     * @param packageId The package ID
     * @return true if all lessons are completed, false otherwise
     */
    public boolean areAllLessonsInPackageCompleted(int userId, int packageId) {
        String sql = "SELECT COUNT(l.LessonID) AS totalLessons, " +
                    "SUM(CASE WHEN lp.Completed = 1 THEN 1 ELSE 0 END) AS completedLessons " +
                    "FROM Lesson l " +
                    "LEFT JOIN LessonProgress lp ON l.LessonID = lp.LessonID AND lp.UserID = ? " +
                    "WHERE l.PackageID = ?";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, packageId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalLessons = rs.getInt("totalLessons");
                    int completedLessons = rs.getInt("completedLessons");
                    
                    // Return true only if there are lessons in the package and all are completed
                    return totalLessons > 0 && totalLessons == completedLessons;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking package completion: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Map a ResultSet row to a LessonProgress object
     * 
     * @param rs The ResultSet
     * @return LessonProgress object
     * @throws SQLException if a database access error occurs
     */
    private LessonProgress mapResultSetToLessonProgress(ResultSet rs) throws SQLException {
        LessonProgress progress = new LessonProgress();
        progress.setProgressID(rs.getInt("ProgressID"));
        progress.setLessonID(rs.getInt("LessonID"));
        progress.setUserID(rs.getInt("UserID"));
        progress.setCourseID(rs.getInt("CourseID"));
        progress.setCompleted(rs.getBoolean("Completed"));
        progress.setCompletedAt(rs.getTimestamp("CompletedAt"));
        progress.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return progress;
    }
}
