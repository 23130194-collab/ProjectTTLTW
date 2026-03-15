package com.example.demo1.service;

import com.example.demo1.dao.*;
import com.example.demo1.model.*;
import java.util.*;
import java.sql.Timestamp;

public class ProductService {
    ProductDao pdao = new ProductDao();
    BrandDao bdao = new BrandDao();
    Product_SpecDao specDao = new Product_SpecDao();
    Product_ImageDao imgDao = new Product_ImageDao();
    ReviewDao reviewDao = new ReviewDao();
    DiscountService discountService = new DiscountService();
    Product_ImageService imageService = new Product_ImageService();

    public int createProduct(Product product, String mainImage, List<Product_Image> detailImages, Double discountValue, Timestamp discountStart, Timestamp discountEnd) {
        product.setImage(mainImage != null && !mainImage.isEmpty() ? mainImage : "https://png.pngtree.com/png-vector/20190223/ourmid/pngtree-vector-picture-icon-png-image_695350.jpg");

        Integer discountId = handleDiscount(null, discountValue, discountStart, discountEnd);
        product.setDiscountId(discountId);

        if (discountValue != null && discountValue > 0) {
            product.setPrice(product.getOldPrice() * (1.0 - (discountValue / 100.0)));
        } else {
            product.setPrice(product.getOldPrice());
        }

        int currentProductId = pdao.addProductAndReturnId(product);

        if (currentProductId > 0 && detailImages != null && !detailImages.isEmpty()) {
            imageService.addImages(currentProductId, detailImages);
        }

        return currentProductId;
    }

    public void updateProduct(Product product, String mainImage, List<Product_Image> detailImages, Double discountValue, Timestamp discountStart, Timestamp discountEnd) {
        Integer oldDiscountId = product.getDiscountId();

        if (mainImage != null) {
            product.setImage(mainImage);
        }

        Integer newDiscountId = handleDiscount(oldDiscountId, discountValue, discountStart, discountEnd);
        product.setDiscountId(newDiscountId);

        if (newDiscountId != null && discountValue != null) {
            product.setPrice(product.getOldPrice() * (1.0 - (discountValue / 100.0)));
        } else {
            product.setPrice(product.getOldPrice());
        }

        pdao.update(product);

        if (newDiscountId == null && oldDiscountId != null) {
            discountService.deleteDiscount(oldDiscountId);
        }

        imgDao.deleteImagesByProductId(product.getId());
        if (detailImages != null && !detailImages.isEmpty()) {
            imageService.addImages(product.getId(), detailImages);
        }
    }

    private Integer handleDiscount(Integer existingDiscountId, Double discountValue, Timestamp startTime, Timestamp endTime) {
        if (discountValue != null && discountValue > 0) {
            if (existingDiscountId != null && existingDiscountId > 0) {
                discountService.updateDiscount(existingDiscountId, discountValue, startTime, endTime);
                return existingDiscountId;
            } else {
                Discount newDiscount = new Discount();
                newDiscount.setDiscountValue(discountValue);
                newDiscount.setStartTime(startTime);
                newDiscount.setEndTime(endTime);
                return discountService.createDiscount(newDiscount);
            }
        }
        return null;
    }

    public Product getProduct(int id) {
        return pdao.getById(id);
    }

    public List<Product_Image> getProductImages(int productId) {
        return imgDao.getImagesByProductId(productId);
    }

    public boolean isProductNameExistsInCategory(String productName, int categoryId, int excludeProductId) {
        return pdao.isProductNameExistsInCategory(productName, categoryId, excludeProductId);
    }

    public void deleteProduct(int productId) {
        Product product = pdao.getById(productId);
        if (product != null) {
            product.setStatus("delete");
            pdao.update(product);
        }
    }

    public Product getPublicProduct(int id) {
        return pdao.getById(id, "active");
    }

    public Brand getBrand(int productId) { return bdao.getBrandByProductId(productId); }
    public List<Product_Spec> getProductSpecs(int productId) {
        List<Product_Spec> specs = specDao.getSpecsByProductId(productId);
        return (specs != null) ? specs : Collections.emptyList();
    }

    public ReviewSummary getReviewSummary(int productId) {
        Map<Integer, Integer> rawData = reviewDao.getRawStarCounts(productId);
        return new ReviewSummary(rawData);
    }
    public List<Product> getRelatedProducts(Product currentProduct) {
        List<Product> candidates = pdao.getRelatedProducts(currentProduct.getCategoryId(), currentProduct.getId(), 100, 0);
        if (candidates == null || candidates.isEmpty()) {
            return Collections.emptyList();
        }
        Collections.shuffle(candidates);
        return new ArrayList<>(candidates.subList(0, Math.min(candidates.size(), 3)));
    }
    public ProductPage filterAndSortProducts(Integer categoryId, String status, String keyword, Integer brandId, Map<Integer, List<String>> specFilters, String sortOrder, int page, int pageSize) {
        return pdao.filterAndSortProducts(categoryId, status, keyword, brandId, specFilters, sortOrder, page, pageSize);
    }

    public List<Product> getRandomProducts(int limit) {
        List<Product> products = pdao.getRandomProducts(limit);

        for (Product p : products) {
            ReviewSummary summary = getReviewSummary(p.getId());
            p.setAvgRating(summary.getAverageRating());

            if (p.getOldPrice() > p.getPrice()) {
                double diff = p.getOldPrice() - p.getPrice();
                double percent = (diff / p.getOldPrice()) * 100;
                p.setDiscountValue(percent);
            }
        }

        return products;
    }

    CategoryDao cdao = new CategoryDao();

    public Category getCategory(int categoryId) {
        return cdao.getById(categoryId);
    }
}
