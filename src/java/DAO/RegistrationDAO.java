/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import java.util.List;
import model.Registration;
import java.sql.*;
import java.util.ArrayList;
import model.Course;
import model.User;

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

    public static void main(String[] args) {
        RegistrationDAO regisDAO = new RegistrationDAO();
        boolean isRegistered = regisDAO.isCourseRegisteredByUser(2, 1);
        System.out.println(isRegistered);
    }
}
