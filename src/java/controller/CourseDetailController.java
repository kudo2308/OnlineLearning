package controller;

import DAO.CartDAO;
import DAO.CourseDAO;
import DAO.FeedbackDAO;
import DAO.LessonDAO;
import DAO.LoginDAO;
import DAO.PackagesDAO;
import DAO.QuizDAO;
import DAO.RegistrationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import model.Course;
import model.Lesson;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Cart;
import model.Feedback;
import model.Packages;

@WebServlet(name = "CourseDetailController", urlPatterns = {"/coursedetail"})
public class CourseDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=coursedetail");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO loginDAO = new LoginDAO();
        Account acc = loginDAO.getAccountByUserID(userID);
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String courseIdParam = request.getParameter("courseId");

        int courseId = 0;
        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdParam);
            } catch (NumberFormatException e) {
                request.getRequestDispatcher("/public/404.jsp").forward(request, response);
                return;
            }
        } else {
            request.getRequestDispatcher("/public/404.jsp").forward(request, response);
            return;
        }

        CourseDAO courseDAO = new CourseDAO();
        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            request.getRequestDispatcher("/public/404.jsp").forward(request, response);
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.get(acc.getUserID());
        if (cart == null) {
            cartDAO.create(acc.getUserID());
            cart = new Cart();
        }
        final int finalCourseId = courseId;
        boolean isInCart = cart.getItems().stream().anyMatch(item -> item.getCourse().getCourseID() == finalCourseId);

        FeedbackDAO feedDAO = new FeedbackDAO();
        List<Feedback> feedList = feedDAO.getFeedbacksByCourseID(courseId);

        RegistrationDAO regisDAO = new RegistrationDAO();
        int register = regisDAO.getNumberOfRegistrationByCourseId(courseId);

        PackagesDAO packagesDAO = new PackagesDAO();
        List<Packages> packageList = packagesDAO.findPackagesByCourseId(courseId);

        // Tạo Map chứa Packages và danh sách Lesson tương ứng
        Map<Packages, List<Lesson>> packageLessonMap = new HashMap<>();
        LessonDAO lessonDAO = new LessonDAO();

        for (Packages pack : packageList) {
            List<Lesson> lessonList = lessonDAO.getAllLessonByPackagesId(pack.getPackageID());
            packageLessonMap.put(pack, lessonList);
        }

        int countLesson = lessonDAO.countLessonsbyCourseId(courseId);

        int duration = packageLessonMap.values().stream()
                .flatMap(List::stream)
                .mapToInt(Lesson::getDuration)
                .sum();
        String durationHour = duration / 60 + "." + duration % 60 / 6;

        QuizDAO quizDAO = new QuizDAO();
        int countQuiz = quizDAO.countQuizByCourseId(courseId);

        boolean isRegistered = regisDAO.isCourseRegisteredByUser(acc.getUserID(), courseId); // Kiểm tra xem người dùng đã đăng ký khóa học chưa
        Map<Integer, Integer> ratingDistribution = feedDAO.getRatingDistribution(courseId);
        int totalRatings = ratingDistribution.values().stream().mapToInt(Integer::intValue).sum();

        double averageRating = 0;
        if (totalRatings > 0) {
            int totalPoints = 0;
            for (Map.Entry<Integer, Integer> entry : ratingDistribution.entrySet()) {
                totalPoints += entry.getKey() * entry.getValue();
            }
            averageRating = (double) totalPoints / totalRatings;
        }

// Gửi dữ liệu về JSP
        request.setAttribute("ratingDistribution", ratingDistribution);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("totalRatings", totalRatings);

        request.setAttribute("feedList", feedList);
        request.setAttribute("isRegistered", isRegistered);  // Truyền thông tin về việc đăng ký khóa học vào JSP
        request.setAttribute("packageLessonMap", packageLessonMap);
        request.setAttribute("packageList", packageList);
        request.setAttribute("isInCart", isInCart);
        request.setAttribute("duration", duration);
        request.setAttribute("durationHour", durationHour);
        request.setAttribute("regisNum", register);
        request.setAttribute("course", course);
        request.setAttribute("quiz", countQuiz);
        request.setAttribute("lessonNumber", countLesson);

        request.getRequestDispatcher("/views/course/CourseDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=Cart");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO loginDAO = new LoginDAO();
        Account acc = loginDAO.getAccountByUserID(userID);
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String content = request.getParameter("content");
        int rating = Integer.parseInt(request.getParameter("rating"));

        FeedbackDAO dao = new FeedbackDAO();
        dao.insertFeedback(acc.getUserID(), courseId, content, rating);

        response.sendRedirect(request.getContextPath() + "/coursedetail?courseId=" + courseId);
    }

    public static void main(String[] args) {
        PackagesDAO pack = new PackagesDAO();
        List<Packages> packList = pack.findPackagesByCourseId(1);
        List<Lesson> lessonList = null;
        LessonDAO lessonDAO = new LessonDAO();
        for (Packages packages : packList) {
            lessonList = lessonDAO.getAllLessonByPackagesId(packages.getPackageID());
        }
        for (Lesson lesson : lessonList) {
            System.out.println(lesson.getTitle());
        }
    }
}
