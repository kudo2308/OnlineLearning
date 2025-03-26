/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.BlogRequest;
import java.sql.Statement;
import model.Blog;

import model.Coupon;
import model.User;

/**
 *
 * @author ASUS
 */
public class BlogRequestDAO extends DBContext {

    private PreparedStatement ps;
    private ResultSet rs;
    private List<BlogRequest> request;

    public BlogRequestDAO() {
        request = new ArrayList<>();
    }

    public boolean sendApprovalRequest(BlogRequest request) {

        try {
            String sql = "INSERT INTO BlogRequest (BlogID, status, CreatedAt, UpdatedAt, AdminID) VALUES (?, ?, GETDATE(), GETDATE(), ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, request.getBlogId());
            ps.setString(2, request.getStatus());
            ps.setInt(3, request.getAdminId()); // Chỉ set AdminID nếu yêu cầu đã được phê duyệt
            int rowsInserted = ps.executeUpdate();

            return rowsInserted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updateRequestStatus(int requestId, String status, int adminId) {

        String updateSQL = "UPDATE BlogRequest SET status = ?, AdminID = ?, UpdatedAt = GETDATE() WHERE ID = ?";

        try {
            ps = connection.prepareStatement(updateSQL);
            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setInt(3, requestId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<BlogRequest> getAllBlogRequests() {
        List<BlogRequest> requests = new ArrayList<>();
        String sql = "SELECT br.ID, br.BlogID, br.Status, br.CreatedAt, br.UpdatedAt, br.AdminID, "
                + "b.Title as BlogTitle, a.FullName as AdminName "
                + "FROM BlogRequest br "
                + "JOIN Blog b ON br.BlogID = b.BlogID "
                + "JOIN Account a ON br.AdminID = a.UserID";

        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BlogRequest request = new BlogRequest();
                request.setId(rs.getInt("ID"));
                request.setBlogId(rs.getInt("BlogID"));
                request.setStatus(rs.getString("Status"));
                request.setCreatedAt(rs.getTimestamp("CreatedAt"));
                request.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                request.setAdminId(rs.getInt("AdminID"));

                Blog blog = new Blog();
                blog.setTitle(rs.getString("BlogTitle"));
                request.setBlog(blog);

                User user = new User();
                user.setFullName(rs.getString("AdminName"));
                request.setAuthor(user);

                requests.add(request);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return requests;
    }

    public BlogRequest getBlogRequestById(int Id) {
        BlogRequest request = null;  // Khởi tạo đối tượng BlogRequest
        String sql = "SELECT br.ID, br.BlogID, br.Status, br.CreatedAt, br.UpdatedAt, br.AdminID, "
                + "b.Title as BlogTitle, a.FullName as AdminName "
                + "FROM BlogRequest br "
                + "JOIN Blog b ON br.BlogID = b.BlogID "
                + "JOIN Account a ON br.AdminID = a.UserID WHERE br.ID = ?";

        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, Id);  // Set parameter ID cho câu truy vấn
            rs = ps.executeQuery();

            if (rs.next()) {  // Chỉ cần xử lý kết quả đầu tiên vì ID là duy nhất
                request = new BlogRequest();  // Khởi tạo đối tượng BlogRequest
                request.setId(rs.getInt("ID"));
                request.setBlogId(rs.getInt("BlogID"));
                request.setStatus(rs.getString("Status"));
                request.setCreatedAt(rs.getTimestamp("CreatedAt"));
                request.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                request.setAdminId(rs.getInt("AdminID"));

                // Lấy thông tin Blog
                Blog blog = new Blog();
                blog.setTitle(rs.getString("BlogTitle"));
                request.setBlog(blog);  // Set Blog vào request

                // Lấy thông tin Admin (Author)
                User user = new User();
                user.setFullName(rs.getString("AdminName"));
                request.setAuthor(user);  // Set Author vào request
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return request;  // Trả về đối tượng BlogRequest duy nhất
    }

    public static void main(String[] args) {
        BlogRequestDAO dao = new BlogRequestDAO();
        BlogRequest que = dao.getBlogRequestById(10);
        System.out.println(que.getBlogId());
    }
}
