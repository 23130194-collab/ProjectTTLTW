package com.example.demo1.dao;

import com.example.demo1.model.Brand;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class BrandDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Brand> getBrands(String keyword, int limit, int offset) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT id, name, logo, display_order, status FROM brands ";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "WHERE name LIKE :keyword ";
            }
            sql += "ORDER BY display_order ASC, id DESC LIMIT :limit OFFSET :offset";

            Query query = handle.createQuery(sql)
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }

            return query.mapToBean(Brand.class).list();
        });
    }

    public int countBrands(String keyword) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM brands ";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "WHERE name LIKE :keyword ";
            }
            Query query = handle.createQuery(sql);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            return query.mapTo(Integer.class).one();
        });
    }

    public Brand getBrandById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, logo, display_order, status FROM brands WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Brand.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public List<Brand> getAllBrands() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name, logo, display_order, status FROM brands ORDER BY display_order ASC")
                        .mapToBean(Brand.class)
                        .list()
        );
    }

    public List<Brand> getBrandsByCategoryId(int categoryId) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT DISTINCT b.id, b.name, b.logo, b.display_order, b.status " +
                                        "FROM brands b " +
                                        "JOIN products p ON b.id = p.brand_id " +
                                        "WHERE p.category_id = :categoryId AND b.status = 'Hoạt động' " +
                                        "ORDER BY b.display_order ASC"
                        )
                        .bind("categoryId", categoryId)
                        .mapToBean(Brand.class)
                        .list()
        );
    }

    public Brand getBrandByProductId(int productId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT b.* FROM brands b JOIN products p ON p.brand_id = b.id WHERE p.id = :productId")
                        .bind("productId", productId)
                        .mapToBean(Brand.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void deleteBrand(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM brands WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public boolean isBrandNameExists(String name, Integer id) {
        String sql = "SELECT COUNT(*) FROM brands WHERE name = :name";
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