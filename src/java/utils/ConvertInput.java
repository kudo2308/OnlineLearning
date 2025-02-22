/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author PC
 */
public class ConvertInput {

    public static String convertToEmbedURL(String videoURL) {
        try {
            java.net.URL url = new java.net.URL(videoURL);
            String host = url.getHost();
            String path = url.getPath();
            String query = url.getQuery();

            if (host.contains("youtube.com") && query != null) {
                // URL dạng dài: youtube.com/watch?v=...
                String[] queryParams = query.split("&");
                for (String param : queryParams) {
                    if (param.startsWith("v=")) {
                        String videoId = param.substring(2);
                        return "https://www.youtube.com/embed/" + videoId;
                    }
                }
            } else if (host.contains("youtu.be")) {
                // URL dạng ngắn: youtu.be/...
                String[] pathSegments = path.split("/");
                if (pathSegments.length > 1) {
                    String videoId = pathSegments[1];
                    return "https://www.youtube.com/embed/" + videoId;
                }
            }

            // Nếu không tìm thấy ID, trả về URL ban đầu
            return videoURL;
        } catch (java.net.MalformedURLException e) {
            System.err.println("Lỗi chuyển đổi URL: " + e.getMessage());
            return videoURL;
        }
    }
}
