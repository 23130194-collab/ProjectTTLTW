package com.example.demo1.model;

public class Product_Image {
    private int id;
    private int productId;
    private String image;
    private int displayOrder;

    public Product_Image(int id, int productId, String image, int displayOrder) {
        this.id = id;
        this.productId = productId;
        this.image = image;
        this.displayOrder = displayOrder;
    }

    public Product_Image() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
