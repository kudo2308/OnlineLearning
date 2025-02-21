package config;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;

public class Json {
     public void sendJsonResponse(HttpServletResponse response, String status, String message, int time) throws IOException {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("status", status);
        jsonResponse.put("message", message);
        jsonResponse.put("time", time);
         PrintWriter out =  response.getWriter();
         out.print(jsonResponse.toString());
         out.flush();
    }
}
