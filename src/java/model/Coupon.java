/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author ASUS
 */
public class Coupon {
    private int couponID;
    private String couponCode;
    private String discountType;  // Loại giảm giá (percentage or fixed)
    private double discountValue;
    private boolean status;  // Trạng thái (1: active, 0: inactive)
    private Date createdAt;
    private Date updatedAt;

    public Coupon() {
    }

    public Coupon(int couponID, String couponCode, String discountType, double discountValue, boolean status) {
        this.couponID = couponID;
        this.couponCode = couponCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.status = status;
    }
    
    
    
    public Coupon(String couponCode, String discountType, double discountValue, boolean status) {
        this.couponCode = couponCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.status = status;
    }
    
    
    // Getters and Setters
    public int getCouponID() {
        return couponID;
    }

    public void setCouponID(int couponID) {
        this.couponID = couponID;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
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
}

