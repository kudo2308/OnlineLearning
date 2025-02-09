package controller;

import DAO.CourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/coursedetails"})
public class CourseDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy courseId từ parameter
            String courseIdStr = request.getParameter("id");
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                throw new ServletException("Course ID is required");
            }
            
            int courseId = Integer.parseInt(courseIdStr);
            
            // Lấy thông tin chi tiết khóa học
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseById(courseId);
            
            if (course == null) {
                throw new ServletException("Course not found");
            }
            
            // Lấy các khóa học liên quan (cùng category)
            int categoryId = course.getCategoryID();
            int currentPage = 1;
            int recordsPerPage = 3; // Số khóa học liên quan muốn hiển thị
            int offset = 0;
            
            request.setAttribute("course", course);
            request.setAttribute("relatedCourses", courseDAO.getCoursesByCategory(categoryId, offset, recordsPerPage));
            
            // Forward to course detail page
            request.getRequestDispatcher("views/course/CourseDetail.jsp").forward(request, response);
              
        } catch (Exception e) {
            System.out.println("Error in CourseDetailServlet: " + e.getMessage());
            request.getRequestDispatcher("public/404.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Course Detail Servlet";
    }
}
