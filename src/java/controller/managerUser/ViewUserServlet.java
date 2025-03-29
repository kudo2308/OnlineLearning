/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.managerUser;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.RegistrationDAO;
import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Category;
import model.Course;
import model.CourseWithCategory;
import model.Registration;
import model.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "ViewUserServlet", urlPatterns = {"/ViewUser"})
public class ViewUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userIDParam = request.getParameter("id");
            if (userIDParam == null || userIDParam.isEmpty()) {
                response.sendRedirect("UserList");
                return;
            }
            
            int userID = Integer.parseInt(userIDParam);
            
            UserDAO userDAO = new UserDAO();
            Account user = userDAO.getAccountByID(userID);
            
            if (user == null) {
                response.sendRedirect("UserList");
                return;
            }
            
            request.setAttribute("user", user);
            System.out.println("User role: " + user.getRole().getRoleName());
            
            if (user.getRole().getRoleName().equals("Expert")) {
                CourseDAO courseDAO = new CourseDAO();
                List<Course> courses = courseDAO.getCoursesByExpertID(userID);
                System.out.println("Expert courses found: " + (courses != null ? courses.size() : "null"));
                request.setAttribute("courses", courses);
            } 
            else if (user.getRole().getRoleName().equals("Student")) {
                // Đơn giản hóa: Lấy danh sách khóa học mà học viên đã đăng ký
                RegistrationDAO registrationDAO = new RegistrationDAO();
                List<Registration> registrations = registrationDAO.getRegistrationsByUserID(userID);
                System.out.println("Student registrations found: " + (registrations != null ? registrations.size() : "null"));
                
                // Lấy danh sách khóa học từ registrations
                List<Course> studentCourses = new ArrayList<>();
                if (registrations != null) {
                    for (Registration reg : registrations) {
                        if (reg.getCourse() != null) {
                            studentCourses.add(reg.getCourse());
                        }
                    }
                }
                System.out.println("Student courses found: " + studentCourses.size());
                request.setAttribute("courses", studentCourses);
                request.setAttribute("registrations", registrations);
            }
            
            request.getRequestDispatcher("viewUser.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in ViewUserServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("UserList");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
