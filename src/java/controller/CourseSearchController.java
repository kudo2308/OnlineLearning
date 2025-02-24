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
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import model.Category;
import model.Course;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CourseSearchController", urlPatterns = {"/CourseSearch"})
public class CourseSearchController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int recordsPerPage = 9;

        String keyword = request.getParameter("search");
        String pageParam = request.getParameter("page");

        // Nhận giá trị lọc theo giá
        String minPriceString = request.getParameter("minPrice");
        String maxPriceString = request.getParameter("maxPrice");

        // Chuyển đổi minPrice và maxPrice thành kiểu số nếu có
        double minPrice = (minPriceString != null && !minPriceString.isEmpty()) ? Double.parseDouble(minPriceString) : 0;
        double maxPrice = (maxPriceString != null && !maxPriceString.isEmpty()) ? Double.parseDouble(maxPriceString) : Double.MAX_VALUE;

        // Lọc theo nhiều danh mục
        String[] categoryIds = request.getParameterValues("categoryId");

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        CourseDAO courseDAO = new CourseDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Category> categories = categoryDAO.findAll();
        List<Course> courses = courseDAO.getAllCourses(0, Integer.MAX_VALUE); // Lấy tất cả khóa học

        // Lọc theo nhiều danh mục
        if (categoryIds != null && categoryIds.length > 0) {
            List<Integer> selectedCategories = Arrays.stream(categoryIds)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            courses = courses.stream()
                    .filter(course -> selectedCategories.contains(course.getCategoryID()))
                    .collect(Collectors.toList());
        }
        // Lọc theo từ khóa
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            courses = courses.stream()
                    .filter(course -> course.getTitle().toLowerCase().contains(keyword.toLowerCase()))
                    .collect(Collectors.toList());
        }

        // Lọc theo giá
        courses = courses.stream()
                .filter(course -> course.getPrice() >= minPrice && course.getPrice() <= maxPrice)
                .collect(Collectors.toList());

        // Tổng số khóa học sau khi lọc
        int totalCourses = courses.size();
        int totalPages = (int) Math.ceil((double) totalCourses / recordsPerPage);

        // Phân trang danh sách sau khi lọc
        int startIndex = (page - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalCourses);
        List<Course> paginatedCourses = courses.subList(startIndex, endIndex);

        // Truyền dữ liệu về JSP
        request.setAttribute("categories", categories);
        request.setAttribute("courses", paginatedCourses);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedCategories", categoryIds); // Giữ các danh mục được chọn
        request.setAttribute("minPrice", minPrice); // Truyền minPrice
        request.setAttribute("maxPrice", maxPrice); // Truyền maxPrice

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
