package com.example.demo1.service;

import com.example.demo1.dao.FavoriteDao;
import com.example.demo1.model.Product;

import java.util.List;

public class FavoriteService {
    private FavoriteDao favoriteDao = new FavoriteDao();
    public List<Product> getFavoritesByUserId(int userId) {
        if (userId <= 0) return null;
        return favoriteDao.getFavoritesByUserId(userId);
    }
    public void removeFavorite(int userId, int productId) {
        if (userId > 0 && productId > 0) {
            favoriteDao.removeFavorite(userId, productId);
        }
    }
    public void addFavorite(int userId, int productId) {
        if (userId > 0 && productId > 0) {
            favoriteDao.addFavorite(userId, productId);
        }
    }
    public boolean isFavorite(int userId, int productId) {
        if (userId <= 0 || productId <= 0) return false;
        return favoriteDao.isFavorite(userId, productId);
    }
    public void deleteByProductId(int productId) {
        if (productId > 0) {
            favoriteDao.deleteByProductId(productId);
        }
    }
}