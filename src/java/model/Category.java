package model;

import java.sql.Timestamp;

public class Category {
    private int categoryID;
    private String name;
    private String description;
    private Timestamp createdAt;
    
    public Category() {
    }

    public Category(int categoryID, String name) {
        this.categoryID = categoryID;
        this.name = name;
    }

    public Category(int categoryID, String name, String description, Timestamp createdAt) {
        this.categoryID = categoryID;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
    }
    
    
    public int getCategoryID() {
        return categoryID;
    }
    
    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Category{" + "categoryID=" + categoryID + ", name=" + name + ", description=" + description + ", createdAt=" + createdAt + '}';
    }
    
    
}
