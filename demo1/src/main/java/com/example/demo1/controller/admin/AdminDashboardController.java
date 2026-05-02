package com.example.demo1.controller.admin;

import com.example.demo1.service.OrderService;
import com.example.demo1.service.ProductService;
import com.example.demo1.service.UserService;
import com.example.demo1.model.Product;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardController", value = "/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderService orderService = new OrderService();
        UserService userService = new UserService();
        ProductService productService = new ProductService();

        double revenue = orderService.getTotalRevenue();
        double monthlyRevenue = orderService.getMonthlyRevenue();
        int orders = orderService.getTotalOrderCount();
        int pendingOrders = orderService.getPendingOrdersCount();
        int customers = userService.getTotalCustomersCount();
        int newCustomersThisMonth = userService.getNewCustomersThisMonth();
        int activeProducts = productService.getActiveProductsCount();
        int lowStockProducts = productService.getLowStockProductsCount(5);
        List<Product> lowStockProductsList = productService.getLowStockProductsList(5);

        double cancelRate = orderService.getCancelRate();
        double todaysRevenue = orderService.getTodaysRevenue();

        int totalProductsSold = orderService.getTotalProductsSold();
        int productsSoldThisMonth = orderService.getProductsSoldThisMonth();
        int processingOrders = orderService.getProcessingOrdersCount();
        int deliveredOrders = orderService.getDeliveredOrdersCount();

        request.setAttribute("revenue", revenue);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("totalOrders", orders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalCustomers", customers);
        request.setAttribute("newCustomersThisMonth", newCustomersThisMonth);
        request.setAttribute("activeProducts", activeProducts);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("lowStockProductsList", lowStockProductsList);
        request.setAttribute("cancelRate", cancelRate);
        request.setAttribute("todaysRevenue", todaysRevenue);
        request.setAttribute("totalProductsSold", totalProductsSold);
        request.setAttribute("productsSoldThisMonth", productsSoldThisMonth);
        request.setAttribute("processingOrders", processingOrders);
        request.setAttribute("deliveredOrders", deliveredOrders);



        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
