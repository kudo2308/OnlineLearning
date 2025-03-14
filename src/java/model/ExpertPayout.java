/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;

public class ExpertPayout {
    private int payoutId;
    private int expertId;
    private BigDecimal amount;
    private String bankAccountNumber;
    private String bankName;
    private String status; // defaults to "pending"; allowed: "pending", "processed", "failed"
    private Date requestedAt;
    private Date processedAt; // can be null

    public ExpertPayout() {
    }

    // Getters and Setters
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
    public BigDecimal getAmount() {
        return amount;
    }
    public void setAmount(BigDecimal amount) {
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
    public Date getRequestedAt() {
        return requestedAt;
    }
    public void setRequestedAt(Date requestedAt) {
        this.requestedAt = requestedAt;
    }
    public Date getProcessedAt() {
        return processedAt;
    }
    public void setProcessedAt(Date processedAt) {
        this.processedAt = processedAt;
    }
}