package model;

import java.sql.Timestamp;

public class ExpertPayout {
    private int payoutId;
    private int expertId;
    private double amount;
    private String bankAccountNumber;
    private String bankName;
    private String status;
    private Timestamp requestedAt;
    private Timestamp processedAt;
    
    public ExpertPayout() {
        this.status = "pending";
    }
    
    public ExpertPayout(int expertId, double amount, String bankAccountNumber, String bankName) {
        this.expertId = expertId;
        this.amount = amount;
        this.bankAccountNumber = bankAccountNumber;
        this.bankName = bankName;
        this.status = "pending";
    }

    public int getPayoutId() {
        return payoutId;
    }

    public void setPayoutId(int payoutId) {
        this.payoutId = payoutId;
    }

    public int getExpertId() {
        return expertId;
    }

    public void setExpertId(int expertId) {
        this.expertId = expertId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }
}