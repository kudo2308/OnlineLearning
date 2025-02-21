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
        if (code.substring(0, 3).compareTo(SECRET_KEY) == 0) {
            return code.substring(3);
        }
        return code;
    }

}
