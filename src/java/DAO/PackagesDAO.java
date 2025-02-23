/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;


import DBContext.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
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

    public List<Packages> findPackagesByCourseId(int courseId) {
        String sql = "select * from Packages p\n"
                + "where p.CourseID = ?";

        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
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
                        .isDelete(rs.getBoolean("isDelete"))
                        .build();
                packages.add(p);

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return packages;
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
                        .isDelete(rs.getBoolean("isDelete"))
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
                        .isDelete(rs.getBoolean("isDelete"))
                        .build();

                return p;

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public static void main(String[] args) {
        PackagesDAO pack = new PackagesDAO();
        System.out.println(pack.findPackageById(1));
    }

}
