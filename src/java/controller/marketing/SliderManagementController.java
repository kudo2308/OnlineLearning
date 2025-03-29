package controller.marketing;

import DAO.SliderDAO;
import model.Slider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "SliderManagementController", urlPatterns = {"/slider"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)

public class SliderManagementController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "web/assets/images/slider";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            listSliders(request, response);
        }
        switch (action) {

            case "add" -> {
                showAddSliderForm(request, response);
                break;
            }
            case "edit" -> {
                System.out.println("in ra");
                showEditSliderForm(request, response);
                break;
            }
            case "delete" -> {
                deleteSlider(request, response);
                break;
            }

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "add" -> {
                addSlider(request, response);
                break;
            }

            case "edit" -> {
                updateSlider(request, response);
                break;
            }

        }
    }

    private void listSliders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("list");
        SliderDAO sliderDAO = new SliderDAO();
        List<Slider> sliders = sliderDAO.getAllSliders();
        request.setAttribute("sliders", sliders);
        request.getRequestDispatcher("views/marketing/SliderList.jsp").forward(request, response);
    }

    private void showAddSliderForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/marketing/SliderForm.jsp").forward(request, response);
    }

    private void showEditSliderForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SliderDAO sliderDAO = new SliderDAO();
        System.out.println("edit");
        int sliderId = Integer.parseInt(request.getParameter("id"));
        Slider slider = sliderDAO.getSliderById(sliderId);
        request.setAttribute("slider", slider);
        request.getRequestDispatcher("views/marketing/SliderForm.jsp").forward(request, response);
    }

    private void addSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SliderDAO sliderDAO = new SliderDAO();
        Slider slider = new Slider();
        slider.setTitle(request.getParameter("title"));
        slider.setLinkUrl(request.getParameter("linkUrl"));
        slider.setStatus(Integer.parseInt(request.getParameter("status")));
        slider.setDescription(request.getParameter("description"));

        // Xử lý upload ảnh
        String imageUrl = null;
        Part filePart = request.getPart("imageUrl");
        // Xử lý hình ảnh nếu người dùng có upload file mới
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Tách phần mở rộng của file
            int dotIndex = fileName.lastIndexOf(".");
            String extension = "";
            String baseName = fileName;

            if (dotIndex > 0) {
                extension = fileName.substring(dotIndex);
                baseName = fileName.substring(0, dotIndex);
            }

            // Lấy đường dẫn gốc của project
            String projectRoot = getServletContext().getRealPath("/");
            if (projectRoot.contains("build")) {
                projectRoot = projectRoot.substring(0, projectRoot.indexOf("build"));
            }

            String uploadPath = projectRoot + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Kiểm tra trùng lặp tên file
            File newFile = new File(uploadPath + File.separator + fileName);
            if (newFile.exists()) {
                fileName = UUID.randomUUID().toString() + "-" + baseName + extension;
                newFile = new File(uploadPath + File.separator + fileName);
            }

            // Lưu file mới
            filePart.write(newFile.getAbsolutePath());
            imageUrl = "/assets/images/slider/" + fileName;
        }
        slider.setImageUrl(imageUrl);

        if (sliderDAO.addSlider(slider)) {
            response.sendRedirect(request.getContextPath() + "/slider");
        } else {
            request.setAttribute("error", "Thêm slider thất bại");
            request.getRequestDispatcher("views/marketing/SliderForm.jsp").forward(request, response);
        }
    }

    private void updateSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SliderDAO sliderDAO = new SliderDAO();
        int sliderId = Integer.parseInt(request.getParameter("sliderId"));
        System.out.println(sliderId);
        Slider slider = sliderDAO.getSliderById(sliderId);

        slider.setTitle(request.getParameter("title"));
        slider.setLinkUrl(request.getParameter("linkUrl"));
        slider.setStatus(Integer.parseInt(request.getParameter("status")));
        slider.setDescription(request.getParameter("description"));

        // Xử lý upload ảnh (nếu có)
        // **Khai báo biến imageUrl trước khi dùng**
        String imageUrl = slider.getImageUrl(); // Giữ nguyên ảnh cũ nếu không upload ảnh mới
        Part filePart = request.getPart("imageUrl");
        // Xử lý hình ảnh nếu người dùng có upload file mới
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Tách phần mở rộng của file
            int dotIndex = fileName.lastIndexOf(".");
            String extension = "";
            String baseName = fileName;

            if (dotIndex > 0) {
                extension = fileName.substring(dotIndex);
                baseName = fileName.substring(0, dotIndex);
            }

            // Lấy đường dẫn gốc của project
            String projectRoot = getServletContext().getRealPath("/");
            if (projectRoot.contains("build")) {
                projectRoot = projectRoot.substring(0, projectRoot.indexOf("build"));
            }

            String uploadPath = projectRoot + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Kiểm tra trùng lặp tên file
            File newFile = new File(uploadPath + File.separator + fileName);
            if (newFile.exists()) {
                fileName = UUID.randomUUID().toString() + "-" + baseName + extension;
                newFile = new File(uploadPath + File.separator + fileName);
            }

            // Lưu file mới
            filePart.write(newFile.getAbsolutePath());
            imageUrl = "/assets/images/slider/" + fileName;
        }
        slider.setImageUrl(imageUrl);
        if (sliderDAO.updateSlider(slider)) {
            response.sendRedirect(request.getContextPath() + "/slider");
        } else {
            request.setAttribute("error", "Cập nhật slider thất bại");
            request.setAttribute("slider", slider);
            request.getRequestDispatcher("/views/marketing/SliderList.jsp").forward(request, response);
        }
    }

    private void deleteSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nhận tham số 'id' từ URL
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int sliderId = Integer.parseInt(idParam);  // Chuyển đổi thành int

                SliderDAO sliderDAO = new SliderDAO();
                boolean isDeleted = sliderDAO.deleteSlider(sliderId);  // Thực hiện xóa slider

                if (isDeleted) {
                    // Nếu xóa thành công, chuyển hướng về danh sách slider
                    response.sendRedirect(request.getContextPath() + "/slider");
                } else {
                    // Nếu xóa thất bại, hiển thị lỗi
                    request.setAttribute("error", "Xóa slider thất bại");
                    listSliders(request, response);
                }
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu 'id' không hợp lệ
                request.setAttribute("error", "ID không hợp lệ");
                listSliders(request, response);
            }
        } else {
            // Nếu 'id' không có trong URL, chuyển về danh sách slider
            request.setAttribute("error", "Không tìm thấy slider");
            listSliders(request, response);
        }
    }

}
