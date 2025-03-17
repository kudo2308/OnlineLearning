/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

@WebServlet(name = "DeleteCourse", urlPatterns = {"/deleteCourse"})
public class DeleteCourse extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            CourseDAO courseDAO = new CourseDAO();

            Course course = courseDAO.findCourseById(courseId);

            if (course == null) {
                throw new Exception("Course not found");
            }
            course.setStatus("Blocked");
            if (courseDAO.UpdateCourse(course)) {
                response.sendRedirect("courses");
            } else {
                throw new Exception("Delete course failed");
            }

        } catch (Exception e) {
            response.sendRedirect("error.jsp");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
