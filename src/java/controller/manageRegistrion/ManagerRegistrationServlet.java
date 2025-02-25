    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */

    package controller.manageRegistrion;

    import DAO.RegistrationDAO;
    import java.io.IOException;
    import java.io.PrintWriter;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import java.util.List;
    import model.Registration;

    /**
     *
     * @author ducba
     */
    @WebServlet(name="ManagerRegistrationServlet", urlPatterns={"/ManagerRegistration"})
    public class ManagerRegistrationServlet extends HttpServlet {

        /** 
         * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
         * @param request servlet request
         * @param response servlet response
         * @throws ServletException if a servlet-specific error occurs
         * @throws IOException if an I/O error occurs
         */
        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Servlet ManagerRegistrationServlet</title>");  
                out.println("</head>");
                out.println("<body>");
                out.println("<h1>Servlet ManagerRegistrationServlet at " + request.getContextPath () + "</h1>");
                out.println("</body>");
                out.println("</html>");
            }
        } 

        // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
        /** 
         * Handles the HTTP <code>GET</code> method.
         * @param request servlet request
         * @param response servlet response
         * @throws ServletException if a servlet-specific error occurs
         * @throws IOException if an I/O error occurs
         */
         @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số trang hiện tại từ request, mặc định là trang 1 nếu không có
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

       
        int recordsPerPage = 5;

       
        RegistrationDAO registrationDAO = new RegistrationDAO();
        List<Registration> registrations = registrationDAO.getRegistrationsPaginated(currentPage, recordsPerPage);

       
        int totalRecords = registrationDAO.getTotalRegistrations();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        
        request.setAttribute("registrations", registrations);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward sang JSP
        request.getRequestDispatcher("managerRegistration.jsp").forward(request, response);
    }

        /** 
         * Handles the HTTP <code>POST</code> method.
         * @param request servlet request
         * @param response servlet response
         * @throws ServletException if a servlet-specific error occurs
         * @throws IOException if an I/O error occurs
         */
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
             
        }

        /** 
         * Returns a short description of the servlet.
         * @return a String containing servlet description
         */
        @Override
        public String getServletInfo() {
            return "Short description";
        }// </editor-fold>

    }
