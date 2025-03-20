package config;

import java.util.Base64;

public class Security {

    private static final String SECRET_KEY = "Vk3iY-+6e*de$s.";

    private Security() {
        throw new IllegalStateException("Utility class");
    }

    public static String encode(String input) {
        if (input == null) {
            throw new IllegalArgumentException("Input cannot be null");
        }
        return Base64.getEncoder().encodeToString((SECRET_KEY + input).getBytes());
    }

    public static String decode(String input) {
        byte[] s = Base64.getDecoder().decode(input);
        String code = new String(s);

        if (code.startsWith(SECRET_KEY)) {
            return code.substring(SECRET_KEY.length());
        }     
        return code;
    }
    
       public static String decode1(String encodedInput) {
        if (encodedInput == null || encodedInput.isEmpty()) {
            throw new IllegalArgumentException("Encoded input cannot be null or empty");
        }

        // Giải mã Base64
        byte[] decodedBytes = Base64.getDecoder().decode(encodedInput);
        String decodedString = new String(decodedBytes);

        // Kiểm tra xem chuỗi giải mã có chứa SECRET_KEY ở đầu không
        if (!decodedString.startsWith(SECRET_KEY)) {
            throw new IllegalArgumentException("Invalid encoded input: SECRET_KEY mismatch");
        }

        // Trả về phần input gốc (loại bỏ SECRET_KEY)
        return decodedString.substring(SECRET_KEY.length());
    }

}
