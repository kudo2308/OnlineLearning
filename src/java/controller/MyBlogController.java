/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import DAO.CategoryDAO;
import DAO.LoginDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Blog;
import model.Category;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "MyBlogController", urlPatterns = {"/myblog"})
public class MyBlogController extends HttpServlet {

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
            out.println("<title>Servlet MyBlogController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyBlogController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=Blog");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        CategoryDAO cateDAO = new CategoryDAO();
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        List<Category> cateList = cateDAO.findAll();
        BlogDAO blogDAO = new BlogDAO();
        List<Blog> blogList = blogDAO.getBlogByUserId(acc.getUserID());

        request.setAttribute("category", cateList);
        request.setAttribute("account", acc);
        request.setAttribute("blogList", blogList);
        request.getRequestDispatcher("/views/user/MyBlog.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        // Kiểm tra đăng nhập
        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=Blog");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        String action = request.getParameter("action");
        String blogIdStr = request.getParameter("blogId");

        // Kiểm tra nếu blogId bị null hoặc rỗng
        if (blogIdStr == null || blogIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myblog?error=missingBlogId");
            return;
        }

        int blogId = Integer.parseInt(blogIdStr);
        BlogDAO blogDAO = new BlogDAO();

        switch (action) {
            case "delete" -> {
                blogDAO.deleteBlog(blogId);
                response.sendRedirect(request.getContextPath() + "/myblog?message=deleted");
            }
            case "update" -> {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String categoryIdStr = request.getParameter("categoryId");
                String status = request.getParameter("status");

                // Kiểm tra nếu categoryId bị null
                if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/myblog?error=missingCategory");
                    return;
                }

                int categoryId = Integer.parseInt(categoryIdStr);

                // Xử lý ảnh nếu có tải lên
                Part filePart = request.getPart("imageUrl");
                String fileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = "uploads/" + filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("/") + fileName;
                    filePart.write(uploadPath);
                }

                Blog blog = blogDAO.getBlogByBlogId(blogId);
                if (blog != null) {
                    blog.setTitle(title);
                    blog.setContent(content);
                    blog.setCategoryID(categoryId);
                    blog.setStatus(status);
                    if (fileName != null) {
                        blog.setImgUrl(fileName);
                    }

                    blogDAO.updateBlog(blog);
                }

                response.sendRedirect(request.getContextPath() + "/myblog?message=updated");
            }
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

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();
        List<Blog> blogList = blogDAO.getBlogByUserId(2);
        for (Blog blog : blogList) {
            System.out.println(blog.getStatus());
        }

    }
}
