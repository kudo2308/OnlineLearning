/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.LoginDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Account;
import model.Course;
import model.SocialLink;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "PublicProfile", urlPatterns = {"/publicprofile"})
public class PublicProfile extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String email = request.getParameter("email");
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByEmail(email);
        SocialLink links = dao.getSocialLink(acc.getUserID());
        if (links.getCheckPrivate().equals("block-view")) {
            request.setAttribute("privateUser", "This user set private profile");
            request.getRequestDispatcher("public_profile.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("linkedin", links.getLinkedin());
        request.getSession().setAttribute("youtube", links.getYoutube());
        request.getSession().setAttribute("xspace", links.getXspace());
        request.getSession().setAttribute("facebook", links.getFacebook());
        request.getSession().setAttribute("description", acc.getDescription());
        request.setAttribute("img", acc.getImage());
        request.setAttribute("fullname", acc.getFullName());
        request.setAttribute("email", email);
        if (links.getCheckPrivate().equals("view-profile-only")) {
            request.getRequestDispatcher("public_profile.jsp").forward(request, response);
            return;
        }
        List<Course> listCourseRegis = dao.getRegisteredCoursesForUser(acc.getUserID());
        if (acc.getRole().getRoleName().equalsIgnoreCase("EXPERT")) {
            List<Course> listCourseTeach = dao.getCoursesByExpert(acc.getUserID());
            if (listCourseTeach != null && !listCourseTeach.isEmpty() && !links.getCheckPrivate().equals("block-inscrits")) {
                request.setAttribute("listCourseTeach", listCourseTeach);
            }
        }
        if (listCourseRegis != null && !listCourseRegis.isEmpty() && !"block-course".equals(links.getCheckPrivate())) {
            request.setAttribute("recentCourses", listCourseRegis);
        }
        request.getRequestDispatcher("public_profile.jsp").forward(request, response);
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
