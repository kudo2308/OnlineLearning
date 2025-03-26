/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.*;
/**
 *
 * @author VICTUS
 */
public class WalletTransactionDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;

    public List<WalletTransaction> getTransactions(String bankTransactionId, int senderId,
            int receiverId, String transactionType,
            int pageIndex, int pageSize) {
        List<WalletTransaction> transactions = new ArrayList<>();

        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT wt.*, s.FullName as SenderName, r.FullName as ReceiverName ");
            sql.append("FROM WalletTransaction wt ");
            sql.append("LEFT JOIN Account s ON wt.SenderID = s.UserID ");
            sql.append("LEFT JOIN Account r ON wt.ReceiverID = r.UserID ");
            sql.append("WHERE 1=1 ");

            // Add filter conditions
            List<Object> params = new ArrayList<>();

            if (bankTransactionId != null && !bankTransactionId.trim().isEmpty()) {
                sql.append("AND wt.BankTransactionID LIKE ? ");
                params.add("%" + bankTransactionId + "%");
            }

            if (senderId > 0) {
                sql.append("AND wt.SenderID = ? ");
                params.add(senderId);
            }

            if (receiverId > 0) {
                sql.append("AND wt.ReceiverID = ? ");
                params.add(receiverId);
            }

            if (transactionType != null && !transactionType.trim().isEmpty()) {
                sql.append("AND wt.TransactionType = ? ");
                params.add(transactionType);
            }

            // Add order by and pagination
            sql.append("ORDER BY wt.CreatedAt DESC ");
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            params.add((pageIndex - 1) * pageSize);
            params.add(pageSize);

            ps = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                WalletTransaction transaction = mapTransaction(rs);
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return transactions;
    }

    /**
     * Count total transactions with filters for pagination
     */
    public int countTransactions(String bankTransactionId, int senderId,
            int receiverId, String transactionType) {
        int count = 0;

        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM WalletTransaction WHERE 1=1 ");

            // Add filter conditions
            List<Object> params = new ArrayList<>();

            if (bankTransactionId != null && !bankTransactionId.trim().isEmpty()) {
                sql.append("AND BankTransactionID LIKE ? ");
                params.add("%" + bankTransactionId + "%");
            }

            if (senderId > 0) {
                sql.append("AND SenderID = ? ");
                params.add(senderId);
            }

            if (receiverId > 0) {
                sql.append("AND ReceiverID = ? ");
                params.add(receiverId);
            }

            if (transactionType != null && !transactionType.trim().isEmpty()) {
                sql.append("AND TransactionType = ? ");
                params.add(transactionType);
            }

            ps = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return count;
    }

    /**
     * Get a transaction by ID
     */
    public WalletTransaction getTransactionById(int transactionId) {
        WalletTransaction transaction = null;

        try {
            String sql = "SELECT wt.*, s.FullName as SenderName, r.FullName as ReceiverName "
                    + "FROM WalletTransaction wt "
                    + "LEFT JOIN Account s ON wt.SenderID = s.UserID "
                    + "LEFT JOIN Account r ON wt.ReceiverID = r.UserID "
                    + "WHERE wt.TransactionID = ?";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, transactionId);

            rs = ps.executeQuery();

            if (rs.next()) {
                transaction = mapTransaction(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return transaction;
    }

    /**
     * Update transaction status
     */
    public boolean updateTransactionStatus(int transactionId, String status, int processedBy) {
        try {
            String sql = "UPDATE WalletTransaction SET Status = ?, ProcessedAt = GETDATE(), ProcessedBy = ? "
                    + "WHERE TransactionID = ?";

            ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, processedBy);
            ps.setInt(3, transactionId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } 
    }

    /**
     * Get all unique senders for dropdown
     * @return 
     */
    public List<Account> getAllSenders() {
        List<Account> senders = new ArrayList<>();

        try {
            String sql = "SELECT DISTINCT a.UserID, a.FullName FROM Account a "
                    + "JOIN WalletTransaction wt ON a.UserID = wt.SenderID "
                    + "WHERE wt.SenderID IS NOT NULL "
                    + "ORDER BY a.FullName";

            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account sender = new Account();
                sender.setUserID(rs.getInt("UserID"));
                sender.setFullName(rs.getString("FullName"));
                senders.add(sender);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return senders;
    }

    /**
     * Get all unique receivers for dropdown
     * @return 
     */
    public List<Account> getAllReceivers() {
        List<Account> receivers = new ArrayList<>();

        try {
            String sql = "SELECT DISTINCT a.UserID, a.FullName FROM Account a "
                    + "JOIN WalletTransaction wt ON a.UserID = wt.ReceiverID "
                    + "WHERE wt.ReceiverID IS NOT NULL "
                    + "ORDER BY a.FullName";

            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account receiver = new Account();
                receiver.setUserID(rs.getInt("UserID"));
                receiver.setFullName(rs.getString("FullName"));
                receivers.add(receiver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return receivers;
    }

    /**
     * Map ResultSet to WalletTransaction object
     */
    private WalletTransaction mapTransaction(ResultSet rs) throws SQLException {
        WalletTransaction transaction = new WalletTransaction();
        transaction.setTransactionID(rs.getInt("TransactionID"));
        transaction.setAmount(rs.getBigDecimal("Amount"));
        transaction.setTransactionType(rs.getString("TransactionType"));
        transaction.setBankTransactionID(rs.getString("BankTransactionID"));
        transaction.setDescription(rs.getString("Description"));
        transaction.setStatus(rs.getString("Status"));
        transaction.setCreatedAt(rs.getTimestamp("CreatedAt"));

        if (rs.getObject("ProcessedAt") != null) {
            transaction.setProcessedAt(rs.getTimestamp("ProcessedAt"));
        }

        // Set sender if exists
        if (rs.getObject("SenderID") != null) {
            Account sender = new Account();
            sender.setUserID(rs.getInt("SenderID"));
            sender.setFullName(rs.getString("SenderName"));
            transaction.setSender(sender);
        }

        // Set receiver if exists
        if (rs.getObject("ReceiverID") != null) {
            Account receiver = new Account();
            receiver.setUserID(rs.getInt("ReceiverID"));
            receiver.setFullName(rs.getString("ReceiverName"));
            transaction.setReceiver(receiver);
        }

        // Set related IDs if they exist
        if (rs.getObject("RelatedOrderID") != null) {
            transaction.setRelatedOrderID(rs.getInt("RelatedOrderID"));
        }

        if (rs.getObject("RelatedPayoutID") != null) {
            transaction.setRelatedPayoutID(rs.getInt("RelatedPayoutID"));
        }

        return transaction;
    }
}