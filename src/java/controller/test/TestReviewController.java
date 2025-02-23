package controller.test;

import DAO.AnswerDAO;
import DAO.QuestionDAO;
import DAO.QuizDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Answer;
import model.Question;
import model.Quiz;

@WebServlet(name = "TestReviewController", urlPatterns = {"/Review"})
public class TestReviewController extends HttpServlet {
    
    private QuizDAO quizDAO;
    private QuestionDAO questionDAO;
    private AnswerDAO answerDAO;
    
    @Override
    public void init() {
        quizDAO = new QuizDAO();
        questionDAO = new QuestionDAO();
        answerDAO = new AnswerDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String quizIdStr = request.getParameter("id");
        
        if (quizIdStr == null || quizIdStr.isEmpty()) {
            response.sendRedirect("Test");
            return;
        }
        
        int quizId = Integer.parseInt(quizIdStr);
        
        if (action == null || action.equals("review")) {
            // Get quiz and questions
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            
            // Load answers for each question
            for (Question question : questions) {
                List<Answer> answers = answerDAO.getAnswersByQuestionId(question.getQuestionID());
                question.setAnswers(answers);
            }
            
            // Set attributes for the review page
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            
            // Forward to review page
            request.getRequestDispatcher("/views/test/TestReview.jsp").forward(request, response);
        } else if (action.equals("retry")) {
            // Redirect to retake the quiz
            response.sendRedirect("Test?action=take&id=" + quizId);
        } else if (action.equals("next")) {
            // Redirect to next quiz
            response.sendRedirect("Test?action=take&id=" + (quizId + 1));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
