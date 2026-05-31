package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UserVoucherServlet", value = "/vouchers")
public class UserVoucherServlet extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }
        request.setAttribute("totalOrders", orderService.countTotalOrdersByUserId(user.getId()));
        request.setAttribute("totalSpent", orderService.calculateTotalSpentByUserId(user.getId()));
        
        java.util.List<com.example.demo1.model.Voucher> vouchers = voucherService.getActiveVouchersForUser(user.getId());
        java.util.List<com.example.demo1.model.Voucher> filteredAndSorted = vouchers.stream()
                .filter(v -> !v.isUsed())
                .sorted((v1, v2) -> {
                    int s1 = v1.isSaved() ? 1 : 0;
                    int s2 = v2.isSaved() ? 1 : 0;
                    return Integer.compare(s1, s2);
                })
                .collect(java.util.stream.Collectors.toList());
        
        request.setAttribute("vouchers", filteredAndSorted);
        request.getRequestDispatcher("/userVouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }
        int voucherId;
        try {
            voucherId = Integer.parseInt(request.getParameter("voucherId"));
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("voucherError", "Voucher không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/vouchers");
            return;
        }

        boolean saved = voucherService.saveVoucherForUser(user.getId(), voucherId);
        request.getSession().setAttribute(saved ? "voucherSuccess" : "voucherError",
                saved ? "Đã lưu voucher." : "Không thể lưu voucher này.");
        response.sendRedirect(request.getContextPath() + "/vouchers");
    }

    private User getLoggedInUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
        return user;
    }
}
