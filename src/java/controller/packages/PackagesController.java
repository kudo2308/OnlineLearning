/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.packages;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.PackagesDAO;
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
import model.Category;
import model.Course;
import model.Packages;
import model.PageControl;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
/**
 *
 * @author
 */
@WebServlet(name = "PackagesController", urlPatterns = {"/packages"})
public class PackagesController extends HttpServlet {

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

            List<Packages> packages = pagination(request, pageControl);

            request.setAttribute("pageControl", pageControl);
            request.setAttribute("packages", packages);

            HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            throw new Exception("Sesson not found!");
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        int userId = Integer.parseInt(userID);
            CourseDAO cdao = new CourseDAO();
            List<Course> courses = cdao.findCouseByExpert(userId);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/views/admin/view-package.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("login");
        }
    }

    private List<Packages> pagination(HttpServletRequest request, PageControl pageControl) throws Exception {

        String pageRaw = request.getParameter("page");
        PackagesDAO packagesDAO = new PackagesDAO();

        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalRecord = 0;
        List<Packages> packages = null;
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            throw new Exception("Sesson not found!");
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        int userId = Integer.parseInt(userID);
        Integer courseId = request.getParameter("courseId") != null && request.getParameter("courseId") != "" ? Integer.parseInt(request.getParameter("courseId")) : null;
        Boolean status = request.getParameter("status") != null && request.getParameter("status") != "" ? Boolean.valueOf(request.getParameter("status").equals("1")) : null;

        packages = packagesDAO.findByPageFilterCourseAndStatus(page, status, courseId, userId);

        totalRecord = packagesDAO.findByPageFilterCourseAndStatus(null, status, courseId, userId).size();

        pageControl.setUrlPattern("packages?");

        request.setAttribute("currentPage", page);
        request.setAttribute("courseId", courseId);
        request.setAttribute("status", status);

        //tìm kiếm xem tổng có bao nhiêu page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0
                ? (totalRecord / RECORD_PER_PAGE)
                : (totalRecord / RECORD_PER_PAGE) + 1;

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);

        return packages;
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
