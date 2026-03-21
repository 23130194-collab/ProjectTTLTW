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
            message.setSubject("Mã OTP xác thực tài khoản TechNova");

            String emailContent = "<h1>Chào mừng bạn đến với TechNova!</h1>"
                                + "<p>Mã OTP để kích hoạt tài khoản của bạn là:</p>"
                                + "<h2 style='color: #ff4e00; font-size: 24px;'>" + otp + "</h2>"
                                + "<p>Mã này sẽ hết hạn sau 2 phút.</p>"
                                + "<p>Trân trọng,<br>Đội ngũ TechNova</p>";
            
            message.setContent(emailContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email OTP đã được gửi thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Gửi email thất bại", e);
        }
    }
}
