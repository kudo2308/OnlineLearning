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
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import model.Account;
import model.SocialLink;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "Private", urlPatterns = {"/private"})
public class Private extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorprivate = request.getParameter("errorprivate");
        String success = request.getParameter("success");

        if (success != null) {
            request.setAttribute("success", success);
        }
        if (errorprivate != null) {
            request.setAttribute("errorprofile", errorprivate);
        }

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);
        SocialLink links = dao.getSocialLink(acc.getUserID());
        request.getSession().setAttribute("linkedin", links.getLinkedin());
        request.getSession().setAttribute("youtube", links.getYoutube());
        request.getSession().setAttribute("xspace", links.getXspace());
        request.getSession().setAttribute("facebook", links.getFacebook());

        if (links.getCheckPrivate().equalsIgnoreCase("block-view")) {
            request.getRequestDispatcher("private.jsp").forward(request, response);
            return;
        }
        if (links.getCheckPrivate().equalsIgnoreCase("public")) {
            request.setAttribute("showProfile", true);
             request.setAttribute("showCoursesRegister", true);
            request.setAttribute("showCourses", true);
        }
        if (links.getCheckPrivate().equalsIgnoreCase("block-inscrits")) {
            request.setAttribute("showProfile", true);
            request.setAttribute("showCourses", true);
        }
        if (links.getCheckPrivate().equalsIgnoreCase("block-course")) {
            request.setAttribute("showProfile", true);
            request.setAttribute("showCoursesRegister", true);
        }
        request.getRequestDispatcher("private.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String linkedin = request.getParameter("linkedin");
        String youtube = request.getParameter("youtube");
        String xspace = request.getParameter("xspace");
        String facebook = request.getParameter("facebook");
        boolean isShowProfileChecked = request.getParameter("showProfile") != null;
        boolean isshowCoursesRegister = request.getParameter("showCoursesRegister") != null;
        boolean isshowCourses = request.getParameter("showCourses") != null;
        String privacy = "public";
        if (isShowProfileChecked && isshowCoursesRegister && isshowCourses) {
            privacy = "public";
        }
        if (!isShowProfileChecked && (!isshowCoursesRegister || !isshowCourses)) {
            privacy = "block-view";
        }
        if (isShowProfileChecked && !isshowCoursesRegister && isshowCourses) {
            privacy = "block-inscrits";
        }
        if (isShowProfileChecked && isshowCoursesRegister && !isshowCourses) {
            privacy = "block-course";
        }
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);
        dao.updateSocialLinks(acc.getUserID(), xspace, youtube, facebook, linkedin, privacy);
        response.sendRedirect("private");
    }

}
