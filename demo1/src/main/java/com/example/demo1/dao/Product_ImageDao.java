package com.example.demo1.dao;

import com.example.demo1.model.Product_Image;
import org.jdbi.v3.core.Jdbi;
import java.util.List;

public class Product_ImageDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Product_Image> getImagesByProductId(int productId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT " +
                                "id, " +
                                "product_id AS productId, " +
                                "image, " +
                                "display_order AS displayOrder " +
                                "FROM product_images " +
                                "WHERE product_id = :pid " +
                                "ORDER BY display_order ASC")
                        .bind("pid", productId)
                        .mapToBean(Product_Image.class)
                        .list()
        );
    }

    public void addImagesForProduct(int productId, List<Product_Image> images) {
        if (images == null || images.isEmpty()) {
            return;
        }
        jdbi.useHandle(handle -> {
            var batch = handle.prepareBatch("INSERT INTO product_images (product_id, image, display_order) VALUES (:productId, :image, :displayOrder)");
            for (Product_Image img : images) {
                batch.bind("productId", productId)
                     .bind("image", img.getImage())
                     .bind("displayOrder", img.getDisplayOrder())
                     .add();
            }
            batch.execute();
        });
    }

    public void deleteImagesByProductId(int productId) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM product_images WHERE product_id = :productId")
                        .bind("productId", productId)
                        .execute()
        );
    }
}
