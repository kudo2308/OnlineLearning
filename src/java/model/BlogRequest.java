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
public class BlogRequest {

    private int id;
    private int blogId;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private int adminId;
    private Blog blog;
    private User author;
    public BlogRequest() {
    }
    
    
    // Constructor
    public BlogRequest(int id, int blogId, String status, Date createdAt, Date updatedAt, int adminId) {
        this.id = id;
        this.blogId = blogId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.adminId = adminId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
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

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public Blog getBlog() {
        return blog;
    }

    public void setBlog(Blog blog) {
        this.blog = blog;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }
    
    

    @Override
    public String toString() {
        return "BlogRequest{"
                + "id=" + id
                + ", blogId=" + blogId
                + ", status='" + status + '\''
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + ", adminId=" + adminId
                + '}';
    }
}
