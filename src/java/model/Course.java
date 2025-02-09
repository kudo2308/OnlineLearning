package model;

import java.sql.Timestamp;

public class Course {
    private int courseID;
    private String title;
    private double price;
    private String description;
    private int expertID;
    private int pricePackageID;
    private int categoryID;
    private String imageUrl;
    private int totalLesson;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Navigation properties
    private Account expert;
    private Category category;
    
    public Course() {
    }
    
    public int getCourseID() {
        return courseID;
    }
    
    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getExpertID() {
        return expertID;
    }
    
    public void setExpertID(int expertID) {
        this.expertID = expertID;
    }
    
    public int getPricePackageID() {
        return pricePackageID;
    }
    
    public void setPricePackageID(int pricePackageID) {
        this.pricePackageID = pricePackageID;
    }
    
    public int getCategoryID() {
        return categoryID;
    }
    
    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public int getTotalLesson() {
        return totalLesson;
    }
    
    public void setTotalLesson(int totalLesson) {
        this.totalLesson = totalLesson;
    }
    
    public boolean isStatus() {
        return status;
    }
    
    public void setStatus(boolean status) {
        this.status = status;
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
    
    public Account getExpert() {
        return expert;
    }
    
    public void setExpert(Account expert) {
        this.expert = expert;
    }
    
    public Category getCategory() {
        return category;
    }
    
    public void setCategory(Category category) {
        this.category = category;
    }
}
