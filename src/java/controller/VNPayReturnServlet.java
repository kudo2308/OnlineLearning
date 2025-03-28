package controller;

import DAO.CourseDAO;
import DAO.ExpertWalletDAO;
import DAO.LoginDAO;
import DAO.NotificationDAO;
import DAO.PaymentDAO;
import DAO.WalletTransactionDAO;
import config.VNPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import model.Account;
import model.OrderItem;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay_return"})
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Thu thập tất cả tham số từ request
        Map<String, String> vnp_Params = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String key = params.nextElement();
            vnp_Params.put(key, request.getParameter(key));
        }

        vnp_Params.remove("vnp_SecureHash");
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames); // Sắp xếp alphabet

        StringBuilder hashData = new StringBuilder();
        for (String fieldName : fieldNames) {
            String value = vnp_Params.get(fieldName);
            if (value != null && !value.isEmpty()) {
                hashData.append(fieldName).append("=").append(value).append("&");
            }
        }

        // ✅ Xóa dấu `&` cuối cùng nếu có
        if (hashData.length() > 0) {
            hashData.deleteCharAt(hashData.length() - 1);
        }
        String vnp_TransactionNo = vnp_Params.get("vnp_TransactionNo");
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
        LoginDAO dao1 = new LoginDAO();
        Account acc = dao1.getAccountByUserID(userID);
        int maxorder = (int) session.getAttribute("maxorder");
        int total = (int) session.getAttribute("total");
        int courseId = (int) session.getAttribute("courseId");
        PaymentDAO dao = new PaymentDAO();
        WalletTransactionDAO d = new WalletTransactionDAO();
        if (vnp_Params.get("vnp_TransactionStatus").equalsIgnoreCase("00")) {
            dao.updateOrder(maxorder, "paid", vnp_TransactionNo);
           List<OrderItem> ListCourseId = dao.getCourseItem(maxorder);
            for (OrderItem list : ListCourseId) {
                 dao.createRegistration(Integer.parseInt(userID), list.getCourseId(), list.getOriginalPrice());
            }
            d.createTransaction(BigDecimal.valueOf(total), "deposit", vnp_TransactionNo, "User "+acc.getFullName()+" transfers into the system", Integer.parseInt(userID) ,1, maxorder, null, "completed");
            d.updateBalance(BigDecimal.valueOf(total));
            // tạo thông báo expert gửi user tại đây 
            NotificationDAO notificationDAO = new NotificationDAO();
            LoginDAO accountDAO = new LoginDAO();
            CourseDAO courseDAO = new CourseDAO();
            ExpertWalletDAO expertWalletDAO = new ExpertWalletDAO();
            List<String> orderItem = dao.getOrderNamesByOrderId(maxorder);
            List<Integer> expertId = dao.getOrderItemExpertId(maxorder);
            List<BigDecimal> moneyPay = dao.getMoneyPayExpert(maxorder);
            NotificationService notificationService = new NotificationService(notificationDAO, accountDAO, dao, courseDAO);
            for (String item : orderItem) {
                String title = "Course " + item + " Registration Successful";
                String content = "Your payment has been processed successfully. You are now enrolled in the courses. Please check your dashboard to start learning.";
                String type = "fee";
                notificationService.sendToUser(Integer.parseInt(userID), title, content, type, maxorder , null);
            }
            for (int i = 0; i < expertId.size(); i++) {
                String title = "User " + acc.getFullName() + " Register Course";
                String content = "Your " + orderItem.get(i) + " was registered check or notify with new Student ";
                String type = "system";
                notificationService.sendToUser(expertId.get(i), title, content, type, maxorder, "notifications");
                if (dao.hasRegisteredBankAccount(expertId.get(i))) {
                    expertWalletDAO.addToWalletBalance(expertId.get(i), moneyPay.get(i).doubleValue());
                    String title1 = "Account balance fluctuations";
                    String content1 = "You just received "+ moneyPay.get(i) + " check your wallet";
                    String type1 = "wallet";
                    notificationService.sendToUser(expertId.get(i), title1, content1, type1, expertId.get(i), "wallet"); // lịch sử nhận tiền 
                } else {
                    expertWalletDAO.createExpertBankInfo(expertId.get(i));
                    expertWalletDAO.addToWalletBalance(expertId.get(i), moneyPay.get(i).doubleValue());
                    String title1 = "Account balance fluctuations";
                    String content1 = "You just received "+moneyPay.get(i) + " check your wallet";
                    String type1 = "wallet";
                    notificationService.sendToUser(expertId.get(i), title1, content1, type1, expertId.get(i), "wallet"); // lịch sử nhận tiền 
                }
            }
           if(orderItem != null){
            String linkCourse = "coursedetail?courseId="+courseId+"&success=You registration course successfully !";
            response.sendRedirect(linkCourse);
           }else{
            response.sendRedirect("cart?success=You registration course successfully !");
           }
        } else {
            dao.updateOrder(maxorder, "failed", vnp_TransactionNo);
            response.sendRedirect("cart?error=You registration course fail !");
        }
    }
}
