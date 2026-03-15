package com.example.demo1.service;

import com.example.demo1.dao.ProductDao;
import com.example.demo1.model.CartItem;
import com.example.demo1.model.Product;
import java.util.HashMap;
import java.util.Map;

public class CartService {
    private ProductDao productDao = new ProductDao();

    public void addToCart(Map<Integer, CartItem> cart, int productId, int quantity) {
        if (cart.containsKey(productId)) {
            CartItem item = cart.get(productId);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            Product p = productDao.getById(productId);
            if (p != null) {
                cart.put(productId, new CartItem(p, quantity));
            }
        }
    }

    public double calculateTotal(Map<Integer, CartItem> cart) {
        return cart.values().stream().mapToDouble(CartItem::getTotalPrice).sum();
    }

    public void updateQuantity(Map<Integer, CartItem> cart, int productId, int quantity) {
        if (cart.containsKey(productId)) {
            CartItem item = cart.get(productId);
            int newQty = item.getQuantity() + quantity;
            if (newQty > 0) {
                item.setQuantity(newQty);
            } else {
                cart.remove(productId);
            }
        }
    }


    public void removeItem(Map<Integer, CartItem> cart, int productId) {
        cart.remove(productId);
    }
}