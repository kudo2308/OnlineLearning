/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.CourseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

/**
 *
 * @author dohie
 */
@WebServlet(name = "CourseServlet", urlPatterns = {"/course"})
public class CourseServlet extends HttpServlet {
   
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
        
        try {
            CourseDAO courseDAO = new CourseDAO();
            
            // Lấy tham số phân trang từ request
            String pageStr = request.getParameter("page");
            int page = 1;
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
            int recordsPerPage = 9; // Số khóa học trên mỗi trang
            int offset = (page - 1) * recordsPerPage;
            
            // Lấy danh sách khóa học cho trang hiện tại
            List<Course> courseList = courseDAO.getAllCourses(offset, recordsPerPage);
            
            // Tính tổng số trang
            int totalCourses = courseDAO.getTotalCourses();
            int totalPages = (int) Math.ceil((double) totalCourses / recordsPerPage);
            
            // Set các thuộc tính vào request
            request.setAttribute("courseList", courseList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            
            // Forward đến trang OurCourse.jsp
            request.getRequestDispatcher("views/course/OurCourse.jsp").forward(request, response);
    
       } catch (Exception e) {
            System.out.println("Error in CourseServlet: " + e.getMessage());
            request.getRequestDispatcher("/public/404.jsp").forward(request, response);
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
        return "Short description";
    }
}
