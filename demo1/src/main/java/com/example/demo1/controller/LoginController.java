package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.AuthService;
import com.example.demo1.util.DataValidator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Map<String, String> errors = new HashMap<>();
        

        request.setAttribute("email_value", email);


        if (!DataValidator.isEmailValid(email)) {
            errors.put("email", "Định dạng email không hợp lệ.");
        }
        if (!DataValidator.isPasswordValid(password)) {
            errors.put("password", "Mật khẩu không đúng định dạng.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        AuthService as = new AuthService();
        User user = as.checkLogin(email, password);

        if (user != null) {

            if ("unverified".equalsIgnoreCase(user.getStatus())) {
                request.getSession().setAttribute("email_for_verification", email);
                response.sendRedirect(request.getContextPath() + "/verify.jsp");
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);


            if (user.getRole() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            User existingUser = as.getUserByEmail(email);
            if (existingUser != null && "Locked".equalsIgnoreCase(existingUser.getStatus())) {
                errors.put("general", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin!");
            } else {
                errors.put("general", "Email hoặc mật khẩu không hợp lệ!");
            }
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
