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
import java.util.List;
import model.Account;

@WebServlet(name = "UserListServlet", urlPatterns = {"/UserList"})
public class UserListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        String searchValue = request.getParameter("searchValue");
        String roleName = request.getParameter("roleName");


        if (roleName != null && roleName.trim().isEmpty()) {
            roleName = null;
        }

        List<Account> userList = dao.getUsersBySearchName(searchValue, roleName);

        int totalUsers = userList.size();
        int totalPages = (int) Math.ceil((double) totalUsers / 6);

        int start = Math.min((page - 1) * 6, totalUsers);
        int end = Math.min(page * 6, totalUsers);
        List<Account> paginatedList = userList.subList(start, end);

        request.setAttribute("listAccount", paginatedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchValue", searchValue);
        request.setAttribute("roleName", roleName);

        request.getRequestDispatcher("listUser.jsp").forward(request, response);
    }

}
