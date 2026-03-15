package com.example.demo1.model;

public class Category {
    private int id;
    private String image;
    private String name;
    private int display_order;
    private String status;

    public Category(int id, String image, String name, int display_order, String status) {
        this.id = id;
        this.image = image;
        this.name = name;
        this.display_order = display_order;
        this.status = status;
    }

    public Category() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDisplay_order() {
        return display_order;
    }

    public void setDisplay_order(int display_order) {
        this.display_order = display_order;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
