package com.example.demo1.dao;

import com.example.demo1.model.Attribute;
import com.example.demo1.model.Category_Attribute;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class CategoryAttributeDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Attribute> getFilterableAttributesByCategoryId(int categoryId) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT a.id, a.name, a.status, ca.display_order, ca.is_filterable " +
                                        "FROM attributes a " +
                                        "JOIN category_attributes ca ON a.id = ca.attribute_id " +
                                        "WHERE ca.category_id = :categoryId AND a.status = 'active' AND ca.is_filterable = 1 " +
                                        "ORDER BY ca.display_order ASC"
                        )
                        .bind("categoryId", categoryId)
                        .mapToBean(Attribute.class)
                        .list()
        );
    }

    public List<Attribute> getAllAttributesByCategoryId(int categoryId) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT a.id, a.name, a.status, ca.display_order, ca.is_filterable " +
                                        "FROM attributes a " +
                                        "JOIN category_attributes ca ON a.id = ca.attribute_id " +
                                        "WHERE ca.category_id = :categoryId AND a.status = 'active' " +
                                        "ORDER BY ca.display_order ASC"
                        )
                        .bind("categoryId", categoryId)
                        .mapToBean(Attribute.class)
                        .list()
        );
    }

    public void addCategoryAttribute(Category_Attribute ca) {
        jdbi.useHandle(handle ->
                handle.createUpdate(
                                "INSERT INTO category_attributes (category_id, attribute_id, is_filterable, display_order) " +
                                        "VALUES (:category_id, :attribute_id, :is_filterable, :display_order)"
                        )
                        .bindBean(ca)
                        .execute()
        );
    }

    public void updateCategoryAttribute(Category_Attribute ca) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE category_attributes " +
                                "SET category_id = :category_id, is_filterable = :is_filterable, display_order = :display_order " +
                                "WHERE attribute_id = :attribute_id")
                        .bindBean(ca)
                        .execute()
        );
    }

    public void deleteByAttributeId(int attributeId) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM category_attributes WHERE attribute_id = :attributeId")
                        .bind("attributeId", attributeId)
                        .execute()
        );
    }
}
