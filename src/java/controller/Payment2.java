package controller;


import DAO.PaymentDAO;
import config.VNPayConfig;
import static config.VNPayConfig.hmacSHA512;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



@WebServlet(name = "Payment2", urlPatterns = {"/payment2"})
public class Payment2 extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }
        
        String totalStr = request.getParameter("amount");
        double total = Double.parseDouble(request.getParameter("amount"));
        String CourseId = request.getParameter("course");
        int courseId = Integer.parseInt(CourseId);
        String ExpertId = request.getParameter("expertId");
        int expertId = Integer.parseInt(ExpertId);
        
        // Tạo đơn hàng   Done
        PaymentDAO paymentDAO = new PaymentDAO();
        paymentDAO.createOrder(Integer.parseInt(userID), BigDecimal.valueOf(total));
        int maxorder = paymentDAO.getMaxOrderId();
        // Thêm các order item vào đơn hàng  
        paymentDAO.createOrderItem(maxorder, courseId, expertId, BigDecimal.valueOf(total));
        session.setAttribute("courseId", courseId);
        session.setAttribute("maxorder", maxorder);
       
        
        int amount = (int) Double.parseDouble(request.getParameter("amount"));
         session.setAttribute("total", amount);
        
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
        String vnp_OrderInfo = "Order Payment OnlineLearn";
        String orderType = "pay online";
        String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

        // ✅ FIX: Chuyển IP localhost IPv6 thành IPv4
        String vnp_IpAddr = request.getRemoteAddr();
        if ("0:0:0:0:0:0:0:1".equals(vnp_IpAddr)) {
            vnp_IpAddr = "127.0.0.1";
        }

        // ✅ Fix: Đúng thứ tự tham số & không encode trước khi hash
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(new Date());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        Calendar cld = Calendar.getInstance();
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // ✅ FIX: Sắp xếp tham số theo đúng thứ tự
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                // ✅ FIX: Loại bỏ khoảng trắng (replace " " với "%20")
                String safeValue = fieldValue.replace(" ", "+");

                if (fieldName.equals("vnp_ReturnUrl")) {
                    safeValue = URLEncoder.encode(safeValue, StandardCharsets.UTF_8);
                } else {
                    safeValue = safeValue.replace(" ", "+");
                }
                hashData.append(fieldName).append('=').append(safeValue).append('&');

                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8))
                        .append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8))
                        .append('&');
            }
        }

        hashData.deleteCharAt(hashData.length() - 1);
        query.deleteCharAt(query.length() - 1);


        String vnp_SecureHash = hmacSHA512(VNPayConfig.secretKey, hashData.toString());

        query.append("&vnp_SecureHash=").append(vnp_SecureHash);

        String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query.toString();


        response.sendRedirect(paymentUrl);
    }
}
