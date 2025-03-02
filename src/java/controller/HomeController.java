package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;
import model.Course;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        CourseDAO courseDAO = new CourseDAO();

        List<Category> categories = categoryDAO.findAll();
        List<Course> courses = courseDAO.getAllCourses(0, 9);

        request.setAttribute("categories", categories);
        request.setAttribute("courses", courses);

        request.getRequestDispatcher("public/home.jsp").forward(request, response);
    }
}
