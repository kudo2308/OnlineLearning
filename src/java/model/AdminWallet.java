package model;

import java.math.BigDecimal;

public class AdminWallet {
    private int adminID;
    private BigDecimal balance;
    
    public AdminWallet() {
    }
    
    public AdminWallet(int adminID, BigDecimal balance) {
        this.adminID = adminID;
        this.balance = balance;
    }
    
    public int getAdminID() {
        return adminID;
    }
    
    public void setAdminID(int adminID) {
        this.adminID = adminID;
    }
    
    public BigDecimal getBalance() {
        return balance;
    }
    
    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
}