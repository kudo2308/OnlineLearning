package model;

import java.sql.Timestamp;

/**
 * Model class representing a user's progress on a lesson
 */
public class LessonProgress {
    private int progressID;
    private int lessonID;
    private int userID;
    private int courseID;
    private boolean completed;
    private Timestamp completedAt;
    private Timestamp createdAt;

    public LessonProgress() {
    }

    public LessonProgress(int progressID, int lessonID, int userID, int courseID, boolean completed, Timestamp completedAt, Timestamp createdAt) {
        this.progressID = progressID;
        this.lessonID = lessonID;
        this.userID = userID;
        this.courseID = courseID;
        this.completed = completed;
        this.completedAt = completedAt;
        this.createdAt = createdAt;
    }

    public int getProgressID() {
        return progressID;
    }

    public void setProgressID(int progressID) {
        this.progressID = progressID;
    }

    public int getLessonID() {
        return lessonID;
    }

    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
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

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "LessonProgress{" + "progressID=" + progressID + ", lessonID=" + lessonID + 
               ", userID=" + userID + ", courseID=" + courseID + ", completed=" + completed + 
               ", completedAt=" + completedAt + ", createdAt=" + createdAt + '}';
    }
}
