/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.LoginDAO;
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

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "PurchaseHistory", urlPatterns = {"/purchase"})
public class PurchaseHistory extends HttpServlet {

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

        LoginDAO dao = new LoginDAO();
        Account account = dao.getAccountByUserID(userID);

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int page = 1;
            int recordsPerPage = 10; 
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            OrderDAO orderDAO = new OrderDAO();
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            List<Order> orderList = orderDAO.getOrdersByAccountId(account.getUserID(), (page - 1) * recordsPerPage, recordsPerPage);
            for (Order order : orderList) {
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(order.getOrderID());
                order.setOrderItems(orderItems);
            }
            int totalOrders = orderDAO.countOrdersByAccountId(account.getUserID());
            int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);
            request.setAttribute("orderList", orderList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("purchaseHistory.jsp").forward(request, response);

        } catch (ServletException | IOException | SQLException e) {
            System.out.println("Error in PurchaseHistoryServlet: " + e.getMessage());
            request.setAttribute("error", "An error occurred while retrieving your purchase history. Please try again later.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
