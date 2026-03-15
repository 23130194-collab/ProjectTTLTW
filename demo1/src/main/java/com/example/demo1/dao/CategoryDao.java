package com.example.demo1.dao;

import com.example.demo1.model.Category;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class CategoryDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Category> getAll() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, display_order, image, status FROM categories ORDER BY display_order")
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public List<Category> getActiveCategories() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, display_order, image, status FROM categories WHERE status = 'active' ORDER BY display_order")
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public Category getById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, display_order, image, status FROM categories WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Category.class)
                        .findOne()
        ).orElse(null);
    }

    public void addCategory(String name, int displayOrder, String image, String status) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("UPDATE categories SET display_order = display_order + 1 WHERE display_order >= :displayOrder")
                    .bind("displayOrder", displayOrder)
                    .execute();

            handle.createUpdate("INSERT INTO categories (name, display_order, image, status) VALUES (:name, :displayOrder, :image, :status)")
                    .bind("name", name)
                    .bind("displayOrder", displayOrder)
                    .bind("image", image)
                    .bind("status", status)
                    .execute();
        });
    }

    public List<Category> searchByName(String keyword) {
        String searchQuery = "%" + keyword + "%";
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, display_order, image, status FROM categories WHERE name LIKE :keyword ORDER BY display_order")
                        .bind("keyword", searchQuery)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public void updateCategory(Category category) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("UPDATE categories SET display_order = display_order + 1 WHERE display_order >= :displayOrder")
                    .bind("displayOrder", category.getDisplay_order())
                    .execute();

            handle.createUpdate("UPDATE categories SET name = :name, display_order = :display_order, image = :image, status = :status WHERE id = :id")
                    .bindBean(category)
                    .execute();
        });
    }

    public void deleteCategory(int id) {
        jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM categories WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public boolean isCategoryNameExists(String name, Integer id) {
        String sql = "SELECT COUNT(*) FROM categories WHERE name = :name";
        if (id != null) {
            sql += " AND id != :id";
        }
        final String finalSql = sql;
        return jdbi.withHandle(handle -> {
            Query query = handle.createQuery(finalSql);
            query.bind("name", name);
            if (id != null) {
                query.bind("id", id);
            }
            return query.mapTo(Integer.class).one() > 0;
        });
    }
}
