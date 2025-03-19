package model;
import java.math.BigDecimal;
import java.util.Date;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int courseId;
    private int expertId;
    private BigDecimal originalPrice;
    private BigDecimal commissionRate; // e.g., 0.20 for 20%
    private BigDecimal finalAmount;    // the amount the expert receives
    private Date createdAt;
    
    // Additional fields for displaying course details
    private String courseTitle;
    private String imageUrl;
    private String expertName;
    
    public OrderItem() {
    }
    
    // Existing Getters and Setters
    public int getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public int getExpertId() {
        return expertId;
    }
    
    public void setExpertId(int expertId) {
        this.expertId = expertId;
    }
    
    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }
    
    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }
    
    public BigDecimal getCommissionRate() {
        return commissionRate;
    }
    
    public void setCommissionRate(BigDecimal commissionRate) {
        this.commissionRate = commissionRate;
    }
    
    public BigDecimal getFinalAmount() {
        return finalAmount;
    }
    
    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    // New getters and setters for additional fields
    public String getCourseTitle() {
        return courseTitle;
    }
    
    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getExpertName() {
        return expertName;
    }
    
    public void setExpertName(String expertName) {
        this.expertName = expertName;
    }

    @Override
    public String toString() {
        return "OrderItem{" + "orderItemId=" + orderItemId + ", orderId=" + orderId + ", courseId=" + courseId + ", expertId=" + expertId + ", originalPrice=" + originalPrice + ", commissionRate=" + commissionRate + ", finalAmount=" + finalAmount + ", createdAt=" + createdAt + ", courseTitle=" + courseTitle + ", imageUrl=" + imageUrl + ", expertName=" + expertName + '}';
    }
    
}