package controller;

import DAO.LoginDAO;
import DAO.OrderDAO;
import DAO.OrderItemDAO;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Order;
import model.OrderItem;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

/**
 *
 * @author VICTUS
 */
@WebServlet(name = "DownloadInvoice", urlPatterns = {"/download-invoice"})
public class DownloadInvoice extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/pdf");
        
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");
        
        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        
        if (userID == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/purchase");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            // Check if order exists, belongs to the current user, and is paid
            if (order == null || order.getAccountID() != Integer.parseInt(userID) || 
                    !order.getPaymentStatus().equalsIgnoreCase("paid")) {
                response.sendRedirect(request.getContextPath() + "/purchase");
                return;
            }
            
            // Get order items with detailed information
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsWithCourseDetails(orderId);
            order.setOrderItems(orderItems);
            
            // Get account details
            LoginDAO loginDAO = new LoginDAO();
            Account account = loginDAO.getAccountByUserID(userID);
            
            // Set response headers
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String fileName = "Invoice_" + orderId + "_" + sdf.format(order.getCreatedAt()) + ".pdf";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            
            // Generate PDF
            OutputStream out = response.getOutputStream();
            generateInvoicePDF(out, order, account, orderItems);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/purchase");
        } catch (SQLException | DocumentException e) {
            System.out.println("Error in DownloadInvoice: " + e.getMessage());
            request.setAttribute("error", "An error occurred while generating the invoice. Please try again later.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    private void generateInvoicePDF(OutputStream out, Order order, Account account, List<OrderItem> orderItems) 
            throws DocumentException {
        Document document = new Document();
        PdfWriter.getInstance(document, out);
        
        document.open();
        
        // Add title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("INVOICE", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph("\n"));
        
        // Add invoice details
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
        Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
        // Invoice information
        document.add(new Paragraph("Invoice Number: " + order.getOrderID(), boldFont));
        document.add(new Paragraph("Date: " + sdf.format(order.getCreatedAt()), normalFont));
        document.add(new Paragraph("Transaction ID: " + order.getVnpayTransactionID(), normalFont));
        document.add(new Paragraph("Payment Method: " + order.getPaymentMethod(), normalFont));
        document.add(new Paragraph("Payment Status: " + order.getPaymentStatus(), normalFont));
        document.add(new Paragraph("\n"));
        
        // Customer information
        document.add(new Paragraph("Customer Information", boldFont));
        document.add(new Paragraph("Name: " + account.getFullName(), normalFont));
        document.add(new Paragraph("Email: " + account.getEmail(), normalFont));
        document.add(new Paragraph("Phone: " + account.getPhone(), normalFont));
        document.add(new Paragraph("\n"));
        
        // Add items table
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[] {1, 3, 2, 2});
        
        // Add table header
        PdfPCell cell;
        
        cell = new PdfPCell(new Phrase("No.", boldFont));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        table.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Course Title", boldFont));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        table.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Instructor", boldFont));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        table.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Price", boldFont));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        table.addCell(cell);
        
        // Add table content
        for (int i = 0; i < orderItems.size(); i++) {
            OrderItem item = orderItems.get(i);
            
            cell = new PdfPCell(new Phrase(String.valueOf(i + 1), normalFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(5);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(item.getCourseTitle(), normalFont));
            cell.setPadding(5);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(item.getExpertName(), normalFont));
            cell.setPadding(5);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("$" + item.getOriginalPrice(), normalFont));
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setPadding(5);
            table.addCell(cell);
        }
        
        // Add total
        cell = new PdfPCell(new Phrase("Total:", boldFont));
        cell.setColspan(3);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell.setPadding(5);
        table.addCell(cell);
        
        cell = new PdfPCell(new Phrase("$" + order.getTotalAmount(), boldFont));
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell.setPadding(5);
        table.addCell(cell);
        
        document.add(table);
        document.add(new Paragraph("\n"));
        
        // Thank you note
        Paragraph thankYou = new Paragraph("Thank you for your purchase!", boldFont);
        thankYou.setAlignment(Element.ALIGN_CENTER);
        document.add(thankYou);
        
        // Terms and conditions
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("Terms and Conditions:", boldFont));
        document.add(new Paragraph("1. Courses are non-refundable once purchased.", normalFont));
        document.add(new Paragraph("2. You have lifetime access to the purchased courses.", normalFont));
        document.add(new Paragraph("3. For support, please contact support@onlinelearning.com", normalFont));
        
        document.close();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Download Invoice Servlet";
    }
}