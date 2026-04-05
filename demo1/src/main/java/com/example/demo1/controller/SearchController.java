package com.example.demo1.controller;

import com.example.demo1.model.Product;
import com.example.demo1.model.ProductPage;
import com.example.demo1.model.User;
import com.example.demo1.service.FavoriteService;
import com.example.demo1.service.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchController", value = "/search")
public class SearchController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final FavoriteService favoriteService = new FavoriteService();

    private static final int PRODUCTS_PER_PAGE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String sortOrder = request.getParameter("sort");
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "popular";
        }

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        ProductPage productPage = productService.filterAndSortProducts(
                null, "active", keyword, null, null, sortOrder, currentPage, PRODUCTS_PER_PAGE
        );

        List<Product> productList = productPage.getProducts();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        for (Product p : productList) {
            p.setAvgRating(productService.getReviewSummary(p.getId()).getAverageRating());

            if (p.getOldPrice() > p.getPrice()) {
                p.setDiscountValue(((p.getOldPrice() - p.getPrice()) / p.getOldPrice()) * 100);
            }

            if (user != null) {
                p.setFavorite(favoriteService.isFavorite(user.getId(), p.getId()));
            }
        }

        request.setAttribute("productList", productList);
        request.setAttribute("selectedKeyword", keyword);
        request.setAttribute("selectedSortOrder", sortOrder);
        request.setAttribute("currentPage", currentPage);

        request.setAttribute("totalPages", (int) Math.ceil((double) productPage.getTotalProducts() / PRODUCTS_PER_PAGE));

        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}