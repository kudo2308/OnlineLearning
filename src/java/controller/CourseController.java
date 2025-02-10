/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import static constant.Constant.RECORD_PER_PAGE;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;
import model.Course;
import model.PageControl;

/**
 *
 * @author PC
 */
public class CourseController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PageControl pageControl = new PageControl();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Category> categories = categoryDAO.findALl();
        List<Course> courses = pagination(request, pageControl);

        request.setAttribute("pageControl", pageControl);
        request.setAttribute("courses", courses);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin/view-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private List<Course> pagination(HttpServletRequest request, PageControl pageControl) {

        String pageRaw = request.getParameter("page");
        CourseDAO courseDAO = new CourseDAO();

        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
        } catch (NumberFormatException e) {
            page = 1;
        }
        int totalRecord = 0;
        List<Course> listCourse = null;

        String action = request.getParameter("action") == null
                ? "defaultFindAll"
                : request.getParameter("action");

        switch (action) {
            case "FilterCategoryAndStatus":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String status = request.getParameter("status");
                listCourse = courseDAO.findByPageFilterCategoryAndStatus(page, categoryId, status);

                totalRecord = listCourse.size();

                pageControl.setUrlPattern("courses?category=" + categoryId + "&status=" + status + "&");

                request.setAttribute("categoryId", categoryId);
                request.setAttribute("status", status);
                break;
            case "searchByName":

                String name = request.getParameter("name");
                listCourse = courseDAO.searchCourseByName(page, name);

                totalRecord = listCourse.size();

                pageControl.setUrlPattern("courses?name=" + name + "&");

                request.setAttribute("name", name);

                break;
            default:
                listCourse = courseDAO.findByPage(page);

                totalRecord = courseDAO.findTotalRecord();

                pageControl.setUrlPattern("courses?");

        }

        request.setAttribute("currentPage", page);

        //tìm kiếm xem tổng có bao nhiêu page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0
                ? (totalRecord / RECORD_PER_PAGE)
                : (totalRecord / RECORD_PER_PAGE) + 1;

        pageControl.setPage(page);
        pageControl.setTotalPage(totalPage);
        pageControl.setTotalRecord(totalRecord);

        return listCourse;
    }

}
