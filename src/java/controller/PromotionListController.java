package controller;

import DAO.CategoryDAO;
import DAO.CourseDAO;
import DAO.LoginDAO;
import DAO.PromotionDAO;
import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Account;
import model.Category;
import model.Course;
import model.Promotion;
import model.User;

@WebServlet(name = "PromotionListController", urlPatterns = {"/promotionList"})
public class PromotionListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String action = request.getParameter("action");

        if (action == null) {
            // Hiển thị trang quản lý khuyến mãi
            showPromotionManagement(request, response);
        } else {
            switch (action) {
                case "add":
                    showAddPromotionForm(request, response);
                    break;
                case "edit":
                    showEditPromotion(request, response);
                    break;
                case "delete":
                    deletePromotion(request, response);
                    break;
                case "toggle":
                    togglePromotionStatus(request, response);
                    break;
                case "reset":
                    resetPromotionPrices(request, response);
                    break;
                case "export":
                    exportPromotionReport(request, response);
                    break;
                default:
                    showPromotionManagement(request, response);
                    break;
            }
        }
    }

    // Thêm phương thức hiển thị form thêm khuyến mãi mới
    private void showAddPromotionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        if (!hasAdminAccess(request.getSession())) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=admin/promotion");
            return;
        }

        // Lấy danh sách danh mục, giảng viên, khóa học để hiển thị dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        UserDAO expertDAO = new UserDAO();
        CourseDAO courseDAO = new CourseDAO();

        List<Category> categories = categoryDAO.findAll();
        List<User> experts = expertDAO.getAllExpert();
        List<Course> courses = courseDAO.getAllCourses();

        // Đặt các thuộc tính vào request
        request.setAttribute("categories", categories);
        request.setAttribute("experts", experts);
        request.setAttribute("courses", courses);

        // Forward đến trang JSP
        request.getRequestDispatcher("/views/marketing/PromotionManagerment.jsp").forward(request, response);
    }

    // Cập nhật phương thức doPost để xử lý thêm mới khuyến mãi
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // Kiểm tra quyền admin
        if (!hasAdminAccess(session)) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=promotion");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.equals("create")) {
            createPromotion(request, response);
        } else if (action.equals("update")) {
            updatePromotion(request, response);
        } else if (action.equals("reset")) {
            resetPromotionPrices(request, response);
        }
    }

    private boolean hasAdminAccess(HttpSession session) {
        // Kiểm tra quyền admin - customize theo logic ứng dụng của bạn
        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            return false;
        }

        // Ví dụ kiểm tra role = admin
        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        if (acc != null) {
            return "Admin".equals(acc.getRole().getRoleName()) || "Marketing".equals(acc.getRole().getRoleName());
        }
        return false;
    }

    private void showPromotionManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách khuyến mãi
        PromotionDAO promotionDAO = new PromotionDAO();
        List<Promotion> promotions = promotionDAO.getAllPromotions();

        // Lấy danh sách danh mục, giảng viên, khóa học để hiển thị dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        UserDAO expertDAO = new UserDAO();
        CourseDAO courseDAO = new CourseDAO();

        List<Category> categories = categoryDAO.findAll();
        List<User> experts = expertDAO.getAllExpert();
        List<Course> courses = courseDAO.getAllCourses();

        // Tạo map tên để hiển thị trong bảng
        Map<Integer, String> categoryMap = new HashMap<>();
        Map<Integer, String> expertMap = new HashMap<>();
        Map<Integer, String> courseMap = new HashMap<>();

        for (Category category : categories) {
            categoryMap.put(category.getCategoryID(), category.getName());
        }

        for (User expert : experts) {
            expertMap.put(expert.getUserID(), expert.getFullName());
        }

        for (Course course : courses) {
            courseMap.put(course.getCourseID(), course.getTitle());
        }

        // Đặt các thuộc tính vào request
        request.setAttribute("promotions", promotions);
        request.setAttribute("categories", categories);
        request.setAttribute("experts", experts);
        request.setAttribute("courses", courses);
        request.setAttribute("categoryMap", categoryMap);
        request.setAttribute("expertMap", expertMap);
        request.setAttribute("courseMap", courseMap);

        // Forward đến trang JSP
        request.getRequestDispatcher("/views/marketing/PromotionManagerment.jsp").forward(request, response);
    }

    private void showEditPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int promotionId = Integer.parseInt(request.getParameter("id"));

        PromotionDAO promotionDAO = new PromotionDAO();
        Promotion promotion = promotionDAO.getPromotionById(promotionId);

        if (promotion == null) {
            // Khuyến mãi không tồn tại
            request.setAttribute("message", "Khuyến mãi không tồn tại hoặc đã bị xóa.");
            request.setAttribute("messageType", "error");
            showPromotionManagement(request, response);
            return;
        }

        // Lấy danh sách danh mục, giảng viên, khóa học
        CategoryDAO categoryDAO = new CategoryDAO();
        UserDAO expertDAO = new UserDAO();
        CourseDAO courseDAO = new CourseDAO();

        List<Category> categories = categoryDAO.findAll();
        List<User> experts = expertDAO.getAllExpert();
        List<Course> courses = courseDAO.getAllCourses();

        // Đặt thông tin vào request
        request.setAttribute("promotion", promotion);
        request.setAttribute("categories", categories);
        request.setAttribute("experts", experts);
        request.setAttribute("courses", courses);
        request.setAttribute("editMode", true);

        // Xác định loại áp dụng
        String applyTo = "all";
        if (promotion.getCategoryID() != 0) {
            applyTo = "category";
        } else if (promotion.getExpertID() != 0) {
            applyTo = "expert";
        } else if (promotion.getCourseID() != 0) {
            applyTo = "course";
        }
        request.setAttribute("applyTo", applyTo);

        // Forward đến trang chỉnh sửa
        request.getRequestDispatcher("/views/marketing/AddPromotion.jsp").forward(request, response);
    }

    private void createPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ form
        String promotionCode = request.getParameter("promotionCode");
        String discountType = request.getParameter("discountType");
        double discountValue = Double.parseDouble(request.getParameter("discountValue"));
        String applyTo = request.getParameter("applyTo");

        // Tạo đối tượng Promotion mới
        Promotion promotion = new Promotion();
        promotion.setPromotionCode(promotionCode);
        promotion.setDiscountType(discountType);
        promotion.setDiscountValue(discountValue);
        promotion.setStatus(true); // Mặc định kích hoạt

        // Xác định đối tượng áp dụng khuyến mãi
        switch (applyTo) {
            case "category":
                int categoryID = Integer.parseInt(request.getParameter("categoryID"));
                promotion.setCategoryID(categoryID);
                break;
            case "expert":
                int expertID = Integer.parseInt(request.getParameter("expertID"));
                promotion.setExpertID(expertID);
                break;
            case "course":
                int courseID = Integer.parseInt(request.getParameter("courseID"));
                promotion.setCourseID(courseID);
                break;
            default:
                // Áp dụng cho tất cả
                break;
        }

        // Lưu vào database
        PromotionDAO promotionDAO = new PromotionDAO();
        boolean success = promotionDAO.createPromotion(promotion);

        // Nếu thành công và người dùng chọn hiển thị giá đã giảm
        if (success && request.getParameter("showDiscountedPrice") != null) {
            calculateAndUpdateDiscountedPrices(promotion);
        }

        // Thông báo kết quả
        if (success) {
            request.setAttribute("message", "Tạo khuyến mãi thành công!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Tạo khuyến mãi thất bại. Vui lòng thử lại.");
            request.setAttribute("messageType", "error");
        }

        // Quay lại trang quản lý
        showPromotionManagement(request, response);
    }

    private void updatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ form
        int promotionID = Integer.parseInt(request.getParameter("promotionID"));
        String promotionCode = request.getParameter("promotionCode");
        String discountType = request.getParameter("discountType");
        double discountValue = Double.parseDouble(request.getParameter("discountValue"));
        String applyTo = request.getParameter("applyTo");

        // Lấy Promotion hiện tại
        PromotionDAO promotionDAO = new PromotionDAO();
        Promotion promotion = promotionDAO.getPromotionById(promotionID);

        if (promotion == null) {
            request.setAttribute("message", "Khuyến mãi không tồn tại.");
            request.setAttribute("messageType", "error");
            showPromotionManagement(request, response);
            return;
        }

        // Cập nhật thông tin
        promotion.setPromotionCode(promotionCode);
        promotion.setDiscountType(discountType);
        promotion.setDiscountValue(discountValue);

        // Reset các giá trị áp dụng
        promotion.setCategoryID(0);
        promotion.setExpertID(0);
        promotion.setCourseID(0);

        // Xác định đối tượng áp dụng khuyến mãi
        switch (applyTo) {
            case "category":
                int categoryID = Integer.parseInt(request.getParameter("categoryID"));
                promotion.setCategoryID(categoryID);
                break;
            case "expert":
                int expertID = Integer.parseInt(request.getParameter("expertID"));
                promotion.setExpertID(expertID);
                break;
            case "course":
                int courseID = Integer.parseInt(request.getParameter("courseID"));
                promotion.setCourseID(courseID);
                break;
            default:
                // Áp dụng cho tất cả
                break;
        }

        // Cập nhật vào database
        boolean success = promotionDAO.updatePromotion(promotion);

        // Nếu thành công và người dùng chọn hiển thị giá đã giảm
        if (success && request.getParameter("showDiscountedPrice") != null) {
            calculateAndUpdateDiscountedPrices(promotion);
        }

        // Thông báo kết quả
        if (success) {
            request.setAttribute("message", "Cập nhật khuyến mãi thành công!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Cập nhật khuyến mãi thất bại. Vui lòng thử lại.");
            request.setAttribute("messageType", "error");
        }

        // Quay lại trang quản lý
        showPromotionManagement(request, response);
    }

    private void deletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int promotionId = Integer.parseInt(request.getParameter("id"));

        PromotionDAO promotionDAO = new PromotionDAO();

        // Lấy promotion để biết khóa học nào bị ảnh hưởng (để reset giá)
        Promotion promotion = promotionDAO.getPromotionById(promotionId);

        boolean success = promotionDAO.deletePromotion(promotionId);

        if (success) {
            // Reset giá các khóa học bị ảnh hưởng
            if (promotion != null) {
                resetDiscountedPrices(promotion);
            }

            request.setAttribute("message", "Xóa khuyến mãi thành công!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Xóa khuyến mãi thất bại. Vui lòng thử lại.");
            request.setAttribute("messageType", "error");
        }

        // Quay lại trang quản lý
        showPromotionManagement(request, response);
    }

    private void togglePromotionStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int promotionId = Integer.parseInt(request.getParameter("id"));

        PromotionDAO promotionDAO = new PromotionDAO();
        Promotion promotion = promotionDAO.getPromotionById(promotionId);

        if (promotion == null) {
            request.setAttribute("message", "Promotion not exist.");
            request.setAttribute("messageType", "error");
            showPromotionManagement(request, response);
            return;
        }

        // Đảo trạng thái
        promotion.setStatus(!promotion.getStatus());

        boolean success = promotionDAO.updateStatusPromotion(promotionId, promotion.getStatus());

        if (success) {
            // Luôn reset giá khi vô hiệu hóa
            if (!promotion.getStatus()) {
                // Nếu vô hiệu hóa, reset giá
                resetDiscountedPrices(promotion);
            } else {
                // Nếu kích hoạt, tính lại giá đã giảm
                calculateAndUpdateDiscountedPrices(promotion);
            }

            String statusMessage = promotion.getStatus() ? "kích hoạt" : "vô hiệu hóa";
            request.setAttribute("message", "Đã " + statusMessage + " khuyến mãi và reset giá thành công!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Thay đổi trạng thái khuyến mãi thất bại. Vui lòng thử lại.");
            request.setAttribute("messageType", "error");
        }

        // Quay lại trang quản lý
        showPromotionManagement(request, response);
    }

    // Thêm phương thức xuất báo cáo khuyến mãi
    private void exportPromotionReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thực hiện logic xuất báo cáo
        // Tùy thuộc vào yêu cầu, có thể xuất ra file Excel, PDF, hoặc hiển thị báo cáo trong trang web

        // Ví dụ: xuất báo cáo dạng HTML
        request.setAttribute("reportGenerated", true);
        showPromotionManagement(request, response);
    }

    // Thêm phương thức tính và cập nhật giá đã giảm
    private void calculateAndUpdateDiscountedPrices(Promotion promotion) {
        CourseDAO courseDAO = new CourseDAO();
        List<Course> allCourses = courseDAO.getAllCourses();
        List<Course> coursesToApplyDiscount = new ArrayList<>();

        // Xác định các khóa học sẽ được áp dụng khuyến mãi
        if (promotion.getCategoryID() != 0) {
            coursesToApplyDiscount = courseDAO.getCoursesByCategories(promotion.getCategoryID());
        } else if (promotion.getExpertID() != 0) {
            coursesToApplyDiscount = courseDAO.getCoursesByExperts(promotion.getExpertID());
        } else if (promotion.getCourseID() != 0) {
            Course course = courseDAO.getCourseById(promotion.getCourseID());
            if (course != null) {
                coursesToApplyDiscount.add(course);
            }
        } else {
            // Áp dụng cho tất cả khóa học
            coursesToApplyDiscount = allCourses;
        }

        // Set danh sách ID khóa học được áp dụng khuyến mãi để kiểm tra
        Set<Integer> discountedCourseIds = new HashSet<>();
        for (Course course : coursesToApplyDiscount) {
            discountedCourseIds.add(course.getCourseID());
        }

        // Cập nhật giá cho tất cả khóa học
        for (Course course : allCourses) {
            if (discountedCourseIds.contains(course.getCourseID())) {
                // Khóa học được áp dụng khuyến mãi
                double originalPrice = course.getPrice();
                double discountedPrice;

                if ("percentage".equals(promotion.getDiscountType())) {
                    discountedPrice = originalPrice * (1 - promotion.getDiscountValue() / 100);
                } else {
                    discountedPrice = Math.max(0, originalPrice - promotion.getDiscountValue());
                }

                discountedPrice = Math.round(discountedPrice * 100) / 100.0;
                course.setDiscountPrice(discountedPrice);
                courseDAO.updateCoursePrice(course.getCourseID(), course.getPrice(), discountedPrice);
            }
        }
    }

    // Thêm phương thức reset giá đã giảm
    private void resetDiscountedPrices(Promotion promotion) {
        CourseDAO courseDAO = new CourseDAO();
        List<Course> coursesToReset = new ArrayList<>();

        // Xác định các khóa học cần reset giá
        if (promotion.getCategoryID() != 0) {
            coursesToReset = courseDAO.getCoursesByCategories(promotion.getCategoryID());
        } else if (promotion.getExpertID() != 0) {
            coursesToReset = courseDAO.getCoursesByExperts(promotion.getExpertID());
        } else if (promotion.getCourseID() != 0) {
            Course course = courseDAO.getCourseById(promotion.getCourseID());
            if (course != null) {
                coursesToReset.add(course);
            }
        } else {
            // Reset tất cả khóa học
            coursesToReset = courseDAO.getAllCourses();
        }

        // Reset giá
        for (Course course : coursesToReset) {
            courseDAO.resetDiscountedPrice(course.getCourseID());
        }
    }

    private void resetPromotionPrices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int promotionId = Integer.parseInt(request.getParameter("id"));

        PromotionDAO promotionDAO = new PromotionDAO();
        Promotion promotion = promotionDAO.getPromotionById(promotionId);

        if (promotion == null) {
            request.setAttribute("message", "Khuyến mãi không tồn tại.");
            request.setAttribute("messageType", "error");
            showPromotionManagement(request, response);
            return;
        }

        // Reset giá các khóa học thuộc khuyến mãi này
        resetDiscountedPrices(promotion);

        request.setAttribute("message", "Đã reset giá các khóa học về giá ban đầu thành công!");
        request.setAttribute("messageType", "success");

        // Quay lại trang quản lý
        showPromotionManagement(request, response);
    }
}
