package com.example.demo1.controller.admin;

import com.example.demo1.service.OrderService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminChartDataController", value = "/admin/chart-data")
public class AdminChartDataController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final com.example.demo1.service.ProductService productService = new com.example.demo1.service.ProductService();
    private final com.example.demo1.service.ReviewService reviewService = new com.example.demo1.service.ReviewService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int days = 30;
        String daysParam = request.getParameter("days");
        if (daysParam != null && !daysParam.isEmpty()) {
            try {
                days = Integer.parseInt(daysParam);
            } catch (NumberFormatException e) {
                days = 30;
            }
        }

        Map<String, Double> revenueTime = orderService.getRevenueByTimeRange(days);
        Map<String, Double> revenueCategory = orderService.getRevenueByCategory(days);
        Map<String, Integer> ordersTime = orderService.getOrdersCountByTimeRange(days);
        Map<String, Integer> orderStatus = orderService.getOrderStatusRatio(days);
        Map<String, Integer> orderSuccess = orderService.getOrderSuccessVsFailRatio(days);

        Map<String, Integer> topProducts = orderService.getTopSellingProducts(days, 10);
        Map<String, Integer> stockByCategory = productService.getStockByCategory();
        Map<String, Integer> brandRatio = productService.getProductRatioByBrand();
        java.util.List<com.example.demo1.model.Product> lowStockList = productService.getLowStockProductsList(4);
        Map<String, Integer> unsoldProducts = productService.getOldestUnsoldProducts(20);
        Map<String, Integer> paymentMethodRatio = orderService.getPaymentMethodRatio(days);
        Map<String, Double> revenueByPaymentMethod = orderService.getRevenueByPaymentMethod(days);
        Map<String, Double> averageRatingByCategory = reviewService.getAverageRatingByCategory(days);
        Map<String, Integer> ratingDistribution = reviewService.getRatingDistribution(days);
        Map<String, Double> cancellationRate = orderService.getOrderCancellationRate(days);

        Map<String, Object> data = new HashMap<>();
        data.put("revenueTime", revenueTime);
        data.put("revenueCategory", revenueCategory);
        data.put("ordersTime", ordersTime);
        data.put("orderStatus", orderStatus);
        data.put("orderSuccess", orderSuccess);
        
        data.put("topProducts", topProducts);
        data.put("stockByCategory", stockByCategory);
        data.put("brandRatio", brandRatio);
        data.put("lowStockList", lowStockList);
        data.put("unsoldProducts", unsoldProducts);
        data.put("paymentMethodRatio", paymentMethodRatio);
        data.put("revenueByPaymentMethod", revenueByPaymentMethod);
        data.put("averageRatingByCategory", averageRatingByCategory);
        data.put("ratingDistribution", ratingDistribution);
        data.put("cancellationRate", cancellationRate);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(data));
            out.flush();
        }
    }
}
