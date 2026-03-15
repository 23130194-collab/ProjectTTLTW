package com.example.demo1.service;

import com.example.demo1.dao.AttributeDao;
import com.example.demo1.dao.CategoryAttributeDao;
import com.example.demo1.model.Attribute;
import com.example.demo1.model.AttributePage;
import com.example.demo1.model.Category_Attribute;

import java.util.List;

public class AttributeService {
    private final AttributeDao attributeDao;
    private final CategoryAttributeDao categoryAttributeDao;

    public AttributeService() {
        this.attributeDao = new AttributeDao();
        this.categoryAttributeDao = new CategoryAttributeDao();
    }

    public void createAttributeForCategory(String name, String status, int categoryId, int displayOrder, int isFilterable) {
        Attribute attribute = new Attribute();
        attribute.setName(name);
        attribute.setStatus(status);
        int newAttributeId = attributeDao.addAttributeAndReturnId(attribute);

        Category_Attribute categoryAttribute = new Category_Attribute();
        categoryAttribute.setCategory_id(categoryId);
        categoryAttribute.setAttribute_id(newAttributeId);
        categoryAttribute.setDisplay_order(displayOrder);
        categoryAttribute.setIs_filterable(isFilterable);
        categoryAttributeDao.addCategoryAttribute(categoryAttribute);
    }

    public void updateAttributeAndCategoryLink(int attributeId, String name, String status, int categoryId, int displayOrder, int isFilterable) {
        Attribute attribute = new Attribute();
        attribute.setId(attributeId);
        attribute.setName(name);
        attribute.setStatus(status);
        attributeDao.updateAttribute(attribute);

        Category_Attribute categoryAttribute = new Category_Attribute();
        categoryAttribute.setAttribute_id(attributeId);
        categoryAttribute.setCategory_id(categoryId);
        categoryAttribute.setDisplay_order(displayOrder);
        categoryAttribute.setIs_filterable(isFilterable);
        categoryAttributeDao.updateCategoryAttribute(categoryAttribute);
    }

    public List<Attribute> getAttributes(String keyword, int categoryId, int limit, int offset) {
        return attributeDao.getAttributes(keyword, categoryId, limit, offset);
    }

    public int countAttributes(String keyword, int categoryId) {
        return attributeDao.countAttributes(keyword, categoryId);
    }

    public void deleteAttribute(int attributeId) {
        categoryAttributeDao.deleteByAttributeId(attributeId);
        attributeDao.deleteAttribute(attributeId);
    }

    public Attribute getAttributeById(int id) {
        return attributeDao.getAttributeById(id);
    }

    public AttributePage getPaginatedAttributes(String keyword, int categoryId, int limit, int offset) {
        List<Attribute> attributes = attributeDao.getAttributes(keyword, categoryId, limit, offset);

        int totalAttributes = attributeDao.countAttributes(keyword, categoryId);

        return new AttributePage(attributes, totalAttributes);
    }

    public boolean isAttributeExists(String name, int categoryId) {
        return attributeDao.isAttributeExists(name, categoryId);
    }

    public boolean isDisplayOrderExists(int categoryId, int displayOrder, int excludeAttributeId) {
        return attributeDao.isDisplayOrderExists(categoryId, displayOrder, excludeAttributeId);
    }

    public void shiftDisplayOrders(int categoryId, int fromOrder) {
        attributeDao.shiftDisplayOrders(categoryId, fromOrder);
    }
}
