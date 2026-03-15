package com.example.demo1.service;

import com.example.demo1.dao.CategoryDao;
import com.example.demo1.dao.ProductDao;
import com.example.demo1.model.Category;

import java.util.List;

public class CategoryService {
    private final CategoryDao categoryDao = new CategoryDao();
    private final ProductDao productDao = new ProductDao();

    public List<Category> getAllCategories() {
        return categoryDao.getAll();
    }

    public List<Category> getActiveCategories() {
        return categoryDao.getActiveCategories();
    }

    public Category getCategoryById(int id) {
        return categoryDao.getById(id);
    }

    public void addCategory(String name, int displayOrder, String image, String status) {
        categoryDao.addCategory(name, displayOrder, image, status);
    }

    public List<Category> searchCategories(String keyword) {
        return categoryDao.searchByName(keyword);
    }

    public void updateCategory(Category category) {
        categoryDao.updateCategory(category);
    }

    public boolean deleteCategory(int id) {
        int productCount = productDao.countProductsByCategoryId(id);
        if (productCount > 0) {
            return false;
        }
        categoryDao.deleteCategory(id);
        return true;
    }

    public boolean isCategoryNameExists(String name, Integer id) {
        return categoryDao.isCategoryNameExists(name, id);
    }
}
