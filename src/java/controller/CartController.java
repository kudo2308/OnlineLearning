/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CartDAO;
import DAO.CourseDAO;
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
import model.Cart;
import model.CartItem;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=Cart");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);
        CartDAO cartDAO = new CartDAO();

        Cart cart = cartDAO.get(acc.getUserID());

        if (cart == null) {
            cartDAO.create(acc.getUserID());
            cart = new Cart();
        }

        request.setAttribute("cart", cart.getItems());
        request.getRequestDispatcher("views/user/Cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        // 1. Kiểm tra đăng nhập
        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=Blog");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String action = request.getParameter("action");

        CourseDAO courseDAO = new CourseDAO();
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.get(acc.getUserID());
        if (cart == null) {
            cartDAO.create(acc.getUserID());
            cart = new Cart();
        }

        switch (action) {

            case "add" -> {
                boolean isExist = false;
                if (cart.getItems() != null) {
                    isExist = cart.getItems().stream().anyMatch(c -> c.getCourse().getCourseID() == courseId);
                }
                if (isExist) {
                    break;
                } else {
                    cartDAO.add(courseDAO.getCourseById(courseId), cart);
                }

            }

            case "delete" -> {
                cartDAO.delete(courseDAO.getCourseById(courseId), cart);
            }
        }

        response.sendRedirect("cart");
    }
}
