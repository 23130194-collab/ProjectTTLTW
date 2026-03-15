package com.example.demo1.controller.admin;

import com.example.demo1.dao.OrderDao;
import com.example.demo1.dao.ProductDao;
import com.example.demo1.dao.UserDao;
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
        OrderDao orderDao = new OrderDao();
        UserDao userDao = new UserDao();
        ProductDao productDao = new ProductDao();

        double revenue = orderDao.getTotalRevenue();
        int orders = orderDao.getTotalOrdersCount();
        int customers = userDao.getTotalCustomersCount();
        int activeProducts = productDao.getActiveProductsCount();

        request.setAttribute("revenue", revenue);
        request.setAttribute("totalOrders", orders);
        request.setAttribute("totalCustomers", customers);
        request.setAttribute("activeProducts", activeProducts);

        Map<String, Double> dailyRevenue = orderDao.getDailyRevenueForLast7Days();
        List<String> chartLabels = new ArrayList<>();
        List<Double> chartData = new ArrayList<>();

        DateTimeFormatter dbFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter chartFormatter = DateTimeFormatter.ofPattern("dd/MM");

        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            String dateStrDb = date.format(dbFormatter);
            String dateStrChart = date.format(chartFormatter);

            chartLabels.add(dateStrChart);
            chartData.add(dailyRevenue.getOrDefault(dateStrDb, 0.0));
        }

        Gson gson = new Gson();
        request.setAttribute("chartLabels", gson.toJson(chartLabels));
        request.setAttribute("chartData", gson.toJson(chartData));

        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
