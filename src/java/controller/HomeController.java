
package controller;

import DAO.BlogDAO;
import DAO.CategoryDAO;
import DAO.CourseDAO;
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

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        CourseDAO courseDAO = new CourseDAO(); 
        BlogDAO blogDAO = new BlogDAO();
        
        List<Blog> blogs = blogDAO.getAllRecentBlogs()
                .stream()
                .limit(9)
                .collect(Collectors.toList());
        List<Category> categories = categoryDAO.findAll();
        List<Course> courses = courseDAO.getAllCourses(0, 3);
        List<Course> recentCourses = courseDAO.getRecentCourses(9);
        
        request.setAttribute("blogs", blogs);
        request.setAttribute("categories", categories);
        request.setAttribute("courses", courses);
        request.setAttribute("recentCourses", recentCourses);

        request.getRequestDispatcher("public/home.jsp").forward(request, response);
    }

    public static void main(String[] args) {
        CourseDAO courseDAO = new CourseDAO(); 
        List<Course> courses = courseDAO.getAllCourses(0, 3);
        for (Course course : courses) {
            System.out.println(course.getTitle() + course.getPrice());
        }
    }
    }
