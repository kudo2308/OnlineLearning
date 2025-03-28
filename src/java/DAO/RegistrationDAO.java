/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.Registration;
import model.Course;
import model.User;
import model.Account;
import java.sql.*;
import java.util.Date;

/**
 *
 * @author ducba
 */
public class RegistrationDAO extends DBContext {

    public void addRegistration(Registration registration) {
        String sql = "INSERT INTO Registration (userID, courseID, price, status, progress, validFrom, validTo, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registration.getUserID());
            stmt.setInt(2, registration.getCourseID());
            stmt.setDouble(3, registration.getPrice());
            stmt.setString(4, registration.getStatus());
            stmt.setInt(5, registration.getProgress());
            stmt.setTimestamp(6, registration.getValidFrom());
            stmt.setTimestamp(7, registration.getValidTo());
            stmt.setTimestamp(8, registration.getCreatedAt());
            stmt.setTimestamp(9, registration.getUpdatedAt());
            stmt.executeUpdate();
        } catch (SQLException e) {

        }
    }

    // Cập nhật một Registration
    public void updateRegistration(Registration registration) {
        String sql = "UPDATE Registration SET userID = ?, courseID = ?, price = ?, status = ?, progress = ?, validFrom = ?, "
                + "validTo = ?, updatedAt = ? WHERE registrationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registration.getUserID());
            stmt.setInt(2, registration.getCourseID());
            stmt.setDouble(3, registration.getPrice());
            stmt.setString(4, registration.getStatus());
            stmt.setInt(5, registration.getProgress());
            stmt.setTimestamp(6, registration.getValidFrom());
            stmt.setTimestamp(7, registration.getValidTo());
            stmt.setTimestamp(8, registration.getUpdatedAt());
            stmt.setInt(9, registration.getRegistrationID());
            stmt.executeUpdate();
        } catch (SQLException e) {

        }
    }

    public void deleteRegistration(int registrationID) {
        String sql = "DELETE FROM Registration WHERE registrationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registrationID);
            stmt.executeUpdate();
        } catch (SQLException e) {

        }
    }

    public List<Registration> getAllRegistrations() {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, c.Title AS CourseTitle "
                + "FROM Registration r "
                + "JOIN Course c ON r.courseID = c.courseID";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Registration registration = new Registration();
                registration.setRegistrationID(rs.getInt("registrationID"));
                registration.setUserID(rs.getInt("userID"));
                registration.setCourseID(rs.getInt("courseID"));
                registration.setPrice(rs.getDouble("price"));
                registration.setStatus(rs.getString("status"));
                registration.setProgress(rs.getInt("progress"));
                registration.setValidFrom(rs.getTimestamp("validFrom"));
                registration.setValidTo(rs.getTimestamp("validTo"));
                registration.setCreatedAt(rs.getTimestamp("createdAt"));
                registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

                Course course = new Course();
                course.setCourseID(rs.getInt("courseID"));
                course.setTitle(rs.getString("CourseTitle"));

                registration.setCourse(course);
                registrations.add(registration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public Registration getRegistrationById(int registrationID) throws SQLException {
        String sql = "SELECT * FROM Registration WHERE registrationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registrationID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Registration registration = new Registration();
                    registration.setRegistrationID(rs.getInt("registrationID"));
                    registration.setUserID(rs.getInt("userID"));
                    registration.setCourseID(rs.getInt("courseID"));
                    registration.setPrice(rs.getDouble("price"));
                    registration.setStatus(rs.getString("status"));
                    registration.setProgress(rs.getInt("progress"));
                    registration.setValidFrom(rs.getTimestamp("validFrom"));
                    registration.setValidTo(rs.getTimestamp("validTo"));
                    registration.setCreatedAt(rs.getTimestamp("createdAt"));
                    registration.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    return registration;
                }
            }
        }
        return null;
    }

    public List<Registration> searchByFullName(String fullname) {
        List<Registration> registrations = new ArrayList<>();

        String sql = "SELECT r.*, c.Title AS CourseTitle, a.fullName , a.email "
                + "FROM Registration r "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "JOIN Account a ON r.userID = a.userID "
                + "WHERE a.fullName LIKE ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + fullname + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = new Registration();
                    registration.setRegistrationID(rs.getInt("registrationID"));
                    registration.setUserID(rs.getInt("userID"));
                    registration.setCourseID(rs.getInt("courseID"));
                    registration.setPrice(rs.getDouble("price"));
                    registration.setStatus(rs.getString("status"));
                    registration.setProgress(rs.getInt("progress"));
                    registration.setValidFrom(rs.getTimestamp("validFrom"));
                    registration.setValidTo(rs.getTimestamp("validTo"));
                    registration.setCreatedAt(rs.getTimestamp("createdAt"));
                    registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

                    User user = new User();
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    registration.setUser(user);

                    Course course = new Course();
                    course.setCourseID(rs.getInt("courseID"));
                    course.setTitle(rs.getString("CourseTitle"));

                    registration.setCourse(course);

                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {

            e.printStackTrace();
        }
        return registrations;
    }

    public Registration getRegiistrationById(int registrationID) {
        String sql = "SELECT * FROM Registration WHERE registrationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registrationID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Registration registration = new Registration();
                    registration.setRegistrationID(rs.getInt("registrationID"));
                    registration.setUserID(rs.getInt("userID"));
                    registration.setCourseID(rs.getInt("courseID"));
                    registration.setPrice(rs.getDouble("price"));
                    registration.setStatus(rs.getString("status"));
                    registration.setProgress(rs.getInt("progress"));
                    registration.setValidFrom(rs.getTimestamp("validFrom"));
                    registration.setValidTo(rs.getTimestamp("validTo"));
                    registration.setCreatedAt(rs.getTimestamp("createdAt"));
                    registration.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    return registration;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Registration getRegistrationByIdWithCourse(int registrationID) {
        String sql = "SELECT r.*, c.Title AS CourseTitle, c.Description AS CourseDescription, a.fullname, a.email "
                + "FROM Registration r "
                + "JOIN Account a ON r.userID = a.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "WHERE r.registrationID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registrationID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Registration registration = new Registration();
                    registration.setRegistrationID(rs.getInt("registrationID"));
                    registration.setUserID(rs.getInt("userID"));
                    registration.setCourseID(rs.getInt("courseID"));
                    registration.setPrice(rs.getDouble("price"));
                    registration.setStatus(rs.getString("status"));
                    registration.setProgress(rs.getInt("progress"));
                    registration.setValidFrom(rs.getTimestamp("validFrom"));
                    registration.setValidTo(rs.getTimestamp("validTo"));
                    registration.setCreatedAt(rs.getTimestamp("createdAt"));
                    registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

                    User user = new User();
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    registration.setUser(user);

                    Course course = new Course();
                    course.setCourseID(rs.getInt("courseID"));
                    course.setTitle(rs.getString("CourseTitle"));
                    course.setDescription(rs.getString("CourseDescription"));
                    registration.setCourse(course);

                    return registration;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Registration> getAllofRegistration() {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, a.fullName , a.email , c.Title AS CourseTitle "
                + "FROM Registration r "
                + "JOIN Account a ON r.userID = a.userID "
                + "JOIN Course c ON r.courseID = c.courseID";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Registration registration = new Registration();
                registration.setRegistrationID(rs.getInt("registrationID"));
                registration.setUserID(rs.getInt("userID"));
                registration.setCourseID(rs.getInt("courseID"));
                registration.setPrice(rs.getDouble("price"));
                registration.setStatus(rs.getString("status"));
                registration.setProgress(rs.getInt("progress"));
                registration.setValidFrom(rs.getTimestamp("validFrom"));
                registration.setValidTo(rs.getTimestamp("validTo"));
                registration.setCreatedAt(rs.getTimestamp("createdAt"));
                registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

                User user = new User();

                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                registration.setUser(user);

                Course course = new Course();
                course.setTitle(rs.getString("CourseTitle"));
                registration.setCourse(course);

                registrations.add(registration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public void updateStatus(int registrationID, String newStatus) {
        String sql = "UPDATE Registration SET status = ?, updatedAt = GETDATE() WHERE registrationID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, registrationID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Registration> getRegistrationsPaginated(int currentPage, int recordsPerPage) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.fullName, u.email , c.Title AS CourseTitle "
                + "FROM Registration r "
                + "JOIN Account u ON r.userID = u.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "ORDER BY r.registrationID "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            int offset = (currentPage - 1) * recordsPerPage;
            stmt.setInt(1, offset);
            stmt.setInt(2, recordsPerPage);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = new Registration();
                    registration.setRegistrationID(rs.getInt("registrationID"));
                    registration.setUserID(rs.getInt("userID"));
                    registration.setCourseID(rs.getInt("courseID"));
                    registration.setPrice(rs.getDouble("price"));
                    registration.setStatus(rs.getString("status"));
                    registration.setProgress(rs.getInt("progress"));
                    registration.setValidFrom(rs.getTimestamp("validFrom"));
                    registration.setValidTo(rs.getTimestamp("validTo"));
                    registration.setCreatedAt(rs.getTimestamp("createdAt"));
                    registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

                    User user = new User();
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    registration.setUser(user);

                    Course course = new Course();
                    course.setTitle(rs.getString("CourseTitle"));
                    registration.setCourse(course);

                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public int getTotalRegistrations() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Registration";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Registration> searchByFullName(String fullname, String sortOrder) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, c.Title AS CourseTitle, a.fullName, a.email "
                + "FROM Registration r "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "JOIN Account a ON r.userID = a.userID "
                + "WHERE a.fullName LIKE ? "
                + "ORDER BY a.fullName " + ("desc".equals(sortOrder) ? "DESC" : "ASC");

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + fullname + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistrationFromResultSet(rs);
                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public List<Registration> searchByEmail(String email, String sortOrder) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, c.Title AS CourseTitle, a.fullName, a.email "
                + "FROM Registration r "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "JOIN Account a ON r.userID = a.userID "
                + "WHERE a.email LIKE ? "
                + "ORDER BY a.fullName " + ("desc".equals(sortOrder) ? "DESC" : "ASC");

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + email + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistrationFromResultSet(rs);
                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    private Registration mapRegistrationFromResultSet(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        registration.setRegistrationID(rs.getInt("registrationID"));
        registration.setUserID(rs.getInt("userID"));
        registration.setCourseID(rs.getInt("courseID"));
        registration.setPrice(rs.getDouble("price"));
        registration.setStatus(rs.getString("status"));
        registration.setProgress(rs.getInt("progress"));
        registration.setValidFrom(rs.getTimestamp("validFrom"));
        registration.setValidTo(rs.getTimestamp("validTo"));
        registration.setCreatedAt(rs.getTimestamp("createdAt"));
        registration.setUpdatedAt(rs.getTimestamp("updatedAt"));

        User user = new User();
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        registration.setUser(user);

        Course course = new Course();
        course.setCourseID(rs.getInt("courseID"));
        course.setTitle(rs.getString("CourseTitle"));
        registration.setCourse(course);

        return registration;
    }

    public int getNumberOfRegistrationByCourseId(int courseId) {
        String sql = "SELECT COUNT(r.RegistrationID) as NumOfRegister FROM Registration r "
                + "left join Course c on r.CourseID = c. CourseID WHERE c.CourseID = ?";
        int NumOfRegister = 0;
        try (Connection connection = new DBContext().getConnection()) {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                NumOfRegister = rs.getInt("NumOfRegister");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return NumOfRegister;
    }

    public List<int[]> getCourseIdsAndUserIds() {
        List<int[]> courseUserIds = new ArrayList<>();
        String sql = "SELECT userID, courseID FROM Registration";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                int userID = rs.getInt("userID");
                int courseID = rs.getInt("courseID");
                courseUserIds.add(new int[]{userID, courseID});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseUserIds;
    }
    
    public boolean isCourseRegisteredByUser(int userID, int courseID) {
    String sql = "SELECT COUNT(*) FROM Registration WHERE userID = ? AND courseID = ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userID);
        stmt.setInt(2, courseID);
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

    public List<Registration> getRegistrationsByStatus(String status) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, a.fullName, a.email, c.Title AS CourseTitle "
                + "FROM Registration r "
                + "JOIN Account a ON r.userID = a.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "WHERE r.status = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistrationFromResultSet(rs);
                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public int getTotalRegistrationsByStatus(String status) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Registration WHERE status = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Registration> getRecentRegistrations(int limit) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT TOP(?) r.*, a.fullName, a.email, c.Title AS CourseTitle "
                + "FROM Registration r "
                + "JOIN Account a ON r.userID = a.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "ORDER BY r.createdAt DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Registration registration = mapRegistrationFromResultSet(rs);
                    registrations.add(registration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    public List<Registration> getNewRegistrations(int days, int page, int recordsPerPage) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.fullName, u.email, c.title FROM Registration r "
                + "JOIN [User] u ON r.userID = u.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "WHERE r.createdAt >= DATEADD(day, ?, GETDATE()) "
                + "ORDER BY r.createdAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, -days);
            stmt.setInt(2, (page - 1) * recordsPerPage);
            stmt.setInt(3, recordsPerPage);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Registration registration = mapRegistrationFromResultSet(rs);
                registrations.add(registration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return registrations;
    }
    
    public int getTotalNewRegistrations(int days) {
        String sql = "SELECT COUNT(*) FROM Registration WHERE createdAt >= DATEADD(day, ?, GETDATE())";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, -days);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public List<Registration> searchNewRegistrationsByEmail(String email, int days, String sortOrder) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.fullName, u.email, c.title FROM Registration r "
                + "JOIN [User] u ON r.userID = u.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "WHERE u.email LIKE ? AND r.createdAt >= DATEADD(day, ?, GETDATE()) "
                + "ORDER BY r.createdAt " + (sortOrder != null && sortOrder.equalsIgnoreCase("asc") ? "ASC" : "DESC");
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + email + "%");
            stmt.setInt(2, -days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Registration registration = mapRegistrationFromResultSet(rs);
                registrations.add(registration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return registrations;
    }
    
    public List<Registration> searchNewRegistrationsByFullName(String fullName, int days, String sortOrder) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.fullName, u.email, c.title FROM Registration r "
                + "JOIN [User] u ON r.userID = u.userID "
                + "JOIN Course c ON r.courseID = c.courseID "
                + "WHERE u.fullName LIKE ? AND r.createdAt >= DATEADD(day, ?, GETDATE()) "
                + "ORDER BY r.createdAt " + (sortOrder != null && sortOrder.equalsIgnoreCase("asc") ? "ASC" : "DESC");
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + fullName + "%");
            stmt.setInt(2, -days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Registration registration = mapRegistrationFromResultSet(rs);
                registrations.add(registration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return registrations;
    }

    public int getNewRegistrationsCount(Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) FROM Registration WHERE createdAt BETWEEN ? AND ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public Map<String, Integer> getMonthlyRegistrationCounts() {
        Map<String, Integer> monthlyData = new HashMap<>();
        String sql = "SELECT FORMAT(createdAt, 'yyyy-MM') as month, COUNT(*) as count "
                + "FROM Registration "
                + "WHERE createdAt >= DATEADD(MONTH, -11, GETDATE()) "
                + "GROUP BY FORMAT(createdAt, 'yyyy-MM') "
                + "ORDER BY month";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String month = rs.getString("month");
                int count = rs.getInt("count");
                monthlyData.put(month, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return monthlyData;
    }

    /**
     * Get total number of students enrolled in an expert's courses
     * @param expertId The ID of the expert
     * @return Number of students
     */
    public int getTotalStudentsByExpert(int expertId) {
        int totalStudents = 0;
        String sql = "SELECT COUNT(DISTINCT r.UserID) AS TotalStudents " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalStudents = rs.getInt("TotalStudents");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total students by expert: " + e.getMessage());
        }
        
        return totalStudents;
    }
    
    /**
     * Get number of new students enrolled in an expert's courses within a date range
     * @param expertId The ID of the expert
     * @param startDate Start date
     * @param endDate End date
     * @return Number of new students
     */
    public int getNewStudentsByExpert(int expertId, Date startDate, Date endDate) {
        int newStudents = 0;
        String sql = "SELECT COUNT(DISTINCT r.UserID) AS NewStudents " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt BETWEEN ? AND ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ps.setTimestamp(2, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(3, new java.sql.Timestamp(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                newStudents = rs.getInt("NewStudents");
            }
        } catch (SQLException e) {
            System.out.println("Error getting new students by expert: " + e.getMessage());
        }
        
        return newStudents;
    }
    
    /**
     * Get total registrations by status for an expert's courses
     * @param expertId The ID of the expert
     * @param status The registration status
     * @return Number of registrations with the specified status
     */
    public int getTotalRegistrationsByExpertAndStatus(int expertId, String status) {
        int totalRegistrations = 0;
        String sql = "SELECT COUNT(*) AS TotalRegistrations " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.Status = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalRegistrations = rs.getInt("TotalRegistrations");
            }
        } catch (SQLException e) {
            System.out.println("Error getting total registrations by expert and status: " + e.getMessage());
        }
        
        return totalRegistrations;
    }
    
    /**
     * Get recent registrations for an expert's courses
     * @param expertId The ID of the expert
     * @param limit Number of registrations to retrieve
     * @return List of recent registrations
     */
    public List<Registration> getRecentRegistrationsByExpert(int expertId, int limit) {
        List<Registration> recentRegistrations = new ArrayList<>();
        String sql = "SELECT TOP(?) r.RegistrationID, r.UserID, r.CourseID, r.Status, r.Progress, r.CreatedAt, " +
                     "a.FullName AS StudentName, c.Title AS CourseTitle " +
                     "FROM Registration r " +
                     "JOIN Account a ON r.UserID = a.UserID " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? " +
                     "ORDER BY r.CreatedAt DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ps.setInt(2, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Registration registration = new Registration();
                registration.setRegistrationID(rs.getInt("RegistrationID"));
                registration.setUserID(rs.getInt("UserID"));
                registration.setCourseID(rs.getInt("CourseID"));
                registration.setStatus(rs.getString("Status"));
                registration.setProgress(rs.getInt("Progress"));
                registration.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional information
                User student = new User();
                student.setFullName(rs.getString("StudentName"));
                registration.setUser(student);
                
                Course course = new Course();
                course.setTitle(rs.getString("CourseTitle"));
                registration.setCourse(course);
                
                recentRegistrations.add(registration);
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent registrations by expert: " + e.getMessage());
        }
        
        return recentRegistrations;
    }
    
    /**
     * Get monthly registration counts for an expert's courses
     * @param expertId The ID of the expert
     * @return Map of month to registration count
     */
    public Map<String, Integer> getMonthlyRegistrationCountsByExpert(int expertId) {
        Map<String, Integer> monthlyRegistrations = new HashMap<>();
        String sql = "SELECT FORMAT(r.CreatedAt, 'yyyy-MM') as Month, COUNT(*) AS RegistrationCount " +
                     "FROM Registration r " +
                     "JOIN Course c ON r.CourseID = c.CourseID " +
                     "WHERE c.ExpertID = ? AND r.CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(r.CreatedAt, 'yyyy-MM') " +
                     "ORDER BY Month";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                int count = rs.getInt("RegistrationCount");
                monthlyRegistrations.put(month, count);
            }
        } catch (SQLException e) {
            System.out.println("Error getting monthly registration counts by expert: " + e.getMessage());
        }
        
        return monthlyRegistrations;
    }

    public static void main(String[] args) {
        RegistrationDAO regisDAO = new RegistrationDAO();
        boolean isRegistered = regisDAO.isCourseRegisteredByUser(2, 1);
        System.out.println(isRegistered);
    }
}
