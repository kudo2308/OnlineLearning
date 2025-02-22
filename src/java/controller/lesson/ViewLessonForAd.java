/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import DAO.LessonDAO;
import DAO.PackagesDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Lesson;
import model.Packages;

/**
 *
 * @author PC
 */
@WebServlet(name = "ViewLessonForAd", urlPatterns = {"/viewLessonForAd"})
public class ViewLessonForAd extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));

            LessonDAO lessonDAO = new LessonDAO();
            PackagesDAO packDAO = new PackagesDAO();

            Lesson lesson = lessonDAO.findLessonById(lessonId);
            if (lesson == null) {
                throw new Exception("View lesson error");
            }
            
            List<Packages> packages = packDAO.findPackagesByCourseId(lesson.getCourse().getCourseID());

            request.setAttribute("packages", packages);
            request.setAttribute("lesson", lesson);
            request.getRequestDispatcher("views/lesson/admin-view-lesson-details.jsp").forward(request, response);
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
    }// </editor-fold>

}
