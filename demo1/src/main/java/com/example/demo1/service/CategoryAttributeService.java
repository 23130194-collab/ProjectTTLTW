package com.example.demo1.service;

import com.example.demo1.dao.CategoryAttributeDao;
import com.example.demo1.model.Attribute;

import java.util.List;

public class CategoryAttributeService {
    private CategoryAttributeDao dao = new CategoryAttributeDao();

    public List<Attribute> getFilterableAttributesByCategoryId(int categoryId) {
        return dao.getFilterableAttributesByCategoryId(categoryId);
    }

    public List<Attribute> getAllAttributesByCategoryId(int categoryId) {
        return dao.getAllAttributesByCategoryId(categoryId);
    }
}
