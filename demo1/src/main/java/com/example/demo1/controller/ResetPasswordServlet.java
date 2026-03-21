package com.example.demo1.controller;

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

@WebServlet(name = "ResetPasswordServlet", value = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authService = new AuthService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("user_can_reset_password");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!DataValidator.isPasswordValid(password)) {
            request.setAttribute("error", "Yêu cầu ít nhất 8 ký tự, gồm chữ hoa, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/matKhauMoi.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/matKhauMoi.jsp").forward(request, response);
            return;
        }

        String hashedPassword = MD5.hash(password);

        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        

        authService.updatePassword(email, hashedPassword, currentTime);

        session.removeAttribute("user_can_reset_password");
        session.setAttribute("successMessage", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
