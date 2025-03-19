package model;

import java.sql.Timestamp;

public class ExpertBankInfo {

    private int expertId;
    private String bankAccountNumber;
    private String bankName;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private double walletBalance;

    public ExpertBankInfo() {
        this.walletBalance = 0.0;
    }

    public ExpertBankInfo(int expertId, String bankAccountNumber, String bankName) {
        this.expertId = expertId;
        this.bankAccountNumber = bankAccountNumber;
        this.bankName = bankName;
        this.walletBalance = 0.0;
    }

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

    public double getWalletBalance() {
        return walletBalance;
    }

    public void setWalletBalance(double walletBalance) {
        this.walletBalance = walletBalance;
    }

    @Override
    public String toString() {
        return "ExpertBankInfo{" + "expertId=" + expertId + ", bankAccountNumber=" + bankAccountNumber + ", bankName=" + bankName + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", walletBalance=" + walletBalance + '}';
    }
    
}
