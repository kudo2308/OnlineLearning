/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Filter;

import DAO.CourseDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import model.Course;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/editCourse", "/deleteCourse"})
public class AuthExpertFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        //lay userid tu session
        Object accountObj = session.getAttribute("account");
 
        if (accountObj == null) {
            httpResponse.sendRedirect("login");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        int userId = Integer.parseInt(userID);
        

        // Get courseId from request parameters
        String courseIdParam = httpRequest.getParameter("courseId");
        if (courseIdParam != null) {
            try {
                int courseId = Integer.parseInt(courseIdParam);

                // Fetch the course from DAO
                CourseDAO courseDAO = new CourseDAO();
                Course course = courseDAO.findCourseById(courseId);

                // check if course not belong to user login 
                if (course == null || course.getExpert().getUserID() != userId) {
                    // If course is not found or user is not the expert, redirect to login page
                    httpResponse.sendRedirect("login");
                    return;
                }
            } catch (Exception e) {
                // Handle exceptions appropriately
                httpResponse.sendRedirect("error.jsp");
                return;
            }
        }

        // Continue with the request if have no error
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }

}
