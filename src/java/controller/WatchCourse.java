package controller;

import DAO.CourseDAO;
import DAO.LessonDAO;
import DAO.VideoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Lesson;
import model.Video;

public class WatchCourse extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/course");
            return;
        }

        // Extract courseId and lessonId from path
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 3) {
            response.sendRedirect(request.getContextPath() + "/course");
            return;
        }

        try {
            int courseId = Integer.parseInt(pathParts[1]);
            int lessonId = Integer.parseInt(pathParts[2]);

            // Get course and lesson details
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseById(courseId);
            
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/course");
                return;
            }

            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.findLessonById(lessonId);
            
            if (lesson == null || lesson.getLessonID()!= courseId) {
                response.sendRedirect(request.getContextPath() + "/course");
                return;
            }

            // Get video details if it's a video lesson
            if (lesson.getLessonType().equalsIgnoreCase("video")) {
                VideoDAO videoDAO = new VideoDAO();
                Video video = videoDAO.getVideoByLessonId(lessonId);
                request.setAttribute("video", video);
                request.getRequestDispatcher("/views/course/viewVideoLesson.jsp").forward(request, response);
            } 
            // Handle document lessons
            else if (lesson.getLessonType().equalsIgnoreCase("doc")) {
                request.getRequestDispatcher("/views/course/viewDocLesson.jsp").forward(request, response);
            }
            // Handle file lessons
            else if (lesson.getLessonType().equalsIgnoreCase("file")) {
                request.getRequestDispatcher("/views/course/viewFileLesson.jsp").forward(request, response);
            }
            // Redirect to course page for unknown lesson types
            else {
                response.sendRedirect(request.getContextPath() + "/course");
            }

            request.setAttribute("lesson", lesson);
            request.setAttribute("course", course);
            request.setAttribute("courseId", courseId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/course");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
