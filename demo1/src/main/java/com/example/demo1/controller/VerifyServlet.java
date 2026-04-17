package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet(name = "VerifyServlet", value = "/verify")
public class VerifyServlet extends HttpServlet {
    private AuthService authService;
    private static final int MAX_OTP_ATTEMPTS = 5;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer otpAttemptCount = (Integer) session.getAttribute("otp_attempt_count");

        if (otpAttemptCount != null && otpAttemptCount >= MAX_OTP_ATTEMPTS) {
            request.setAttribute("otp_error", "Bạn đã nhập sai OTP quá nhiều lần. Vui lòng gửi lại mã OTP mới.");
            request.setAttribute("disable_otp_input", true);
        }
        request.getRequestDispatcher("/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String otpFlow = (String) session.getAttribute("otp_flow");
        String otp = request.getParameter("otp");

        Integer otpAttemptCount = (Integer) session.getAttribute("otp_attempt_count");
        if (otpAttemptCount == null) {
            otpAttemptCount = 0;
        }

        if (otpAttemptCount >= MAX_OTP_ATTEMPTS) {
            request.setAttribute("otp_error", "Bạn đã nhập sai OTP quá nhiều lần. Vui lòng gửi lại mã OTP mới.");
            request.setAttribute("disable_otp_input", true);
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
            return;
        }

        if (otpFlow == null || otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn hoặc dữ liệu không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("/login").forward(request, response);
            return;
        }

        User user = null;
        if ("update_email".equals(otpFlow)) {
            Integer userId = (Integer) session.getAttribute("user_id_for_verification");
            if (userId != null) {
                user = authService.getUserById(userId);
            }
        } else {
            String email = (String) session.getAttribute("email_for_verification");
            if (email != null) {
                user = authService.getUserByEmail(email);
            }
        }

        if (user == null) {
            request.setAttribute("otp_error", "Không tìm thấy thông tin người dùng để xác thực.");
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
            return;
        }

        if (user.getOtpCode() != null && user.getOtpCode().equals(otp)) {
            if (user.getOtpExpiry() != null && user.getOtpExpiry().after(new Timestamp(System.currentTimeMillis()))) {
                session.removeAttribute("otp_flow");
                session.removeAttribute("otp_attempt_count");

                if ("registration".equals(otpFlow)) {
                    authService.activateUser(user.getId());
                    session.removeAttribute("email_for_verification");
                    session.setAttribute("successMessage", "Tài khoản của bạn đã được kích hoạt thành công! Vui lòng đăng nhập.");
                    response.sendRedirect(request.getContextPath() + "/login");
                } else if ("reset_password".equals(otpFlow)) {
                    session.removeAttribute("email_for_verification");
                    session.setAttribute("user_can_reset_password", user.getEmail());
                    response.sendRedirect(request.getContextPath() + "/matKhauMoi.jsp");
                } else if ("update_email".equals(otpFlow)) {
                    User updatedUserInfo = (User) session.getAttribute("temp_user_update_info");
                    if (updatedUserInfo != null) {
                        authService.updateUser(updatedUserInfo);

                        authService.clearOtpForUser(updatedUserInfo.getId());

                        User refreshedUser = authService.getUserById(updatedUserInfo.getId());
                        if (refreshedUser != null) {
                            refreshedUser.setPassword(null);
                            session.setAttribute("user", refreshedUser);
                        } else {
                            session.setAttribute("user", updatedUserInfo);
                        }

                        session.removeAttribute("temp_user_update_info");
                        session.removeAttribute("user_id_for_verification");
                        session.removeAttribute("new_email_for_display");
                        session.removeAttribute("last_otp_send_time");
                        session.setAttribute("updateProfileSuccess", "Cập nhật thông tin thành công!");
                        response.sendRedirect(request.getContextPath() + "/account");
                    } else {
                        session.setAttribute("updateProfileError", "Phiên cập nhật đã hết hạn. Vui lòng thử lại.");
                        response.sendRedirect(request.getContextPath() + "/account?mode=edit");
                    }
                }

            } else {
                request.setAttribute("otp_error", "Mã OTP đã hết hạn.");
                request.getRequestDispatcher("/verify.jsp").forward(request, response);
            }
        } else {
            otpAttemptCount++;
            session.setAttribute("otp_attempt_count", otpAttemptCount);

            if (otpAttemptCount >= MAX_OTP_ATTEMPTS) {
                request.setAttribute("otp_error", "Bạn đã nhập sai OTP quá nhiều lần. Vui lòng gửi lại mã OTP mới.");
                request.setAttribute("disable_otp_input", true);
            } else {
                request.setAttribute("otp_error", "Mã OTP không chính xác. Bạn còn " + (MAX_OTP_ATTEMPTS - otpAttemptCount) + " lần thử.");
            }
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
        }
    }
}
