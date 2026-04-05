package com.example.demo1.controller;

import com.example.demo1.service.AuthService;
import com.example.demo1.service.EmailService;
import com.example.demo1.service.OtpService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet(name = "ResendOtpServlet", value = "/resend-otp")
public class ResendOtpServlet extends HttpServlet {

    private static final long OTP_RESEND_COOLDOWN = 60 * 1000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email_for_verification");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        Long lastSendTime = (Long) session.getAttribute("last_otp_send_time");
        long currentTime = System.currentTimeMillis();

        if (lastSendTime != null && (currentTime - lastSendTime < OTP_RESEND_COOLDOWN)) {
            long timeLeft = (OTP_RESEND_COOLDOWN - (currentTime - lastSendTime)) / 1000;
            session.setAttribute("resend_error", "Vui lòng đợi " + timeLeft + " giây nữa để gửi lại mã.");
            response.sendRedirect(request.getContextPath() + "/verify");
            return;
        }

        AuthService authService = new AuthService();
        
        String otp = OtpService.generateOtp();
        Timestamp otpExpiry = OtpService.getOtpExpiryTime();
        authService.updateOtpForUser(email, otp, otpExpiry);

        try {
            EmailService.sendOtpEmail(email, otp);
            session.setAttribute("resend_success", "Mã OTP mới đã được gửi thành công!");

            session.setAttribute("last_otp_send_time", currentTime);
        } catch (Exception e) {
            session.setAttribute("resend_error", "Không thể gửi lại mã OTP vào lúc này.");
        }

        response.sendRedirect(request.getContextPath() + "/verify");
    }
}
