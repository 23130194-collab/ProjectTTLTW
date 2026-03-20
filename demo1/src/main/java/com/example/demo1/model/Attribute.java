package com.example.demo1.model;

public class Attribute {
    private int id;
    private String name;
    private String status;
    private int categoryId;
    private int displayOrder;
    private int isFilterable;

    public Attribute() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public int getIsFilterable() {
        return isFilterable;
    }

    public void setIsFilterable(int isFilterable) {
        this.isFilterable = isFilterable;
    }
}
