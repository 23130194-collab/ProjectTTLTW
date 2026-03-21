package com.example.demo1.controller;

import com.example.demo1.dao.FavoriteDao;
import com.example.demo1.model.*;
import com.example.demo1.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "ListProductController", value = "/list-product")
public class ListProductController extends HttpServlet {
    private static final int PRODUCTS_PER_PAGE = 20;
    private FavoriteDao favoriteDao = new FavoriteDao();

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductService ps = new ProductService();
        CategoryService cs = new CategoryService();
        BannerService bs = new BannerService();
        BrandService brandService = new BrandService();
        CategoryAttributeService cas = new CategoryAttributeService();
        Product_SpecService pss = new Product_SpecService();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {

            String idStr = request.getParameter("id");
            int categoryId;

            if (idStr == null || idStr.isEmpty()) {
                List<Category> allCategories = cs.getAllCategories();
                if (allCategories != null && !allCategories.isEmpty()) {
                    categoryId = allCategories.get(0).getId();
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy danh mục nào.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
            } else {
                categoryId = Integer.parseInt(idStr);
            }


            String brandIdStr = request.getParameter("brandId");
            Integer brandId = null;
            if (brandIdStr != null && !brandIdStr.isEmpty()) {
                brandId = Integer.parseInt(brandIdStr);
            }


            String sortOrder = request.getParameter("sort");
            if (sortOrder == null || sortOrder.isEmpty()) {
                sortOrder = "popular";
            }


            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
            }


            Map<Integer, List<String>> specFilters = new HashMap<>();
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (paramName.startsWith("spec_")) {
                    try {
                        int attributeId = Integer.parseInt(paramName.substring(5));
                        String[] values = request.getParameterValues(paramName);
                        if (values != null && values.length > 0) {
                            specFilters.put(attributeId, Arrays.asList(values));
                        }
                    } catch (NumberFormatException e) {

                    }
                }
            }


            ProductPage productPage = ps.filterAndSortProducts(categoryId, "active", null, brandId, specFilters, sortOrder, currentPage, PRODUCTS_PER_PAGE);
            List<Product> productList = productPage.getProducts();
            int totalProducts = productPage.getTotalProducts();
            int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);


            if (user != null) {
                for (Product p : productList) {
                    p.setFavorite(favoriteDao.isFavorite(user.getId(), p.getId()));
                }
            }

            Category category = cs.getCategoryById(categoryId);


            List<Banner> bannersForCategory = bs.getBannersByPosition(String.valueOf(categoryId));
            List<Banner> leftBanners = bannersForCategory;
            List<Banner> rightBanners = new ArrayList<>(bannersForCategory);
            Collections.reverse(rightBanners);

            List<Brand> brandList = brandService.getBrandsByCategoryId(categoryId);

            Map<Attribute, List<String>> filterableAttributes = new LinkedHashMap<>();
            List<Attribute> attributes = cas.getFilterableAttributesByCategoryId(categoryId);
            for (Attribute attr : attributes) {
                List<String> values = pss.getDistinctSpecValues(categoryId, attr.getId());
                if (!values.isEmpty()) {
                    filterableAttributes.put(attr, values);
                }
            }


            request.setAttribute("productList", productList);
            request.setAttribute("category", category);
            request.setAttribute("leftBanners", leftBanners);
            request.setAttribute("rightBanners", rightBanners);
            request.setAttribute("brandList", brandList);
            request.setAttribute("selectedBrandId", brandId);
            request.setAttribute("filterableAttributes", filterableAttributes);
            request.setAttribute("selectedSpecs", specFilters);
            request.setAttribute("selectedSortOrder", sortOrder);
            

            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);


            request.getRequestDispatcher("category.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }
}
