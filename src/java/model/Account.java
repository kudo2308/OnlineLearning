package model;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Account {

    @Override
    public String toString() {
        return "Account{" + "userID=" + userID + ", fullName=" + fullName + ", description=" + description + ", password=" + password + ", email=" + email + ", phone=" + phone + ", image=" + image + ", address=" + address + ", genderID=" + genderID + ", dob=" + dob + ", role=" + role + ", subScriptionType=" + subScriptionType + ", subScriptionExpiry=" + subScriptionExpiry + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }

    private int userID;
    private String fullName;
    private String description;
    private String password;
    private String email;
    private String phone;
    private String image;
    private String address;
    private String genderID;
    private Date dob;
    private Role role;
    private String subScriptionType;
    private Timestamp subScriptionExpiry;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Account() {
    }

    public Account(int userID, String fullName, int roleID) {
        this.userID = userID;
        this.fullName = fullName;
        this.role = new Role(roleID, "base"); // Đặt tên mặc định
    }

    public Account(int userID, String fullName, Role role) {
        this.userID = userID;
        this.fullName = fullName;
        this.role = role;
    }

    public Account(int userID, String fullName, String description, String password, String email, String phone, String image, String address, String genderID, Date dob, Role role, String subScriptionType, Timestamp subScriptionExpiry, boolean status, Timestamp createdAt, Timestamp updatedAt) {
        this.userID = userID;
        this.fullName = fullName;
        this.description = description;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.image = image;
        this.address = address;
        this.genderID = genderID;
        this.dob = dob;
        this.role = role;
        this.subScriptionType = subScriptionType;
        this.subScriptionExpiry = subScriptionExpiry;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getGenderID() {
        return genderID;
    }

    public void setGenderID(String genderID) {
        this.genderID = genderID;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getSubScriptionType() {
        return subScriptionType;
    }

    public void setSubScriptionType(String subScriptionType) {
        this.subScriptionType = subScriptionType;
    }

    public Timestamp getSubScriptionExpiry() {
        return subScriptionExpiry;
    }

    public void setSubScriptionExpiry(Timestamp subScriptionExpiry) {
        this.subScriptionExpiry = subScriptionExpiry;
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

}
