/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.packages;

import DAO.CourseDAO;
import DAO.PackagesDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;
import model.Packages;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
/**
 *
 * @author Admin
 */
@WebServlet(name = "EditPackageController", urlPatterns = {"/editPackage"})
public class EditPackageController extends HttpServlet {

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

            String packageId = request.getParameter("packageId");
            PackagesDAO packagesDAO = new PackagesDAO();
            Packages p = packagesDAO.findPackageById(Integer.parseInt(packageId));
            request.setAttribute("p", p);

            request.getRequestDispatcher("/views/admin/edit-package.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        response.setContentType("text/html;charset=UTF-8");
        try {

            String packageId = request.getParameter("packageId");
            String courseId = request.getParameter("courseIdEdit");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean status = request.getParameter("statusEdit").equals("1");
            PackagesDAO packDAO = new PackagesDAO();

            Course course = new Course();
            course.setCourseID(Integer.parseInt(courseId));

            Packages pack = Packages.builder()
                    .packageID(Integer.parseInt(packageId))
                    .course(course)
                    .name(name)
                    .description(description)
                    .Status(status)
                    .build();

            if (packDAO.updatePackage(pack)) {
                request.setAttribute("message", "Update Successfully");
                request.getRequestDispatcher("packages").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Update fail");
                request.getRequestDispatcher("packages").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
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
