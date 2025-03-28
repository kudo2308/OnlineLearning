/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import DAO.LessonDAO;
import DAO.PackagesDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Course;
import model.Lesson;
import model.Packages;
import utils.ConvertInput;
import utils.ValidateInput;
import utils.YouTubeDurationFetcher;

/**
 *
 * @author PC
 */
@WebServlet(name = "AddLesson", urlPatterns = {"/addLesson"})
public class AddLesson extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            PackagesDAO packDAO = new PackagesDAO();
            HttpSession session = request.getSession();
            Object accountObj = session.getAttribute("account");

            if (accountObj == null) {
                throw new Exception("Sesson not found!");
            }

            String userID = null;
            if (accountObj instanceof Map) {
                Map<String, String> accountData = (Map<String, String>) accountObj;
                userID = accountData.get("userId");
            }
            int userId = Integer.parseInt(userID);
            List<Packages> packages = packDAO.findPackageByExpert(userId);

            request.setAttribute("packages", packages);

            request.getRequestDispatcher("views/lesson/add-lesson.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String lessonType = request.getParameter("lessonType");
            String videoUrl = request.getParameter("videoUrl");
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String documentUrl = request.getParameter("documentUrl");
//            int orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
            boolean status = request.getParameter("status").equals("1");

            if (!ValidateInput.isYouTubeLinkActive(videoUrl)) {
                throw new Exception("Link youtube not active!");
            }

            LessonDAO lessonDAO = new LessonDAO();
            PackagesDAO packDAO = new PackagesDAO();

            int courseIdOfPackages = packDAO.findPackageById(packageId).getCourse().getCourseID();

            Course course = new Course();
            course.setCourseID(courseIdOfPackages);

            Packages pack = Packages.builder()
                    .packageID(packageId)
                    .build();

            Lesson lesson = new Lesson(0, title, content, lessonType,
                    ConvertInput.convertToEmbedURL(videoUrl), documentUrl, YouTubeDurationFetcher.getVideoDurationInMinutesFromUrl(videoUrl), 0,
                    courseIdOfPackages, packageId, status, null, null, course, pack);

            if (lessonDAO.addLesson(lesson)) {

                List<Packages> packages = packDAO.findAllPackages();
                request.setAttribute("packages", packages);
                request.setAttribute("message", "Add Successfully");

                request.getRequestDispatcher("lessons").forward(request, response);
            } else {
                throw new Exception("Add failed!");
            }
        } catch (Exception e) {
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
