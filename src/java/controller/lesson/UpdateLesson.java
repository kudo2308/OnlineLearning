/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import DAO.LessonDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.EOFException;
import java.sql.Timestamp;
import model.Lesson;
import utils.ValidateInput;
import utils.YouTubeDurationFetcher;

/**
 *
 * @author PC
 */
@WebServlet(name = "UpdateLesson", urlPatterns = {"/updateLesson"})
public class UpdateLesson extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String lessonType = request.getParameter("lessonType");
            String videoUrl = request.getParameter("videoUrl");
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String documentUrl = request.getParameter("documentUrl");
            int orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
            boolean status = request.getParameter("status").equals("1");

            if (!ValidateInput.isYouTubeLinkActive(videoUrl)) {
                throw new Exception("Link youtube not active!");
            }

            LessonDAO lessonDAO = new LessonDAO();

            Lesson lesson = lessonDAO.findLessonById(lessonId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setLessonType(lessonType);
            lesson.setVideoUrl(convertToEmbedURL(videoUrl));
            lesson.setDuration(YouTubeDurationFetcher.getVideoDurationInMinutesFromUrl(videoUrl));
            lesson.setDocumentUrl(documentUrl);
            lesson.setOrderNumber(orderNumber);
            lesson.setStatus(status);
            lesson.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            lesson.getPackages().setPackageID(packageId);

            if (lessonDAO.updateLesson(lesson)) {
                response.sendRedirect("viewLessonForAd?lessonId=" + lessonId);
            } else {
               throw new EOFException("Update lesson failed!");
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

    public static String convertToEmbedURL(String videoURL) {
        try {
            java.net.URL url = new java.net.URL(videoURL);
            String host = url.getHost();
            String path = url.getPath();
            String query = url.getQuery();

            if (host.contains("youtube.com") && query != null) {
                // URL dạng dài: youtube.com/watch?v=...
                String[] queryParams = query.split("&");
                for (String param : queryParams) {
                    if (param.startsWith("v=")) {
                        String videoId = param.substring(2);
                        return "https://www.youtube.com/embed/" + videoId;
                    }
                }
            } else if (host.contains("youtu.be")) {
                // URL dạng ngắn: youtu.be/...
                String[] pathSegments = path.split("/");
                if (pathSegments.length > 1) {
                    String videoId = pathSegments[1];
                    return "https://www.youtube.com/embed/" + videoId;
                }
            }

            // Nếu không tìm thấy ID, trả về URL ban đầu
            return videoURL;
        } catch (java.net.MalformedURLException e) {
            System.err.println("Lỗi chuyển đổi URL: " + e.getMessage());
            return videoURL;
        }
    }

}
