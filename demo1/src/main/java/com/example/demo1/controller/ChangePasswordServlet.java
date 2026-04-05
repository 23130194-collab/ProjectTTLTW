package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.AuthService;
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

@WebServlet(name = "ChangePasswordServlet", value = "/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User userInSession = (User) session.getAttribute("user");

        if (userInSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        AuthService authService = new AuthService();
        User userFromDb = authService.getUserByEmail(userInSession.getEmail());

        if (userFromDb == null || !userFromDb.getPassword().equals(MD5.hash(oldPassword))) {
            request.setAttribute("oldPassword_error", "Mật khẩu cũ không chính xác.");
            request.getRequestDispatcher("/thayDoiMK.jsp").forward(request, response);
            return;
        }

        if (!DataValidator.isPasswordValid(newPassword)) {
            request.setAttribute("newPassword_error", "Mật khẩu mới phải dài ít nhất 8 ký tự, gồm chữ hoa, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/thayDoiMK.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("confirmPassword_error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/thayDoiMK.jsp").forward(request, response);
            return;
        }

        String hashedNewPassword = MD5.hash(newPassword);

        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        
        authService.updatePassword(userInSession.getEmail(), hashedNewPassword, currentTime);


        User updatedUser = authService.getUserByEmail(userInSession.getEmail());
        session.setAttribute("user", updatedUser);

        session.setAttribute("changePassSuccess", "Đổi mật khẩu thành công!");
        response.sendRedirect(request.getContextPath() + "/thongTinTaiKhoan.jsp");
    }
}
