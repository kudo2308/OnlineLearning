/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBContext.DBContext;
import static constant.Constant.RECORD_PER_PAGE;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Lesson;
import model.Packages;

/**
 *
 * @author PC
 */
public class PackagesDAO {

    private PreparedStatement ps;
    private ResultSet rs;
    private Connection connection;
    private List<Packages> packages;

    public PackagesDAO() {
        packages = new ArrayList<>();
        if (connection == null) {
            connection = new DBContext().getConnection();
        }
    }

    public List<Packages> findByPageFilterCourseAndStatus(Integer page,
            Boolean statusRequest, Integer courseId, int expert) {
        List<Packages> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("select p.* from Packages p"
                + " left join [Course] c on p.CourseID = c.CourseID where  ((? is null and c.ExpertID = ?) or p.CourseID = ?) and (? is null or p.[Status] = ?)");
        if (page != null) {
            sql.append("ORDER BY p.PackageID desc ")
                    .append("OFFSET ? ROWS ")
                    .append("FETCH NEXT ? ROWS ONLY");
        }

        try (Connection connection = new DBContext().getConnection()) {
            ps = connection.prepareStatement(sql.toString());
            ps.setObject(1, courseId);
            ps.setObject(2, expert);
            ps.setObject(3, courseId);
            ps.setObject(4, statusRequest);
            ps.setObject(5, statusRequest);
            if (page != null) {
                ps.setInt(6, (page - 1) * RECORD_PER_PAGE);
                ps.setInt(7, RECORD_PER_PAGE);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Packages p = Packages.builder()
                        .packageID(rs.getInt("PackageID"))
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .updatedAt(rs.getTimestamp("updatedAt"))
                        .Status(rs.getBoolean("Status"))
                        .build();
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Packages> findPackagesByCourseId(int courseId) {
        List<Packages> packageList = new ArrayList<>();
        String sql = "SELECT * FROM Packages WHERE CourseID = ?";

        try {
            Connection conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(courseId);

                Packages p = Packages.builder()
                        .packageID(rs.getInt("PackageID"))
                        .course(course)
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .updatedAt(rs.getTimestamp("updatedAt"))
                        .Status(rs.getBoolean("Status"))
                        .build();
                packageList.add(p);
            }
            
            // Close resources
            rs.close();
            ps.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return packageList;
    }

    public List<Packages> findAllPackages() {
        String sql = "select * from Packages p";

        try {
            ps = connection.prepareStatement(sql);

            rs = ps.executeQuery();
            while (rs.next()) {

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));

                Packages p = Packages.builder()
                        .packageID(rs.getInt("PackageID"))
                        .course(course)
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .updatedAt(rs.getTimestamp("updatedAt"))
                        .Status(rs.getBoolean("Status"))
                        .build();
                packages.add(p);

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return packages;
    }

    public Packages findPackageById(int id) {
        String sql = "select * from Packages p\n"
                + "where p.PackageID = ?";
        Packages p = null;
        try {
            ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next()) {

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));

                p = Packages.builder()
                        .packageID(rs.getInt("PackageID"))
                        .course(course)
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .updatedAt(rs.getTimestamp("updatedAt"))
                        .Status(rs.getBoolean("Status"))
                        .build();

                return p;

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<Packages> findPackageByExpert(int expertId) {
        List<Packages> psList = new ArrayList<>();
        String sql = "select p.* from Packages p\n"
                + "left join Course c on p.CourseID = c.CourseID\n"
                + "where c.ExpertID = ?";
        Packages p = null;
        try {
            ps = connection.prepareStatement(sql);

            ps.setInt(1, expertId);

            rs = ps.executeQuery();
            while (rs.next()) {

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));

                p = Packages.builder()
                        .packageID(rs.getInt("PackageID"))
                        .course(course)
                        .name(rs.getString("Name"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .updatedAt(rs.getTimestamp("updatedAt"))
                        .Status(rs.getBoolean("Status"))
                        .build();

                psList.add(p);

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return psList;
    }

    public boolean addPackage(Packages p) {
        String sql = "INSERT INTO [dbo].[Packages]\n"
                + "           ([Name]\n"
                + "      ,[Description]\n"
                + "      ,[CourseID]\n"
                + "      ,[Status]\n"
                + "      ,[CreatedAt])\n"
                + "     VALUES\n"
                + "           (?,?,?,?,GETDATE())";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getCourse().getCourseID());
            ps.setBoolean(4, p.isStatus());
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    public boolean updatePackage(Packages p) {
        String sql = "UPDATE [dbo].[Packages]\n"
                + "           set [Name] = ?\n"
                + "      ,[Description] = ?\n"
                + "      ,[CourseID] = ?\n"
                + "      ,[Status] = ?\n"
                + "      ,[UpdatedAt] = GETDATE()\n"
                + "    where [PackageID] = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getCourse().getCourseID());
            ps.setBoolean(4, p.isStatus());
            ps.setInt(5, p.getPackageID());
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    public static void main(String[] args) {
        PackagesDAO pack = new PackagesDAO();
        System.out.println(pack.findPackageById(1));
    }

}
