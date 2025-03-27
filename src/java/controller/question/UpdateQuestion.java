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
import model.Answer;
import model.Question;
import model.Quiz;

/**
 *
 * @author PC
 */
@WebServlet(name="UpdateQuestion", urlPatterns={"/updateQuestion"})
public class UpdateQuestion extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        
        if (action == null) {
            // Hiển thị form chỉnh sửa câu hỏi
            String questionIdParam = request.getParameter("id");
            if (questionIdParam != null && !questionIdParam.isEmpty()) {
                try {
                    int questionId = Integer.parseInt(questionIdParam);
                    
                    // Lấy thông tin câu hỏi
                    QuestionDAO questionDAO = new QuestionDAO();
                    Question question = questionDAO.getQuestionById(questionId);
                    
                    if (question != null) {
                        // Lấy danh sách câu trả lời
                        AnswerDAO answerDAO = new AnswerDAO();
                        List<Answer> answers = answerDAO.getAnswersByQuestionId(questionId);
                        
                        System.out.println("Question ID: " + questionId);
                        System.out.println("Question content: " + question.getContent());
                        System.out.println("Number of answers: " + answers.size());
                        
                        // In thông tin tất cả các đáp án để debug
                        for (Answer answer : answers) {
                            System.out.println("Answer ID: " + answer.getAnswerID() + 
                                               ", Content: " + answer.getContent() + 
                                               ", Is Correct: " + answer.isCorrect() +
                                               ", Explanation: " + answer.getExplanation());
                        }
                        
                        // Nếu không có đáp án, tạo ít nhất 2 đáp án mặc định
                        if (answers.isEmpty() || answers.size() < 2) {
                            System.out.println("Creating default answers because there are fewer than 2 answers");
                            
                            // Tạo danh sách mới nếu không có đáp án
                            if (answers.isEmpty()) {
                                answers = new ArrayList<>();
                            }
                            
                            // Đảm bảo có ít nhất 2 đáp án
                            while (answers.size() < 2) {
                                Answer defaultAnswer = Answer.builder()
                                        .answerID(0) // ID = 0 cho đáp án mới
                                        .content("") // Nội dung trống
                                        .isCorrect(answers.isEmpty()) // Đáp án đầu tiên được đánh dấu là đúng
                                        .explanation("")
                                        .questionID(questionId)
                                        .build();
                                answers.add(defaultAnswer);
                                System.out.println("Added default answer #" + answers.size());
                            }
                        }
                        
                        // Lấy danh sách quiz cho dropdown
                        QuizDAO quizDAO = new QuizDAO();
                        List<Quiz> quizzes = quizDAO.getAllQuizzes();
                        
                        // Đặt thuộc tính cho request
                        request.setAttribute("question", question);
                        request.setAttribute("answers", answers);
                        request.setAttribute("quizzes", quizzes);
                        
                        // Chuyển hướng đến trang chỉnh sửa
                        request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Xử lý lỗi nếu id không phải là số
                    request.setAttribute("error", "Invalid question ID");
                }
            }
            
            // Nếu không tìm thấy câu hỏi hoặc có lỗi, chuyển hướng về trang quản lý câu hỏi
            response.sendRedirect(request.getContextPath() + "/manageQuestion");
        } else if (action.equals("update")) {
            // Xử lý cập nhật câu hỏi
            try {
                // Lấy thông tin câu hỏi từ form
                String questionIdParam = request.getParameter("questionId");
                String quizIdParam = request.getParameter("quizID");
                String content = request.getParameter("content");
                String pointPerQuestionParam = request.getParameter("pointPerQuestion");
                String statusParam = request.getParameter("status");
                
                if (questionIdParam != null && !questionIdParam.isEmpty() 
                        && quizIdParam != null && !quizIdParam.isEmpty() 
                        && content != null && !content.isEmpty() 
                        && pointPerQuestionParam != null && !pointPerQuestionParam.isEmpty() 
                        && statusParam != null && !statusParam.isEmpty()) {
                    
                    int questionId = Integer.parseInt(questionIdParam);
                    int quizId = Integer.parseInt(quizIdParam);
                    int pointPerQuestion = Integer.parseInt(pointPerQuestionParam);
                    boolean status = Boolean.parseBoolean(statusParam);
                    
                    // Tạo đối tượng Question
                    Question question = Question.builder()
                            .questionID(questionId)
                            .content(content)
                            .pointPerQuestion(pointPerQuestion)
                            .quizID(quizId)
                            .status(status)
                            .updatedAt(new Timestamp(System.currentTimeMillis()))
                            .build();
                    
                    // Cập nhật câu hỏi
                    QuestionDAO questionDAO = new QuestionDAO();
                    boolean questionUpdated = questionDAO.updateQuestion(question);
                    
                    if (questionUpdated) {
                        // Lấy thông tin câu trả lời từ form
                        String[] answerIds = request.getParameterValues("answerId[]");
                        String[] answerContents = request.getParameterValues("answerContent[]");
                        String correctAnswerIndex = request.getParameter("isCorrect");
                        String[] explanations = request.getParameterValues("explanation[]");
                        
                        if (answerIds != null && answerContents != null && explanations != null && correctAnswerIndex != null) {
                            // Tạo danh sách câu trả lời
                            List<Answer> answers = new ArrayList<>();
                            for (int i = 0; i < answerContents.length; i++) {
                                boolean isCorrect = String.valueOf(i).equals(correctAnswerIndex);
                                int answerId = Integer.parseInt(answerIds[i]);
                                
                                Answer answer = Answer.builder()
                                        .answerID(answerId)
                                        .content(answerContents[i])
                                        .isCorrect(isCorrect)
                                        .explanation(explanations[i])
                                        .questionID(questionId)
                                        .build();
                                answers.add(answer);
                            }
                            
                            // Cập nhật câu trả lời
                            AnswerDAO answerDAO = new AnswerDAO();
                            boolean answersUpdated = answerDAO.updateAnswers(answers);
                            
                            if (!answersUpdated) {
                                request.setAttribute("error", "Failed to update answers for question. Please try again.");
                                // Lấy lại thông tin câu hỏi và câu trả lời
                                Question updatedQuestion = questionDAO.getQuestionById(questionId);
                                List<Answer> updatedAnswers = answerDAO.getAnswersByQuestionId(questionId);
                                List<Quiz> quizzes = new QuizDAO().getAllQuizzes();
                                
                                request.setAttribute("question", updatedQuestion);
                                request.setAttribute("answers", updatedAnswers);
                                request.setAttribute("quizzes", quizzes);
                                
                                request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
                                return;
                            }
                        } else {
                            request.setAttribute("error", "Missing answer information. Please provide all required fields.");
                            // Lấy lại thông tin câu hỏi và câu trả lời
                            Question updatedQuestion = questionDAO.getQuestionById(questionId);
                            List<Answer> updatedAnswers = new AnswerDAO().getAnswersByQuestionId(questionId);
                            List<Quiz> quizzes = new QuizDAO().getAllQuizzes();
                            
                            request.setAttribute("question", updatedQuestion);
                            request.setAttribute("answers", updatedAnswers);
                            request.setAttribute("quizzes", quizzes);
                            
                            request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
                            return;
                        }
                        
                        // Chuyển hướng về trang quản lý câu hỏi
                        response.sendRedirect(request.getContextPath() + "/manageQuestion");
                    } else {
                        request.setAttribute("error", "Failed to update question. Please try again.");
                        // Lấy lại thông tin câu hỏi và câu trả lời
                        Question updatedQuestion = questionDAO.getQuestionById(questionId);
                        List<Answer> updatedAnswers = new AnswerDAO().getAnswersByQuestionId(questionId);
                        List<Quiz> quizzes = new QuizDAO().getAllQuizzes();
                        
                        request.setAttribute("question", updatedQuestion);
                        request.setAttribute("answers", updatedAnswers);
                        request.setAttribute("quizzes", quizzes);
                        
                        request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Missing question information. Please provide all required fields.");
                    request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "An error occurred: " + e.getMessage());
                request.getRequestDispatcher("/views/test/EditQuestion.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Update Question Controller";
    }
}
