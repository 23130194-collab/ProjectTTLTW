package com.example.demo1.controller.admin;

import com.example.demo1.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LockCustomerController", value = "/admin/lock-customer")
public class LockCustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);

                UserService userService = new UserService();

                String currentStatus = userService.getUserStatus(id);

                String newStatus = "Active";
                String msg = "Đã mở khóa tài khoản!";

                if (currentStatus == null || currentStatus.equalsIgnoreCase("Active")) {
                    newStatus = "Locked";
                    msg = "Đã khóa tài khoản thành công!";
                }

                userService.updateUserStatus(id, newStatus);

                request.getSession().setAttribute("updateSuccess", msg);

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("updateError", "Lỗi khi cập nhật trạng thái!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }
}