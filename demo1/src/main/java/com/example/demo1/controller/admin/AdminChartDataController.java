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
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int days = 30; // default
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

        Map<String, Object> data = new HashMap<>();
        data.put("revenueTime", revenueTime);
        data.put("revenueCategory", revenueCategory);
        data.put("ordersTime", ordersTime);
        data.put("orderStatus", orderStatus);
        data.put("orderSuccess", orderSuccess);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(data));
            out.flush();
        }
    }
}
