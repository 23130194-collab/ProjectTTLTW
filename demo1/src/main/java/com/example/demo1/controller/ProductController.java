package com.example.demo1.controller;

import com.example.demo1.dao.FavoriteDao;
import com.example.demo1.model.Product;
import com.example.demo1.model.Review;
import com.example.demo1.model.ReviewSummary;
import com.example.demo1.model.User;
import com.example.demo1.model.Category;
import com.example.demo1.service.ProductService;
import com.example.demo1.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductController", value = "/product-detail")
public class ProductController extends HttpServlet {
    private FavoriteDao favoriteDao = new FavoriteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("home.jsp");
                return;
            }

            int id = Integer.parseInt(idStr);
            ProductService ps = new ProductService();
            ReviewService rs = new ReviewService();

            Product p = ps.getPublicProduct(id);

            if (p == null) {
                response.sendRedirect("error.jsp");
                return;
            }

            Category category = ps.getCategory(p.getCategoryId());

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                p.setFavorite(favoriteDao.isFavorite(user.getId(), p.getId()));
            }


            List<Product> relatedProducts = ps.getRelatedProducts(p);
            if (user != null) {
                for (Product rp : relatedProducts) {
                    rp.setFavorite(favoriteDao.isFavorite(user.getId(), rp.getId()));
                }
            }
            

            Map<Integer, Integer> rawData = rs.getReviewSummary(id);
            ReviewSummary summary = (rawData != null) ? new ReviewSummary(rawData) : new ReviewSummary();

            List<Review> initialReviews = rs.getReviewsForUser(id, 0, 5, 0);
            if (initialReviews == null) {
                initialReviews = Collections.emptyList();
            }

            request.setAttribute("p", p);
            request.setAttribute("category", category);
            request.setAttribute("brand", ps.getBrand(id));
            request.setAttribute("specs", ps.getProductSpecs(id));
            request.setAttribute("images", ps.getProductImages(id));
            request.setAttribute("reviews", initialReviews);
            request.setAttribute("reviewSummary", summary);
            request.setAttribute("relatedProducts", relatedProducts);

            request.getRequestDispatcher("sanPham.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        } catch (Exception e) {

            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải trang sản phẩm.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
