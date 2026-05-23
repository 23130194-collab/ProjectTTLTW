package com.example.demo1.controller.cart;

import com.example.demo1.model.CartItem;
import com.example.demo1.model.User;
import com.example.demo1.service.CartService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class CartFilter implements Filter {
    private final CartService cartService = new CartService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                List<CartItem> cartItems = cartService.getCartItems(user.getId());

                httpRequest.setAttribute("cartItems", cartItems);
            }
        }

        chain.doFilter(request, response);
    }
}