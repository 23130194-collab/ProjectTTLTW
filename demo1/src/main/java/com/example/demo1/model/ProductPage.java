package com.example.demo1.model;

import java.util.List;

public class ProductPage {
    private final List<Product> products;
    private final int totalProducts;

    public ProductPage(List<Product> products, int totalProducts) {
        this.products = products;
        this.totalProducts = totalProducts;
    }

    public List<Product> getProducts() {
        return products;
    }

    public int getTotalProducts() {
        return totalProducts;
    }
}
