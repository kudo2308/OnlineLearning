package controller;

import DAO.OrderDAO;
import DAO.OrderItemDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Order;
import model.OrderItem;
import DAO.LoginDAO;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "OrderDetails", urlPatterns = {"/order-details"})
public class OrderDetails extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");
        
        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        
        if (userID == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/purchase");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            // Check if order exists and belongs to the current user
            if (order == null || order.getAccountID() != Integer.parseInt(userID)) {
                response.sendRedirect(request.getContextPath() + "/purchase");
                return;
            }
            
            // Get order items with detailed information
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsWithCourseDetails(orderId);
            order.setOrderItems(orderItems);
            
            // Get account details
            LoginDAO loginDAO = new LoginDAO();
            Account account = loginDAO.getAccountByUserID(userID);
            
            request.setAttribute("order", order);
            request.setAttribute("account", account);
            request.getRequestDispatcher("orderDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/purchase");
        } catch (SQLException e) {
            System.out.println("Error in OrderDetails: " + e.getMessage());
            request.setAttribute("error", "An error occurred while retrieving order details. Please try again later.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
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
        return "Order Details Servlet";
    }
}