package controller;

import DAO.CourseDAO;
import DAO.LessonDAO;
import DAO.QuizDAO;
import DAO.RegistrationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Lesson;
import java.util.List;

@WebServlet(name = "CourseDetailController", urlPatterns = {"/coursedetail"})
public class CourseDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdParam = request.getParameter("courseId");

        int courseId = 0;
        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdParam);
            } catch (NumberFormatException e) {
                request.getRequestDispatcher("/public/404.jsp").forward(request, response);
            }
        }
        CourseDAO courseDAO = new CourseDAO();
        Course course = courseDAO.getCourseById(courseId);
        RegistrationDAO regisDAO = new RegistrationDAO();
        LessonDAO lessonDAO = new LessonDAO();

        int register = regisDAO.getNumberOfRegistrationByCourseId(courseId);
        int countLesson = lessonDAO.countLessonsbyCourseId(courseId);
        List<Lesson> lessonList = lessonDAO.getAllLessonByCourseId(courseId);
        int duration = 0;
        for (Lesson lesson : lessonList) {
            duration += lesson.getDuration();
        }
        String durationHour = duration / 60 + "." + duration % 60 / 6;

        QuizDAO quizDAO = new QuizDAO();
        int countQuiz = quizDAO.countQuizByCourseId(courseId);

        request.setAttribute("duration", duration);
        request.setAttribute("durationHour", durationHour);
        request.setAttribute("lessonList", lessonList);
        request.setAttribute("regisNum", register);
        request.setAttribute("course", course);
        request.setAttribute("quiz", countQuiz);
        request.setAttribute("lessonNumber", countLesson);
        // Forward to the course detail page
        request.getRequestDispatcher("/views/course/CourseDetail.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    public static void main(String[] args) {
        CourseDAO courseDAO = new CourseDAO();
        Course course = courseDAO.getCourseById(1);
        System.out.println(course.getTitle());
    }
}
