/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import DAO.LessonDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Lesson;

/**
 *
 * @author dohie
 */
public class LessonController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LessonController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LessonController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            LessonDAO lessonDAO = new LessonDAO();

            // Get courseId from request, default to 1 if not provided
            int courseId = 1;
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                try {
                    courseId = Integer.parseInt(courseIdParam);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid courseId parameter: " + courseIdParam);
                }
            }

            // Get current lesson ID from request
            int lessonId = 0;
            String lessonIdParam = request.getParameter("lessonId");
            if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
                try {
                    lessonId = Integer.parseInt(lessonIdParam);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid lessonId parameter: " + lessonIdParam);
                }
            }

            // Get all lessons for the course
            List<Lesson> lessonList = lessonDAO.getLessonsByCourseId(courseId);
            System.out.println("Found " + lessonList.size() + " lessons for course " + courseId);

            if (lessonList.isEmpty()) {
                System.out.println("No lessons found for course " + courseId);
                request.setAttribute("errorMessage", "No lessons found for this course.");
                request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);
                return;
            }

            // Print out all lessons found
            System.out.println("Lessons found:");
            for (Lesson lesson : lessonList) {
                System.out.println("- Lesson ID: " + lesson.getLessonID()
                        + ", Title: " + lesson.getTitle()
                        + ", Course ID: " + lesson.getCourseID()
                        + ", Video URL: " + lesson.getVideoUrl());
            }

            // Get current lesson
            Lesson currentLesson = null;
            if (lessonId > 0) {
                currentLesson = lessonDAO.findLessonById(lessonId);
                System.out.println("Looking for lesson with ID: " + lessonId);
            }

            if (currentLesson == null) {
                currentLesson = lessonList.get(0);
                System.out.println("Using first lesson as current lesson: " + currentLesson.getLessonID());
            }

            // Find previous and next lessons
            Lesson prevLesson = null;
            Lesson nextLesson = null;
            for (int i = 0; i < lessonList.size(); i++) {
                if (lessonList.get(i).getLessonID() == currentLesson.getLessonID()) {
                    if (i > 0) {
                        prevLesson = lessonList.get(i - 1);
                    }
                    if (i < lessonList.size() - 1) {
                        nextLesson = lessonList.get(i + 1);
                    }
                    break;
                }
            }

            // Calculate progress (demo values for now)
            int completedLessons = 0;
            int totalLessons = lessonList.size();
            double progressPercentage = (completedLessons * 100.0) / totalLessons;

            // Set attributes for the JSP
            request.setAttribute("lessonList", lessonList);
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("prevLesson", prevLesson);
            request.setAttribute("nextLesson", nextLesson);
            request.setAttribute("courseId", courseId);
            request.setAttribute("completedLessons", completedLessons);
            request.setAttribute("totalLessons", totalLessons);
            request.setAttribute("progressPercentage", progressPercentage);

            System.out.println("Forwarding to JSP with current lesson: " + currentLesson.getTitle());
            request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in LessonDemoController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading the lesson.");
            request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
