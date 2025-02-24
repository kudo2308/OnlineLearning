/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import DAO.CategoryDAO;
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
import model.Blog;
import model.Category;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "BlogController", urlPatterns = {"/Blog"})
public class BlogController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1; // Trang mặc định
        int recordsPerPage = 6; // Số bài viết mỗi trang

        // Nhận tham số từ request
        String pageParam = request.getParameter("page");
        String categoryIdParam = request.getParameter("categoryId");
        String keyword = request.getParameter("search");

        // Chuyển đổi `page` từ String sang int
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Chuyển đổi `categoryId` từ String sang int
        int categoryId = 0; // 0 = lấy tất cả danh mục (All Categories)
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }

        // Tính toán offset để phân trang
        int offset = (page - 1) * recordsPerPage;

        // Khởi tạo DAO
        CategoryDAO categoryDAO = new CategoryDAO();
        BlogDAO blogDAO = new BlogDAO();

        // Lấy danh sách danh mục
        List<Category> categoryList = categoryDAO.findAll();

        // Lấy danh sách blog theo danh mục (nếu có)
        List<Blog> blogs;

        if (categoryId > 0) {
            // 🔹 Nếu có danh mục được chọn, lấy blog theo danh mục
            blogs = blogDAO.getBlogByCategoryId(categoryId);
        } else {
            // 🔹 Nếu chọn "All Categories" (categoryId = 0), lấy toàn bộ blog
            blogs = blogDAO.getAllBlogs(0, Integer.MAX_VALUE);
        }

        // 🔹 Nếu có từ khóa tìm kiếm, lọc danh sách bằng `stream()`
        if (keyword != null && !keyword.trim().isEmpty()) {
            blogs = blogs.stream()
                    .filter(blog -> blog.getTitle().toLowerCase().contains(keyword.toLowerCase()))
                    .collect(Collectors.toList());
        }

        // Tính tổng số bài viết sau khi lọc
        int totalBlogs = blogs.size();
        int totalPages = (int) Math.ceil((double) totalBlogs / recordsPerPage);

        // 🔹 Cắt danh sách blog theo trang (phân trang sau khi lọc)
        int toIndex = Math.min(offset + recordsPerPage, totalBlogs);
        if (offset < totalBlogs) {
            blogs = blogs.subList(offset, toIndex);
        } else {
            blogs = List.of(); // Tránh lỗi IndexOutOfBoundsException
        }

        // Đưa dữ liệu vào request
        request.setAttribute("blogs", blogs);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("categories", categoryList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("selectedCategory", categoryId);

        // Forward đến trang blog
        request.getRequestDispatcher("views/user/BlogClassic.jsp").forward(request, response);
    }
}





