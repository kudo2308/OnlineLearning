package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Answer;
import DBContext.DBContext;

public class AnswerDAO {
    private DBContext db;
    
    public AnswerDAO() {
        db = new DBContext();
    }
    
    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        String sql = "SELECT answerID, content, isCorrect, Explanation, questionID FROM Answer WHERE questionID = ?";
        
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("Getting answers for question " + questionId);
            
            while (rs.next()) {
                int answerId = rs.getInt("answerID");
                String content = rs.getString("content");
                boolean isCorrect = rs.getBoolean("isCorrect");
                String explanation = rs.getString("Explanation");
                
                System.out.println("Found answer: " + answerId + " - " + content);
                
                Answer answer = Answer.builder()
                        .answerID(answerId)
                        .content(content)
                        .isCorrect(isCorrect)
                        .explanation(explanation)
                        .questionID(questionId)
                        .build();
                answers.add(answer);
            }
            
            if (answers.isEmpty()) {
                System.out.println("No answers found for question " + questionId);
            } else {
                System.out.println("Total answers found: " + answers.size());
            }
            
            rs.close();
            ps.close();
            
        } catch (SQLException e) {
            System.out.println("Error getting answers for question " + questionId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return answers;
    }
    
    public List<Answer> getCorrectAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        String sql = "SELECT * FROM Answer WHERE questionID = ? AND isCorrect = 1";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Answer answer = Answer.builder()
                    .answerID(rs.getInt("answerID"))
                    .content(rs.getString("content"))
                    .isCorrect(rs.getBoolean("isCorrect"))
                    .explanation(rs.getString("Explanation")) // Thêm trường Explanation
                    .questionID(rs.getInt("questionID"))
                    .build();
                answers.add(answer);
            }
        } catch (SQLException e) {
            System.out.println("Error getting correct answers: " + e.getMessage());
        }
        
        return answers;
    }
    
    public int addAnswer(Answer answer) {
        String sql = "INSERT INTO Answer (content, isCorrect, explanation, questionID) VALUES (?, ?, ?, ?)";
        int generatedId = 0;
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, answer.getContent());
            ps.setBoolean(2, answer.isCorrect());
            ps.setString(3, answer.getExplanation());
            ps.setInt(4, answer.getQuestionID());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding answer: " + e.getMessage());
        }
        
        return generatedId;
    }
}
