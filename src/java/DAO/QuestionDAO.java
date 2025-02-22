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
import model.Question;
import DBContext.DBContext;

/**
 *
 * @author dohie
 */
public class QuestionDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String query = "SELECT * FROM Question WHERE quizID = ? AND status = 1";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, quizId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Question question = Question.builder()
                    .questionID(rs.getInt("questionID"))
                    .content(rs.getString("content"))
                    .pointPerQuestion(rs.getInt("pointPerQuestion"))
                    .quizID(rs.getInt("quizID"))
                    .status(rs.getBoolean("status"))
                    .createdAt(rs.getTimestamp("createdAt"))
                    .updatedAt(rs.getTimestamp("updatedAt"))
                    .build();
                list.add(question);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            closeResources();
        }
        return list;
    }
    
    public Question getQuestionById(int questionId) {
        String query = "SELECT * FROM Question WHERE questionID = ? AND status = 1";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, questionId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return Question.builder()
                    .questionID(rs.getInt("questionID"))
                    .content(rs.getString("content"))
                    .pointPerQuestion(rs.getInt("pointPerQuestion"))
                    .quizID(rs.getInt("quizID"))
                    .status(rs.getBoolean("status"))
                    .createdAt(rs.getTimestamp("createdAt"))
                    .updatedAt(rs.getTimestamp("updatedAt"))
                    .build();
            }
        } catch (SQLException e) {
            System.out.println(e);
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
