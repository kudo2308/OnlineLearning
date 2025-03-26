/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author ASUS
 */
import DBContext.DBContext;
import java.sql.*;
import java.util.*;
import model.Coupon;
import model.Course;

public class CouponDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<Coupon> coupon;

    public CouponDAO() {
        coupon = new ArrayList<>();
    }

    // Thêm coupon mới
    public boolean addCoupon(Coupon coupon) {
        String query = "INSERT INTO Coupon (CouponCode, DiscountType, DiscountValue, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, coupon.getCouponCode());
            ps.setString(2, coupon.getDiscountType());
            ps.setDouble(3, coupon.getDiscountValue());
            ps.setBoolean(4, coupon.getStatus());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật coupon
    public boolean updateCoupon(Coupon coupon) {
        String query = "UPDATE Coupon SET CouponCode = ?, DiscountType = ?, DiscountValue = ?, Status = ?, UpdatedAt = GETDATE() WHERE CouponID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, coupon.getCouponCode());
            ps.setString(2, coupon.getDiscountType());
            ps.setDouble(3, coupon.getDiscountValue());
            ps.setBoolean(4, coupon.getStatus());
            ps.setInt(5, coupon.getCouponID());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách tất cả coupon
    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        String query = "SELECT * FROM Coupon";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Coupon coupon = new Coupon();
                coupon.setCouponID(rs.getInt("CouponID"));
                coupon.setCouponCode(rs.getString("CouponCode"));
                coupon.setDiscountType(rs.getString("DiscountType"));
                coupon.setDiscountValue(rs.getDouble("DiscountValue"));
                coupon.setStatus(rs.getBoolean("Status"));
                coupon.setCreatedAt(rs.getDate("CreatedAt"));
                coupon.setUpdatedAt(rs.getDate("UpdatedAt"));
                coupons.add(coupon);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return coupons;
    }

    // Xóa coupon
    public boolean deleteCoupon(int couponID) {
        String query = "DELETE FROM Coupon WHERE CouponID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, couponID);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tìm coupon theo couponCode
    public Coupon getCouponByCode(String couponCode) {
        Coupon coupon = null;
        String query = "SELECT * FROM Coupon WHERE CouponCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, couponCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    coupon = new Coupon();
                    coupon.setCouponID(rs.getInt("CouponID"));
                    coupon.setCouponCode(rs.getString("CouponCode"));
                    coupon.setDiscountType(rs.getString("DiscountType"));
                    coupon.setDiscountValue(rs.getDouble("DiscountValue"));
                    coupon.setStatus(rs.getBoolean("Status"));
                    coupon.setCreatedAt(rs.getDate("CreatedAt"));
                    coupon.setUpdatedAt(rs.getDate("UpdatedAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return coupon;
    }
    
    public static void main(String[] args) {
        CouponDAO cou = new CouponDAO();
        List<Coupon> couli = cou.getAllCoupons();
        for (Coupon coupon : couli) {
            System.out.println(coupon.getCouponCode());
        }
    }
}
