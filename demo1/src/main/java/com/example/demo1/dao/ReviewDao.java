package com.example.demo1.dao;

import com.example.demo1.model.Review;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewDao {
    private Jdbi jdbi = DatabaseDao.get();
    private final String REVIEW_COLUMNS = "r.id, r.user_id, r.product_id, r.rating, r.content, r.created_at, r.status, ";
    private final String USER_PRODUCT_COLUMNS = "u.name AS userName, p.name AS productName, p.image as productImage ";
    private final String JOIN_TABLES = "FROM reviews r LEFT JOIN users u ON r.user_id = u.id LEFT JOIN products p ON r.product_id = p.id ";

    private final String BASE_SELECT = "SELECT r.id, r.user_id, r.product_id, r.rating, r.content, r.created_at, r.status, " +
            "COALESCE(u.name, 'Người dùng ẩn danh') as userName, " +
            "p.name as productName, p.image as productImage " +
            "FROM reviews r " +
            "LEFT JOIN users u ON r.user_id = u.id " +
            "LEFT JOIN products p ON r.product_id = p.id ";

    public List<Review> getAllReviewsForAdmin(String keyword, String status) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT " + REVIEW_COLUMNS + USER_PRODUCT_COLUMNS + JOIN_TABLES);
            boolean hasWhere = false;

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("WHERE (p.name LIKE :keyword OR u.name LIKE :keyword) ");
                hasWhere = true;
            }

            if (status != null && !status.trim().isEmpty()) {
                sql.append(hasWhere ? "AND " : "WHERE ");
                sql.append("r.status = :status ");
            }

            sql.append("ORDER BY r.created_at DESC");

            Query query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                query.bind("status", status);
            }

            return query.mapToBean(Review.class).list();
        });
    }

    public Review getReviewById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT " + REVIEW_COLUMNS + USER_PRODUCT_COLUMNS + JOIN_TABLES + "WHERE r.id = :id")
                        .bind("id", id)
                        .mapToBean(Review.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void updateReviewStatus(int reviewId, String status) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE reviews SET status = :status WHERE id = :id")
                        .bind("status", status)
                        .bind("id", reviewId)
                        .execute()
        );
    }

    public Map<Integer, Integer> getRawStarCounts(int productId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT rating, COUNT(*) as count FROM reviews WHERE product_id = :productId AND status LIKE '%active%' GROUP BY rating")
                        .bind("productId", productId)
                        .reduceRows(new HashMap<Integer, Integer>(), (map, row) -> {
                            map.put(row.getColumn("rating", Integer.class), row.getColumn("count", Integer.class));
                            return map;
                        })
        );
    }

    public List<Review> getReviewsWithFilterAndPagination(int productId, int ratingFilter, int limit, int offset, boolean forAdmin) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT r.*, COALESCE(u.name, 'Người dùng ẩn danh') AS userName ")
                    .append("FROM reviews r ")
                    .append("LEFT JOIN users u ON r.user_id = u.id ")
                    .append("WHERE r.product_id = :productId ");

            if (!forAdmin) {
                sql.append("AND r.status LIKE '%active%' ");
            }

            if (ratingFilter > 0) {
                sql.append("AND r.rating = :rating ");
            }

            sql.append("ORDER BY r.created_at DESC, r.id DESC LIMIT :limit OFFSET :offset");

            Query query = handle.createQuery(sql.toString())
                    .bind("productId", productId)
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (ratingFilter > 0) {
                query.bind("rating", ratingFilter);
            }

            return query.mapToBean(Review.class).list();
        });
    }

    public void addReview(int productId, int userId, int rating, String comment) {
        jdbi.useHandle(handle ->
                handle.createUpdate("INSERT INTO reviews (product_id, user_id, rating, content, created_at, status) VALUES (:productId, :userId, :rating, :content, NOW(), 'active')")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("rating", rating)
                        .bind("content", comment)
                        .execute()
        );
    }

    public List<Review> getReviewsByPage(int offset, int limit, String keyword, String status) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder(BASE_SELECT);
            boolean hasWhere = false;

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("WHERE (p.name LIKE :keyword OR u.name LIKE :keyword) ");
                hasWhere = true;
            }

            if (status != null && !status.trim().isEmpty()) {
                sql.append(hasWhere ? "AND " : "WHERE ");
                sql.append("r.status = :status ");
            }

            sql.append("ORDER BY r.created_at DESC LIMIT :limit OFFSET :offset");

            Query query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                query.bind("status", status);
            }
            query.bind("limit", limit);
            query.bind("offset", offset);

            return query.mapToBean(Review.class).list();
        });
    }

    public int getTotalReviewCount(String keyword, String status) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM reviews r ");
            sql.append("LEFT JOIN users u ON r.user_id = u.id ");
            sql.append("LEFT JOIN products p ON r.product_id = p.id ");
            boolean hasWhere = false;

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("WHERE (p.name LIKE :keyword OR u.name LIKE :keyword) ");
                hasWhere = true;
            }

            if (status != null && !status.trim().isEmpty()) {
                sql.append(hasWhere ? "AND " : "WHERE ");
                sql.append("r.status = :status ");
            }

            Query query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                query.bind("status", status);
            }

            return query.mapTo(Integer.class).one();
        });
    }
}
