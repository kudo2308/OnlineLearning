package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.LessonDAO;
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
import model.Lesson;

@WebServlet(name = "CourseServlet", urlPatterns = {"/course"})
public class CourseServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            CourseDAO dao = new CourseDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            LessonDAO lessonDAO = new LessonDAO();
            // Get search and filter parameters
            String searchQuery = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String sortBy = request.getParameter("sort"); // price, date, name
            
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
            int recordsPerPage = 4;
            int offset = (page - 1) * recordsPerPage;
            
            // Retrieve user email from session
            String userEmail = (String) request.getSession().getAttribute("userEmail");
            
            // Get courses by user email
            List<Course> userCourses = dao.getCourseByEmail(userEmail);
            request.setAttribute("userCourses", userCourses);

            // Get courses with categories
            List<Course> courseLst;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                courseLst = dao.searchCourse(searchQuery, offset, recordsPerPage);
            } else if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                courseLst = dao.getCoursesByCategories(Integer.parseInt(categoryFilter), offset, recordsPerPage);
            } else if (sortBy != null) {
                courseLst = dao.getSortedCourses(sortBy, offset, recordsPerPage);
            } else {
                courseLst = dao.getAllCourses(offset, recordsPerPage);
            }
            
            List<CourseWithCategory> lst = new ArrayList<>();
            for (Course course : courseLst) {
                Category category = categoryDAO.findById(course.getCategoryID());
                lst.add(new CourseWithCategory(course, category));
            }
            
            // Get total records for pagination based on filters
            int totalRecords;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                totalRecords = dao.getTotalSearchResults(searchQuery);
            } else if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                totalRecords = dao.getTotalCoursesByCategories(Integer.parseInt(categoryFilter));
            } else {
                totalRecords = dao.getTotalCourses();
            }
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            // Set attributes
            request.setAttribute("listcourse", lst);
            request.setAttribute("listallcategory", categoryDAO.findAll());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("sortBy", sortBy);
            
            request.getRequestDispatcher("/views/course/courseList.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in CourseServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading courses. Please try again later.");
            request.getRequestDispatcher("/views/course/courseList.jsp").forward(request, response);
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
