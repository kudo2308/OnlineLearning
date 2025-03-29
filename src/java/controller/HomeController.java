package controller;

import DAO.BlogDAO;
import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.SliderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.stream.Collectors;
import model.Blog;
import model.Category;
import model.Course;
import model.Slider;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        CourseDAO courseDAO = new CourseDAO();
        BlogDAO blogDAO = new BlogDAO();
        SliderDAO sliderDAO = new SliderDAO(); // Thêm SliderDAO

        List<Blog> blogs = blogDAO.getAllRecentBlogs()
                .stream()
                .limit(9)
                .collect(Collectors.toList());
        List<Category> categories = categoryDAO.findAll();
        List<Course> courses = courseDAO.getAllCourses(0, 3);
        List<Course> recentCourses = courseDAO.getRecentCourses(9);
        
        // Lấy các slider đang hoạt động
        List<Slider> activeSliders = sliderDAO.getActiveSliders();

        request.setAttribute("blogs", blogs);
        request.setAttribute("categories", categories);
        request.setAttribute("courses", courses);
        request.setAttribute("recentCourses", recentCourses);
        request.setAttribute("sliders", activeSliders); // Thêm slider vào request

        request.getRequestDispatcher("/public/home.jsp").forward(request, response);
    }
}



