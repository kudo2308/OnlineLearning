package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SystemWalletTransaction {
    private int transactionID;
    private BigDecimal amount;
    private BigDecimal previousBalance;
    private BigDecimal newBalance;
    private String transactionType;
    private String bankTransactionID;
    private String description;
    private Timestamp createdAt;
    
    // Constructors
    public SystemWalletTransaction() {
    }
    
    // Getters and setters
    public int getTransactionID() {
        return transactionID;
    }
    
    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public BigDecimal getPreviousBalance() {
        return previousBalance;
    }
    
    public void setPreviousBalance(BigDecimal previousBalance) {
        this.previousBalance = previousBalance;
    }
    
    public BigDecimal getNewBalance() {
        return newBalance;
    }
    
    public void setNewBalance(BigDecimal newBalance) {
        this.newBalance = newBalance;
    }
    
    public String getTransactionType() {
        return transactionType;
    }
    
    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }
    
    public String getBankTransactionID() {
        return bankTransactionID;
    }
    
    public void setBankTransactionID(String bankTransactionID) {
        this.bankTransactionID = bankTransactionID;
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
}