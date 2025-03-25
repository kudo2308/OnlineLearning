/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.quiz;

import controller.*;
import DAO.QuizDAO;
import DAO.QuestionDAO;
import DAO.AnswerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Quiz;
import model.Question;
import model.Answer;

/**
 *
 * @author dohie
 */
@WebServlet(name = "QuizController", urlPatterns = {"/Quiz"})
public class QuizController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listQuizzes(request, response);
                break;
            case "view":
                viewQuiz(request, response);
                break;
            case "start":
                startQuiz(request, response);
                break;
            default:
                listQuizzes(request, response);
        }
    }
    
    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuizDAO quizDAO = new QuizDAO();
        List<Quiz> quizzes = quizDAO.getAllQuizzes();
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("/views/test/Quiz.jsp").forward(request, response);
    }
    
    private void viewQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int quizId = Integer.parseInt(request.getParameter("id"));
            QuizDAO quizDAO = new QuizDAO();
            
            Quiz quiz = quizDAO.getQuizById(quizId);
            if (quiz != null) {
                request.setAttribute("quiz", quiz);
                request.getRequestDispatcher("/views/test/QuizDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/Quiz");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Quiz");
        }
    }
    
    private void startQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int quizId = Integer.parseInt(request.getParameter("id"));
            QuizDAO quizDAO = new QuizDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            AnswerDAO answerDAO = new AnswerDAO();
            
            Quiz quiz = quizDAO.getQuizById(quizId);
            if (quiz != null) {
                List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
                
                // Lấy đáp án cho mỗi câu hỏi
                for (Question question : questions) {
                    List<Answer> answers = answerDAO.getAnswersByQuestionId(question.getQuestionID());
                    question.setAnswers(answers);
                }
                
                request.setAttribute("quiz", quiz);
                request.setAttribute("questions", questions);
                request.getRequestDispatcher("/views/test/TakeQuiz.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/Quiz");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Quiz");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Quiz Controller";
    }// </editor-fold>

}
