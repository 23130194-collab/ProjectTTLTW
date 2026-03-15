package com.example.demo1.dao;

import com.example.demo1.model.Attribute;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class AttributeDao {

    private final Jdbi jdbi = DatabaseDao.get();

    public List<Attribute> getAttributes(String keyword, int categoryId, int limit, int offset) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT a.id, a.name, a.status, " +
                    "       ca.category_id AS categoryId, " +
                    "       ca.display_order AS displayOrder " +
                    "FROM attributes a " +
                    "LEFT JOIN category_attributes ca ON a.id = ca.attribute_id " +
                    "WHERE 1=1 ";

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

            if (hasKeyword) {
                sql += " AND a.name LIKE :keyword ";
            }

            if (categoryId > 0) {
                sql += " AND ca.category_id = :categoryId ";
            }

            sql += "ORDER BY a.id DESC LIMIT :limit OFFSET :offset";

            Query query = handle.createQuery(sql)
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (hasKeyword) {
                query.bind("keyword", "%" + keyword + "%");
            }

            if (categoryId > 0) {
                query.bind("categoryId", categoryId);
            }

            return query.mapToBean(Attribute.class).list();
        });
    }

    public int countAttributes(String keyword, int categoryId) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM attributes a " +
                    "LEFT JOIN category_attributes ca ON a.id = ca.attribute_id " +
                    "WHERE 1=1 ";

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            if (hasKeyword) {
                sql += " AND a.name LIKE :keyword ";
            }

            if (categoryId > 0) {
                sql += " AND ca.category_id = :categoryId ";
            }

            Query query = handle.createQuery(sql);

            if (hasKeyword) {
                query.bind("keyword", "%" + keyword + "%");
            }

            if (categoryId > 0) {
                query.bind("categoryId", categoryId);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public Attribute getAttributeById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT a.id, a.name, a.status, ca.category_id as categoryId, ca.display_order as displayOrder, ca.is_filterable as isFilterable " +
                                "FROM attributes a " +
                                "LEFT JOIN category_attributes ca ON a.id = ca.attribute_id " +
                                "WHERE a.id = :id")
                        .bind("id", id)
                        .mapToBean(Attribute.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public int addAttributeAndReturnId(Attribute attribute) {
        return jdbi.inTransaction(handle -> {
            int newAttrId = handle.createUpdate("INSERT INTO attributes (name, status) VALUES (:name, :status)")
                    .bindBean(attribute)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            if (attribute.getCategoryId() > 0) {
                handle.createUpdate("INSERT INTO category_attributes (attribute_id, category_id, display_order, is_filterable) " +
                                "VALUES (:attrId, :categoryId, :displayOrder, :isFilterable)")
                        .bind("attrId", newAttrId)
                        .bindBean(attribute)
                        .execute();
            }

            return newAttrId;
        });
    }

    public void updateAttribute(Attribute attribute) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE attributes SET name = :name, status = :status WHERE id = :id")
                        .bindBean(attribute)
                        .execute()
        );
    }

    public void deleteAttribute(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM attributes WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public boolean isAttributeExists(String name, int categoryId) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM attributes a " +
                    "JOIN category_attributes ca ON a.id = ca.attribute_id " +
                    "WHERE a.name = :name AND ca.category_id = :categoryId";

            int count = handle.createQuery(sql)
                    .bind("name", name)
                    .bind("categoryId", categoryId)
                    .mapTo(Integer.class)
                    .one();

            return count > 0;
        });
    }

    public boolean isDisplayOrderExists(int categoryId, int displayOrder, int excludeAttributeId) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM category_attributes " +
                    "WHERE category_id = :categoryId AND display_order = :displayOrder";

            if (excludeAttributeId > 0) {
                sql += " AND attribute_id != :excludeId";
            }

            int count = handle.createQuery(sql)
                    .bind("categoryId", categoryId)
                    .bind("displayOrder", displayOrder)
                    .bind("excludeId", excludeAttributeId)
                    .mapTo(Integer.class)
                    .one();

            return count > 0;
        });
    }

    public void shiftDisplayOrders(int categoryId, int fromOrder) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE category_attributes SET display_order = display_order + 1 " +
                                "WHERE category_id = :categoryId AND display_order >= :fromOrder")
                        .bind("categoryId", categoryId)
                        .bind("fromOrder", fromOrder)
                        .execute()
        );
    }
}