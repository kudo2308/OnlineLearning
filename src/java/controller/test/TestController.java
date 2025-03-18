package controller.test;

import DAO.AnswerDAO;
import DAO.QuestionDAO;
import DAO.QuizDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Answer;
import model.Question;
import model.Quiz;

@WebServlet(name = "TestController", urlPatterns = {"/Test"})
public class TestController extends HttpServlet {
    
    private QuizDAO quizDAO;
    private QuestionDAO questionDAO;
    private AnswerDAO answerDAO;
    private final Gson gson = new Gson();
    
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
        
        if (action == null) {
            // Display quiz list
            List<Quiz> quizList = quizDAO.getAllQuizzes();
            request.setAttribute("quizList", quizList);
            request.getRequestDispatcher("/views/test/testQuiz.jsp").forward(request, response);
        } else if (action.equals("take")) {
            // Start taking a quiz
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            
            System.out.println("Debug - Starting quiz: " + quiz.getName());
            System.out.println("Debug - Total questions: " + questions.size());
            
            // Load answers for each question
            for (Question question : questions) {
                System.out.println("\nDebug - Loading answers for question ID: " + question.getQuestionID());
                List<Answer> answers = answerDAO.getAnswersByQuestionId(question.getQuestionID());
                question.setAnswers(answers);
                System.out.println("Debug - Answers loaded: " + answers.size());
                
                // Print each answer for verification
                for (Answer answer : answers) {
                    System.out.println("Debug - Answer: " + answer.getContent());
                }
            }
            
            // Clear old session data and store new questions
            HttpSession session = request.getSession();

            // Store new data in session
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("quizQuestions", questions);
            
            // Reset to first question
            Question firstQuestion = questions.get(0);
            System.out.println("\nDebug - Setting first question:");
            System.out.println("Question ID: " + firstQuestion.getQuestionID());
            System.out.println("Question content: " + firstQuestion.getContent());
            System.out.println("Number of answers: " + (firstQuestion.getAnswers() != null ? firstQuestion.getAnswers().size() : 0));
            
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("currentQuestionNum", 1);
            request.setAttribute("totalQuestions", questions.size());
            request.setAttribute("currentQuestion", firstQuestion);
            
            request.getRequestDispatcher("/views/test/Test.jsp").forward(request, response);
        } else if (action.equals("question")) {
            // Handle navigation between questions
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            int questionNum = Integer.parseInt(request.getParameter("num"));
            
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            
            // Load answers for the current question
            Question currentQuestion = questions.get(questionNum - 1);
            List<Answer> answers = answerDAO.getAnswersByQuestionId(currentQuestion.getQuestionID());
            currentQuestion.setAnswers(answers);
            
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("currentQuestionNum", questionNum);
            request.setAttribute("totalQuestions", questions.size());
            request.setAttribute("currentQuestion", currentQuestion);
            
            request.getRequestDispatcher("/views/test/Test.jsp").forward(request, response);
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
            
            double totalScore = 0;
            int totalPoints = 0;
            
            System.out.println("Debug - Processing quiz submission:");
            System.out.println("Quiz ID: " + quizId);
            System.out.println("Total questions: " + questions.size());
            
            for (Question question : questions) {
                String selectedAnswerId = request.getParameter("question" + question.getQuestionID());
                System.out.println("\nQuestion ID: " + question.getQuestionID());
                System.out.println("Selected Answer ID: " + selectedAnswerId);
                
                if (selectedAnswerId != null) {
                    List<Answer> answers = answerDAO.getAnswersByQuestionId(question.getQuestionID());
                    for (Answer answer : answers) {
                        if (answer.getAnswerID() == Integer.parseInt(selectedAnswerId)) {
                            System.out.println("Found matching answer - IsCorrect: " + answer.isCorrect());
                            if (answer.isCorrect()) {
                                totalScore += question.getPointPerQuestion();
                            }
                            break;
                        }
                    }
                }
                totalPoints += question.getPointPerQuestion();
            }
            
            // Calculate percentage score
            double percentage = (totalScore / totalPoints) * 100;
            
            System.out.println("\nFinal Results:");
            System.out.println("Total Score: " + totalScore);
            System.out.println("Total Points Possible: " + totalPoints);
            System.out.println("Percentage: " + percentage + "%");
            
            // Get quiz for pass rate comparison
            Quiz quiz = quizDAO.getQuizById(quizId);
            boolean passed = percentage >= quiz.getPassRate();
            
            // Store results in request
            request.setAttribute("quiz", quiz);
            request.setAttribute("score", totalScore);
            request.setAttribute("totalPoints", totalPoints);
            request.setAttribute("percentage", percentage);
            request.setAttribute("passed", passed);
            
            // Forward to results page
            request.getRequestDispatcher("/views/test/Results.jsp").forward(request, response);
        }
    }
}
