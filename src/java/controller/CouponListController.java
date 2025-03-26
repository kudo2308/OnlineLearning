/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CouponDAO;
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
import model.Coupon;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CouponListController", urlPatterns = {"/couponList"})
public class CouponListController extends HttpServlet {

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
            out.println("<title>Servlet CouponController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CouponController at " + request.getContextPath() + "</h1>");
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
            response.sendRedirect(request.getContextPath() + "/login?redirect=MyBlog");
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

        int page = 1; // Mặc định trang đầu tiên
        int recordsPerPage = 7; // Số bài viết mỗi trang

        // Lấy tham số từ request
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * recordsPerPage;

        // Lấy thông báo lỗi/thành công từ URL
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        CouponDAO couponDAO = new CouponDAO();
        List<Coupon> couponList = couponDAO.getAllCoupons();
        int totalBlogs = couponList.size();
        int totalPages = (int) Math.ceil((double) totalBlogs / recordsPerPage);

        int toIndex = Math.min(offset + recordsPerPage, totalBlogs);
        if (offset < totalBlogs) {
            couponList = couponList.subList(offset, toIndex);
        } else {
            couponList = List.of();
        }

        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("couponList", couponList);
        request.getRequestDispatcher("/views/marketting/CouponList.jsp").forward(request, response);
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

        // Lấy thông tin tài khoản từ session
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=couponList");
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

        // Lấy action từ form (add, update, delete)
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=invalidAction");
            return;
        }

        CouponDAO couponDAO = new CouponDAO();

        switch (action) {
            case "add":
                handleAddCoupon(request, response, couponDAO);
                break;

            case "update":
                handleUpdateCoupon(request, response, couponDAO);
                break;

            case "delete":
                handleDeleteCoupon(request, response, couponDAO);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/couponList?error=invalidAction");
                break;
        }
    }

    private void handleAddCoupon(HttpServletRequest request, HttpServletResponse response, CouponDAO couponDAO) throws IOException {
        String couponCode = request.getParameter("couponCode");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String statusStr = request.getParameter("status");

        if (couponCode == null || couponCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingCouponCode");
            return;
        }

        if (discountValueStr == null || discountValueStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingDiscountValue");
            return;
        }

        if (statusStr == null || statusStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingStatus");
            return;
        }

        double discountValue = 0;
        try {
            discountValue = Double.parseDouble(discountValueStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=invalidDiscountValue");
            return;
        }

        boolean status = "1".equals(statusStr); // Convert status to boolean (1 -> active, 0 -> inactive)

        Coupon coupon = new Coupon(couponCode, discountType, discountValue, status);
        boolean isAdded = couponDAO.addCoupon(coupon);

        if (isAdded) {
            response.sendRedirect(request.getContextPath() + "/couponList?message=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/couponList?error=addFailed");
        }
    }

    private void handleUpdateCoupon(HttpServletRequest request, HttpServletResponse response, CouponDAO couponDAO) throws IOException {
        String couponIDStr = request.getParameter("couponID");
        String couponCode = request.getParameter("couponCode");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String statusStr = request.getParameter("status");

        if (couponIDStr == null || couponIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingCouponId");
            return;
        }

        int couponID;
        try {
            couponID = Integer.parseInt(couponIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=invalidCouponId");
            return;
        }

        if (couponCode == null || couponCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingCouponCode");
            return;
        }

        if (discountValueStr == null || discountValueStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingDiscountValue");
            return;
        }

        double discountValue = 0;
        try {
            discountValue = Double.parseDouble(discountValueStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=invalidDiscountValue");
            return;
        }

        if (statusStr == null || statusStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingStatus");
            return;
        }

        boolean status = "1".equals(statusStr); // Convert status to boolean (1 -> active, 0 -> inactive)

        Coupon coupon = new Coupon(couponID, couponCode, discountType, discountValue, status);
        boolean isUpdated = couponDAO.updateCoupon(coupon);

        if (isUpdated) {
            response.sendRedirect(request.getContextPath() + "/couponList?message=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/couponList?error=updateFailed");
        }
    }

    private void handleDeleteCoupon(HttpServletRequest request, HttpServletResponse response, CouponDAO couponDAO) throws IOException {
        String couponIDStr = request.getParameter("couponID");

        if (couponIDStr == null || couponIDStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=missingCouponId");
            return;
        }

        int couponID;
        try {
            couponID = Integer.parseInt(couponIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/couponList?error=invalidCouponId");
            return;
        }

        boolean isDeleted = couponDAO.deleteCoupon(couponID);

        if (isDeleted) {
            response.sendRedirect(request.getContextPath() + "/couponList?message=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/couponList?error=deleteFailed");
        }
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

    public static void main(String[] args) {
        CouponDAO cou = new CouponDAO();
        List<Coupon> couli = cou.getAllCoupons();
        for (Coupon coupon : couli) {
            System.out.println(coupon.getCouponCode());
        }
    }
}
