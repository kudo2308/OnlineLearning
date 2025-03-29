/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.managerUser;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author SWP Team
 */
public class ChangeRoleServlet extends HttpServlet {
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the form
        String userIDParam = request.getParameter("userID");
        String newRole = request.getParameter("newRole");
        
        if (userIDParam != null && !userIDParam.isEmpty() && newRole != null && !newRole.isEmpty()) {
            try {
                int userID = Integer.parseInt(userIDParam);
                UserDAO userDAO = new UserDAO();
                
                // Update user role
                boolean success = userDAO.updateUserRole(userID, newRole);
                
                if (success) {
                    // Set success message
                    request.getSession().setAttribute("message", 
                        "User role has been changed to " + newRole + " successfully");
                } else {
                    // Set error message
                    request.getSession().setAttribute("error", "Failed to update user role");
                }
            } catch (NumberFormatException e) {
                // Set error message
                request.getSession().setAttribute("error", "Invalid user ID");
            }
        } else {
            // Handle case where parameters are not provided
            request.getSession().setAttribute("error", "User ID and new role are required");
        }
        
        // Redirect back to user list
        response.sendRedirect("UserList");
    }
}
