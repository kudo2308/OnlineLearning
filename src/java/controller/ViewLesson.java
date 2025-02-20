/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DocDAO;
import DAO.FileDAO;
import DAO.LessonDAO;
import DAO.VideoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Docs;
import model.FileLesson;
import model.Lesson;
import model.Video;

/**
 *
 * @author dohie
 */
public class ViewLesson extends HttpServlet {

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
            out.println("<title>Servlet ViewLesson</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewLesson at " + request.getContextPath() + "</h1>");
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
     * 
     */
    private static final String COURSE_ID = "courseId";
    private static final String LESSON = "lesson";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("adminaccount") == null) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        try {
            int courseId = Integer.parseInt(request.getParameter(COURSE_ID));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            LessonDAO ldao = new LessonDAO();
            Lesson lesson = ldao.getLessonById(lessonId);

            if (request.getParameter("docs") != null) {
                DocDAO docDAO = new DocDAO();
                Docs docs = docDAO.getDocsByLesson(lessonId);
                request.setAttribute("docs", docs);
                request.setAttribute(LESSON, lesson);
                request.setAttribute(COURSE_ID, courseId);
                request.getRequestDispatcher("viewDocLesson.jsp").forward(request, response);
            } else if (request.getParameter("file") != null) {
                FileDAO fileDAO = new FileDAO();
                FileLesson file = fileDAO.getFileByLesson(lessonId);
                request.setAttribute("file", file);
                request.setAttribute(LESSON, lesson);
                request.setAttribute(COURSE_ID, courseId);
                request.getRequestDispatcher("viewFileLesson.jsp").forward(request, response);
            } else if (request.getParameter("video") != null) {
                VideoDAO vDAO = new VideoDAO();
                Video video = vDAO.getVideoByLessonId(lessonId);
                request.setAttribute("video", video);
                request.setAttribute(LESSON, lesson);
                request.setAttribute(COURSE_ID, courseId);
                request.getRequestDispatcher("viewVideoLesson.jsp").forward(request, response);
            }

        } catch (Exception e) {
            response.sendRedirect("admin-course-manage");
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
