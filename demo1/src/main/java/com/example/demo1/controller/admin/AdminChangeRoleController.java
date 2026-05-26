package com.example.demo1.controller.admin;

import com.example.demo1.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "AdminChangeRoleController", value = "/admin/change-role")
public class AdminChangeRoleController extends HttpServlet {

    private static final int ROLE_USER = 0;
    private static final int ROLE_ADMIN = 1;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customers");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            UserService userService = new UserService();

            int currentRole = userService.getRoleById(userId);
            int newRole = (currentRole == ROLE_ADMIN) ? ROLE_USER : ROLE_ADMIN;

            boolean success = userService.updateRole(userId, newRole);

            if (success && newRole == ROLE_USER) {
                userService.updateUserStatus(userId, "active");
            }

            if (success) {
                request.getSession().setAttribute("successMessage",
                        newRole == ROLE_ADMIN
                                ? "Đã cấp quyền Admin thành công!"
                                : "Đã hạ về quyền User thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Cập nhật quyền thất bại!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }
}
