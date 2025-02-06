package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackID;
    private int userID;
    private int courseID;
    private String content;
    private int rating;
    private boolean status;
    private Timestamp createdAt;
    
    // Navigation properties
    private Account user;
    private Course course;
    
    public Feedback() {
    }
    
    public int getFeedbackID() {
        return feedbackID;
    }
    
    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
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
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
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
    
    public Account getUser() {
        return user;
    }
    
    public void setUser(Account user) {
        this.user = user;
    }
    
    public Course getCourse() {
        return course;
    }
    
    public void setCourse(Course course) {
        this.course = course;
    }
}
