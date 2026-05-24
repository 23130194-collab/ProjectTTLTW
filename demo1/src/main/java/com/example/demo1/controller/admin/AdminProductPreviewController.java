package com.example.demo1.controller.admin;

import com.example.demo1.dao.FavoriteDao;
import com.example.demo1.model.Category;
import com.example.demo1.model.Product;
import com.example.demo1.model.Review;
import com.example.demo1.model.ReviewSummary;
import com.example.demo1.service.ProductService;
import com.example.demo1.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminProductPreviewController", value = "/admin/product-preview")
public class AdminProductPreviewController extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ProductService ps = new ProductService();
            ReviewService rs = new ReviewService();

            Product p = ps.getProduct(id);

            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }

            Category category = ps.getCategory(p.getCategoryId());

            Map<Integer, Integer> rawData = rs.getReviewSummary(id);
            ReviewSummary summary = (rawData != null) ? new ReviewSummary(rawData) : new ReviewSummary();

            List<Review> initialReviews = rs.getReviewsForUser(id, 0, 5, 0);
            if (initialReviews == null) {
                initialReviews = Collections.emptyList();
            }

            List<Product> relatedProducts = ps.getRelatedProducts(p);

            request.setAttribute("p", p);
            request.setAttribute("category", category);
            request.setAttribute("brand", ps.getBrand(id));
            request.setAttribute("specs", ps.getProductSpecs(id));
            request.setAttribute("images", ps.getProductImages(id));
            request.setAttribute("reviews", initialReviews);
            request.setAttribute("reviewSummary", summary);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("canReview", false);
            request.setAttribute("hasReviewed", false);

            request.getRequestDispatcher("/sanPham.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}
