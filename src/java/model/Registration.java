package model;

import java.sql.Timestamp;

public class Registration {
    private int registrationID;
    private int userID;
    private int courseID;
    private double price;
    private String status;
    private int progress;
    private Timestamp validFrom;
    private Timestamp validTo;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    
    private User user;
    private Course course;
    
    public Registration() {
    }
    
    public int getRegistrationID() {
        return registrationID;
    }
    
    public void setRegistrationID(int registrationID) {
        this.registrationID = registrationID;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public int getCourseID() {
        return courseID;
    }
    
    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getProgress() {
        return progress;
    }
    
    public void setProgress(int progress) {
        this.progress = progress;
    }
    
    public Timestamp getValidFrom() {
        return validFrom;
    }
    
    public void setValidFrom(Timestamp validFrom) {
        this.validFrom = validFrom;
    }
    
    public Timestamp getValidTo() {
        return validTo;
    }
    
    public void setValidTo(Timestamp validTo) {
        this.validTo = validTo;
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
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Course getCourse() {
        return course;
    }
    
    public void setCourse(Course course) {
        this.course = course;
    }

    @Override
    public String toString() {
        return "Registration{" + "registrationID=" + registrationID + ", userID=" + userID + ", courseID=" + courseID + ", price=" + price + ", status=" + status + ", progress=" + progress + ", validFrom=" + validFrom + ", validTo=" + validTo + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", user=" + user + ", course=" + course + '}';
    }
    
}
