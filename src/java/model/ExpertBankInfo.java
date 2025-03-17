package model;

import java.util.Date;

public class ExpertBankInfo {
    private int expertId; // Primary key
    private String bankAccountNumber;
    private String bankName;
    private Date createdAt;
    private Date updatedAt;

    public ExpertBankInfo() {
    }

    // Getters and Setters
    public int getExpertId() {
        return expertId;
    }
    public void setExpertId(int expertId) {
        this.expertId = expertId;
    }
    public String getBankAccountNumber() {
        return bankAccountNumber;
    }
    public void setBankAccountNumber(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }
    public String getBankName() {
        return bankName;
    }
    public void setBankName(String bankName) {
        this.bankName = bankName;
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
}
