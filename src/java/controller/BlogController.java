/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import DAO.BlogRequestDAO;
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
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import model.Account;
import model.Blog;
import model.BlogRequest;
import model.Category;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "BlogController", urlPatterns = "/Blog")
@MultipartConfig( // Cấu hình giới hạn kích thước file upload
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class BlogController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "web/assets/images/blog/recent-blog";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1; // Trang mặc định
        int recordsPerPage = 6; // Số bài viết mỗi trang

        // Nhận tham số từ request
        String pageParam = request.getParameter("page");
        String categoryIdParam = request.getParameter("categoryId");
        String keyword = request.getParameter("search");
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        // Hiển thị thông báo thành công hoặc lỗi nếu có
        if ("true".equals(success)) {
            request.setAttribute("successMessage", "Add blog successfully!");
        } else if ("missingTitle".equals(error)) {
            request.setAttribute("errorMessage", "Vui long nhap title");
        } else if ("missingContent".equals(error)) {
            request.setAttribute("errorMessage", "Vui lòng nhập content.");
        } else if ("missingCategory".equals(error)) {
            request.setAttribute("errorMessage", "Vui lòng nhập category.");
        } else if ("missingImage".equals(error)) {
            request.setAttribute("errorMessage", "Vui lòng nhập image.");
        } else if ("missingStatus".equals(error)) {
            request.setAttribute("errorMessage", "Vui lòng chọn status");
        } else if ("invalidCategory".equals(error)) {
            request.setAttribute("errorMessage", "Category invalid.");
        } else if ("addFailed".equals(error)) {
            request.setAttribute("errorMessage", "Add blog failed, Please try again!");
        }

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
        CategoryDAO categoryDAO = new CategoryDAO();
        BlogDAO blogDAO = new BlogDAO();
        List<Category> categoryList = categoryDAO.findAll();
        List<Blog> blogs;

        if (categoryId > 0) {
            blogs = blogDAO.getBlogByCategoryId(categoryId);
        } else {
            blogs = blogDAO.getAllBlogs(0, Integer.MAX_VALUE);
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

        request.setAttribute("blogs", blogs);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("categories", categoryList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("views/user/BlogClassic.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalidAccount");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String categoryIdStr = request.getParameter("categoryId");
        Part filePart = request.getPart("imageUrl"); // Lấy file upload
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String status = request.getParameter("status");

        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Blog?error=missingTitle");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Blog?error=missingContent");
            return;
        }

        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Blog?error=missingCategory");
            return;
        }

        if (status == null || status.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Blog?error=missingStatus");
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Blog?error=invalidCategory");
            return;
        }

        String projectRoot = getServletContext().getRealPath("/");
        if (projectRoot.contains("build")) {
            projectRoot = projectRoot.substring(0, projectRoot.indexOf("build"));
        }

        String uploadPath = projectRoot + File.separator + UPLOAD_DIRECTORY;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        String imageUrl = "/assets/images/blog/recent-blog/" + fileName;

        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(acc.getUserID());
        blog.setCategoryID(categoryId);
        blog.setImgUrl(imageUrl);

        // Nếu chọn Public, set trạng thái Pending, nếu chọn Private thì set Private
        if ("true".equals(status)) {
            blog.setStatus("Pending"); // Nếu chọn Public, set trạng thái Pending
        } else {
            blog.setStatus("Private"); // Nếu chọn Private, giữ nguyên Private
        }

        BlogDAO blogDAO = new BlogDAO();
        boolean isAdded = blogDAO.addBlog(blog);

        if (isAdded) {
            // Lấy BlogID sau khi blog được thêm vào thành công
            int blogId = blog.getBlogId(); // Lấy ID của blog đã được thêm

            if ("Pending".equals(blog.getStatus())) {
                // Sau khi blog được thêm vào với trạng thái Pending, gửi yêu cầu phê duyệt
                BlogRequest requestBlog = new BlogRequest();
                requestBlog.setBlogId(blogId);  // Sử dụng BlogID đã lấy
                requestBlog.setAdminId(acc.getUserID());  // ID admin của người đăng nhập
                requestBlog.setStatus("Pending");

                BlogRequestDAO blogRequestDAO = new BlogRequestDAO();
                boolean requestSent = blogRequestDAO.sendApprovalRequest(requestBlog);

                if (requestSent) {
                    response.sendRedirect(request.getContextPath() + "/Blog?success=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/Blog?error=addFailed");
                }
            } else {
                // Nếu trạng thái là Private, không cần gửi yêu cầu phê duyệt
                response.sendRedirect(request.getContextPath() + "/Blog?success=true");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/Blog?error=addFailed");
        }
    }

    public static void main(String[] args) {
        Blog blog = new Blog();
        blog.setTitle("title");
        blog.setContent("content");
        blog.setAuthorId(3);
        blog.setCategoryID(1);
        blog.setImgUrl("haha");
        blog.setStatus("Public");
        BlogDAO blogDAO = new BlogDAO();
        boolean isAdded = blogDAO.addBlog(blog);
        System.out.println(isAdded);
        if (isAdded) {
            // Lấy BlogID sau khi blog được thêm vào thành công
            int blogId = blog.getBlogId(); // Lấy ID của blog đã được thêm
            System.out.println(blogId);
        }
        
    }

}
