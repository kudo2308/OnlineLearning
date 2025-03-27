package DAO;

import DBContext.DBContext;
import java.sql.*;
import java.util.*;
import model.Promotion;

public class PromotionDAO extends DBContext {

    public PromotionDAO() {
    }

    /**
     * Lấy tất cả các khuyến mãi từ database
     *
     * @return Danh sách khuyến mãi
     */
    public List<Promotion> getAllPromotions() {
        List<Promotion> promotions = new ArrayList<>();
        String query = "SELECT * FROM [SWP_ver2].[dbo].[Promotion] ORDER BY CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion promotion = mapResultSetToPromotion(rs);
                promotions.add(promotion);
            }
        } catch (SQLException e) {
            System.out.println("Error getting promotions: " + e.getMessage());
        }

        return promotions;
    }

    /**
     * Lấy khuyến mãi theo ID
     *
     * @param promotionID ID của khuyến mãi cần lấy
     * @return Đối tượng Promotion hoặc null nếu không tìm thấy
     */
    public Promotion getPromotionById(int promotionID) {
        String query = "SELECT * FROM [SWP_ver2].[dbo].[Promotion] WHERE PromotionID = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, promotionID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPromotion(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting promotion by ID: " + e.getMessage());
        }

        return null;
    }

    /**
     * Lấy khuyến mãi theo mã code
     *
     * @param promotionCode Mã code của khuyến mãi
     * @return Đối tượng Promotion hoặc null nếu không tìm thấy
     */
    public Promotion getPromotionByCode(String promotionCode) {
        String query = "SELECT * FROM [SWP_ver2].[dbo].[Promotion] WHERE PromotionCode = ? AND Status = 1";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, promotionCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPromotion(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting promotion by code: " + e.getMessage());
        }

        return null;
    }

    /**
     * Tạo khuyến mãi mới
     *
     * @param promotion Đối tượng Promotion cần tạo
     * @return true nếu tạo thành công, ngược lại false
     */
    public boolean createPromotion(Promotion promotion) {
        String query = "INSERT INTO [SWP_ver2].[dbo].[Promotion] "
                + "(PromotionCode, DiscountType, DiscountValue, Status, CategoryID, ExpertID, CourseID, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, promotion.getPromotionCode());
            ps.setString(2, promotion.getDiscountType());
            ps.setDouble(3, promotion.getDiscountValue());
            ps.setBoolean(4, promotion.getStatus());

            // Nếu CategoryID = 0 thì set NULL vào SQL
            if (promotion.getCategoryID() == 0) {
                ps.setNull(5, java.sql.Types.INTEGER);
            } else {
                ps.setInt(5, promotion.getCategoryID());
            }

            // Nếu ExpertID = 0 thì set NULL vào SQL
            if (promotion.getExpertID() == 0) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, promotion.getExpertID());
            }

            // Nếu CourseID = 0 thì set NULL vào SQL
            if (promotion.getCourseID() == 0) {
                ps.setNull(7, java.sql.Types.INTEGER);
            } else {
                ps.setInt(7, promotion.getCourseID());
            }

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error creating promotion: " + e.getMessage());
            return false;
        }
    }

    /**
     * Cập nhật thông tin khuyến mãi
     *
     * @param promotion Đối tượng Promotion cần cập nhật
     * @return true nếu cập nhật thành công, ngược lại false
     */
    public boolean updatePromotion(Promotion promotion) {
        String query = "UPDATE [SWP_ver2].[dbo].[Promotion] SET "
                + "PromotionCode = ?, DiscountType = ?, DiscountValue = ?, Status = ?, "
                + "CategoryID = ?, ExpertID = ?, CourseID = ?, UpdatedAt = GETDATE() "
                + "WHERE PromotionID = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, promotion.getPromotionCode());
            ps.setString(2, promotion.getDiscountType());
            ps.setDouble(3, promotion.getDiscountValue());
            ps.setBoolean(4, promotion.getStatus());
            ps.setInt(5, promotion.getCategoryID());
            ps.setInt(6, promotion.getExpertID());
            ps.setInt(7, promotion.getCourseID());
            ps.setInt(8, promotion.getPromotionID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error creating promotion: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateStatusPromotion(int promotionID, boolean status) {
    String query = "UPDATE [SWP_ver2].[dbo].[Promotion] SET Status = ?, UpdatedAt = GETDATE() WHERE PromotionID = ?";

    try (PreparedStatement ps = connection.prepareStatement(query)) {
        // Set parameter for Status and PromotionID
        ps.setBoolean(1, status);
        ps.setInt(2, promotionID);

        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;  // Return true if at least one row was updated
    } catch (SQLException e) {
        System.out.println("Error updating promotion status: " + e.getMessage());
        return false;
    }
}
    /**
     * Xóa khuyến mãi theo ID
     *
     * @param promotionID ID của khuyến mãi cần xóa
     * @return true nếu xóa thành công, ngược lại false
     */
    public boolean deletePromotion(int promotionID) {
        String query = "DELETE FROM [SWP_ver2].[dbo].[Promotion] WHERE PromotionID = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, promotionID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting promotion: " + e.getMessage());
            return false;
        }
    }

    /**
     * Lấy khuyến mãi áp dụng cho khóa học cụ thể
     *
     * @param courseID ID của khóa học
     * @param expertID ID của giảng viên
     * @param categoryID ID của danh mục
     * @return Danh sách khuyến mãi áp dụng
     */
    public List<Promotion> getPromotionsForCourse(int courseID, int expertID, int categoryID) {
        List<Promotion> promotions = new ArrayList<>();

        String query = "SELECT * FROM [SWP_ver2].[dbo].[Promotion] WHERE Status = 1 AND ("
                + "(CourseID = ? AND CourseID != 0) OR "
                + "(ExpertID = ? AND ExpertID != 0) OR "
                + "(CategoryID = ? AND CategoryID != 0) OR "
                + "(CourseID = 0 AND ExpertID = 0 AND CategoryID = 0)"
                + ") ORDER BY DiscountValue DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, courseID);
            ps.setInt(2, expertID);
            ps.setInt(3, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Promotion promotion = mapResultSetToPromotion(rs);
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting promotions for course: " + e.getMessage());
        }

        return promotions;
    }

    /**
     * Mapping dữ liệu từ ResultSet sang đối tượng Promotion
     *
     * @param rs ResultSet chứa dữ liệu
     * @return Đối tượng Promotion
     * @throws SQLException Nếu có lỗi khi truy cập dữ liệu
     */
    private Promotion mapResultSetToPromotion(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setPromotionID(rs.getInt("PromotionID"));
        promotion.setPromotionCode(rs.getString("PromotionCode"));
        promotion.setDiscountType(rs.getString("DiscountType"));
        promotion.setDiscountValue(rs.getDouble("DiscountValue"));
        promotion.setStatus(rs.getBoolean("Status"));
        promotion.setCategoryID(rs.getInt("CategoryID"));
        promotion.setExpertID(rs.getInt("ExpertID"));
        promotion.setCourseID(rs.getInt("CourseID"));
        promotion.setCreatedAt(rs.getTimestamp("CreatedAt"));
        promotion.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return promotion;
    }

    public static void main(String[] args) {
        PromotionDAO dao = new PromotionDAO();
        Promotion test = new Promotion();
        System.out.println(test.getExpertID());
    }
}
