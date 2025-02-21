/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.SQLException;
import DBContext.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author dohie
 */
public class LessonDAO extends DBContext {

    public List<Lesson> getListLessonByPage(List<Lesson> list, int start, int end) {
        List<Lesson> arr = new ArrayList<>();
        for (int i = start; i < end; ++i) {
            arr.add(list.get(i));
        }
        return arr;
    }

    public int getNewLessonId() {
        int id = 0;
        try {
            PreparedStatement st = connection.prepareStatement("SELECT IDENT_CURRENT('lessons')");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                id = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }

    public List<Lesson> getLessonByCourseId(int courseId) {
        Lesson lesson = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lesson> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM lessons WHERE course_id = ? AND status = 1";
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, courseId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                lesson = new Lesson();
                lesson.setLessonID(rs.getInt("lesson_id"));
                lesson.setCourseID(rs.getInt("course_id"));            
                lesson.setTitle(rs.getString("title"));
                lesson.setContent(rs.getString("content"));
                lesson.setLessonType(rs.getString("lesson_type"));
                lesson.setDuration(rs.getInt("duration"));
                lesson.setOrderNumber(rs.getInt("order_number"));
                lesson.setStatus(rs.getBoolean("status"));
                lesson.setCreatedAt(rs.getDate("created_at"));
                lesson.setUpdatedAt(rs.getDate("updated_at"));
                list.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Lesson getLessonById(int lessonId) {
        Lesson lesson = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM lessons WHERE lesson_id = ? AND status = 1";
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, lessonId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                lesson = new Lesson();
                lesson.setLessonID(rs.getInt("lesson_id"));
                lesson.setCourseID(rs.getInt("course_id"));            
                lesson.setTitle(rs.getString("title"));
                lesson.setContent(rs.getString("content"));
                lesson.setLessonType(rs.getString("lesson_type"));
                lesson.setDuration(rs.getInt("duration"));
                lesson.setOrderNumber(rs.getInt("order_number"));
                lesson.setStatus(rs.getBoolean("status"));
                lesson.setCreatedAt(rs.getDate("created_at"));
                lesson.setUpdatedAt(rs.getDate("updated_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lesson;
    }

    public void updateLesson(Lesson lesson) {
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE lessons SET title=?, content=?, lesson_type=?, duration=?, " +
                        "order_number=?, course_id=?, status=?, updated_at=GETDATE() " +
                        "WHERE lesson_id=?";

            stmt = connection.prepareStatement(sql);
            stmt.setString(1, lesson.getTitle());
            stmt.setString(2, lesson.getContent());
            stmt.setString(3, lesson.getLessonType());
            stmt.setInt(4, lesson.getDuration());
            stmt.setInt(5, lesson.getOrderNumber());
            stmt.setInt(6, lesson.getCourseID());
            stmt.setBoolean(7, lesson.isStatus());
            stmt.setInt(8, lesson.getLessonID());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void createLesson(Lesson lesson) {
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO lessons (course_id, title, content, lesson_type, duration, " +
                        "order_number, status, created_at, updated_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, lesson.getCourseID());
            stmt.setString(2, lesson.getTitle());
            stmt.setString(3, lesson.getContent());
            stmt.setString(4, lesson.getLessonType());
            stmt.setInt(5, lesson.getDuration());
            stmt.setInt(6, lesson.getOrderNumber());
            stmt.setBoolean(7, lesson.isStatus());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        LessonDAO lDAO = new LessonDAO();
        System.out.println(lDAO.getLessonById(6).getTitle());
    }
}
