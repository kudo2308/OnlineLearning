/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DTOs.CreateCourseRequest;
import DTOs.UpdateCourseRequest;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.Set;
import mapper.CourseMapper;
import model.Category;
import model.Course;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
@WebServlet(name = "EditCourse", urlPatterns = {"/editCourse"})
public class EditCourse extends HttpServlet {

    private Validator validator;
    private static final String UPLOAD_DIR = "img";

    @Override
    public void init() throws ServletException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            CourseDAO courseDAO = new CourseDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            List<Category> categories = categoryDAO.findAll();
            Course course = courseDAO.findCourseById(courseId);

            if (course == null) {
                throw new Exception("Object not found!");
            }
            request.setAttribute("course", course);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("views/admin/edit-course.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("error.jsp");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int totalLesson = Integer.parseInt(request.getParameter("totalLesson"));
            Part filePart = request.getPart("image");
            Float price = Float.valueOf(request.getParameter("price"));
            String status = request.getParameter("status");

            int courseId = Integer.parseInt(request.getParameter("courseId"));

            CourseDAO courseDAO = new CourseDAO();

            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            Course course = courseDAO.findCourseById(courseId);

            if (course == null) {
                throw new Exception("Course not found");
            }

            UpdateCourseRequest courseRequest = new UpdateCourseRequest(title, description,
                    categoryId, totalLesson, price, status);

            Set<ConstraintViolation<UpdateCourseRequest>> violations = validator.validate(courseRequest);

            if (!violations.isEmpty()) {
                request.setAttribute("courseRequest", courseRequest);
                request.setAttribute("violations", violations);
                request.getRequestDispatcher("/views/admin/edit-course.jsp").forward(request, response);
                return;
            }
            CourseMapper.mapUpdateCoursetoCourse(course, courseRequest);

            String fileName = extractFileName(filePart);

            if (!fileName.isEmpty()) {
                String imagePath = saveFile(filePart, fileName);
                course.setImageUrl(imagePath);
            }

            //example experId = 2
            // lay userid tu sesson
            HttpSession session = request.getSession();

            Object accountObj = session.getAttribute("account");

            if (accountObj == null) {
                throw new Exception("Session not found!");
            }

            String userID = null;
            if (accountObj instanceof Map) {
                Map<String, String> accountData = (Map<String, String>) accountObj;
                userID = accountData.get("userId");
            }
            int userId = Integer.parseInt(userID);
            course.setExpertID(userId);

            if (courseDAO.UpdateCourse(course)) {
                response.sendRedirect("editCourse?courseId=" + courseId);
            } else {
                throw new Exception("Update faild");
            }
        } catch (Exception e) {
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    private String saveFile(Part filePart, String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Xác định thư mục upload
        String uploadFolder = getServletContext().getRealPath("") + "../../web/" + UPLOAD_DIR;
        File folder = new File(uploadFolder);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        // Đường dẫn đầy đủ trên server
        File file = new File(uploadFolder, fileName);

        // Lưu file
        try (InputStream fileContent = filePart.getInputStream(); OutputStream out = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }

        // Trả về đường dẫn tương đối
        return UPLOAD_DIR + "/" + fileName;
    }

}
