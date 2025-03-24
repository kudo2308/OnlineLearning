package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class representing a wallet transaction in the system
 * @author VICTUS
 */
public class WalletTransaction {
    private int transactionID;
    private BigDecimal amount;
    private String transactionType;
    private String bankTransactionID;
    private String description;
    private Account sender;
    private Account receiver;
    private int relatedOrderID;
    private int relatedPayoutID;
    private String status;
    private Timestamp createdAt;
    private Timestamp processedAt;
    private int processedBy;

    public WalletTransaction() {
    }

    // Constructor with essential fields
    public WalletTransaction(int transactionID, BigDecimal amount, String transactionType, 
            String status, Timestamp createdAt) {
        this.transactionID = transactionID;
        this.amount = amount;
        this.transactionType = transactionType;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
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

    public Account getSender() {
        return sender;
    }

    public void setSender(Account sender) {
        this.sender = sender;
    }

    public Account getReceiver() {
        return receiver;
    }

    public void setReceiver(Account receiver) {
        this.receiver = receiver;
    }

    public int getRelatedOrderID() {
        return relatedOrderID;
    }

    public void setRelatedOrderID(int relatedOrderID) {
        this.relatedOrderID = relatedOrderID;
    }

    public int getRelatedPayoutID() {
        return relatedPayoutID;
    }

    public void setRelatedPayoutID(int relatedPayoutID) {
        this.relatedPayoutID = relatedPayoutID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }

    public int getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(int processedBy) {
        this.processedBy = processedBy;
    }

    @Override
    public String toString() {
        return "WalletTransaction{" +
                "transactionID=" + transactionID +
                ", amount=" + amount +
                ", transactionType='" + transactionType + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}