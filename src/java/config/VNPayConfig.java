package config;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;

public class VNPayConfig {

    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:8080/SWP_OLSver1/vnpay_return";
    public static String vnp_TmnCode = "D2LK05I5";
    public static String secretKey = "HA0EJ17DWUY8C69KT0FS5KS41JQCNSBE";
    public static String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    // ✅ Tạo chữ ký HMAC-SHA512 chuẩn
    public static String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString().toUpperCase(); // VNPay yêu cầu chữ HOA
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new RuntimeException(e);
        }
    }

    // ✅ Tạo URL thanh toán VNPay
    public static String generatePaymentUrl(String vnpUrl, Map<String, String> params, String secretKey) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames); // Sắp xếp tham số theo alphabet

        StringBuilder query = new StringBuilder();
        StringBuilder hashData = new StringBuilder();

        for (String fieldName : fieldNames) {
            String value = params.get(fieldName);
            if (value != null && !value.isEmpty()) {
                hashData.append(fieldName).append("=").append(value).append("&"); // Không encode khi hash
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8))
                        .append("=")
                        .append(URLEncoder.encode(value, StandardCharsets.UTF_8))
                        .append("&");
            }
        }
        // Bỏ ký tự & cuối cùng trước khi hash
        String rawHash = hashData.substring(0, hashData.length() - 1);
        String queryString = query.substring(0, query.length() - 1);

          // ✅ FIX: In ra dữ liệu trước khi hash để debug
        System.out.println("🔹 Chuỗi hashData trước khi hash: " + rawHash);
        System.out.println("🔹 Secret Key: " + secretKey);

        // ✅ FIX: Tạo SecureHash bằng SHA-512 chuẩn
        String secureHash = hmacSHA512(secretKey, rawHash);

        return vnpUrl + "?" + queryString + "&vnp_SecureHash=" + secureHash;
    }
}
