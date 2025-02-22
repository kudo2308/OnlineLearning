package controller.test;

import DAO.QuestionDAO;
import DAO.QuizDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Question;
import model.Quiz;

@WebServlet(name = "TestController", urlPatterns = {"/Test"})
public class TestController extends HttpServlet {
    
    private QuizDAO quizDAO;
    private QuestionDAO questionDAO;
    private final Gson gson = new Gson();
    
    @Override
    public void init() {
        quizDAO = new QuizDAO();
        questionDAO = new QuestionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            // Display quiz list
            List<Quiz> quizList = quizDAO.getAllQuizzes();
            request.setAttribute("quizList", quizList);
            request.getRequestDispatcher("/views/test/Test.jsp").forward(request, response);
        } else if (action.equals("take")) {
            // Start taking a quiz
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            
            // Store questions in session for later use
            HttpSession session = request.getSession();
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("quizQuestions", questions);
            
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("currentQuestionNum", 1);
            request.setAttribute("totalQuestions", questions.size());
            request.setAttribute("currentQuestion", questions.get(0));
            
            request.getRequestDispatcher("/views/test/Test.jsp").forward(request, response);
        } else if (action.equals("question")) {
            // Handle AJAX request for question data
            HttpSession session = request.getSession();
            List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
            
            int questionNum = Integer.parseInt(request.getParameter("num")) - 1;
            Question question = questions.get(questionNum);
            
            // Create response object
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(question));
            out.flush();
            return;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equals("submit")) {
            // Handle quiz submission
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            
            int score = 0;
            for (Question question : questions) {
                String selectedAnswer = request.getParameter("question" + question.getQuestionID());
                if (selectedAnswer != null && Integer.parseInt(selectedAnswer) == question.getCorrectAnswer()) {
                    score++;
                }
            }
            
            // Save the quiz result
            // TODO: Implement quiz result saving logic
            
            // Add comment if provided
            String comment = request.getParameter("comment");
            if (comment != null && !comment.trim().isEmpty()) {
                // TODO: Save comment to database
            }
            
            // Redirect to results page
            response.sendRedirect(request.getContextPath() + "/Test?action=results&quizId=" + quizId + "&score=" + score);
        }
    }
}
