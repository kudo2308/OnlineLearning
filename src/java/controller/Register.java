package controller;

import DAO.LoginDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("dk.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");

        // Kiểm tra nếu có trường nào bị bỏ trống
        if (user == null || user.isEmpty()
                || pass == null || pass.isEmpty()
                || email == null || email.isEmpty()
                || phone == null || phone.isEmpty()
                || fullname == null || fullname.isEmpty()
                || address == null || address.isEmpty()) {
            request.setAttribute("errorregister", "Tất cả các trường đều bắt buộc");
            request.getRequestDispatcher("dk.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng email hợp lệ
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errorregister", "Định dạng email không hợp lệ");
            request.getRequestDispatcher("dk.jsp").forward(request, response);
            return;
        }

        // Kiểm tra số điện thoại hợp lệ (giả sử 10 chữ số)
        if (!phone.matches("^[0-9]{10}$")) {
            request.setAttribute("errorregister", "Số điện thoại phải là 10 chữ số");
            request.getRequestDispatcher("dk.jsp").forward(request, response);
            return;
        }

        LoginDAO d = new LoginDAO();
        Account tk = d.check(user); 

        if (tk == null) {
            // Nếu tài khoản chưa tồn tại, tạo người dùng mới
            boolean userCreated = d.createAccount(user, pass, fullname, phone, address, email);

            if (userCreated) {
                // Nếu tạo thành công, đăng nhập và chuyển hướng tới home.jsp
                HttpSession session = request.getSession();
                Account newUser = d.check(user); // Lấy thông tin user vừa tạo
                session.setAttribute("account", newUser);
                response.sendRedirect("home");
            } else {
                // Nếu tạo tài khoản thất bại, thông báo lỗi
                request.setAttribute("errorregister", "Tạo tài khoản thất bại");
                request.getRequestDispatcher("dk.jsp").forward(request, response);
            }
        } else {
            // Nếu người dùng đã tồn tại, thông báo lỗi
            request.setAttribute("errorregister", "Tài khoản đã tồn tại");
            request.getRequestDispatcher("dk.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for user registration";
    }
}
