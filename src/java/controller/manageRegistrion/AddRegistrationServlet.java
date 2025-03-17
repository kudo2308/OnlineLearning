///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package controller.manageRegistrion;
//
//import DAO.CourseDAO;
//import DAO.RegistrationDAO;
//import DAO.UserDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//
//import java.sql.Timestamp;
//import model.Course;
//import model.Registration;
//import model.User;
//
///**
// *
// * @author ducba
// */
//@WebServlet(name="AddRegistrationServlet", urlPatterns={"/AddRegistration"})
//public class AddRegistrationServlet extends HttpServlet {
//   
//    /** 
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet AddRegistrationServlet</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet AddRegistrationServlet at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    } 
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /** 
//     * Handles the HTTP <code>GET</code> method.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//     private RegistrationDAO registrationDAO;
//    private UserDAO userDAO;
//    private CourseDAO courseDAO;
//
//    @Override
//    public void init() {
//        registrationDAO = new RegistrationDAO();
//        userDAO = new UserDAO();
//        courseDAO = new CourseDAO();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Lấy danh sách khóa học để hiển thị trong dropdown
//        List<Course> courses = courseDAO.getAllCourses();
//        request.setAttribute("courses", courses);
//        request.getRequestDispatcher("/add-registration.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String email = request.getParameter("email");
//        int courseID = Integer.parseInt(request.getParameter("courseID"));
//        String status = "active"; 
//
//      
//        User user = userDAO.getUserByEmail(email);
//        if (user == null) {
//            request.setAttribute("error", "Email does not exist!.");
//            List<Course> courses = courseDAO.getAllCourses();
//            request.setAttribute("courses", courses);
//            request.getRequestDispatcher("/add-registration.jsp").forward(request, response);
//            return;
//        }
//
//        
//        Course course = courseDAO.getCourseById(courseID);
//        if (course == null) {
//            request.setAttribute("error", "Course does not exist!");
//            List<Course> courses = courseDAO.getAllCourses();
//            request.setAttribute("courses", courses);
//            request.getRequestDispatcher("/add-registration.jsp").forward(request, response);
//            return;
//        }
//
//      
//        Registration registration = new Registration();
//        registration.setUserID(user.getUserID());
//        registration.setCourseID(courseID);
//        registration.setPrice(course.getPrice());
//        registration.setStatus(status);
//        registration.setProgress(0); 
//        registration.setProgress(0); // Default progress is 0
//        registration.setValidFrom(new Timestamp(System.currentTimeMillis()));
//        registration.setValidTo(new Timestamp(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000)); // Valid for 30 days
//        registration.setCreatedAt(new Timestamp(System.currentTimeMillis()));
//        registration.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
//
//
//        
//        registrationDAO.addRegistration(registration);
//        response.sendRedirect("ManagerRegistration");
//    }
//
//    /** 
//     * Returns a short description of the servlet.
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
