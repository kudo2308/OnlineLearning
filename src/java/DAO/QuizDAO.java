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
import model.Quiz;
import DBContext.DBContext;

/**
 *
 * @author dohie
 */
public class QuizDAO {
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
                quiz.setTimeLimit(rs.getInt("duration")); 
                quiz.setPassRate(rs.getDouble("passRate"));
                quiz.setTotalQuestion(rs.getInt("totalQuestion"));
                quiz.setCourseID(rs.getInt("courseID"));
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
    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
