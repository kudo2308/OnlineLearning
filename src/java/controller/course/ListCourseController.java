/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.course;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import static constant.Constant.RECORD_PER_PAGE;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Category;
import model.Course;
import model.PageControl;

/**
 *
 * @author PC
 */
@WebServlet(name = "ListCourseController", urlPatterns = {"/manager-courses"})
public class ListCourseController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            PageControl pageControl = new PageControl();
            CategoryDAO categoryDAO = new CategoryDAO();

            List<Category> categories = categoryDAO.findAll();
            List<Course> courses = pagination(request, pageControl);

            request.setAttribute("pageControl", pageControl);
            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("listCourse.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("dsfdsfdf" + e.getMessage());
            response.sendRedirect("login");
        }
    }

    private List<Course> pagination(HttpServletRequest request, PageControl pageControl) throws Exception {

        String pageRaw = request.getParameter("page");
        CourseDAO courseDAO = new CourseDAO();

        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalRecord = 0;
        List<Course> listCourse = null;

//        String action = request.getParameter("action") == null
//                ? "defaultFindAll"
//                : request.getParameter("action");

//        HttpSession session = request.getSession();
//        Object accountObj = session.getAttribute("account");
//
//        if (accountObj == null) {
//            throw new Exception("Sesson not found!");
//        }
//
//        String userID = null;
//        if (accountObj instanceof Map) {
//            Map<String, String> accountData = (Map<String, String>) accountObj;
//            userID = accountData.get("userId");
//        }
//        int userId = Integer.parseInt(userID);

        int categoryId = Integer.parseInt(request.getParameter("categoryId") == null ? "0" : request.getParameter("categoryId"));
        String status = request.getParameter("status") == null ? "Pending" : request.getParameter("status");
        String name = request.getParameter("name") == null ? "" : request.getParameter("name");
        listCourse = courseDAO.findByPageFilterCategoryAndStatus(page,
                categoryId, status, null, name);

        totalRecord = courseDAO.findByPageFilterCategoryAndStatus(null,
                categoryId, status, null, name).size();

        pageControl.setUrlPattern("manager-courses?categoryId=" + categoryId + "&status=" + status + "&");

        request.setAttribute("categoryId", categoryId);
        request.setAttribute("status", status);
        request.setAttribute("name", name);

        request.setAttribute("currentPage", page);

        //tìm kiếm xem tổng có bao nhiêu page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0
                ? (totalRecord / RECORD_PER_PAGE)
                : (totalRecord / RECORD_PER_PAGE) + 1;

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);

        return listCourse;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
