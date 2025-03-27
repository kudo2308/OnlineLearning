package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.MyCourseDAO;
import DAO.RegistrationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Category;
import model.Course;
import model.CourseWithCategory;

@WebServlet(name = "MyCourseController", urlPatterns = {"/my-courses"})
public class MyCourseController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            MyCourseDAO myCourseDAO = new MyCourseDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            RegistrationDAO registrationDAO = new RegistrationDAO();
            // Get search and filter parameters
            
            String searchQuery = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String sortBy = request.getParameter("sort"); // price, date, name

            // Get page parameter
            String pageStr = request.getParameter("page");
            int page = 1;
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            // Calculate offset
            int recordsPerPage = 2;
            int offset = (page - 1) * recordsPerPage;

            // Get user information from session
            HttpSession session = request.getSession();
            Object accountObj = session.getAttribute("account");
            if (accountObj == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String userID = null;
            if (accountObj instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, String> accountData = (Map<String, String>) accountObj;
                userID = accountData.get("userId");
            }
            int userId = Integer.parseInt(userID);

            // Get student's enrolled courses
            List<Course> courseLst;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                courseLst = myCourseDAO.searchCourse(searchQuery, userId, offset, recordsPerPage);
            } else if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                courseLst = myCourseDAO.getCoursesByCategories(Integer.parseInt(categoryFilter), userId, offset, recordsPerPage);
            } else if (sortBy != null) {
                courseLst = myCourseDAO.getSortedCourses(sortBy, userId, offset, recordsPerPage);
            } else {
                courseLst = myCourseDAO.getCoursesByStudent(userId, offset, recordsPerPage);
            }
        // 1
            List<CourseWithCategory> lst = new ArrayList<>();
            for (Course course : courseLst) {
                Category category = categoryDAO.findById(course.getCategoryID());
                lst.add(new CourseWithCategory(course, category));
            }

            int totalRecords;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                totalRecords = myCourseDAO.getTotalEnrolledSearchResults(searchQuery, userId);
            } else if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                totalRecords = myCourseDAO.getTotalEnrolledCoursesByCategories(Integer.parseInt(categoryFilter), userId);
            } else {
                totalRecords = myCourseDAO.getTotalEnrolledCourses(userId);
            }
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // Set attributes
            request.setAttribute("enrolledCourses", lst);
            request.setAttribute("listallcategory", categoryDAO.findAll());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("pageTitle", "My Courses");

            request.getRequestDispatcher("/views/course/myCourseList.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in MyCourseController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading your courses. Please try again later.");
            request.getRequestDispatcher("/views/course/myCourseList.jsp").forward(request, response);
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
        return "My Course listing servlet";
    }
}
