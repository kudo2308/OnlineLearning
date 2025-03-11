/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.managerUser;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 *
 * @author ducba
 */
@WebServlet(name="BlockUserServlet", urlPatterns={"/BlockUserServlet"})
public class BlockUserServlet extends HttpServlet {
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName = request.getParameter("gmail");
        String status = request.getParameter("status");
        
        UserDAO userDAO = new UserDAO();
        userDAO.updateStatus(userName, Boolean.parseBoolean(status));
        response.sendRedirect("UserList");
    }

}
