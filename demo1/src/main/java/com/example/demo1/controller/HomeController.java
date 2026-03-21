package com.example.demo1.controller;

import com.example.demo1.model.*;
import com.example.demo1.service.BannerService;
import com.example.demo1.service.CategoryService;
import com.example.demo1.service.FavoriteService;
import com.example.demo1.service.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", value = "/home")
public class HomeController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final BannerService bannerService = new BannerService();
    private final FavoriteService favoriteService = new FavoriteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            List<Category> categoryList = categoryService.getAllCategories();
            request.setAttribute("categoryList", categoryList);

            List<Banner> bannerList = bannerService.getBannersByPosition("Trang chủ");
            request.setAttribute("bannerList", bannerList);

            ProductPage popularPage = productService.filterAndSortProducts(null, "active", null, null, null, "popular", 1, 10);
            List<Product> flashSaleList = popularPage.getProducts();

            for (Product p : flashSaleList) {
                p.setAvgRating(productService.getReviewSummary(p.getId()).getAverageRating());

                if (p.getOldPrice() > p.getPrice()) {
                    p.setDiscountValue(((p.getOldPrice() - p.getPrice()) / p.getOldPrice()) * 100);
                }

                if (user != null) {
                    p.setFavorite(favoriteService.isFavorite(user.getId(), p.getId()));
                }
            }
            request.setAttribute("flashSaleList", flashSaleList);

            List<Product> randomProducts = productService.getRandomProducts(8);
            for (Product p : randomProducts) {
                if (user != null) {
                    p.setFavorite(favoriteService.isFavorite(user.getId(), p.getId()));
                }
            }
            request.setAttribute("suggestedProducts", randomProducts);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}