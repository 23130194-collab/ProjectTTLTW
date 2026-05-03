package com.example.demo1.controller.admin;

import com.example.demo1.service.OrderService;
import com.example.demo1.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.example.demo1.model.User;
import com.example.demo1.service.UserService;


import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerDetailController", value = "/admin/customer-detail")
public class CustomerDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("updateSuccess") != null) {
            request.setAttribute("updateSuccess", session.getAttribute("updateSuccess"));
            session.removeAttribute("updateSuccess");
        }
        if (session.getAttribute("updateError") != null) {
            request.setAttribute("updateError", session.getAttribute("updateError"));
            session.removeAttribute("updateError");
        }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int userId = Integer.parseInt(idStr);

                UserService userService = new UserService();
                User customer = userService.getUserById(userId);

                request.setAttribute("customer", customer);

                int page = 1;
                String pageStr = request.getParameter("page");
                if (pageStr != null) {
                    try {
                        page = Integer.parseInt(pageStr);
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }

                int pageSize = 5;

                OrderService orderService = new OrderService();
                int totalOrders = orderService.countOrdersByUserId(userId);
                int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
                int offset = (page - 1) * pageSize;
                List<Order> orderList = orderService.getOrdersByUserIdPaging(userId, pageSize, offset);

                request.setAttribute("orderList", orderList);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);

                request.setAttribute("userId", userId);

                request.getRequestDispatcher("/admin/detailsCustomers.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/customers");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");

        try {
            int userId = Integer.parseInt(idStr);
            UserService userService = new UserService();

            User customer = userService.getUserById(userId);

            if (customer != null) {
                customer.setName(request.getParameter("name"));
                customer.setPhone(request.getParameter("phone"));
                customer.setGender(request.getParameter("gender"));
                customer.setEmail(request.getParameter("email"));
                customer.setAddress(request.getParameter("address"));

                String birthdayStr = request.getParameter("birthday");
                if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                    try {
                        customer.setBirthday(java.sql.Date.valueOf(birthdayStr));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Lỗi định dạng ngày sinh: " + birthdayStr);
                    }
                }

                userService.updateUser(customer);

                session.setAttribute("successMessage", "Cập nhật thông tin khách hàng thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Cập nhật thất bại: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-detail?id=" + idStr);
    }
}
