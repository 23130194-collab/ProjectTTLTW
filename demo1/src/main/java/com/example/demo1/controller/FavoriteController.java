package com.example.demo1.controller;

import com.example.demo1.dao.FavoriteDao;
import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.Product;
import com.example.demo1.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FavoriteController", urlPatterns = {"/favorites", "/remove-favorite", "/add-favorite", "/toggle-favorite"})
public class FavoriteController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String ajaxHeader = request.getHeader("X-Requested-With");
        if (user == null) {
            if ("XMLHttpRequest".equals(ajaxHeader)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"requireLogin\": true}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        FavoriteDao favDao = new FavoriteDao();
        String path = request.getServletPath();
        String referer = request.getHeader("Referer");

        if (path.equals("/add-favorite")) {
            int productId = Integer.parseInt(request.getParameter("id"));
            favDao.addFavorite(user.getId(), productId);
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");
            return;
        }

        if (path.equals("/remove-favorite")) {
            int productId = Integer.parseInt(request.getParameter("id"));
            favDao.removeFavorite(user.getId(), productId);
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/favorites");
            }
            return;
        }

        if (path.equals("/toggle-favorite")) {
            int productId = Integer.parseInt(request.getParameter("id"));

            boolean isNowFavorite;
            if (favDao.isFavorite(user.getId(), productId)) {
                favDao.removeFavorite(user.getId(), productId);
                isNowFavorite = false;
            } else {
                favDao.addFavorite(user.getId(), productId);
                isNowFavorite = true;
            }

            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"isFavorite\": " + isNowFavorite + "}");
                return;
            } else {
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");
            }
            return;
        }

        OrderDao orderDao = new OrderDao();
        request.setAttribute("totalOrders", orderDao.countTotalOrdersByUserId(user.getId()));
        request.setAttribute("totalSpent", orderDao.calculateTotalSpentByUserId(user.getId()));


        int pageSize = 4;
        int currentPage = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException ignored) {}
        int totalItems = favDao.countFavoritesByUserId(user.getId());
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;
        int offset = (currentPage - 1) * pageSize;
        request.setAttribute("favList", favDao.getFavoritesByUserIdPaged(user.getId(), offset, pageSize));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/sanPhamYeuThich.jsp").forward(request, response);
    }
}
