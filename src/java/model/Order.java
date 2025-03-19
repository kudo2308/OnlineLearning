package model;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int orderID;
    private int accountID;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private String vnpayTransactionID;
    private Date createdAt;
    private Date updatedAt;
    private List<OrderItem> orderItems; // New field to store order items
    
    public Order() {}
    
    public Order(int orderID, int accountID, BigDecimal totalAmount, String paymentMethod, String paymentStatus, String vnpayTransactionID, Date createdAt, Date updatedAt) {
        this.orderID = orderID;
        this.accountID = accountID;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.vnpayTransactionID = vnpayTransactionID;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Existing getters and setters
    public int getOrderID() {
        return orderID;
    }
    
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }
    
    public int getAccountID() {
        return accountID;
    }
    
    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getVnpayTransactionID() {
        return vnpayTransactionID;
    }
    
    public void setVnpayTransactionID(String vnpayTransactionID) {
        this.vnpayTransactionID = vnpayTransactionID;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // New getter and setter for orderItems
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
}