 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DTOs.CreateCourseRequest;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
import java.util.Set;
import mapper.CourseMapper;
import model.Category;
import model.Course;
//gioi han kich thuoc tep
    
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class AddCourse extends HttpServlet {

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
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Category> categories = categoryDAO.findALl();

        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin/add-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int totalLesson = Integer.parseInt(request.getParameter("totalLesson"));
        Part filePart = request.getPart("image");

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.findALl();
        request.setAttribute("categories", categories);
     CreateCourseRequest courseRequest = new CreateCourseRequest(title, description, categoryId, totalLesson);
     Set<ConstraintViolation<CreateCourseRequest>> violations = validator.validate(courseRequest);
     if (!violations.isEmpty()) {
            request.setAttribute("courseRequest", courseRequest);
            request.setAttribute("violations", violations);
            request.getRequestDispatcher("/views/admin/add-course.jsp").forward(request, response);
            return;
        }
       String fileName = extractFileName(filePart);
        String imagePath = saveFile(filePart, fileName);
        Course course = CourseMapper.mapCreateCoursetoCourse(courseRequest);
        course.setImageUrl(imagePath);
        course.setStatus(true);
        course.setExpertID(2);
<<<<<<< HEAD
=======

>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
        CourseDAO courseDAO = new CourseDAO();
        if (courseDAO.AddCourse(course)) {
            request.setAttribute("courseRequest", courseRequest);
            request.setAttribute("msg", "Add successfully!");
            request.getRequestDispatcher("/views/admin/add-course.jsp").forward(request, response);
        } else {
            response.sendRedirect("error.jsp");
        }

<<<<<<< HEAD
=======
     
>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
<<<<<<< HEAD
     private String extractFileName(Part part) {
=======
      private String extractFileName(Part part) {
>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
<<<<<<< HEAD
=======

>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
    private String saveFile(Part filePart, String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
<<<<<<< HEAD
=======

>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
        // Xác định thư mục upload
        String uploadFolder = getServletContext().getRealPath("") + "../../web/" + UPLOAD_DIR;
        File folder = new File(uploadFolder);
        if (!folder.exists()) {
            folder.mkdirs();
        }
<<<<<<< HEAD
        // Đường dẫn đầy đủ trên server
        File file = new File(uploadFolder, fileName);
=======

        // Đường dẫn đầy đủ trên server
        File file = new File(uploadFolder, fileName);

>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
        // Lưu file
        try (InputStream fileContent = filePart.getInputStream(); OutputStream out = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
<<<<<<< HEAD
=======

>>>>>>> ff559f16fb7d91e4c2e6f372889e35eb2dd026bf
        // Trả về đường dẫn tương đối
        return UPLOAD_DIR + "/" + fileName;
    }
}
