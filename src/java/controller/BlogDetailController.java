/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.Blog;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "BlogDetail", urlPatterns = {"/BlogDetail"})
public class BlogDetailController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BlogDetail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BlogDetail at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blogIdParam = request.getParameter("blogId");
        
        int blogId = 0;
        if (blogIdParam != null && !blogIdParam.isEmpty()) {
            try {
                blogId = Integer.parseInt(blogIdParam);
            } catch (NumberFormatException e) {
                request.getRequestDispatcher("/public/404.jsp").forward(request, response);
            }
        }
        // Get blog details
        BlogDAO blogDAO = new BlogDAO();
        Blog blogDetail = blogDAO.getBlogByBlogId(blogId);
        List<Blog> relatedBlogs = blogDAO.getBlogByCategoryId(blogDetail.getCategoryID())
                .stream()
                .filter(blog -> blog.getBlogId() != blogDetail.getBlogId()) // Loại bỏ blog hiện tại
                .limit(3)
                .collect(Collectors.toList());

        List<Blog> recentBlogs = blogDAO.getAllRecentBlogs()
                .stream()
                .filter(blog -> blog.getBlogId() != blogDetail.getBlogId()) // Loại bỏ bài hiện tại
                .sorted((b1, b2) -> b2.getCreateAt().compareTo(b1.getCreateAt())) // Sắp xếp bài mới nhất lên đầu
                .limit(3) // Hiển thị tối đa 5 bài gần nhất
                .collect(Collectors.toList());
        

        // Set attributes for the JSP
        request.setAttribute("blog", blogDetail);
        request.setAttribute("relatedBlogs", relatedBlogs);
        request.setAttribute("recentBlogs", recentBlogs);

        // Forward to the course detail page
        request.getRequestDispatcher("/views/user/BlogDetail.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.getBlogByBlogId(1);
        List<Blog> blogs = blogDAO.getBlogsByCategoryId(blog.getCategoryID(), 1, 3);
        for (Blog blog1 : blogs) {
            System.out.println(blog1.getTitle());
        }
    }
}
