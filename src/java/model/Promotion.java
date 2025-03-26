package model;

import java.sql.Timestamp;

public class Promotion {
    private int promotionID;
    private String promotionCode;
    private String discountType;  // "percentage" hoặc "fixed"
    private double discountValue;
    private boolean status;
    private int categoryID;
    private int expertID;
    private int courseID;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Promotion() {
        // Constructor mặc định
        this.categoryID = 0;
        this.expertID = 0;
        this.courseID = 0;
    }

    public Promotion(int promotionID, String promotionCode, String discountType, double discountValue, 
                     boolean status, int categoryID, int expertID, int courseID, 
                     Timestamp createdAt, Timestamp updatedAt) {
        this.promotionID = promotionID;
        this.promotionCode = promotionCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.status = status;
        this.categoryID = categoryID;
        this.expertID = expertID;
        this.courseID = courseID;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters và Setters
    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public String getPromotionCode() {
        return promotionCode;
    }

    public void setPromotionCode(String promotionCode) {
        this.promotionCode = promotionCode;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getExpertID() {
        return expertID;
    }

    public void setExpertID(int expertID) {
        this.expertID = expertID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Method để kiểm tra xem khuyến mãi có áp dụng cho tất cả không
    public boolean isGlobal() {
        return categoryID == 0 && expertID == 0 && courseID == 0;
    }
    
    // Method để kiểm tra khuyến mãi theo phần trăm
    public boolean isPercentageDiscount() {
        return "percentage".equalsIgnoreCase(discountType);
    }
    
    // Method để tính giá trị giảm giá dựa trên giá gốc
    public double calculateDiscountAmount(double originalPrice) {
        if (isPercentageDiscount()) {
            return originalPrice * discountValue / 100;
        } else {
            return Math.min(discountValue, originalPrice); // Không để giá trị giảm nhiều hơn giá gốc
        }
    }
    
    // Method để tính giá sau khi giảm
    public double calculateFinalPrice(double originalPrice) {
        double discount = calculateDiscountAmount(originalPrice);
        return originalPrice - discount;
    }
}