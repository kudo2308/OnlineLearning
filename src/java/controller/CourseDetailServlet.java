package controller;

import DAO.CourseDAO;
import DAO.LessonDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Lesson;
import java.util.List;

@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/course/*"})
public class CourseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/course");
            return;
        }

        try {
            // Extract courseId from path
            String[] pathParts = pathInfo.split("/");
            int courseId = Integer.parseInt(pathParts[1]);
            int lessonId = Integer.parseInt(pathParts[2]);
             
            // Get course details
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/course");
                return;
            }

            // Get lessons for this course
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.findLessonById(lessonId);

            // Set attributes for the JSP
            request.setAttribute("course", course);
            request.setAttribute("lessons", lesson);

            // Forward to the course detail page
            request.getRequestDispatcher("/views/course/CourseDetail.jsp").forward(request, response);

        } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
            response.sendRedirect(request.getContextPath() + "/course");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
