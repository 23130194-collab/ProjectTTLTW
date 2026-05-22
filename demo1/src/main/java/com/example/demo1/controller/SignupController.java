package com.example.demo1.controller;

import com.example.demo1.service.AuthService;
import com.example.demo1.service.EmailService;
import com.example.demo1.service.OtpService;
import com.example.demo1.util.DataValidator;
import com.example.demo1.util.MD5;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "SignupController", value = "/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isEmpty()) {
            request.getSession().setAttribute("post_auth_redirect", redirect);
        }
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        Map<String, String> errors = new HashMap<>();
        AuthService service = new AuthService();

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Họ và tên không được để trống.");
        } else {
            if (name.trim().length() > 50) {
                errors.put("name", "Họ và tên không được vượt quá 50 ký tự.");
            }
            if (!name.trim().contains(" ")) {
                errors.put("name", "Giữa họ và tên phải có khoảng trắng.");
            }

            if (!name.matches("^[\\p{L}\\s'-]+$")) {
                errors.put("name", "Họ và tên không được chứa ký tự đặc biệt hoặc số.");
            }
        }

        if (!DataValidator.isEmailValid(email)) {
            errors.put("email", "Định dạng email không hợp lệ.");
        } else if (service.emailExists(email)) {
            errors.put("email", "Email này đã được đăng ký.");
        }

        if (!DataValidator.isPasswordValid(password)) {
            errors.put("password", "Mật khẩu cần ít nhất 8 ký tự, gồm chữ hoa, số và ký tự đặc biệt.");
        }

        if (!password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("name_value", name);
            request.setAttribute("email_value", email);
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        String hashedPassword = MD5.hash(password);
        String otp = OtpService.generateOtp();
        Timestamp otpExpiry = OtpService.getOtpExpiryTime();

        service.register(name, email, hashedPassword, otp, otpExpiry);

        try {
            EmailService.sendOtpEmail(email, otp);
            HttpSession session = request.getSession();
            session.setAttribute("otp_flow", "registration");
            session.setAttribute("email_for_verification", email);
            session.setAttribute("otp_attempt_count", 0);

            session.setAttribute("last_otp_send_time", System.currentTimeMillis());
            response.sendRedirect(request.getContextPath() + "/verify");
        } catch (Exception e) {
            errors.put("general", "Không thể gửi email xác thực. Vui lòng thử lại sau.");
            request.setAttribute("errors", errors);
            request.setAttribute("name_value", name);
            request.setAttribute("email_value", email);
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}
