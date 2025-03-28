package controller;

import DAO.LoginDAO;
import DAO.RegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Registration;

@WebServlet(name = "AdminNewRegistrationsController", urlPatterns = {"/admin-new-registrations"})
public class AdminNewRegistrationsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user has admin access
        if (!hasAdminAccess(session)) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        // Get parameters for filtering and pagination
        String searchQuery = request.getParameter("search");
        String searchType = request.getParameter("searchType"); // email or fullname
        String daysStr = request.getParameter("days");
        String sortOrder = request.getParameter("sortOrder");
        
        // Default to 30 days if not specified
        int days = 30;
        try {
            if (daysStr != null && !daysStr.isEmpty()) {
                days = Integer.parseInt(daysStr);
            }
        } catch (NumberFormatException e) {
            days = 30;
        }
        
        // Get page parameter
        String pageStr = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(pageStr);
            if (page < 1) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Records per page
        int recordsPerPage = 10;
        
        // Initialize DAO
        RegistrationDAO registrationDAO = new RegistrationDAO();
        List<Registration> newRegistrations;
        int totalRegistrations;
        
        // Handle search, filter, and sort
        if (searchQuery != null && !searchQuery.isEmpty()) {
            if ("email".equals(searchType)) {
                newRegistrations = registrationDAO.searchNewRegistrationsByEmail(searchQuery, days, sortOrder);
            } else {
                newRegistrations = registrationDAO.searchNewRegistrationsByFullName(searchQuery, days, sortOrder);
            }
            totalRegistrations = newRegistrations.size();
            
            // Manual pagination for search results
            int fromIndex = (page - 1) * recordsPerPage;
            int toIndex = Math.min(fromIndex + recordsPerPage, newRegistrations.size());
            
            if (fromIndex < newRegistrations.size()) {
                newRegistrations = newRegistrations.subList(fromIndex, toIndex);
            } else {
                newRegistrations.clear();
            }
        } else {
            // Get paginated new registrations
            newRegistrations = registrationDAO.getNewRegistrations(days, page, recordsPerPage);
            totalRegistrations = registrationDAO.getTotalNewRegistrations(days);
        }
        
        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalRegistrations / recordsPerPage);
        
        // Set attributes for the view
        request.setAttribute("newRegistrations", newRegistrations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchType", searchType);
        request.setAttribute("days", daysStr);
        request.setAttribute("sortOrder", sortOrder);
        
        // Forward to the admin new registrations page
        request.getRequestDispatcher("/views/admin/new-registrations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user has admin access
        if (!hasAdminAccess(session)) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action != null) {
            RegistrationDAO registrationDAO = new RegistrationDAO();
            
            if (action.equals("update-status")) {
                // Get registration ID and new status
                int registrationId = Integer.parseInt(request.getParameter("registrationId"));
                String newStatus = request.getParameter("status");
                
                // Update registration status
                registrationDAO.updateStatus(registrationId, newStatus);
                
                // Add success message
                request.getSession().setAttribute("successMessage", "Registration status updated successfully.");
            }
        }
        
        // Redirect back to the new registrations page
        response.sendRedirect(request.getContextPath() + "/admin-new-registrations");
    }
    
    private boolean hasAdminAccess(HttpSession session) {
        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            return false;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        if (acc != null) {
            return "Admin".equals(acc.getRole().getRoleName());
        }
        return false;
    }
}
