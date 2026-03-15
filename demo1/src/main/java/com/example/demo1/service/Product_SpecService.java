package com.example.demo1.service;

import com.example.demo1.dao.Product_SpecDao;

import java.util.List;

public class Product_SpecService {
    private Product_SpecDao dao = new Product_SpecDao();

    public List<String> getDistinctSpecValues(int categoryId, int attributeId) {
        return dao.getDistinctSpecValues(categoryId, attributeId);
    }
}
