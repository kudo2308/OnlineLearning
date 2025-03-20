/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import static constant.Constant.RECORD_PER_PAGE;
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
                    SELECT l.[LessonID]
                          ,l.[Title]
                          ,l.[Content]
                          ,l.[LessonType]
                          ,l.[VideoUrl]
                          ,l.[DocumentUrl]
                          ,l.[Duration]
                          ,l.[OrderNumber]
                          ,l.[CourseID]
                          ,l.[Status]
                          ,l.[CreatedAt]
                          ,l.[UpdatedAt]
                          ,l.[PackageID]
                          ,c.[Title] as CourseTitle
                    FROM [dbo].[Lesson] l
                    INNER JOIN [dbo].[Course] c ON l.[CourseID] = c.[CourseID]
                    WHERE l.[CourseID] = ? AND l.[Status] = 1
                    ORDER BY l.[OrderNumber] ASC, l.[LessonID] ASC
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
                lesson.setCourseID(courseId);
                lesson.setStatus(rs.getBoolean("Status"));
                lesson.setCreatedAt(rs.getTimestamp("CreatedAt"));
                lesson.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                // Set Course info
                Course course = new Course();
                course.setCourseID(courseId);
                course.setTitle(rs.getString("CourseTitle"));
                lesson.setCourse(course);
                
                // Set Package info
                Packages packages = new Packages();
                packages.setPackageID(rs.getInt("PackageID"));
                lesson.setPackages(packages);
                
                lessonList.add(lesson);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lessons by course ID: " + ex.getMessage());
            ex.printStackTrace();
        }
        return lessonList;
    }
    
    public List<Lesson> getLessonsByCourseId(int courseId) {
        List<Lesson> courseLessons = new ArrayList<>();
        String sql = "SELECT l.*, c.*, p.* FROM Lesson l "
                + "JOIN Course c ON l.CourseID = c.CourseID "
                + "JOIN Packages p ON l.PackageID = p.PackageID "
                + "WHERE l.CourseID = ? "
                + "ORDER BY l.OrderNumber ASC";
        System.out.println("Executing SQL: " + sql + " with courseId: " + courseId);
        
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            System.out.println("SQL executed successfully");

            while (rs.next()) {
                Lesson lesson = new Lesson();
                
                // Set lesson properties
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
                
                // Set Course information
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("c.Title"));
                course.setDescription(rs.getString("Description"));
                course.setImageUrl(rs.getString("ImageUrl"));
                course.setStatus(rs.getString("c.Status"));
                lesson.setCourse(course);
                
                // Set Package information
                Packages packages = new Packages();
                packages.setPackageID(rs.getInt("PackageID"));
                packages.setName(rs.getString("Name"));
                lesson.setPackages(packages);
                
                System.out.println("Found lesson: ID=" + lesson.getLessonID() 
                    + ", Title=" + lesson.getTitle() 
                    + ", Course=" + course.getTitle());
                
                courseLessons.add(lesson);
            }
        } catch (SQLException e) {
            System.out.println("Error in getLessonsByCourseId: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Returning " + courseLessons.size() + " lessons");
        return courseLessons;
    }
    
    public List<Lesson> getLessonsByCourseIdNew(int courseId) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT l.*, c.Title as CourseTitle, p.Name as PackageName FROM Lesson l "
                + "JOIN Course c ON l.CourseID = c.CourseID "
                + "JOIN Packages p ON l.PackageID = p.PackageID "
                + "WHERE l.CourseID = ? "
                + "ORDER BY l.OrderNumber ASC";
        
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();

            while (rs.next()) {
                int lessonID = rs.getInt("LessonID");
                String title = rs.getString("Title");
                String content = rs.getString("Content");
                String lessonType = rs.getString("LessonType");
                String videoUrl = rs.getString("VideoUrl");
                String documentUrl = rs.getString("DocumentUrl");
                int duration = rs.getInt("Duration");
                int orderNumber = rs.getInt("OrderNumber");
                boolean status = rs.getBoolean("Status");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");

                // Course info
                Course course = new Course();
                course.setCourseID(courseId);
                course.setTitle(rs.getString("CourseTitle"));

                // Package info
                int packageId = rs.getInt("PackageID");
                Packages packages = Packages.builder()
                        .packageID(packageId)
                        .name(rs.getString("PackageName"))
                        .build();

                Lesson lesson = new Lesson(lessonID, title, content,
                        lessonType, videoUrl, documentUrl,
                        duration, orderNumber, courseId, status,
                        createdAt, updatedAt, course, packages);

                lessons.add(lesson);
            }
        } catch (SQLException e) {
            System.out.println("Error getting lessons by course ID: " + e.getMessage());
        }
        return lessons;
    }
    
    public boolean updateLessonVideo(int lessonId, String videoUrl, int duration) {
        String sql = "UPDATE Lesson SET VideoUrl = ?, Duration = ?, UpdatedAt = GETDATE() WHERE LessonID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, videoUrl);
            ps.setInt(2, duration);
            ps.setInt(3, lessonId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating lesson video: " + e.getMessage());
            return false;
        }
    }
    
    public boolean lessonExists(int lessonId) {
        String sql = "SELECT COUNT(*) FROM Lesson WHERE LessonID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, lessonId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking lesson existence: " + e.getMessage());
        }
        return false;
    }

    public List<Lesson> getAllLessonByPackagesId(int packageId) {
        List<Lesson> lessonList = new ArrayList<>();
        String sql = """
                    SELECT l.[LessonID]
                          ,l.[Title]
                          ,l.[Content]
                          ,l.[LessonType]
                          ,l.[VideoUrl]
                          ,l.[DocumentUrl]
                          ,l.[Duration]
                          ,l.[OrderNumber]
                          ,l.[CourseID]
                          ,l.[Status]
                          ,l.[CreatedAt]
                          ,l.[UpdatedAt]
                          ,l.[PackageID]
                          ,c.[Title] as CourseTitle
                    FROM [dbo].[Lesson] l
                    INNER JOIN [dbo].[Course] c ON l.[CourseID] = c.[CourseID]
                    JOIN [dbo].[Packages] p ON l.[PackageID] = p.[PackageID]
                    WHERE l.[PackageID] = ? AND l.[Status] = 1
                    ORDER BY l.[OrderNumber] ASC, l.[LessonID] ASC
                    """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, packageId);
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
                lesson.setStatus(rs.getBoolean("Status"));
                lesson.setCreatedAt(rs.getTimestamp("CreatedAt"));
                lesson.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                // Set Package info
                Packages packages = new Packages();
                packages.setPackageID(rs.getInt("PackageID"));
                lesson.setPackages(packages);

                lessonList.add(lesson);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lessons by course ID: " + ex.getMessage());
            ex.printStackTrace();
        }
        return lessonList;
    }

    public static void main(String[] args) {
        LessonDAO less = new LessonDAO();
        List<Lesson> lesssonList = less.getAllLessonByPackagesId(1);

        for (Lesson lesson : lesssonList) {
            System.out.println(lesson);
        }
    }
}
