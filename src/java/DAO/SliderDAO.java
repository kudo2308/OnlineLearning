package DAO;

import DBContext.DBContext;
import model.Slider;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

public class SliderDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Slider> slider;

    // Thêm slider mới
    public SliderDAO() {
        slider = new ArrayList<>();
    }

    public boolean addSlider(Slider slider) {
        String sql = "INSERT INTO Sliders (title, imageUrl, linkUrl, status, description) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, slider.getTitle());
            stmt.setString(2, slider.getImageUrl());
            stmt.setString(3, slider.getLinkUrl());
            stmt.setInt(4, slider.getStatus());
            stmt.setString(5, slider.getDescription());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật slider
    public boolean updateSlider(Slider slider) {
        String sql = "UPDATE Sliders SET title=?, imageUrl=?, linkUrl=?, status=?, description=? WHERE sliderId=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, slider.getTitle());
            stmt.setString(2, slider.getImageUrl());
            stmt.setString(3, slider.getLinkUrl());
            stmt.setInt(4, slider.getStatus());
            stmt.setString(5, slider.getDescription());
            stmt.setInt(6, slider.getSliderId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa slider
    public boolean deleteSlider(int sliderId) {
        String sql = "DELETE FROM Sliders WHERE sliderId=?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, sliderId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;  // Nếu xóa thành công, trả về true
        } catch (SQLException e) {
            e.printStackTrace();  // In ra lỗi nếu có
            return false;  // Trả về false nếu có lỗi xảy ra
        }
    }

    // Lấy tất cả slider - Tối ưu hóa truy vấn
    public List<Slider> getAllSliders() {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM Sliders ORDER BY sliderId";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Slider slider = new Slider(
                            rs.getInt("sliderId"),
                            rs.getString("title"),
                            rs.getString("imageUrl"),
                            rs.getString("linkUrl"),
                            rs.getInt("status"),
                            rs.getString("description")
                    );
                    sliders.add(slider);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sliders;
    }

    // Lấy slider theo ID - Tối ưu hóa
    public Slider getSliderById(int sliderId) {
        String sql = "SELECT * FROM Sliders WHERE sliderId=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, sliderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Slider(
                            rs.getInt("sliderId"),
                            rs.getString("title"),
                            rs.getString("imageUrl"),
                            rs.getString("linkUrl"),
                            rs.getInt("status"),
                            rs.getString("description")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy các slider đang hoạt động - Tối ưu hóa
    public List<Slider> getActiveSliders() {
        List<Slider> activeSliders = new ArrayList<>();
        String sql = "SELECT * FROM Sliders WHERE status = 1 ORDER BY sliderId";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Slider slider = new Slider(
                            rs.getInt("sliderId"),
                            rs.getString("title"),
                            rs.getString("imageUrl"),
                            rs.getString("linkUrl"),
                            rs.getInt("status"),
                            rs.getString("description")
                    );
                    activeSliders.add(slider);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activeSliders;
    }
}
