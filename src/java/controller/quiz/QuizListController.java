package controller.quiz;

import DAO.CourseDAO;
import DAO.PackagesDAO;
import DAO.QuizDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Packages;
import model.Quiz;

public class QuizListController extends HttpServlet {
    
    private QuizDAO quizDAO;
    private CourseDAO courseDAO;
    private PackagesDAO packagesDAO;
    private static final int PAGE_SIZE = 5; // Số lượng quiz trên mỗi trang
    
    @Override
    public void init() throws ServletException {
        super.init();
        quizDAO = new QuizDAO();
        courseDAO = new CourseDAO();
        packagesDAO = new PackagesDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("list")) {
            // Get filter parameters
            String courseIdParam = request.getParameter("courseId");
            String packageIdParam = request.getParameter("packageId");
            String statusParam = request.getParameter("status");
            String pageParam = request.getParameter("page");
            
            int courseId = 0;
            int packageId = 0;
            Boolean status = null;
            int page = 1; // Mặc định là trang 1
            
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                courseId = Integer.parseInt(courseIdParam);
            }
            
            if (packageIdParam != null && !packageIdParam.isEmpty()) {
                packageId = Integer.parseInt(packageIdParam);
            }
            
            if (statusParam != null && !statusParam.isEmpty()) {
                status = Boolean.parseBoolean(statusParam);
            }
            
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1; // Đảm bảo trang không nhỏ hơn 1
            }
            
            // Lấy tổng số quiz theo bộ lọc
            int totalQuizzes = quizDAO.getTotalFilteredQuizzes(courseId, packageId, status);
            
            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalQuizzes / PAGE_SIZE);
            if (page > totalPages && totalPages > 0) {
                page = totalPages; // Đảm bảo trang không vượt quá tổng số trang
            }
            
            // Get quizzes with filters and paging
            List<Quiz> quizzes = quizDAO.getFilteredQuizzesWithPaging(courseId, packageId, status, page, PAGE_SIZE);
            
            // Get all courses and packages for filter dropdowns
            List<Course> courses = courseDAO.findAll();
            List<Packages> packages = packagesDAO.findAllPackages();
            
            // Set attributes
            request.setAttribute("quizzes", quizzes);
            request.setAttribute("courses", courses);
            request.setAttribute("packages", packages);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("courseId", courseId);
            request.setAttribute("packageId", packageId);
            request.setAttribute("status", status);
            
            // Forward to the quiz list page
            request.getRequestDispatcher("/views/test/QuizList.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            // Handle edit action
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quiz quiz = quizDAO.getQuizById(quizId);
            
            if (quiz != null) {
                // Get all courses and packages for dropdowns
                List<Course> courses = courseDAO.findAll();
                List<Packages> packages = packagesDAO.findAllPackages();
                
                // Set attributes
                request.setAttribute("quiz", quiz);
                request.setAttribute("courses", courses);
                request.setAttribute("packages", packages);
                
                // Forward to the edit quiz page
                request.getRequestDispatcher("/views/test/EditQuiz.jsp").forward(request, response);
            } else {
                // Quiz not found, redirect to list
                response.sendRedirect(request.getContextPath() + "/QuizList?action=list");
            }
        } else if (action.equals("delete")) {
            // Handle delete action
            int quizId = Integer.parseInt(request.getParameter("id"));
            boolean success = quizDAO.deleteQuiz(quizId);
            
            // Redirect to the quiz list page
            response.sendRedirect(request.getContextPath() + "/QuizList?action=list");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action != null && action.equals("update")) {
            // Get parameters from the form
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int duration = Integer.parseInt(request.getParameter("duration"));
            double passRate = Double.parseDouble(request.getParameter("passRate"));
            int totalQuestion = Integer.parseInt(request.getParameter("totalQuestion"));
            int courseID = Integer.parseInt(request.getParameter("courseID"));
            int packageID = Integer.parseInt(request.getParameter("packageID"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            
            // Create quiz object
            Quiz quiz = Quiz.builder()
                    .quizID(quizId)
                    .name(name)
                    .description(description)
                    .duration(duration)
                    .passRate(passRate)
                    .totalQuestion(totalQuestion)
                    .courseID(courseID)
                    .packageID(packageID)
                    .status(status)
                    .build();
            
            // Update quiz
            boolean success = quizDAO.updateQuiz(quiz);
            
            // Redirect to the quiz list page
            response.sendRedirect(request.getContextPath() + "/QuizList?action=list");
        }
    }
}
