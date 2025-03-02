/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.LoginDAO;
import DAO.ProfileDAO;
import config.OTP;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;
import java.util.Map;
import model.Account;

@WebServlet(name = "Photo", urlPatterns = {"/photo"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB (gồm tất cả dữ liệu multipart)
)
public class Photo extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/images/avatar";
    private static final String DEFAULT_IMAGE = "unknow.jpg";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorprofile = request.getParameter("errorprofile");
        String success = request.getParameter("success");

        if (success != null) {
            request.setAttribute("success", success);
        }
        if (errorprofile != null) {
            request.setAttribute("errorphoto", errorprofile);
        }
        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");
        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);
        Map<String, String> accountData = (Map<String, String>) accountObj;
        accountData.put("img", acc.getImage());
        session.setAttribute("account", accountData);
        System.out.println(acc.getImage());
        request.getRequestDispatcher("photo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<String, String> accountData = (Map<String, String>) accountObj;
        String userID = accountData.get("userId");
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String croppedImage = request.getParameter("croppedImage");
        Part filePart = request.getPart("file");
        String newImagePath = null;

        if (croppedImage != null && !croppedImage.isEmpty()) {
            // Xử lý ảnh crop (base64)
            newImagePath = saveBase64Image(croppedImage, uploadPath, userID);
        } else if (filePart != null && filePart.getSize() > 0) {
            // Xử lý ảnh upload trực tiếp
            String fileName = "user_" + userID + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;

            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(filePart.getInputStream().readAllBytes());
            }
            newImagePath = filePath + File.separator + fileName;
        }

        if (newImagePath != null) {
            deleteOldFile(acc.getImage());
            ProfileDAO profileDAO = new ProfileDAO();
            profileDAO.updateUserImage(acc.getUserID(), newImagePath);
            OTP otp = new OTP();
            String sessionId = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("SessionID_User".equals(cookie.getName())) {
                        sessionId = cookie.getValue();
                        break;
                    }
                }
            }
            otp.updateSessionField(sessionId, "img", newImagePath);
            response.sendRedirect("photo?success=You have successfully updated your profile picture");
        } else {
            response.sendRedirect("photo?errorphoto=Upload failed. Please try again");
        }
    }

    private String getFileExtension(String base64Image) {
        String mimeType = base64Image.split(",")[0].split(":")[1].split(";")[0];
        return mimeType.split("/")[1];
    }

    private String saveBase64Image(String base64Image, String uploadPath, String userId) throws IOException {
        String fileExtension = getFileExtension(base64Image);
        String fileName = "user_" + userId + "_" + System.currentTimeMillis() + "." + fileExtension;
        String filePath = uploadPath + File.separator + fileName;
        byte[] imageBytes = Base64.getDecoder().decode(base64Image.split(",")[1]);

        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            fos.write(imageBytes);
        }

        return "/" + UPLOAD_DIR + "/" + fileName;
    }

   private void deleteOldFile(String imagePath) throws IOException {
    if (imagePath != null && !imagePath.contains(DEFAULT_IMAGE) && !imagePath.startsWith("http://") && !imagePath.startsWith("https://")) {
        String filePath = getServletContext().getRealPath("/") + imagePath;
        Path oldFilePath = Path.of(filePath);
        Files.deleteIfExists(oldFilePath);
    }
}
}
