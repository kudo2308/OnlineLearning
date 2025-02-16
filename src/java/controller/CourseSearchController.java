/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CourseSearchController", urlPatterns = {"/CourseSearch"})
public class CourseSearchController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    int page = 1; // Mặc định là trang đầu tiên
    int recordsPerPage = 6;

    String keyword = request.getParameter("search");
    String pageParam = request.getParameter("page");

    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            page = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            page = 1; // Nếu có lỗi, quay về trang đầu
        }
    }

    int offset = (page - 1) * recordsPerPage;
    CourseDAO courseDAO = new CourseDAO();
    
    // Lấy tất cả khóa học từ database
    List<Course> allCourses = courseDAO.getAllCourses(0, Integer.MAX_VALUE);

    // Lọc danh sách khóa học theo từ khóa tìm kiếm
    List<Course> filteredCourses = allCourses;
    if (keyword != null && !keyword.trim().isEmpty()) {
        filteredCourses = allCourses.stream()
            .filter(course -> course.getTitle().toLowerCase().contains(keyword.toLowerCase()))
            .toList();
    }

    // Lấy số lượng khóa học sau khi lọc
    int totalCourses = filteredCourses.size();
    int totalPages = (int) Math.ceil((double) totalCourses / recordsPerPage);

    // Phân trang danh sách sau khi lọc
    int startIndex = (page - 1) * recordsPerPage;
    int endIndex = Math.min(startIndex + recordsPerPage, totalCourses);
    List<Course> paginatedCourses = filteredCourses.subList(startIndex, endIndex);

    request.setAttribute("courses", paginatedCourses);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPage", page);
    request.setAttribute("searchKeyword", keyword); // Lưu từ khóa tìm kiếm để hiển thị lại trên giao diện
    request.getRequestDispatcher("/views/course/Courses.jsp").forward(request, response);
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

}
