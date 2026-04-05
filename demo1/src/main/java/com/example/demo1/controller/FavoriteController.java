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
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
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
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/favorites");
            return;
        }

        if (path.equals("/toggle-favorite")) {
            int productId = Integer.parseInt(request.getParameter("id"));
            if (favDao.isFavorite(user.getId(), productId)) {
                favDao.removeFavorite(user.getId(), productId);
            } else {
                favDao.addFavorite(user.getId(), productId);
            }
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");
            return;
        }


        OrderDao orderDao = new OrderDao();
        request.setAttribute("totalOrders", orderDao.countTotalOrdersByUserId(user.getId()));
        request.setAttribute("totalSpent", orderDao.calculateTotalSpentByUserId(user.getId()));


        request.setAttribute("favList", favDao.getFavoritesByUserId(user.getId()));
        request.getRequestDispatcher("/sanPhamYeuThich.jsp").forward(request, response);
    }
}
