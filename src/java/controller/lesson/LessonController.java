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
import utils.YouTubeDurationFetcher;

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

            // Get courseId from request
            int courseId = 1;
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                try {
                    courseId = Integer.parseInt(courseIdParam);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid courseId parameter: " + courseIdParam);
                }
            }

            // Get all lessons for the course, ordered by OrderNumber
            List<Lesson> lessonList = lessonDAO.getAllLessonByCourseId(courseId);
            if (lessonList.isEmpty()) {
                request.setAttribute("errorMessage", "No lessons found for this course.");
                request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);
                return;
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

            // Find the current lesson
            Lesson currentLesson = null;
            int currentIndex = 0;

            // If no specific lesson requested, use the first lesson
            if (lessonId == 0) {
                currentLesson = lessonList.get(0);
                currentIndex = 0;
            } else {
                // Find the lesson in the ordered list
                for (int i = 0; i < lessonList.size(); i++) {
                    if (lessonList.get(i).getLessonID() == lessonId) {
                        currentLesson = lessonList.get(i);
                        currentIndex = i;
                        break;
                    }
                }
                // If lesson not found in list, use first lesson
                if (currentLesson == null) {
                    currentLesson = lessonList.get(0);
                    currentIndex = 0;
                }
            }

            // Set previous and next lessons based on OrderNumber
            Lesson previousLesson = null;
            Lesson nextLesson = null;

            if (currentIndex > 0) {
                previousLesson = lessonList.get(currentIndex - 1);
            }

            if (currentIndex < lessonList.size() - 1) {
                nextLesson = lessonList.get(currentIndex + 1);
            }

            // Set attributes for the view
            request.setAttribute("courseId", courseId);
            request.setAttribute("lessonList", lessonList);
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("previousLesson", previousLesson);
            request.setAttribute("nextLesson", nextLesson);

            // Forward to the view
            request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in LessonController: " + e.getMessage());
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
        String action = request.getParameter("action");
        
        if ("updateVideo".equals(action)) {
            handleVideoUpdate(request, response);
        } else {
            // Handle other actions
            processRequest(request, response);
        }
    }

    private void handleVideoUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String videoUrl = request.getParameter("videoUrl");
            
            // Validate YouTube URL
            if (!isValidYouTubeUrl(videoUrl)) {
                request.setAttribute("error", "Invalid YouTube URL. Please provide a valid YouTube video URL.");
                response.sendRedirect(request.getContextPath() + "/lesson?lessonId=" + lessonId);
                return;
            }
            
            // Get video duration using YouTubeDurationFetcher
            int duration = YouTubeDurationFetcher.getVideoDurationInMinutesFromUrl(videoUrl);
            
            // Update lesson in database
            LessonDAO lessonDAO = new LessonDAO();
            boolean success = lessonDAO.updateLessonVideo(lessonId, videoUrl, duration);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/lesson?lessonId=" + lessonId);
            } else {
                request.setAttribute("error", "Failed to update video URL");
                response.sendRedirect(request.getContextPath() + "/lesson?lessonId=" + lessonId);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating video: " + e.getMessage());
        }
    }
    
    private boolean isValidYouTubeUrl(String url) {
        if (url == null || url.isEmpty()) {
            return false;
        }
        
        // Basic YouTube URL validation
        return url.matches("^(https?://)?(www\\.)?(youtube\\.com/watch\\?v=|youtu\\.be/)[a-zA-Z0-9_-]{11}.*");
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
