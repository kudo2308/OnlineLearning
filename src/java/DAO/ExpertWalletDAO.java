package DAO;

import DBContext.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ExpertBankInfo;
import model.ExpertPayout;

public class ExpertWalletDAO extends DBContext {

    // Get expert bank info by expert ID
    public ExpertBankInfo getExpertBankInfo(int expertId) {
        ExpertBankInfo bankInfo = null;
        String sql = "SELECT * FROM ExpertBankInfo WHERE ExpertID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bankInfo = new ExpertBankInfo();
                    bankInfo.setExpertId(rs.getInt("ExpertID"));
                    bankInfo.setBankAccountNumber(rs.getString("BankAccountNumber"));
                    bankInfo.setBankName(rs.getString("BankName"));
                    bankInfo.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    bankInfo.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    bankInfo.setWalletBalance(rs.getDouble("WalletBalance"));
                }
            }
        } catch (SQLException e) {
            e.getMessage();
        }

        return bankInfo;
    }

    // Create new expert bank info
    public boolean createExpertBankInfo(ExpertBankInfo bankInfo) {
        String sql = "INSERT INTO ExpertBankInfo (ExpertID, BankAccountNumber, BankName, WalletBalance) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bankInfo.getExpertId());
            ps.setString(2, bankInfo.getBankAccountNumber());
            ps.setString(3, bankInfo.getBankName());
            ps.setDouble(4, bankInfo.getWalletBalance());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.getMessage();
            return false;
        }
    }
    public boolean createExpertBankInfo(int expertId) {
        String sql = "INSERT INTO ExpertBankInfo (ExpertID, BankAccountNumber, BankName, WalletBalance) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            ps.setString(2, null);
            ps.setString(3, null);
            ps.setDouble(4, 0);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.getMessage();
            return false;
        }
    }
    public boolean updateExpertBankInfo(ExpertBankInfo bankInfo) {
        String sql = "UPDATE ExpertBankInfo SET BankAccountNumber = ?, BankName = ?, UpdatedAt = GETDATE() WHERE ExpertID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, bankInfo.getBankAccountNumber());
            ps.setString(2, bankInfo.getBankName());
            ps.setInt(3, bankInfo.getExpertId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            return false;
        }
    }

    // Update wallet balance
    public boolean updateWalletBalance(int expertId, double newBalance) {
        String sql = "UPDATE ExpertBankInfo SET WalletBalance = ?, UpdatedAt = GETDATE() WHERE ExpertID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, newBalance);
            ps.setInt(2, expertId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.getMessage();
            return false;
        }
    }

     // Create payout system 
    public boolean createPayoutSysyem(int expertId , double  amount) {
        String sql = "INSERT INTO ExpertPayout (ExpertID, Amount, BankAccountNumber, BankName) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            ps.setDouble(2, amount);
            ps.setString(3, "xx.xx.xx");
            ps.setString(4, "System");

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.getMessage();
            return false;
        }
    }
    
    // Create new payout request
    public boolean createPayoutRequest(ExpertPayout payout) {
        String sql = "INSERT INTO ExpertPayout (ExpertID, Amount, BankAccountNumber, BankName) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, payout.getExpertId());
            ps.setDouble(2, payout.getAmount());
            ps.setString(3, payout.getBankAccountNumber());
            ps.setString(4, payout.getBankName());

            int rowsAffected = ps.executeUpdate();

            // If payout request is created successfully, reduce wallet balance
            if (rowsAffected > 0) {
                ExpertBankInfo bankInfo = getExpertBankInfo(payout.getExpertId());
                if (bankInfo != null) {
                    double newBalance = bankInfo.getWalletBalance() - payout.getAmount();
                    return updateWalletBalance(payout.getExpertId(), newBalance);
                }
            }

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.getMessage();
            return false;
        }
    }

    // Get all payout requests for an expert
    public List<ExpertPayout> getExpertPayouts(int expertId) {
        List<ExpertPayout> payoutList = new ArrayList<>();
        String sql = "SELECT * FROM ExpertPayout WHERE ExpertID = ? ORDER BY RequestedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ExpertPayout payout = new ExpertPayout();
                    payout.setPayoutId(rs.getInt("PayoutID"));
                    payout.setExpertId(rs.getInt("ExpertID"));
                    payout.setAmount(rs.getDouble("Amount"));
                    payout.setBankAccountNumber(rs.getString("BankAccountNumber"));
                    payout.setBankName(rs.getString("BankName"));
                    payout.setStatus(rs.getString("Status"));
                    payout.setRequestedAt(rs.getTimestamp("RequestedAt"));
                    payout.setProcessedAt(rs.getTimestamp("ProcessedAt"));
                    payoutList.add(payout);
                }
            }
        } catch (SQLException e) {
            e.getMessage();
        }

        return payoutList;
    }

     public boolean addToWalletBalance(int expertId, double additionalAmount) {
        // Kiểm tra số tiền thêm vào phải lớn hơn 0
        if (additionalAmount <= 0) {
            return false;
        }

        // Lấy thông tin ví hiện tại
        ExpertBankInfo bankInfo = getExpertBankInfo(expertId);
        if (bankInfo == null) {
            return false; // Không tìm thấy thông tin ví
        }

        // Tính toán số dư mới
        double currentBalance = bankInfo.getWalletBalance();
        double newBalance = currentBalance + additionalAmount;

        // Cập nhật số dư mới vào cơ sở dữ liệu
        String sql = "UPDATE ExpertBankInfo SET WalletBalance = ?, UpdatedAt = GETDATE() WHERE ExpertID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, newBalance);
            ps.setInt(2, expertId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                createPayoutSysyem(expertId , additionalAmount);
            }
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            return false;
        }
    }
    public boolean hasSufficientBalance(int expertId, double amount) {
        ExpertBankInfo bankInfo = getExpertBankInfo(expertId);
        if (bankInfo != null) {
            return bankInfo.getWalletBalance() >= amount;
        }
        return false;
    }
}
