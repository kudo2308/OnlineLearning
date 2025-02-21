package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Course;
import model.CourseWithCategory;

@WebServlet(name = "CourseServlet", urlPatterns = {"/courses"})
public class CourseServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            CourseDAO dao = new CourseDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            // Get page parameter
            String pageStr = request.getParameter("page");
            int page = 1;
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Calculate offset
            int recordsPerPage = 6;
            int offset = (page - 1) * recordsPerPage;
            
            // Get courses with categories
            List<Course> courseLst = dao.getAllCourses(offset, recordsPerPage);
            List<CourseWithCategory> lst = new ArrayList<>();
            for (Course course : courseLst) {
                Category category = categoryDAO.findById(course.getCategoryID());
                lst.add(new CourseWithCategory(course, category));
            }
            
            // Get total records for pagination
            int totalRecords = dao.getTotalCourses();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            // Set attributes
            request.setAttribute("listcourse", lst);
            request.setAttribute("listallcategory", categoryDAO.findAll());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            
            request.getRequestDispatcher("/views/course/OurCourse.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in CourseServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("public/404.jsp");
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
        return "Course listing servlet";
    }
}
