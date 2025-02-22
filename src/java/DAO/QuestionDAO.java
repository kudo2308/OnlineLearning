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
        List<Question> q = questionDAO.filterQuestions("Java", "Giới thiệu về Java", "Cơ Bản", true, "Which", 1);

        for (Question o : q) {
            System.out.println(o);
        }
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
                + "on qu.CourseID = c.CourseID\n"
                + "join Lesson l\n"
                + "on qu.LessonID = l.LessonID\n"
                + "where qu.[Status] = 1\n"
                + "Order by qu.QuestionID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(2, RECORD_PER_PAGE);
            rs = ps.executeQuery();
            while (rs.next()) {

                Quiz quiz = Quiz.builder()
                        .quizID(rs.getInt("QuizID"))
                        .name(rs.getString("Name"))
                        .build();

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString(21));

                Lesson lesson = Lesson.builder()
                        .lessonID(rs.getInt("LessonID"))
                        .title(rs.getString(32))
                        .lessonType(rs.getString(34))
                        .build();

                Question question = Question.builder()
                        .questionID(rs.getInt("QuestionID"))
                        .content(rs.getString("Content"))
                        .pointPerQuestion(rs.getInt("PointPerQuestion"))
                        .quizID(rs.getInt("QuizID"))
                        .status(rs.getBoolean("Status"))
                        .createdAt(rs.getTimestamp("CreatedAt"))
                        .updatedAt(rs.getTimestamp("UpdatedAt"))
                        .course(course)
                        .quiz(quiz)
                        .lession(lesson)
                        .build();
                listQuestion.add(question);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return listQuestion;
    }

    public List<Question> filterQuestions(String titleOfCourse, String titleOfLesson, String lessonType, boolean status, String searchContent, int page) {
        String sql = "select * from Question qu\n"
                + "join Quiz q\n"
                + "on qu.QuizID = q.QuizID\n"
                + "join Course c\n"
                + "on qu.CourseID = c.CourseID\n"
                + "join Lesson l\n"
                + "on qu.LessonID = l.LessonID\n"
                + "where qu.[Status] = ? and c.Title like ? \n"
                + "and l.Title like ? and \n"
                + "l.LessonType like ? and qu.Content like ?\n"
                + "Order by qu.QuestionID\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";
        try {
            ps = connection.prepareStatement(sql);

            ps.setBoolean(1, status);
            ps.setString(2, "%" + titleOfCourse + "%");
            ps.setString(3, "%" + titleOfLesson + "%");
            ps.setString(4, "%" + lessonType + "%");
            ps.setString(5, "%" + searchContent + "%");
            ps.setInt(6, (page - 1) * RECORD_PER_PAGE);
            ps.setInt(7, RECORD_PER_PAGE);

            rs = ps.executeQuery();

            while (rs.next()) {

                Quiz quiz = Quiz.builder()
                        .quizID(rs.getInt("QuizID"))
                        .name(rs.getString("Name"))
                        .build();

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString(21));

                Lesson lessonObj = Lesson.builder()
                        .lessonID(rs.getInt("LessonID"))
                        .title(rs.getString(32))
                        .lessonType(rs.getString(34))
                        .build();

                Question question = Question.builder()
                        .questionID(rs.getInt("QuestionID"))
                        .content(rs.getString("Content"))
                        .pointPerQuestion(rs.getInt("PointPerQuestion"))
                        .quizID(rs.getInt("QuizID"))
                        .status(rs.getBoolean("Status"))
                        .createdAt(rs.getTimestamp("CreatedAt"))
                        .updatedAt(rs.getTimestamp("UpdatedAt"))
                        .course(course)
                        .quiz(quiz)
                        .lession(lessonObj)
                        .build();
                listQuestion.add(question);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return listQuestion;
    }

    public boolean addQuestion(Question question) {
        String sql = "INSERT INTO [dbo].[Question] ([Content], [PointPerQuestion], [QuizID], [Status], [CreatedAt], [UpdatedAt], [CourseID], [LessonID]) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);

            ps.setString(1, question.getContent());
            ps.setInt(2, question.getPointPerQuestion());
            ps.setInt(3, question.getQuizID());
            ps.setBoolean(4, question.isStatus());
            ps.setTimestamp(5, question.getCreatedAt());
            ps.setTimestamp(6, question.getUpdatedAt());
            ps.setInt(7, question.getCourse().getCourseID());
            ps.setInt(8, question.getLession().getLessonID());

            int rowAff = ps.executeUpdate();

            return rowAff > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }
}