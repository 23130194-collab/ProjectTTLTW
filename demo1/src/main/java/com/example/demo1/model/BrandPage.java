package com.example.demo1.model;

import java.util.List;

public class BrandPage {
    private List<Brand> brands;
    private int totalBrands;

    public BrandPage(List<Brand> brands, int totalBrands) {
        this.brands = brands;
        this.totalBrands = totalBrands;
    }

    public List<Brand> getBrands() {
        return brands;
    }

    public int getTotalBrands() {
        return totalBrands;
    }
}
