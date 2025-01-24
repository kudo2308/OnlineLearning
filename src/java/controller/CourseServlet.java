    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

/**
 *
 * @author dohie
 */

@WebServlet(name = "CourseServlet", urlPatterns = {"/course"})
public class CourseServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Create sample course data
        List<Course> courses = new ArrayList<>();
        
        // Add sample courses
        Course course1 = new Course();
        course1.setId(1);
        course1.setTitle("Introduction to Java Programming");
        course1.setCategory("Programming Language");
        course1.setImage("pic1.jpg");
        course1.setPrice(120.0);
        course1.setOriginalPrice(190.0);
        course1.setRating(4);
        course1.setReviewCount(3);
        courses.add(course1);
        
        Course course2 = new Course();
        course2.setId(2);
        course2.setTitle("Web Development Bootcamp");
        course2.setCategory("Web Development");
        course2.setImage("pic2.jpg");
        course2.setPrice(150.0);
        course2.setOriginalPrice(200.0);
        course2.setRating(5);
        course2.setReviewCount(7);
        courses.add(course2);
        
        // Add more sample courses as needed
        
        // Set attributes for the view
        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 1);
        
        // Forward to the view
        request.getRequestDispatcher("/views/course/OurCourse.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Course Servlet";
    }
}
