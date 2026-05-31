package com.example.demo1.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "testdoan45@gmail.com";
    private static final String APP_PASSWORD = "fkfuewuathfuunmt";
    private static final String HOST_NAME = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    public static void sendOtpEmail(String toEmail, String otp) {
        sendHtmlEmail(toEmail, "Mã OTP xác thực tài khoản TechNova",
                "<h1>Chào mừng bạn đến với TechNova!</h1>"
                        + "<p>Mã OTP để kích hoạt tài khoản của bạn là:</p>"
                        + "<h2 style='color: #ff4e00; font-size: 24px;'>" + otp + "</h2>"
                        + "<p>Mã này sẽ hết hạn sau 2 phút.</p>"
                        + "<p>Trân trọng,<br>Đội ngũ TechNova</p>");
    }

    public static void sendContactResponseEmail(String toEmail, String customerName, String originalContent, String responseContent) {
        String safeName = escapeHtml(customerName == null || customerName.trim().isEmpty() ? "bạn" : customerName.trim());
        String safeOriginalContent = escapeHtml(originalContent == null ? "" : originalContent.trim()).replace("\n", "<br>");
        String safeResponseContent = escapeHtml(responseContent == null ? "" : responseContent.trim()).replace("\n", "<br>");

        String emailContent = "<h2>TechNova đã phản hồi liên hệ của bạn</h2>"
                + "<p>Xin chào <strong>" + safeName + "</strong>,</p>"
                + "<p>Chúng tôi đã nhận được nội dung liên hệ của bạn:</p>"
                + "<blockquote style='margin: 16px 0; padding: 12px 16px; background: #f8fafc; border-left: 4px solid #5b86e5;'>"
                + safeOriginalContent
                + "</blockquote>"
                + "<p>Nội dung phản hồi từ TechNova:</p>"
                + "<div style='margin: 16px 0; padding: 12px 16px; background: #eff6ff; border-radius: 8px; line-height: 1.7;'>"
                + safeResponseContent
                + "</div>"
                + "<p>Trân trọng,<br>Đội ngũ TechNova</p>";

        sendHtmlEmail(toEmail, "Phản hồi liên hệ từ TechNova", emailContent);
    }

    public static void sendAdminCreatedAccountEmail(String toEmail, String customerName, String password) {
        String safeName = escapeHtml(customerName == null || customerName.trim().isEmpty() ? "bạn" : customerName.trim());
        String safeEmail = escapeHtml(toEmail == null ? "" : toEmail.trim());
        String safePassword = escapeHtml(password == null ? "" : password);

        String emailContent = "<h2>Tài khoản TechNova của bạn đã được tạo</h2>"
                + "<p>Xin chào <strong>" + safeName + "</strong>,</p>"
                + "<p>TechNova đã tạo tài khoản khách hàng cho bạn. Bạn có thể đăng nhập bằng thông tin sau:</p>"
                + "<div style='margin: 16px 0; padding: 12px 16px; background: #eff6ff; border-radius: 8px; line-height: 1.7;'>"
                + "<p><strong>Email:</strong> " + safeEmail + "</p>"
                + "<p><strong>Mật khẩu:</strong> " + safePassword + "</p>"
                + "</div>"
                + "<p>Vui lòng đăng nhập và đổi mật khẩu để bảo mật tài khoản.</p>"
                + "<p>Trân trọng,<br>Đội ngũ TechNova</p>";

        sendHtmlEmail(toEmail, "Thông tin tài khoản TechNova của bạn", emailContent);
    }

    private static String escapeHtml(String value) {
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private static void sendHtmlEmail(String toEmail, String subject, String emailContent) {
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST_NAME);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);
            message.setContent(emailContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email đã được gửi thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Gửi email thất bại", e);
        }
    }
}
