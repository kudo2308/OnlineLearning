package controller.quiz;

import DAO.CourseDAO;
import DAO.QuizDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Quiz;
import java.sql.Timestamp;
import java.util.List;
import model.Course;

@WebServlet(name = "AddQuizController", urlPatterns = {"/AddQuiz"})
public class AddQuizController extends HttpServlet {
    
    private QuizDAO quizDAO;
    private CourseDAO courseDAO;
    
    @Override
    public void init() {
        quizDAO = new QuizDAO();
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            // Create a new CourseDAO instance each time to avoid duplicate data
            CourseDAO courseDAOInstance = new CourseDAO();
            List<Course> courses = courseDAOInstance.findAll();
            request.setAttribute("courses", courses);
            
            // Forward to the add quiz form
            request.getRequestDispatcher("/views/test/AddQuiz.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from the form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int duration = Integer.parseInt(request.getParameter("duration"));
            double passRate = Double.parseDouble(request.getParameter("passRate"));
            int totalQuestion = Integer.parseInt(request.getParameter("totalQuestion"));
            int courseID = Integer.parseInt(request.getParameter("courseID"));
            
            // Create quiz object
            Quiz quiz = Quiz.builder()
                    .name(name)
                    .description(description)
                    .duration(duration)
                    .passRate(passRate)
                    .totalQuestion(totalQuestion)
                    .courseID(courseID)
                    .status(true)
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .updatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            
            // Add quiz to database
            boolean success = quizDAO.addQuiz(quiz);
                
            if (success) {
                // Get the newly created quiz ID
                int newQuizId = quizDAO.getLatestQuizId();
                // Store totalQuestion in session for tracking
                request.getSession().setAttribute("remainingQuestions", quiz.getTotalQuestion());
                request.getSession().setAttribute("currentQuizId", newQuizId);
                // Redirect to add questions
                response.sendRedirect(request.getContextPath() + "/AddQuestion");
            } else {
                request.setAttribute("error", "Failed to create quiz");
                request.getRequestDispatcher("/views/test/AddQuiz.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input data. Please check your form values.");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}
