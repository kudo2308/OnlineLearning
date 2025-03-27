/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import DAO.LessonDAO;
import DAO.LessonProgressDAO;
import DAO.PackagesDAO;
import DAO.QuizDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Lesson;
import model.Packages;
import model.Quiz;
import utils.YouTubeDurationFetcher;

/**
 *
 * @author ADMIN
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
            PackagesDAO packagesDAO = new PackagesDAO();

            // Get lessonId from request - support both new and old parameter formats
            int lessonId = 0;
            String lessonIdParam = request.getParameter("id");
            if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
                try {
                    lessonId = Integer.parseInt(lessonIdParam);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid lessonId parameter: " + lessonIdParam);
                }
            } else {
                // Try the old parameter format (lessonId)
                String oldLessonIdParam = request.getParameter("lessonId");
                if (oldLessonIdParam != null && !oldLessonIdParam.isEmpty()) {
                    try {
                        lessonId = Integer.parseInt(oldLessonIdParam);
                    } catch (NumberFormatException e) {
                        System.out.println("Invalid old lessonId parameter: " + oldLessonIdParam);
                    }
                }
            }

            // Handle courseId parameter (old format)
            int courseId = 0;
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                try {
                    courseId = Integer.parseInt(courseIdParam);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid courseId parameter: " + courseIdParam);
                }
            }

            // If we have a courseId but no lessonId, get the first lesson of the course
            if (courseId > 0 && lessonId == 0) {
                List<Lesson> courseLessons = lessonDAO.getAllLessonByCourseId(courseId);
                if (!courseLessons.isEmpty()) {
                    lessonId = courseLessons.get(0).getLessonID();
                }
            }

            // If no lesson ID provided, redirect to my-courses page
            if (lessonId == 0) {
                response.sendRedirect(request.getContextPath() + "/my-courses");
                return;
            }

            // Get the current lesson
            Lesson currentLesson = lessonDAO.findLessonById(lessonId);
            if (currentLesson == null) {
                request.setAttribute("errorMessage", "Lesson not found.");
                request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);
                return;
            }

            // Get the course ID from the current lesson
            courseId = currentLesson.getCourseID();

            // Get all lessons for the course with package information
            List<Lesson> lessonList = lessonDAO.getLessonsByCourseIdNew(courseId);
            if (lessonList.isEmpty()) {
                request.setAttribute("errorMessage", "No lessons found for this course.");
                request.getRequestDispatcher("/views/lesson/lessonView.jsp").forward(request, response);
                return;
            }

            // Find previous and next lessons
            Lesson prevLesson = null;
            Lesson nextLesson = null;
            
            for (int i = 0; i < lessonList.size(); i++) {
                if (lessonList.get(i).getLessonID() == lessonId) {
                    // Set previous lesson
                    if (i > 0) {
                        prevLesson = lessonList.get(i - 1);
                    }
                    
                    // Set next lesson
                    if (i < lessonList.size() - 1) {
                        nextLesson = lessonList.get(i + 1);
                    }
                    
                    break;
                }
            }

            // Calculate course progress
            int totalLessons = lessonList.size();
            int courseProgress = 0;
            
            if (totalLessons > 0) {
                // For now, just calculate a simple percentage based on the current lesson's position
                // In a real application, you would track completed lessons for each user
                for (int i = 0; i < lessonList.size(); i++) {
                    if (lessonList.get(i).getLessonID() == lessonId) {
                        courseProgress = (int) Math.round((double) (i + 1) / totalLessons * 100);
                        break;
                    }
                }
            }

            // Set attributes for the view
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("lessonList", lessonList);
            request.setAttribute("prevLesson", prevLesson);
            request.setAttribute("nextLesson", nextLesson);
            request.setAttribute("courseProgress", courseProgress);
            
            // Get all quizzes for the course to display in sidebar
            QuizDAO quizDAO = new QuizDAO();
            List<Quiz> quizList = quizDAO.getQuizzesByCourseId(courseId);
            request.setAttribute("quizList", quizList);
            
            // Check if user is logged in
            HttpSession session = request.getSession();
            Account currentUser = (Account) session.getAttribute("account");
            
            if (currentUser != null) {
                // Get the package ID of the current lesson
                int packageId = 0;
                if (currentLesson.getPackages() != null) {
                    packageId = currentLesson.getPackages().getPackageID();
                }
                
                // Check if all lessons in the package are completed
                if (packageId > 0) {
                    LessonProgressDAO progressDAO = new LessonProgressDAO();
                    boolean packageCompleted = progressDAO.areAllLessonsInPackageCompleted(currentUser.getUserID(), packageId);
                    
                    if (packageCompleted) {
                        // Check if there's a quiz for this package
                        QuizDAO quizDAO2 = new QuizDAO();
                        Quiz quiz = quizDAO2.getQuizByPackageId(packageId);
                        
                        if (quiz != null) {
                            request.setAttribute("packageCompleted", true);
                            request.setAttribute("hasQuiz", true);
                            request.setAttribute("quizInfo", quiz);
                        }
                    }
                }
            }

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
    HttpSession session = request.getSession();
    
    try {
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String videoUrl = request.getParameter("videoUrl");

        if (!isValidYouTubeUrl(videoUrl)) {
            session.setAttribute("error", "Invalid YouTube URL. Please provide a valid YouTube video URL.");
            response.sendRedirect(request.getContextPath() + "/lesson?id=" + lessonId);
            return;
        }

        // Get video duration
        int duration = YouTubeDurationFetcher.getVideoDurationInMinutesFromUrl(videoUrl);
        if (duration <= 0) {
            session.setAttribute("error", "Failed to retrieve video duration.");
            response.sendRedirect(request.getContextPath() + "/lesson?id=" + lessonId);
            return;
        }

        // Check if lesson exists
        LessonDAO lessonDAO = new LessonDAO();
        if (!lessonDAO.lessonExists(lessonId)) {
            session.setAttribute("error", "Invalid lesson: The specified lesson ID " + lessonId + " does not exist in the system.");
            response.sendRedirect(request.getContextPath() + "/my-courses");
            return;
        }

        // Update video
        boolean success = lessonDAO.updateLessonVideo(lessonId, videoUrl, duration);
        if (success) {
            session.setAttribute("success", "Video updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update video.");
        }
        
        // Redirect back to lesson page
        response.sendRedirect(request.getContextPath() + "/lesson?id=" + lessonId);
        
    } catch (NumberFormatException e) {
        session.setAttribute("error", "Invalid lesson ID format.");
        response.sendRedirect(request.getContextPath() + "/my-courses");
    } catch (Exception e) {
        session.setAttribute("error", "An error occurred: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/my-courses");
    }
}

    private boolean isValidYouTubeUrl(String url) {
        if (url == null || url.trim().isEmpty()) {
            return false;
        }
        
        // Basic validation for YouTube URLs
        return url.contains("youtube.com/watch?v=") || url.contains("youtu.be/");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Lesson Controller";
    }// </editor-fold>

}
