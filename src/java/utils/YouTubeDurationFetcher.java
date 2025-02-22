/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.JSONObject;

public class YouTubeDurationFetcher {

    // Thay YOUR_API_KEY bằng API key của bạn
    private static final String API_KEY = "AIzaSyDQj-MvuAKq4sL9LXF0LMYm8_r4IV5iQ2s";

    // Lấy thời lượng video tính bằng phút từ URL của YouTube
    public static int getVideoDurationInMinutesFromUrl(String videoUrl) {
        String videoId = extractVideoId(videoUrl);
        if (videoId == null || videoId.isEmpty()) {
            System.out.println("Không thể trích xuất videoId từ URL.");
            return -1;
        }
        return getVideoDurationInMinutes(videoId);
    }

    // Lấy thời lượng video từ YouTube Data API dựa trên videoId và trả về số phút
    public static int getVideoDurationInMinutes(String videoId) {
        String urlString = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id="
                + videoId + "&key=" + API_KEY;
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Phân tích dữ liệu JSON trả về
            JSONObject json = new JSONObject(response.toString());
            if (json.getJSONArray("items").length() > 0) {
                JSONObject contentDetails = json.getJSONArray("items")
                        .getJSONObject(0)
                        .getJSONObject("contentDetails");
                // Lấy duration ở định dạng ISO 8601, ví dụ: "PT15M33S"
                String isoDuration = contentDetails.getString("duration");
                // Chuyển đổi sang số phút (int)
                return convertDurationToMinutes(isoDuration);
            } else {
                System.out.println("Không tìm thấy video.");
                return -1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // Chuyển đổi chuỗi duration ISO 8601 sang số phút (int)
    public static int convertDurationToMinutes(String isoDuration) {
        int hours = 0, minutes = 0, seconds = 0;
        // Sử dụng regex để lấy các giá trị giờ, phút, giây
        Pattern pattern = Pattern.compile("PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?");
        Matcher matcher = pattern.matcher(isoDuration);
        if (matcher.matches()) {
            if (matcher.group(1) != null) {
                hours = Integer.parseInt(matcher.group(1));
            }
            if (matcher.group(2) != null) {
                minutes = Integer.parseInt(matcher.group(2));
            }
            if (matcher.group(3) != null) {
                seconds = Integer.parseInt(matcher.group(3));
            }
        }
        // Tính tổng số giây
        int totalSeconds = hours * 3600 + minutes * 60 + seconds;
        // Chuyển đổi thành số phút (lấy phần nguyên)
        return totalSeconds / 60;
    }

    // Phương thức tách videoId từ URL của YouTube
    public static String extractVideoId(String videoUrl) {
        try {
            URL url = new URL(videoUrl);
            String query = url.getQuery(); // lấy phần query sau dấu ?
            Map<String, String> params = splitQuery(query);
            // Thông thường, videoId nằm trong tham số "v"
            return params.get("v");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Chuyển đổi query string thành Map
    public static Map<String, String> splitQuery(String query) throws Exception {
        Map<String, String> queryPairs = new HashMap<>();
        String[] pairs = query.split("&");
        for (String pair : pairs) {
            int idx = pair.indexOf("=");
            String key = URLDecoder.decode(pair.substring(0, idx), StandardCharsets.UTF_8.name());
            String value = URLDecoder.decode(pair.substring(idx + 1), StandardCharsets.UTF_8.name());
            queryPairs.put(key, value);
        }
        return queryPairs;
    }

    public static void main(String[] args) {
        // URL của video YouTube
        String videoUrl = "https://www.youtube.com/watch?v=msnHQ3DraYU";
        int durationMinutes = getVideoDurationInMinutesFromUrl(videoUrl);
        if (durationMinutes != -1) {
            System.out.println("Thời lượng video (phút): " + durationMinutes);
        }
    }
}
