/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.net.HttpURLConnection;
import java.net.URL;

/**
 *
 * @author PC
 */
public class ValidateInput {

    public static boolean isYouTubeLinkActive(String url) {
        try {
            URL link = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) link.openConnection();
            connection.setRequestMethod("HEAD");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            int responseCode = connection.getResponseCode();

            return (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_MOVED_TEMP);
        } catch (Exception e) {
            return false;
        }
    }

    public static void main(String[] args) {
        String youtubeLink = "";
        boolean isActive = isYouTubeLinkActive(youtubeLink);
        System.out.println("Link YouTube hợp lệ: " + isActive);
    }
}
