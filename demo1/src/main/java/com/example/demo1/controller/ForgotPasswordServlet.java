package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.AuthService;
import com.example.demo1.service.EmailService;
import com.example.demo1.service.OtpService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        AuthService authService = new AuthService();
        User user = authService.getUserByEmail(email);

        request.setAttribute("emailValue", email); 

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("/forgot.jsp").forward(request, response);
            return;
        }

        String otp = OtpService.generateOtp();
        Timestamp otpExpiry = OtpService.getOtpExpiryTime();
        authService.updateOtpForUser(email, otp, otpExpiry);

        try {
            EmailService.sendOtpEmail(email, otp);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email vào lúc này. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/forgot.jsp").forward(request, response);
            return;
        }


        request.getSession().setAttribute("otp_flow", "reset_password");
        request.getSession().setAttribute("email_for_verification", email);
        response.sendRedirect(request.getContextPath() + "/verify");
    }
}
