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
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(name = "UpdateProfileServlet", value = "/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");
            String newEmail = request.getParameter("email");

            AuthService authService = new AuthService();

            if (newEmail != null && !newEmail.equalsIgnoreCase(currentUser.getEmail())) {
                if (authService.emailExists(newEmail)) {
                    session.setAttribute("updateProfileError", "Email này đã được sử dụng bởi tài khoản khác.");
                    response.sendRedirect(request.getContextPath() + "/account?mode=edit");
                    return;
                }

                User updatedUserInfo = new User();
                updatedUserInfo.setId(currentUser.getId());
                updatedUserInfo.setName(name);
                updatedUserInfo.setPhone(phone);
                updatedUserInfo.setAddress(currentUser.getAddress());
                updatedUserInfo.setGender(gender);
                if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                    updatedUserInfo.setBirthday(Date.valueOf(birthdayStr));
                }
                updatedUserInfo.setEmail(newEmail);

                String otp = OtpService.generateOtp();
                Timestamp otpExpiry = OtpService.getOtpExpiryTime();
                
                authService.updateOtpForUserById(currentUser.getId(), otp, otpExpiry);

                EmailService.sendOtpEmail(newEmail, otp);

                session.setAttribute("temp_user_update_info", updatedUserInfo);
                session.setAttribute("user_id_for_verification", currentUser.getId());
                session.setAttribute("new_email_for_display", newEmail);
                session.setAttribute("otp_flow", "update_email");
                session.setAttribute("otp_attempt_count", 0);
                session.removeAttribute("last_otp_send_time");
                response.sendRedirect(request.getContextPath() + "/verify");
                return;

            } else {
                currentUser.setName(name);
                currentUser.setPhone(phone);
                currentUser.setGender(gender);
                if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                    currentUser.setBirthday(Date.valueOf(birthdayStr));
                }

                authService.updateUser(currentUser);
                session.setAttribute("user", currentUser);
                session.setAttribute("updateProfileSuccess", "Cập nhật thông tin thành công!");
                response.sendRedirect(request.getContextPath() + "/account");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("updateProfileError", "Đã xảy ra lỗi. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/account?mode=edit");
        }
    }
}
