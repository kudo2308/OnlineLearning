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
import java.util.List;
import model.Blog;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "BlogController", urlPatterns = {"/Blog"})
public class BlogController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 2;
        int recordsPerPage = 3;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

// Tính toán offset cho truy vấn
        int offset = (page - 1) * recordsPerPage;

// Khởi tạo DAO
        BlogDAO blogDAO = new BlogDAO();

// Lấy danh sách bài viết với phân trang
        List<Blog> blogList = blogDAO.getAllBlogs(offset, recordsPerPage);

// Lấy tổng số bài viết để tính số trang
        int totalBlogs = blogDAO.getTotalBlogs();
        int totalPages = (int) Math.ceil((double) totalBlogs / recordsPerPage);

// Đưa dữ liệu vào request
        request.setAttribute("blogs", blogList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

// Forward đến trang blogclassic.jsp
        request.getRequestDispatcher("views/user/BlogClassic.jsp").forward(request, response);
    }

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();

        List<Blog> blogs = blogDAO.getAllBlogs(0, 9);
        for (Blog course : blogs) {
            System.out.println(course.getTitle() + course.getImgUrl());
        }
    }
}
