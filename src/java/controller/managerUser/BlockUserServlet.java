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
        // Get userID parameter from the form
        String userIDParam = request.getParameter("userID");
        
        if (userIDParam != null && !userIDParam.isEmpty()) {
            try {
                int userID = Integer.parseInt(userIDParam);
                UserDAO userDAO = new UserDAO();
                
                // Get current user status
                User user = userDAO.getUserByID(userID);
                
                if (user != null) {
                    // Toggle status: If active (1), change to inactive (0) and vice versa
                    int currentStatus = user.getStatus();
                    int newStatus = (currentStatus == 1) ? 0 : 1;
                    
                    // Update user status
                    boolean success = userDAO.updateStatus(userID, newStatus);
                    
                    if (success) {
                        // Set success message
                        request.getSession().setAttribute("message", 
                            newStatus == 1 ? "User has been unblocked successfully" : "User has been blocked successfully");
                    } else {
                        // Set error message
                        request.getSession().setAttribute("error", "Failed to update user status");
                    }
                } else {
                    // Set error message
                    request.getSession().setAttribute("error", "User not found");
                }
            } catch (NumberFormatException e) {
                // Set error message
                request.getSession().setAttribute("error", "Invalid user ID");
            }
        } else {
            // Handle case where userID is not provided
            request.getSession().setAttribute("error", "User ID is required");
        }
        
        // Redirect back to user list
        response.sendRedirect("UserList");
    }
}
