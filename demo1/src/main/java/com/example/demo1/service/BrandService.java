package com.example.demo1.service;

import com.example.demo1.dao.BrandDao;
import com.example.demo1.dao.DatabaseDao;
import com.example.demo1.dao.ProductDao;
import com.example.demo1.model.Brand;
import com.example.demo1.model.BrandPage;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BrandService {
    private final BrandDao brandDao = new BrandDao();
    private final ProductDao productDao = new ProductDao();
    private final Jdbi jdbi = DatabaseDao.get();

    public BrandPage getPagedBrands(String keyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Brand> brands = brandDao.getBrands(keyword, pageSize, offset);
        int totalBrands = brandDao.countBrands(keyword);
        return new BrandPage(brands, totalBrands);
    }

    public Brand getBrandById(int id) {
        return brandDao.getBrandById(id);
    }

    public List<Brand> getBrandsByCategoryId(int categoryId) {
        return brandDao.getBrandsByCategoryId(categoryId);
    }

    public List<Brand> getAllBrands() {
        return brandDao.getAllBrands();
    }

    public void saveBrand(Brand brand) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("UPDATE brands SET display_order = display_order + 1 WHERE display_order >= :displayOrder")
                    .bind("displayOrder", brand.getDisplayOrder())
                    .execute();

            if (brand.getId() == 0) {
                handle.createUpdate("INSERT INTO brands (name, logo, display_order, status) VALUES (:name, :logo, :displayOrder, :status)")
                        .bindBean(brand)
                        .execute();
            } else {
                handle.createUpdate("UPDATE brands SET name = :name, logo = :logo, display_order = :displayOrder, status = :status WHERE id = :id")
                        .bindBean(brand)
                        .execute();
            }
        });
    }

    public boolean deleteBrand(int id) {
        int productCount = productDao.countProductsByBrandId(id);
        if (productCount > 0) {
            return false;
        }
        brandDao.deleteBrand(id);
        return true;
    }

    public boolean isBrandNameExists(String name, Integer id) {
        return brandDao.isBrandNameExists(name, id);
    }
}
