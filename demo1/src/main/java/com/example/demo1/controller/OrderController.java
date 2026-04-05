package com.example.demo1.controller;

import com.example.demo1.dao.NotificationDao;
import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.Notification;
import com.example.demo1.model.Order;
import com.example.demo1.model.OrderItem;
import com.example.demo1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderController", urlPatterns = {"/my-orders", "/order-detail", "/account"})
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDao orderDao = new OrderDao();

        int totalOrders = orderDao.countTotalOrdersByUserId(user.getId());
        double totalSpent = orderDao.calculateTotalSpentByUserId(user.getId());

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalSpent", totalSpent);

        String path = request.getServletPath();

        if (path.equals("/my-orders") || path.equals("/user")) {
            handleListOrders(request, response, user, orderDao);

        } else if (path.equals("/order-detail")) {
            handleOrderDetail(request, response, user, orderDao);

        } else if (path.equals("/account")) {
            request.getRequestDispatcher("/thongTinTaiKhoan.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/order-detail")) {
            handleCancelOrder(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }


    private void handleListOrders(HttpServletRequest request, HttpServletResponse response, User user, OrderDao orderDao) throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Order> orderList;

        if (status != null && !status.isEmpty()) {
            orderList = orderDao.getOrdersByUserIdAndStatus(user.getId(), status);
        } else {
            orderList = orderDao.getOrdersByUserId(user.getId());
        }

        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("/user.jsp").forward(request, response);
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, User user, OrderDao orderDao) throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDao.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.getRequestDispatcher("/chiTietDonHang.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("id");

        if ("cancel".equals(action) && orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                OrderDao orderDao = new OrderDao();
                Order order = orderDao.getOrderById(orderId);

                if (order != null && order.getUserId() == user.getId()) {
                    if ("Chờ xác nhận".equals(order.getOrderStatus())) {
                        orderDao.cancelOrder(orderId);
                        try {
                            NotificationDao notiDao = new NotificationDao();
                            String adminContent = "Khách hàng " + user.getName() + " vừa HỦY đơn hàng " + order.getOrderCode();
                            String adminLink = "admin/orders?action=view&id=" + order.getId();
                            Notification adminNoti = new Notification(null, adminContent, adminLink, 1);
                            notiDao.insert(adminNoti);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/my-orders");
    }

}
