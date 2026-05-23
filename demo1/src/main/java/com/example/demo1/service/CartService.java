package com.example.demo1.service;

import com.example.demo1.dao.CartDao;
import com.example.demo1.model.CartItem;
import java.util.List;

public class CartService {
    private final CartDao cartDao = new CartDao();

    public void addToCart(int userId, int productId, int quantity) {
        cartDao.addItem(userId, productId, quantity);
    }

    public double calculateTotal(int userId) {
        return cartDao.calculateTotal(userId);
    }

    public void updateQuantity(int userId, int productId, int quantity) {
        cartDao.updateItemQuantity(userId, productId, quantity);
    }

    public void removeItem(int userId, int productId) {
        cartDao.removeItem(userId, productId);
    }

    public List<CartItem> getCartItems(int userId) {
        return cartDao.getCartItems(userId);
    }

    public int countItems(int userId) {
        return cartDao.countItems(userId);
    }

    public void clearCart(int userId) {
        cartDao.clearCart(userId);
    }
}