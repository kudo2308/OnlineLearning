/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;
import java.sql.Timestamp;
import model.Course;
import model.Packages;


public class LessonDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Lesson> listLesson;
    private Connection connection;

    public LessonDAO() {
        listLesson = new ArrayList<>();
        if (connection == null) {
            connection = new DBContext().getConnection();
        }
    }

    public Lesson findLessonById(int id) {
        String sql = "select * from Lesson l\n"
                + "join Course c\n"
                + "on l.CourseID = c.CourseID\n"
                + "join Packages p \n"
                + "on l.PackageID = p.PackageID\n"
                + "where l.LessonID = ?";
        try {
            ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            rs = ps.executeQuery();

            if (rs.next()) {
                int lessionID = rs.getInt("LessonID");
                String title = rs.getString("Title");
                String content = rs.getString("Content");
                String lesstionType = rs.getString("LessonType");
                String videoUrl = rs.getString("VideoUrl");
                String documentUrl = rs.getString("DocumentUrl");
                int duration = rs.getInt("Duration");
                int orderNumber = rs.getInt("OrderNumber");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");

                // get infor course
                int courseId = rs.getInt("CourseID");
                String titleCourse = rs.getString(15);

                //get infor package
                int packageId = rs.getInt("PackageID");
                String name = rs.getString("Name");

                // built object course
                Course course = new Course();
                course.setCourseID(courseId);
                course.setTitle(titleCourse);

                //built object packages
                Packages packages = Packages.builder()
                        .packageID(packageId)
                        .name(name)
                        .build();

                Lesson lesson = new Lesson(lessionID, title, content,
                        lesstionType, videoUrl, documentUrl,
                        duration, orderNumber, courseId, status,
                        createdAt, updatedAt, course, packages);

                return lesson;

            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return null;
    }

    public List<Lesson> findAll() {
        String sql = "select * from Lesson l\n"
                + "join Course c\n"
                + "on l.CourseID = c.CourseID\n"
                + "join Packages p\n"
                + "on l.PackageID = p.PackageID";
        try {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {
                int lessionID = rs.getInt("LessonID");
                String title = rs.getString("Title");
                String content = rs.getString("Content");
                String lesstionType = rs.getString("LessonType");
                String videoUrl = rs.getString("VideoUrl");
                String documentUrl = rs.getString("DocumentUrl");
                int duration = rs.getInt("Duration");
                int orderNumber = rs.getInt("OrderNumber");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");

                // get infor course
                int courseId = rs.getInt("CourseID");
                String titleCourse = rs.getString(15);

                //get infor package
                int packageId = rs.getInt("PackageID");
                String name = rs.getString("Name");

                // built object course
                Course course = new Course();
                course.setCourseID(courseId);
                course.setTitle(titleCourse);

                //built object packages
                Packages packages = Packages.builder()
                        .packageID(packageId)
                        .name(name)
                        .build();

                Lesson lesson = new Lesson(lessionID, title, content,
                        lesstionType, videoUrl, documentUrl,
                        duration, orderNumber, courseId, status,
                        createdAt, updatedAt, course, packages);

                listLesson.add(lesson);

            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return listLesson;
    }

    public boolean addLesson(Lesson lesson) {
        String sql = "INSERT INTO [dbo].[Lesson]\n"
                + "           ([Title]\n"
                + "           ,[Content]\n"
                + "           ,[LessonType]\n"
                + "           ,[VideoUrl]\n"
                + "           ,[DocumentUrl]\n"
                + "           ,[Duration]\n"
                + "           ,[OrderNumber]\n"
                + "           ,[CourseID]\n"
                + "           ,[Status]\n"
                + "           ,[UpdatedAt]\n"
                + "           ,[PackageID])\n"
                + "     VALUES\n"
                + "           (?,?,?,?,?,?,?,?,?,?,?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setString(3, lesson.getLessonType());
            ps.setString(4, lesson.getVideoUrl());
            ps.setString(5, lesson.getDocumentUrl());
            ps.setInt(6, lesson.getDuration());
            ps.setInt(7, lesson.getOrderNumber());
            ps.setInt(8, lesson.getCourseID());
            ps.setBoolean(9, lesson.isStatus());
            ps.setTimestamp(10, lesson.getUpdatedAt());
            ps.setInt(11, lesson.getPackages().getPackageID());
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    public boolean updateLesson(Lesson lesson) {
        String sql = "UPDATE [dbo].[Lesson]\n"
                + "   SET [Title] = ?\n"
                + "      ,[Content] = ?\n"
                + "      ,[LessonType] = ?\n"
                + "      ,[VideoUrl] = ?\n"
                + "      ,[DocumentUrl] = ?\n"
                + "      ,[Duration] = ?\n"
                + "      ,[OrderNumber] = ?\n"
                + "      ,[CourseID] = ?\n"
                + "      ,[Status] = ?\n"
                + "      ,[CreatedAt] = ?\n"
                + "      ,[UpdatedAt] = ?\n"
                + "      ,[PackageID] = ?\n"
                + " WHERE [LessonID] = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setString(3, lesson.getLessonType());
            ps.setString(4, lesson.getVideoUrl());
            ps.setString(5, lesson.getDocumentUrl());
            ps.setInt(6, lesson.getDuration());
            ps.setInt(7, lesson.getOrderNumber());
            ps.setInt(8, lesson.getCourseID());
            ps.setBoolean(9, lesson.isStatus());
            ps.setTimestamp(10, lesson.getCreatedAt());
            ps.setTimestamp(11, lesson.getUpdatedAt());
            ps.setInt(12, lesson.getPackages().getPackageID());
            ps.setInt(13, lesson.getLessonID());
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }
    
    public int countLessonsbyCourseId(int courseId) {
        String sql = "SELECT COUNT(L.LessonID) AS LessonCount FROM Lesson L WHERE L.CourseID = ?";
        int lessonCount = 0;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet resultSet = ps.executeQuery();

            if (resultSet.next()) {
                lessonCount = resultSet.getInt("LessonCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lessonCount;
    }
    
    public List<Lesson> getAllLessonByCourseId(int courseId) {
        List<Lesson> lessonList = new ArrayList<>();
        String sql = """
                    SELECT b.[LessonID]
                          ,b.[Title]
                          ,b.[Content]
                          ,b.[LessonType]
                          ,b.[VideoUrl]
                          ,b.[DocumentUrl]
                          ,b.[Duration]
                          ,b.[OrderNumber]
                          ,b.[CourseID]
                          ,b.[Status]
                          ,b.[CreatedAt]
                          ,b.[UpdatedAt]
                    FROM [dbo].[Lesson] b
                    WHERE b.[Status] = 1 and b.[CourseID] = ?
                    ORDER BY b.[LessonID]
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Lesson lesson = new Lesson();
                lesson.setLessonID(rs.getInt("LessonID"));
                lesson.setTitle(rs.getString("Title"));
                lesson.setContent(rs.getString("Content"));
                lesson.setLessonType(rs.getString("LessonType"));
                lesson.setVideoUrl(rs.getString("VideoUrl"));
                lesson.setDocumentUrl(rs.getString("DocumentUrl"));
                lesson.setDuration(rs.getInt("Duration"));
                lesson.setOrderNumber(rs.getInt("OrderNumber"));
                lesson.setCourseID(rs.getInt("CourseID"));
                lesson.setStatus(rs.getBoolean("Status"));
                lesson.setCreatedAt(rs.getTimestamp("CreatedAt"));
                lesson.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                lessonList.add(lesson);
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return lessonList;
    }
    public static void main(String[] args) {
        LessonDAO less = new LessonDAO();
        List<Lesson> lesssonList = less.getAllLessonByCourseId(1);
        int duration = 0;
        for (Lesson lesson : lesssonList) {
            duration += lesson.getDuration();
        }
        System.out.println(duration/60 + "." + duration%60/10);
        System.out.println(duration);
    }
}
