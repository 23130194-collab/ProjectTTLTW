package com.example.demo1.controller.admin;

import com.example.demo1.service.AuthService;
import com.example.demo1.service.EmailService;
import com.example.demo1.service.UserService;
import com.example.demo1.util.DataValidator;
import com.example.demo1.util.MD5;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminAddCustomerController", value = "/admin/add-customer")
public class AdminAddCustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin/AdminAddCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        Map<String, String> errors = new HashMap<>();
        AuthService authService = new AuthService();
        UserService userService = new UserService();

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Họ và tên không được để trống.");
        } else if (name.trim().length() > 50) {
            errors.put("name", "Họ và tên không được vượt quá 50 ký tự.");
        } else if (!name.trim().contains(" ")) {
            errors.put("name", "Giữa họ và tên phải có khoảng trắng.");
        } else if (!name.matches("^[\\p{L}\\s'-]+$")) {
            errors.put("name", "Họ và tên không được chứa ký tự đặc biệt hoặc số.");
        }

        if (!DataValidator.isEmailValid(email)) {
            errors.put("email", "Định dạng email không hợp lệ.");
        } else if (authService.emailExists(email)) {
            errors.put("email", "Email này đã được đăng ký trong hệ thống.");
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
            request.getRequestDispatcher("/admin/AdminAddCustomer.jsp").forward(request, response);
            return;
        }

        try {
            String hashedPassword = MD5.hash(password);
            userService.addCustomerByAdmin(name, email, hashedPassword);

            try {
                EmailService.sendAdminCreatedAccountEmail(email, name, password);
                session.setAttribute("successMessage", "Thêm khách hàng mới thành công! Email thông báo đã được gửi đến khách hàng.");
            } catch (Exception emailException) {
                session.setAttribute("errorMessage", "Thêm khách hàng mới thành công nhưng gửi email thông báo thất bại. Vui lòng kiểm tra cấu hình email.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        }
    }
}
