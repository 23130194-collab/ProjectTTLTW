package com.example.demo1.model;

public class Product_Spec {
    private int id;
    private int productId;
    private int attributeId;
    private String attributeName;
    private String specValue;

    public Product_Spec(int id, int productId, int attributeId, String attributeName, String specValue) {
        this.id = id;
        this.productId = productId;
        this.attributeId = attributeId;
        this.attributeName = attributeName;
        this.specValue = specValue;
    }

    public Product_Spec() {
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

    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getSpecValue() {
        return specValue;
    }

    public void setSpecValue(String specValue) {
        this.specValue = specValue;
    }
}
