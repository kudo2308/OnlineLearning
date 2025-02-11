/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
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
import java.util.List;
import java.util.Set;
import model.Category;
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
     
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
}
