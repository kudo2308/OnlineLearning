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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;
import model.Account;
import model.Blog;
import model.Category;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "AddBlogController", urlPatterns = {"/AddBlogController"})
public class AddBlogController extends HttpServlet {

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
            out.println("<title>Servlet AddBlogController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddBlogController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set attributes for the JSP
        CategoryDAO cateDAO = new CategoryDAO();

        List<Category> cateList = cateDAO.findAll();
        request.setAttribute("categories", cateList);

        // Forward to the course detail page
        request.getRequestDispatcher("/views/user/BlogClassic.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String categoryIdStr = request.getParameter("categoryId");
        String imageUrl = request.getParameter("imageUrl"); // Đường dẫn ảnh (nếu có)

        // Lấy thông tin người dùng đăng nhập
        HttpSession session = request.getSession();
        Account author = (Account) session.getAttribute("account");

        // Kiểm tra nếu chưa đăng nhập
        if (author == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Kiểm tra dữ liệu đầu vào
        if (title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()
                || categoryIdStr == null || categoryIdStr.isEmpty()) {

            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("BlogClassic.jsp").forward(request, response);
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Danh mục không hợp lệ.");
            request.getRequestDispatcher("BlogClassic.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Blog
        
        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(author.getUserID()); // Lấy ID từ tài khoản đăng nhập
        blog.setCategoryID(categoryId);
        blog.setImgUrl(imageUrl);
        blog.setStatus(true); // Mặc định trạng thái là true

        // Gọi DAO để thêm blog vào database
        BlogDAO blogDAO = new BlogDAO();
        boolean isAdded = blogDAO.addBlog(blog);

        if (isAdded) {
            // Nếu thành công, chuyển hướng đến trang danh sách blog
            response.sendRedirect("BlogDetail.jsp");
        } else {
            // Nếu thất bại, thông báo lỗi
            request.setAttribute("errorMessage", "Thêm blog thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("BlogClassic.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
