package com.example.demo1.controller;

import com.example.demo1.dao.NotificationDao;
import com.example.demo1.dao.ProductDao;
import com.example.demo1.dao.ReviewDao;
import com.example.demo1.model.Notification;
import com.example.demo1.model.Product;
import com.example.demo1.model.User;

import com.example.demo1.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SubmitReviewServlet", value = "/submit-review")
public class SubmitReviewServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            int userId = user.getId();

            reviewService.addReview(productId, userId, rating, comment);

            try {
                ProductDao productDao = new ProductDao();
                Product product = productDao.getById(productId);
                String productName = (product != null) ? product.getName() : "Sản phẩm " + productId;

                String adminContent = "Đánh giá mới " + rating + "* cho: " + productName;
                String adminLink = "admin/reviews";
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("product-detail?id=" + productId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
}
