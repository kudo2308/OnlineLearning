/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package constant;

/**
 *
 * @author VICTUS
 */
public class Iconstant {

    private Iconstant() {
        throw new IllegalStateException("Utility class");
    }

    public static final String GOOGLE_CLIENT_ID = "847733471444-6gh1cs98e3j6furm5rbjiarevghabvej.apps.googleusercontent.com";

    public static final String GOOGLE_CLIENT_SECRET = "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";

    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/SWP_OLSver1/Logingooglehandler";

    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

}
