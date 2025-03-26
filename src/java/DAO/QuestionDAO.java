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
import static constant.Constant.RECORD_PER_PAGE;
import model.Course;
import model.Lesson;
import model.Quiz;

/**
 *
 * @author dohie
 */
public class QuestionDAO {
    private PreparedStatement ps;
    private ResultSet rs;
    private Connection connection;
    private List<Question> listQuestion;
    public QuestionDAO() {
        listQuestion = new ArrayList<>();
        if (connection == null) {
            connection = new DBContext().getConnection();
        }
    }

    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String query = "SELECT * FROM Question WHERE quizID = ? AND status = 1";
        try {
            connection = new DBContext().getConnection();
            ps = connection.prepareStatement(query);
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
            connection = new DBContext().getConnection();
            ps = connection.prepareStatement(query);
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
    
    public boolean updateQuestion(Question question) {
        String query = "UPDATE Question SET content = ?, pointPerQuestion = ?, quizID = ?, status = ?, updatedAt = ? WHERE questionID = ?";
        try {
            connection = new DBContext().getConnection();
            // Kiểm tra kết nối
            if (connection == null) {
                System.out.println("Error: Unable to establish database connection");
                return false;
            }
            
            ps = connection.prepareStatement(query);
            ps.setString(1, question.getContent());
            ps.setInt(2, question.getPointPerQuestion());
            ps.setInt(3, question.getQuizID());
            ps.setBoolean(4, question.isStatus());
            ps.setTimestamp(5, question.getUpdatedAt());
            ps.setInt(6, question.getQuestionID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating question: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
    public static void main(String[] args) {
        QuestionDAO questionDAO = new QuestionDAO();
    }

    public int findTotalRecord() {
        String sql = "select count(q.QuestionID) from Question q\n"
                + "where q.[Status] = 1";
        try {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return -1;
    }

    public List<Question> findByPage(int page) {
        String sql = "select * from Question qu\n"
                + "join Quiz q\n"
                + "on qu.QuizID = q.QuizID\n"
                + "join Course c\n"
                + "on q.CourseID = c.CourseID\n"
                + "Order by qu.QuestionID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(2, RECORD_PER_PAGE);
            rs = ps.executeQuery();
            while (rs.next()) {
                Question question = buildQuestionFromResultSet(rs);
                listQuestion.add(question);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return listQuestion;
    }
    private Question buildQuestionFromResultSet(ResultSet rs) throws SQLException {
        Course course = Course.builder()
                .courseID(rs.getInt("CourseID"))
                .title(rs.getString(19))
                .build();

        Quiz quiz = Quiz.builder()
                .quizID(rs.getInt("QuizID"))
                .name(rs.getString("Name"))
                .courseID(rs.getInt("CourseID"))
                .course(course)
                .build();

        return Question.builder()
                .questionID(rs.getInt("QuestionID"))
                .content(rs.getString("Content"))
                .pointPerQuestion(rs.getInt("PointPerQuestion"))
                .quizID(rs.getInt("QuizID"))
                .status(rs.getBoolean("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .updatedAt(rs.getTimestamp("UpdatedAt"))
                .quiz(quiz)
                .build();
    }
    public List<Question> filterQuestions(String searchContent, String titleOfCourse,
            String titleOfQuiz, String status, String sortMode, int page) {
        StringBuilder sql = new StringBuilder("select * from Question qu\n"
                + "join Quiz q\n"
                + "on qu.QuizID = q.QuizID\n"
                + "join Course c\n"
                + "on q.CourseID = c.CourseID\n"
                + "where qu.Content like ? and c.Title like ? and q.[Name] like ? and qu.[Status] like ? \n"
                + "Order by qu.QuestionID ");

        if ("1".equals(sortMode)) {
            sql.append("desc\n");
        }

        sql.append("OFFSET ? ROWS\n");
        sql.append("FETCH NEXT ? ROWS ONLY");
        try {
            ps = connection.prepareStatement(sql.toString());

            ps.setString(1, "%" + searchContent + "%");
            ps.setString(2, "%" + titleOfCourse + "%");
            ps.setString(3, "%" + titleOfQuiz + "%");
            ps.setString(4, "%" + status + "%");
            ps.setInt(5, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(6, RECORD_PER_PAGE);

            rs = ps.executeQuery();

            while (rs.next()) {
                Question question = buildQuestionFromResultSet(rs);
                listQuestion.add(question);

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return listQuestion;
    }
    public List<Quiz> findAllQuiz() {
        List<Quiz> quizz = new ArrayList<>();

        String sql = "select * from Quiz";

        try {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {
                Quiz quiz = getQuizFromRs(rs);
                quizz.add(quiz);
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return quizz;
    }
    private Quiz getQuizFromRs(ResultSet rs) throws SQLException, Exception {
        Quiz quiz = Quiz.builder()
                .quizID(rs.getInt("QuizID"))
                .name(rs.getString("Name"))
                .description(rs.getString("Description"))
                .duration(rs.getInt("Duration"))
                .passRate(rs.getDouble("PassRate"))
                .totalQuestion(rs.getInt("TotalQuestion"))
                .status(rs.getBoolean("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .updatedAt(rs.getTimestamp("UpdatedAt"))
                .build();

        if (quiz != null) {
            return quiz;
        }
        throw new Exception("Quizz is null");

    }
    public int findTotalRecordByFilter(String searchContent, String titleOfCourse, String titleOfQuiz, String status) {
        int totalRecords = 0;
        String sql = "select count(*) as total from Question qu\n"
                + "join Quiz q\n"
                + "on qu.QuizID = q.QuizID\n"
                + "join Course c\n"
                + "on q.CourseID = c.CourseID\n"
                + "where qu.Content like ? and c.Title like ? and q.[Name] like ? and qu.[Status] like ?";

        try {

            ps = connection.prepareStatement(sql);

            ps.setString(1, "%" + searchContent + "%");
            ps.setString(2, "%" + titleOfCourse + "%");
            ps.setString(3, "%" + titleOfQuiz + "%");
            ps.setString(4, "%" + status + "%");

            rs = ps.executeQuery();

            if (rs.next()) {
                totalRecords = rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return totalRecords;
    }
    public int addQuestion(Question question) {
        String sql = "INSERT INTO Question (content, pointPerQuestion, quizID, status, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        int generatedId = 0;

        try {
            connection = new DBContext().getConnection();
            ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setString(1, question.getContent());
            ps.setInt(2, question.getPointPerQuestion());
            ps.setInt(3, question.getQuizID());
            ps.setBoolean(4, question.isStatus());
            ps.setTimestamp(5, question.getCreatedAt());
            ps.setTimestamp(6, question.getUpdatedAt());

            System.out.println("Adding question: " + question.getContent());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    System.out.println("Generated question ID: " + generatedId);
                }
                rs.close();
            }

        } catch (SQLException e) {
            System.out.println("Error adding question: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return generatedId;
    }
}