package com.example.demo1.dao;

import com.example.demo1.model.CartItem;
import com.example.demo1.model.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CartDao {

    private final Jdbi jdbi = DatabaseDao.get();

    public int getOrCreateCartId(int userId) {
        try {
            return jdbi.inTransaction(handle -> {
                Optional<Integer> existingCartId = handle.createQuery("SELECT id FROM cart WHERE user_id = :userId")
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .findOne();

                if (existingCartId.isPresent()) {
                    return existingCartId.get();
                }

                return handle.createUpdate("INSERT INTO cart (user_id) VALUES (:userId)")
                        .bind("userId", userId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();
            });
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<CartItem> getCartItems(int userId) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return new ArrayList<>();

            String sql = "SELECT p.id, p.name, p.price, p.old_price, p.stock, p.image, ci.quantity " +
                    "FROM cart_items ci " +
                    "JOIN products p ON ci.product_id = p.id " +
                    "WHERE ci.cart_id = :cartId";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("cartId", cartId)
                            .map((rs, ctx) -> {
                                Product p = new Product();
                                p.setId(rs.getInt("id"));
                                p.setName(rs.getString("name"));
                                p.setPrice(rs.getDouble("price"));
                                p.setOldPrice(rs.getDouble("old_price"));
                                p.setStock(rs.getInt("stock"));
                                p.setImage(rs.getString("image"));

                                int quantity = rs.getInt("quantity");
                                return new CartItem(p, quantity);
                            }).list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void addItem(int userId, int productId, int quantity) {
        try {
            int cartId = getOrCreateCartId(userId);

            String sql = "INSERT INTO cart_items (cart_id, product_id, quantity) " +
                    "VALUES (:cartId, :productId, :quantity) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + :quantity";

            jdbi.useTransaction(handle ->
                    handle.createUpdate(sql)
                            .bind("cartId", cartId)
                            .bind("productId", productId)
                            .bind("quantity", quantity)
                            .execute()
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateItemQuantity(int userId, int productId, int delta) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return;

            jdbi.useTransaction(handle -> {
                handle.createUpdate("UPDATE cart_items SET quantity = quantity + :delta WHERE cart_id = :cartId AND product_id = :productId")
                        .bind("delta", delta)
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .execute();

                handle.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId AND product_id = :productId AND quantity <= 0")
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .execute();
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeItem(int userId, int productId) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return;

            jdbi.useTransaction(handle ->
                    handle.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId AND product_id = :productId")
                            .bind("cartId", cartId)
                            .bind("productId", productId)
                            .execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void clearCart(int userId) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return;

            jdbi.useTransaction(handle ->
                    handle.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId")
                            .bind("cartId", cartId)
                            .execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int countItems(int userId) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return 0;

            return jdbi.withHandle(handle ->
                    handle.createQuery("SELECT COUNT(product_id) FROM cart_items WHERE cart_id = :cartId")
                            .bind("cartId", cartId)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double calculateTotal(int userId) {
        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) return 0.0;

            return jdbi.withHandle(handle ->
                    handle.createQuery("SELECT SUM(p.price * ci.quantity) FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = :cartId")
                            .bind("cartId", cartId)
                            .mapTo(Double.class)
                            .findOne()
                            .orElse(0.0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
}