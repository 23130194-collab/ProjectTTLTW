package com.example.demo1.service;

import com.example.demo1.dao.Product_ImageDao;
import com.example.demo1.model.Product_Image;

import java.util.List;

public class Product_ImageService {
    private final Product_ImageDao imageDao = new Product_ImageDao();

    public void addImages(int productId, List<Product_Image> images) {
        if (productId > 0 && images != null && !images.isEmpty()) {
            imageDao.addImagesForProduct(productId, images);
        }
    }
}
