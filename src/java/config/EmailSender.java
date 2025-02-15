package config;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailSender {
    
    private EmailSender() {
        throw new IllegalStateException("Utility class");
    }

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "baonguyenvothai@gmail.com"; // Thay bằng email của bạn
    private static final String EMAIL_PASSWORD = "bfizpppzlpawkezb"; // Mật khẩu ứng dụng Gmail

    public static void sendOTP(String toEmail,String fullname, int otp) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST); 

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Online Learning Login: Here's the 6-digit verification code you requested");
             String htmlContent = "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "<meta charset=\"UTF-8\" />\n" +
                "<title>Online Learning OTP</title>\n" +
                "<style>\n" +
                "body { margin: 0; padding: 0; font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif; color: #333; background-color: #fff; }\n" +
                ".container { margin: 0 auto; width: 100%; max-width: 600px; padding: 0 0px; padding-bottom: 10px; border-radius: 5px; line-height: 1.8; }\n" +
                ".header { border-bottom: 1px solid #eee; }\n" +
                ".header a { font-size: 1.4em; color: #000; text-decoration: none; font-weight: 600; }\n" +
                ".content { min-width: 700px; overflow: auto; line-height: 2; }\n" +
                ".otp { background: linear-gradient(to right, #00bc69 0, #00bc88 50%, #00bca8 100%); margin: 0 auto; width: max-content; padding: 0 10px; color: #fff; border-radius: 4px; }\n" +
                ".footer { color: #aaa; font-size: 0.8em; line-height: 1; font-weight: 300; }\n" +
                ".email-info { color: #666666; font-weight: 400; font-size: 13px; line-height: 18px; padding-bottom: 6px; }\n" +
                ".email-info a { text-decoration: none; color: #00bc69; }\n" +
                "</style>\n" +
                "</head>\n" +
                "<body>\n" +
                "<div class=\"container\">\n" +
                "<div class=\"header\">\n" +
                "<a>Online Learning</a>\n" +
                "</div>\n" +
                "<br />\n" +
                "<strong>Dear " + fullname + "</strong>\n" +
                "<p>Use the code below to log in to your Online Learning account.</p>\n" +
                "<p><b>Your One-Time Password (OTP) verification code is:</b></p>\n" +
                "<h2 class=\"otp\">" + otp + "</h2>\n" +
                "<p style=\"font-size: 0.9em\">\n" +
                "<strong>One-Time Password (OTP) is valid for 3 minutes.</strong>\n" +
                "<br /><br />\n" +
                "If you did not initiate this login request, please disregard this message. Please ensure the confidentiality of your OTP and do not share it with anyone.<br />\n" +
                "<strong>Do not forward or give this code to anyone.</strong>\n" +
                "<br /><br />\n" +
                "<strong>Thank you for using Online Learning.</strong>\n" +
                "<br /><br />\n" +
                "</p>\n" +
                "<hr style=\"border: none; border-top: 0.5px solid #131111\" />\n" +
                "<div class=\"footer\">\n" +
                "<p>This email can't receive replies.</p>\n" +
                "<p>For more information about Online Learning and your account, visit <strong>Contact us</strong></p>\n" +
                "</div>\n" +
                "</div>\n" +
                "</body>\n" +
                "</html>";

            message.setContent(htmlContent,"text/html");
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace(); 
        }
    }
}
