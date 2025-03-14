/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.managerUser;

import DAO.LoginDAO;
import config.Security;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ducbach
 */
@WebServlet(name = "AddUserServlet", urlPatterns = {"/AddUserServlet"})
public class AddUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullname = request.getParameter("fullName");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("roleID");

        if (fullname == null || fullname.isEmpty()) {
            request.setAttribute("error", "Please enter Fullname field");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        request.setAttribute("fullname", fullname);
        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Please enter Email field");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "The email does not exist , check format or domain");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        request.setAttribute("email", email);

        if (pass == null || pass.isEmpty()) {
            request.setAttribute("error", "Please enter Password field");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        LoginDAO dao = new LoginDAO();
        boolean checkUser = dao.check(email);
        if (checkUser) {
            request.setAttribute("error", "This email has been registered");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        //Kiểm tra định dạng của passwword
        if (pass.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 character ");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*[A-Z].*")) {
            request.setAttribute("error", "Password must be contain an uppercase letter");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*\\d.*")) {
            request.setAttribute("error", "Password must be has number");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        if (!pass.matches(".*[@#$%^&+=!].*")) {
            request.setAttribute("error", "Password must be has a special character");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        if (role == null || role.isEmpty()) {
            request.setAttribute("error", "Please choose role field");
            request.getRequestDispatcher("addUser.jsp").forward(request, response);
            return;
        }
        //Hash Email  
        String passHash = Security.encode(pass);
        dao.createAccountAdmin(fullname, email, passHash, Integer.parseInt(role));
        dao.createSocialLinks(dao.getLastUserID());
        request.setAttribute("success", "Creat new user successfully ");
        request.getRequestDispatcher("addUser.jsp").forward(request, response);
    }

}
