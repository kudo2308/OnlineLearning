/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author dohie
 */
public class Account {
    private int userID;
    private String fullName;
    private String username;
    private String password;
    private String email;
    private int roleID;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Navigation property
    private Role role;
    
    public Account() {
    }

    public Account(int userID, String fullName, int roleID) {
        this.userID = userID;
        this.fullName = fullName;
        this.roleID = roleID;
    }
    
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public int getRoleID() {
        return roleID;
    }
    
    public void setRoleID(int roleID) {
        this.roleID = roleID;
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
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Account{" + "userID=" + userID + ", fullName=" + fullName + ", username=" + username + ", password=" + password + ", email=" + email + ", roleID=" + roleID + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", role=" + role + '}';
    }
    
    
}
