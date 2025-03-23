package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackID;
    private int userID;
    private int courseID;
    private int blogId;
    private String content;
    private int rating;
    private boolean status;
    private Timestamp createdAt;
    
    // Navigation properties
    private Account user;
    private Course course;
    private Blog blog;
    private Role role;
    
    public Feedback() {
    }

    public Feedback(int feedbackID, int userID, int courseID, int blogId, String content, int rating, boolean status, Timestamp createdAt, Account user, Course course, Blog blog) {
        this.feedbackID = feedbackID;
        this.userID = userID;
        this.courseID = courseID;
        this.blogId = blogId;
        this.content = content;
        this.rating = rating;
        this.status = status;
        this.createdAt = createdAt;
        this.user = user;
        this.course = course;
        this.blog = blog;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public Blog getBlog() {
        return blog;
    }

    public void setBlog(Blog blog) {
        this.blog = blog;
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

    @Override
    public String toString() {
        return "Feedback{" + "feedbackID=" + feedbackID + ", userID=" + userID + ", courseID=" + courseID + ", blogId=" + blogId + ", content=" + content + ", rating=" + rating + ", status=" + status + ", createdAt=" + createdAt + ", user=" + user + ", course=" + course + ", blog=" + blog + ", role=" + role + '}';
    }
    
    
}
