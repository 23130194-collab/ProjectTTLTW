package com.example.demo1.dao;

import com.example.demo1.model.User;
import org.jdbi.v3.core.Jdbi;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class UserDao {
    private Jdbi jdbi = DatabaseDao.get();

    public User getUserByEmail(String email) {
        return jdbi.withHandle(h -> h.createQuery("SELECT * FROM users WHERE email = :email")
                .bind("email", email)
                .mapToBean(User.class)
                .stream().findFirst().orElse(null));
    }

    public void insertUser(String name, String email, String password) {
        jdbi.useHandle(h ->
                h.createUpdate("INSERT INTO users(name, email, password, role, status) VALUES (:name, :email, :password, :role, :status)")
                        .bind("name", name)
                        .bind("email", email)
                        .bind("password", password)
                        .bind("role", 0)
                        .bind("status", "unverified")
                        .execute()
        );
    }

    public void activateUser(int userId) {
        jdbi.useHandle(h ->
                h.createUpdate("UPDATE users SET status = 'active' WHERE id = :id")
                        .bind("id", userId)
                        .execute()
        );
    }

    public void updateUser(User user) {
        jdbi.useHandle(h ->
                h.createUpdate("UPDATE users SET name = :name, email = :email, phone = :phone, address = :address, gender = :gender, birthday = :birthday WHERE id = :id")
                        .bindBean(user)
                        .execute()
        );
    }


    public void updateUserStatus(int userId, String newStatus) {
        jdbi.useHandle(h ->
                h.createUpdate("UPDATE users SET status = :status WHERE id = :id")
                        .bind("status", newStatus)
                        .bind("id", userId)
                        .execute()
        );
    }

    public String getUserStatus(int userId) {
        return jdbi.withHandle(h ->
                h.createQuery("SELECT status FROM users WHERE id = :id")
                        .bind("id", userId)
                        .mapTo(String.class)
                        .one()
        );
    }

    public int countCustomersByFilter(String status, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role = 0");

        boolean hasStatus = status != null && !status.equals("all");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasStatus) {
            sql.append(" AND status = :status");
        }
        if (hasKeyword) {
            sql.append(" AND (name LIKE :keyword OR email LIKE :keyword)");
        }

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sql.toString());
            if (hasStatus) query.bind("status", status);
            if (hasKeyword) query.bind("keyword", "%" + keyword + "%");
            return query.mapTo(Integer.class).one();
        });
    }

    public List<User> getCustomersPaging(int limit, int offset, String status, String keyword) {
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT u.*, COUNT(o.id) as orderCount ");
        sql.append("FROM users u ");
        sql.append("LEFT JOIN orders o ON u.id = o.user_id ");
        sql.append("WHERE u.role = 0 ");

        boolean hasStatus = status != null && !status.equals("all");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasStatus) {
            sql.append("AND u.status = :status ");
        }
        if (hasKeyword) {
            sql.append("AND (u.name LIKE :keyword OR u.email LIKE :keyword) ");
        }

        sql.append("GROUP BY u.id ");
        sql.append("ORDER BY u.created_at DESC LIMIT :limit OFFSET :offset");

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sql.toString())
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (hasStatus) {
                query.bind("status", status);
            }

            if (hasKeyword) {
                query.bind("keyword", "%" + keyword + "%");
            }

            return query.mapToBean(User.class).list();
        });
    }

    public int getTotalCustomersCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE role = 0")
                        .mapTo(Integer.class)
                        .one()
        );
    }
}
