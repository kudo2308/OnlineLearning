package controller.question;

import DAO.AnswerDAO;
import DAO.QuestionDAO;
import DAO.QuizDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
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

@WebServlet(name = "AddQuestionController", urlPatterns = {"/AddQuestion"})
public class AddQuestionController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Get list of quizzes for the dropdown
        QuizDAO quizDAO = new QuizDAO();
        List<Quiz> quizzes = quizDAO.getAllQuizzes();
        request.setAttribute("quizzes", quizzes);
        
        // Get remaining questions count from session
        Integer remainingQuestions = (Integer) session.getAttribute("remainingQuestions");
        Integer currentQuizId = (Integer) session.getAttribute("currentQuizId");
        
        if (remainingQuestions != null && remainingQuestions > 0) {
            request.setAttribute("remainingQuestions", remainingQuestions);
            // Pre-select the current quiz in the dropdown
            request.setAttribute("selectedQuizId", currentQuizId);
        }
        
        if (action == null) {
            // Show the add question form
            request.getRequestDispatcher("/views/test/AddQuestion.jsp").forward(request, response);
        } else if (action.equals("add")) {
            try {
                // Get question data
                int quizID = Integer.parseInt(request.getParameter("quizID"));
                String content = request.getParameter("content");
                int pointPerQuestion = Integer.parseInt(request.getParameter("pointPerQuestion"));
                
                // Create question object
                Question question = Question.builder()
                        .content(content)
                        .pointPerQuestion(pointPerQuestion)
                        .quizID(quizID)
                        .status(true)
                        .createdAt(new Timestamp(System.currentTimeMillis()))
                        .updatedAt(new Timestamp(System.currentTimeMillis()))
                        .build();
                
                // Add question to database
                QuestionDAO questionDAO = new QuestionDAO();
                int questionID = questionDAO.addQuestion(question);
                
                if (questionID >= 1) {
                    // Get answer data
                    String[] answerContents = request.getParameterValues("answerContent[]");
                    String correctAnswerIndex = request.getParameter("isCorrect");
                    String[] explanations = request.getParameterValues("explanation[]");
                    
                    // Create list of answers
                    List<Answer> answers = new ArrayList<>();
                    for (int i = 0; i < answerContents.length; i++) {
                        boolean isCorrect = String.valueOf(i).equals(correctAnswerIndex);
                        
                        Answer answer = Answer.builder()
                                .content(answerContents[i])
                                .isCorrect(isCorrect)
                                .explanation(explanations[i])
                                .questionID(questionID)
                                .build();
                        answers.add(answer);
                        System.out.println("Created answer object: " + answer.getContent());
                    }
                    
                    // Add all answers to database in one transaction
                    AnswerDAO answerDAO = new AnswerDAO();
                    boolean answersAdded = answerDAO.addAnswers(answers);
                    
                    if (!answersAdded) {
                        request.setAttribute("error", "Failed to add answers for question. Please try again.");
                        request.getRequestDispatcher("/views/test/AddQuestion.jsp").forward(request, response);
                        return;
                    }
                    
                    // Update remaining questions count
                    if (remainingQuestions != null && remainingQuestions > 0) {
                        remainingQuestions--;
                        session.setAttribute("remainingQuestions", remainingQuestions);
                        
                        if (remainingQuestions > 0) {
                            // Redirect back to add question form
                            response.sendRedirect(request.getContextPath() + "/AddQuestion");
                            return;
                        }
                    }
                    
                    // If no more questions needed or not tracking questions,
                    // redirect back to testQuiz page through QuizController
                    session.removeAttribute("remainingQuestions");
                    session.removeAttribute("currentQuizId");
                    response.sendRedirect(request.getContextPath() + "/Quiz");
                } else {
                    request.setAttribute("error", "Failed to add question");
                    request.getRequestDispatcher("/views/test/AddQuestion.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid input data");
                request.getRequestDispatcher("/views/test/AddQuestion.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "An error occurred: " + e.getMessage());
                request.getRequestDispatcher("/views/test/AddQuestion.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
