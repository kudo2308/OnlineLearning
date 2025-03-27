package controller.quiz;

import DAO.QuizDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Quiz;

@WebServlet(name = "QuizController", urlPatterns = {"/quiz"})
public class Quizzz extends HttpServlet {
    
    private QuizDAO quizDAO;
    
    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all quizzes
        List<Quiz> quizzes = quizDAO.getAllQuizzes();
        request.setAttribute("quizzes", quizzes);
        
        // Forward to quiz list page
        request.getRequestDispatcher("/views/test/Quiz.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }
}
