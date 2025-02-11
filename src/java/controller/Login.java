package controller;

import DAO.LoginDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

@WebServlet(name = "Login", urlPatterns = {"/login"})
public class Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Login</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Login at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String rem = request.getParameter("remember");
        LoginDAO d = new LoginDAO();
        Account account = d.check(user, pass);
        if (account == null) {
            request.setAttribute("errorlogin", "FailLogin");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            Cookie us = new Cookie("user", user);
            Cookie pas = new Cookie("pass", pass);
            Cookie re = new Cookie("remember", rem);
            if (rem == null) {
                us.setMaxAge(0);
                pas.setMaxAge(0);
                re.setMaxAge(0);
            } else {
                us.setMaxAge(60 * 60 * 24);
                pas.setMaxAge(60 * 60 * 24);
                re.setMaxAge(60 * 60 * 24);
            }
            response.addCookie(us);
            response.addCookie(pas);
            response.addCookie(re);
            response.sendRedirect("home");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
