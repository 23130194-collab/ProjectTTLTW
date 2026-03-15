package com.example.demo1.service;

import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public class OrderService {
    private final OrderDao orderDao = new OrderDao();

    public OrderPage getPagedOrders(String keyword, int currentPage, int ordersPerPage) {
        List<Order> orders;
        int totalOrders;

        if (keyword != null && !keyword.isEmpty()) {
            orders = orderDao.searchOrders(keyword, currentPage, ordersPerPage);
            totalOrders = orderDao.getSearchOrderCount(keyword);
        } else {
            orders = orderDao.getAllOrders(currentPage, ordersPerPage);
            totalOrders = orderDao.getTotalOrderCount();
        }
        return new OrderPage(orders, totalOrders);
    }

    public OrderDetail getOrderDetailById(int orderId) {
        return orderDao.getOrderDetailById(orderId);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        boolean success = orderDao.updateOrderStatus(orderId, status);
        if (success) {
            recalculateAndSyncOrderTotals(orderId);
        }
        return success;
    }

    public void recalculateAndSyncOrderTotals(int orderId) {
        List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
        Order order = orderDao.getOrderById(orderId);

        if (order == null || items == null) {
            return;
        }

        double subprice = 0;
        double discountAmount = 0;

        for (OrderItem item : items) {
            subprice += item.getOriginalPrice() * item.getQuantity();
            discountAmount += (item.getOriginalPrice() - item.getUnitPrice()) * item.getQuantity();
        }

        double totalAmount = subprice - discountAmount + order.getShippingFee();

        orderDao.updateOrderTotals(orderId, subprice, discountAmount, totalAmount);
    }

    public Order getOrderById(int orderId) {
        return orderDao.getOrderById(orderId);
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        return orderDao.getOrderItemsByOrderId(orderId);
    }

    public List<Order> getAllOrders(int page, int pageSize) {
        return orderDao.getAllOrders(page, pageSize);
    }

    public int getTotalOrderCount() {
        return orderDao.getTotalOrderCount();
    }

    public List<Order> searchOrders(String keyword, int page, int pageSize) {
        return orderDao.searchOrders(keyword, page, pageSize);
    }

    public int getSearchOrderCount(String keyword) {
        return orderDao.getSearchOrderCount(keyword);
    }

    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }

    public int countOrdersByUserId(int userId) {
        return orderDao.countOrdersByUserId(userId);
    }

    public List<Order> getOrdersByUserIdPaging(int userId, int limit, int offset) {
        return orderDao.getOrdersByUserIdPaging(userId, limit, offset);
    }

    public int countTotalOrdersByUserId(int userId) {
        return orderDao.countTotalOrdersByUserId(userId);
    }

    public double calculateTotalSpentByUserId(int userId) {
        return orderDao.calculateTotalSpentByUserId(userId);
    }

    public List<Order> getOrdersByUserIdAndStatus(int userId, String status) {
        return orderDao.getOrdersByUserIdAndStatus(userId, status);
    }

    public boolean createOrder(Order order, RecipientInfo recipient, Map<Integer, CartItem> cart, Payment payment) {
        return orderDao.createOrder(order, recipient, cart, payment);
    }

    public boolean cancelOrder(int orderId) {
        return orderDao.cancelOrder(orderId);
    }

    public RecipientInfo getRecipientInfoByOrderId(int orderId) {
        return orderDao.getRecipientInfoByOrderId(orderId);
    }

}