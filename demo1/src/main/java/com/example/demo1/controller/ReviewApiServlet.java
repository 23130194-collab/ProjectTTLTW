package com.example.demo1.controller;

import com.example.demo1.model.Review;
import com.example.demo1.service.ReviewService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ReviewApiServlet", value = "/api/reviews")
public class ReviewApiServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int ratingFilter = Integer.parseInt(request.getParameter("filter"));
            int offset = Integer.parseInt(request.getParameter("offset"));
            int limit = 5;

            List<Review> reviews = reviewService.getReviewsForUser(productId, ratingFilter, limit, offset);

            String jsonResponse = this.gson.toJson(reviews);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng tham số không hợp lệ");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi!");
            e.printStackTrace();
        }
    }
}
