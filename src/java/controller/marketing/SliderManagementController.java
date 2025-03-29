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
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "SliderManagementController", urlPatterns = {"/slider"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)

public class SliderManagementController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "web/assets/images/slider";
    private SliderDAO sliderDAO;
    
    @Override
    public void init() throws ServletException {
        sliderDAO = new SliderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            listSliders(request, response);
            return;
        }
        
        switch (action) {
            case "add":
                showAddSliderForm(request, response);
                break;
            case "edit":
                showEditSliderForm(request, response);
                break;
            case "delete":
                deleteSlider(request, response);
                break;
            default:
                listSliders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addSlider(request, response);
                break;
            case "edit":
                updateSlider(request, response);
                break;
            default:
                listSliders(request, response);
                break;
        }
    }

    private void listSliders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tối ưu hóa: Không cần tạo mới SliderDAO mỗi lần gọi
        List<Slider> sliders = sliderDAO.getAllSliders();
        request.setAttribute("sliders", sliders);
        request.getRequestDispatcher("/views/marketing/SliderList.jsp").forward(request, response);
    }

    private void showAddSliderForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/marketing/SliderForm.jsp").forward(request, response);
    }

    private void showEditSliderForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int sliderId = Integer.parseInt(request.getParameter("id"));
            Slider slider = sliderDAO.getSliderById(sliderId);
            if (slider != null) {
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("/views/marketing/SliderForm.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy slider");
                listSliders(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ");
            listSliders(request, response);
        }
    }

    private void addSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Slider slider = new Slider();
        slider.setTitle(request.getParameter("title"));
        slider.setLinkUrl(request.getParameter("linkUrl"));
        slider.setStatus(Integer.parseInt(request.getParameter("status")));
        slider.setDescription(request.getParameter("description"));

        // Xử lý upload ảnh
        String imageUrl = processImageUpload(request);
        slider.setImageUrl(imageUrl);

        if (sliderDAO.addSlider(slider)) {
            response.sendRedirect(request.getContextPath() + "/slider");
        } else {
            request.setAttribute("error", "Thêm slider thất bại");
            request.setAttribute("slider", slider);
            request.getRequestDispatcher("/views/marketing/SliderForm.jsp").forward(request, response);
        }
    }

    private void updateSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int sliderId = Integer.parseInt(request.getParameter("sliderId"));
            Slider slider = sliderDAO.getSliderById(sliderId);
            
            if (slider == null) {
                request.setAttribute("error", "Không tìm thấy slider");
                listSliders(request, response);
                return;
            }

            slider.setTitle(request.getParameter("title"));
            slider.setLinkUrl(request.getParameter("linkUrl"));
            slider.setStatus(Integer.parseInt(request.getParameter("status")));
            slider.setDescription(request.getParameter("description"));

            // Xử lý upload ảnh (nếu có)
            Part filePart = request.getPart("imageUrl");
            if (filePart != null && filePart.getSize() > 0) {
                String imageUrl = processImageUpload(request);
                slider.setImageUrl(imageUrl);
            }

            if (sliderDAO.updateSlider(slider)) {
                response.sendRedirect(request.getContextPath() + "/slider");
            } else {
                request.setAttribute("error", "Cập nhật slider thất bại");
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("/views/marketing/SliderForm.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ");
            listSliders(request, response);
        }
    }

    private String processImageUpload(HttpServletRequest request) throws IOException, ServletException {
        String imageUrl = null;
        Part filePart = request.getPart("imageUrl");
        
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

            // Tạo tên file duy nhất để tránh trùng lặp
            String uniqueFileName = UUID.randomUUID().toString() + "-" + baseName + extension;
            
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

            // Lưu file mới
            File newFile = new File(uploadPath + File.separator + uniqueFileName);
            filePart.write(newFile.getAbsolutePath());
            imageUrl = "/assets/images/slider/" + uniqueFileName;
        }
        
        return imageUrl;
    }

    private void deleteSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nhận tham số 'id' từ URL
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int sliderId = Integer.parseInt(idParam);  // Chuyển đổi thành int

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
