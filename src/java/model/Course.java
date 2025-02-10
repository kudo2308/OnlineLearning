package model;

import java.sql.Timestamp;

public class Course {
    private int courseID;
    private double price;
    private String title;
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

    public Course(int courseID, String title, String description, int expertID, int pricePackageID, int categoryID, String imageUrl, int totalLesson, boolean status, Timestamp createdAt, Timestamp updatedAt, Account expert, Category category) {
        this.courseID = courseID;
        this.title = title;
        this.description = description;
        this.expertID = expertID;
        this.pricePackageID = pricePackageID;
        this.categoryID = categoryID;
        this.imageUrl = imageUrl;
        this.totalLesson = totalLesson;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.expert = expert;
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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

    @Override
    public String toString() {
        return "Course{" + "courseID=" + courseID + ", title=" + title + ", description=" + description + ", expertID=" + expertID + ", pricePackageID=" + pricePackageID + ", categoryID=" + categoryID + ", imageUrl=" + imageUrl + ", totalLesson=" + totalLesson + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", expert=" + expert + ", category=" + category + '}';
    }
    
    
}
