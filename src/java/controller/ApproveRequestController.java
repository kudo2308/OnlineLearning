/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import DAO.BlogRequestDAO;
import DAO.LoginDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Account;
import model.BlogRequest;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ApproveRequestController", urlPatterns = {"/approveRequest"})
public class ApproveRequestController extends HttpServlet {

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
            out.println("<title>Servlet ApproveRequestController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApproveRequestController at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

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

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalidAccount");
            return;
        }

        String requestIdStr = request.getParameter("requestId");
        String action = request.getParameter("action");
        BlogRequestDAO blogRequestDAO = new BlogRequestDAO();
        BlogDAO blogDAO = new BlogDAO(); // DAO for Blog

        if (requestIdStr != null && !requestIdStr.isEmpty() && action != null) {
            int requestId = Integer.parseInt(requestIdStr);

            boolean success = false;
            BlogRequest blogRequest = blogRequestDAO.getBlogRequestById(requestId); // Get BlogRequest

            if (blogRequest != null) {
                // Cập nhật trạng thái của yêu cầu
                if (action.equals("approve")) {
                    success = blogRequestDAO.updateRequestStatus(requestId, "Approved", acc.getUserID());

                    // Cập nhật trạng thái của Blog thành 'Public'
                    if (success) {
                        success = blogDAO.updateBlogStatus(blogRequest.getBlogId(), "Public");
                    }
                } else if (action.equals("reject")) {
                    success = blogRequestDAO.updateRequestStatus(requestId, "Rejected", acc.getUserID());

                    // Cập nhật trạng thái của Blog thành 'Private'
                    if (success) {
                        success = blogDAO.updateBlogStatus(blogRequest.getBlogId(), "Private");
                    }
                }

                // Xóa yêu cầu BlogRequest sau khi xử lý
                if (success) {
                    success = blogRequestDAO.deleteBlogRequest(requestId); // Xóa BlogRequest
                }
            }

            // Quay lại trang admin với thông báo thành công
            if (success) {
                request.setAttribute("status", "success");
                request.setAttribute("message", "Request processed successfully!");
            } else {
                request.setAttribute("status", "error");
                request.setAttribute("message", "An error occurred. Please try again.");
            }
        } else {
            request.setAttribute("status", "invalidRequest");
            request.setAttribute("message", "Invalid request.");
        }

        // Lấy tất cả các yêu cầu BlogRequest
        List<BlogRequest> list = blogRequestDAO.getAllBlogRequests();
        request.setAttribute("requests", list);

        // Forward request đến trang JSP để hiển thị kết quả
        request.getRequestDispatcher("/views/marketing/AdminApprovalPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);  // Gọi lại doGet để xử lý POST như GET
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
