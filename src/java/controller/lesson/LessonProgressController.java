package controller.lesson;

import DAO.LessonDAO;
import DAO.LessonProgressDAO;
import DAO.QuizDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Lesson;
import model.LessonProgress;
import model.Quiz;
import model.Packages;
import org.json.JSONObject;

/**
 * Controller for tracking and updating lesson progress
 */
@WebServlet(name = "LessonProgressController", urlPatterns = {"/lesson-progress"})
public class LessonProgressController extends HttpServlet {

    /**
     * Handles the HTTP POST method to update lesson progress
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        try {
            // Get the current user from session
            HttpSession session = request.getSession();
            Account currentUser = (Account) session.getAttribute("account");
            
            if (currentUser == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "User not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Get parameters from request
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            boolean completed = Boolean.parseBoolean(request.getParameter("completed"));
            
            // Get lesson information
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.findLessonById(lessonId);
            int courseId = lesson.getCourseID();
            int packageId = 0;
            
            // Get package ID if available
            if (lesson.getPackages() != null) {
                packageId = lesson.getPackages().getPackageID();
            }
            
            // Create or update lesson progress
            LessonProgressDAO progressDAO = new LessonProgressDAO();
            LessonProgress progress = progressDAO.getLessonProgressByUserAndLesson(currentUser.getUserID(), lessonId);
            
            if (progress == null) {
                // Create new progress record
                progress = new LessonProgress();
                progress.setUserID(currentUser.getUserID());
                progress.setLessonID(lessonId);
                progress.setCourseID(courseId);
                progress.setCompleted(completed);
                
                boolean created = progressDAO.createLessonProgress(progress);
                jsonResponse.put("success", created);
                jsonResponse.put("message", created ? "Progress created successfully" : "Failed to create progress");
            } else {
                // Update existing progress record
                progress.setCompleted(completed);
                
                boolean updated = progressDAO.updateLessonProgress(progress);
                jsonResponse.put("success", updated);
                jsonResponse.put("message", updated ? "Progress updated successfully" : "Failed to update progress");
            }
            
            // Calculate and return the updated course progress
            int courseProgress = progressDAO.calculateCourseProgress(currentUser.getUserID(), courseId);
            jsonResponse.put("courseProgress", courseProgress);
            
            // Check if all lessons in the package are completed
            if (completed && packageId > 0) {
                boolean packageCompleted = progressDAO.areAllLessonsInPackageCompleted(currentUser.getUserID(), packageId);
                jsonResponse.put("packageCompleted", packageCompleted);
                
                // If package is completed, get quiz information
                if (packageCompleted) {
                    QuizDAO quizDAO = new QuizDAO();
                    Quiz quiz = quizDAO.getQuizByPackageId(packageId);
                    
                    if (quiz != null) {
                        JSONObject quizInfo = new JSONObject();
                        quizInfo.put("quizId", quiz.getQuizID());
                        quizInfo.put("name", quiz.getName());
                        quizInfo.put("description", quiz.getDescription());
                        quizInfo.put("duration", quiz.getDuration());
                        
                        jsonResponse.put("hasQuiz", true);
                        jsonResponse.put("quizInfo", quizInfo);
                    } else {
                        jsonResponse.put("hasQuiz", false);
                    }
                }
            }
            
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Lesson Progress Controller - Handles tracking and updating lesson progress";
    }
}
