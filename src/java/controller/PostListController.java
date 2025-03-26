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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import model.Account;
import model.Blog;
import model.Category;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "PostListController", urlPatterns = {"/postList"})
@MultipartConfig( // Cấu hình giới hạn kích thước file upload
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class PostListController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "web/assets/images/blog/recent-blog";

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=MyBlog");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalidAccount");
            return;
        }

        int page = 1; // Mặc định trang đầu tiên
        int recordsPerPage = 7; // Số bài viết mỗi trang

        // Lấy tham số từ request
        String pageParam = request.getParameter("page");
        String categoryIdParam = request.getParameter("categoryId");
        String keyword = request.getParameter("search");

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int categoryId = 0;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }
        
        int offset = (page - 1) * recordsPerPage;
        
        // Lấy thông báo lỗi/thành công từ URL
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        CategoryDAO categoryDAO = new CategoryDAO();
        BlogDAO blogDAO = new BlogDAO();
        List<Category> categoryList = categoryDAO.findAll();
        List<Blog> blogs;

        if (categoryId > 0) {
            blogs = blogDAO.getBlogByCategoryId(categoryId);
        } else {
            blogs = blogDAO.getAllBlogsAdmin();
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            blogs = blogs.stream()
                    .filter(blog -> blog.getTitle().toLowerCase().contains(keyword.toLowerCase()))
                    .collect(Collectors.toList());
        }

        int totalBlogs = blogs.size();
        int totalPages = (int) Math.ceil((double) totalBlogs / recordsPerPage);

        int toIndex = Math.min(offset + recordsPerPage, totalBlogs);
        if (offset < totalBlogs) {
            blogs = blogs.subList(offset, toIndex);
        } else {
            blogs = List.of();
        }

        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.setAttribute("account", acc);
        request.setAttribute("blogs", blogs);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("categories", categoryList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("/views/marketting/PostList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalidAccount");
            return;
        }

        String action = request.getParameter("action");
        String blogIdStr = request.getParameter("blogId");

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/postList?error=invalidAction");
            return;
        }

        if (blogIdStr == null || blogIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/postList?error=missingBlogId");
            return;
        }

        int blogId;
        try {
            blogId = Integer.parseInt(blogIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/postList?error=invalidBlogId");
            return;
        }

        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.getBlogByBlogId(blogId);

        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/postList?error=blogNotFound");
            return;
        }

        switch (action) {
            case "update" -> {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String categoryIdStr = request.getParameter("categoryId");
                String status = request.getParameter("status");

                if (title == null || title.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/postList?error=missingTitle");
                    return;
                }

                if (content == null || content.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/postList?error=missingContent");
                    return;
                }

                if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/postList?error=missingCategory");
                    return;
                }

                int categoryId;
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/postList?error=invalidCategory");
                    return;
                }

                // **Khai báo biến imageUrl trước khi dùng**
                String imageUrl = blog.getImgUrl(); // Giữ nguyên ảnh cũ nếu không upload ảnh mới

                // Xử lý hình ảnh nếu người dùng có upload file mới
                Part filePart = request.getPart("imageUrl");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                    // Tách phần mở rộng của file
                    int dotIndex = fileName.lastIndexOf(".");
                    String extension = "";
                    String baseName = fileName;

                    if (dotIndex > 0) {
                        extension = fileName.substring(dotIndex);
                        baseName = fileName.substring(0, dotIndex);
                    }

                    // Lấy đường dẫn gốc của project
                    String projectRoot = getServletContext().getRealPath("/");
                    if (projectRoot.contains("build")) {
                        projectRoot = projectRoot.substring(0, projectRoot.indexOf("build"));
                    }

                    String uploadPath = projectRoot + File.separator + UPLOAD_DIRECTORY;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Kiểm tra trùng lặp tên file
                    File newFile = new File(uploadPath + File.separator + fileName);
                    if (newFile.exists()) {
                        fileName = UUID.randomUUID().toString() + "-" + baseName + extension;
                        newFile = new File(uploadPath + File.separator + fileName);
                    }

                    // Lưu file mới
                    filePart.write(newFile.getAbsolutePath());
                    imageUrl = "/assets/images/blog/recent-blog/" + fileName;
                }

                // Cập nhật thông tin blog
                blog.setTitle(title);
                blog.setContent(content);
                blog.setCategoryID(categoryId);
                blog.setStatus(status);
                blog.setImgUrl(imageUrl);

                blogDAO.updateBlog(blog);
                response.sendRedirect(request.getContextPath() + "/postList?message=updated");
            }
            case "delete" -> {
                boolean deleted = blogDAO.deleteBlog(blogId);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/postList?message=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/postList?error=deleteFailed");
                }
            }
            default ->
                response.sendRedirect(request.getContextPath() + "/postList?error=invalidAction");
        }
    }

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
