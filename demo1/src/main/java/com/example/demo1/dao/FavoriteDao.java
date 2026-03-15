package com.example.demo1.dao;

import com.example.demo1.model.Product;
import org.jdbi.v3.core.Jdbi;
import java.util.List;

public class FavoriteDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Product> getFavoritesByUserId(int userId) {
        String sql = "SELECT p.* FROM products p JOIN favorites f ON p.id = f.product_id WHERE f.user_id = :userId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void removeFavorite(int userId, int productId) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM favorites WHERE user_id = :userId AND product_id = :productId")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        );
    }
    public void addFavorite(int userId, int productId) {
        String sql = "INSERT IGNORE INTO favorites (user_id, product_id) VALUES (:userId, :productId)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        );
    }

    public boolean isFavorite(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM favorites WHERE user_id = :userId AND product_id = :productId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }


}
