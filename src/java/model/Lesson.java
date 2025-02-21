package model;

import java.sql.Date;

public class Lesson {
    private int lessonID;
    private String title;
    private String content;
    private String lessonType;
    private int duration;
    private int orderNumber;
    private int courseID;
    private boolean status;
    private Date createdAt;
    private Date updatedAt;
    
    // Navigation property
    private Course course;
    
    public Lesson() {
    }
    
    public int getLessonID() {
        return lessonID;
    }
    
    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getLessonType() {
        return lessonType;
    }
    
    public void setLessonType(String lessonType) {
        this.lessonType = lessonType;
    }
   
    
    public int getDuration() {
        return duration;
    }
    
    public void setDuration(int duration) {
        this.duration = duration;
    }
    
    public int getOrderNumber() {
        return orderNumber;
    }
    
    public void setOrderNumber(int orderNumber) {
        this.orderNumber = orderNumber;
    }
    
    public int getCourseID() {
        return courseID;
    }
    
    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }
    
    public boolean isStatus() {
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
    
    public Course getCourse() {
        return course;
    }
    
    public void setCourse(Course course) {
        this.course = course;
    }
}
