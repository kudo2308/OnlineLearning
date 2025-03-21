/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.question;

import DAO.CourseDAO;
import DAO.LessonDAO;
import DAO.QuestionDAO;
import static constant.Constant.RECORD_PER_PAGE;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;
import model.Lesson;
import model.PageControl;
import model.Question;
import model.Quiz;
@WebServlet(name = "ManageQuestion", urlPatterns = {"/manageQuestion"})
public class ManageQuestion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PageControl pageControl = new PageControl();

        LessonDAO lessonDAO = new LessonDAO();
        CourseDAO courseDAO = new CourseDAO();
        List<Course> courses = courseDAO.findAll();
        List<Lesson> lessons = lessonDAO.findAll();

        List<Question> questions = pagination(request, pageControl);

        request.setAttribute("lessons", lessons);
        request.setAttribute("courses", courses);
        request.setAttribute("pageControl", pageControl);
        request.setAttribute("questions", questions);

        request.getRequestDispatcher("views/question/admin-question-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private List<Question> pagination(HttpServletRequest request, PageControl pageControl) {

        String pageRaw = request.getParameter("page");
        QuestionDAO questionDAO = new QuestionDAO();

        List<Quiz> quizz = questionDAO.findAllQuiz();
        request.setAttribute("quizz", quizz);

        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
        } catch (NumberFormatException e) {
            page = 1;
        }
        int totalRecord = 0;
        List<Question> questions = null;

        String action = request.getParameter("action") == null
                ? "defaultFindAll"
                : request.getParameter("action");

        switch (action) {
            case "FilterAll":
                String titleCourse = request.getParameter("titleCourse");
                String titleQuiz = request.getParameter("quizName");
                String content = request.getParameter("content");
                String sort = request.getParameter("sort");

                String status = request.getParameter("status");

                questions = questionDAO.filterQuestions(content,
                        titleCourse, titleQuiz, status,
                        sort, page);

                totalRecord = questionDAO.findTotalRecordByFilter(content, 
                        titleCourse, titleQuiz, status);
                
                pageControl.setUrlPattern("manageQuestion?content=" + content + "&titleCourse="
                        + titleCourse + "&titleQuiz=" + titleQuiz + "&action=FilterAll&");

                request.setAttribute("titleCourse", titleCourse);
                request.setAttribute("quizName", titleQuiz);
                request.setAttribute("content", content);
                request.setAttribute("status", status);
                request.setAttribute("sort", sort);

                break;
            default:
                questions = questionDAO.findByPage(page);

                totalRecord = questionDAO.findTotalRecord();

                pageControl.setUrlPattern("manageQuestion?");

        }

        request.setAttribute("currentPage", page);

        //tìm kiếm xem tổng có bao nhiêu page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0
                ? (totalRecord / RECORD_PER_PAGE)
                : (totalRecord / RECORD_PER_PAGE) + 1;

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);

        return questions;
    }

}
