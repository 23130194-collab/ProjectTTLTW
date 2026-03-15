package com.example.demo1.model;

public class Category_Attribute {
    private int id;
    private int category_id;
    private int attribute_id;
    private int is_filterable;
    private int display_order;

    public Category_Attribute(int id, int category_id, int attribute_id, int is_filterable, int display_order) {
        this.id = id;
        this.category_id = category_id;
        this.attribute_id = attribute_id;
        this.is_filterable = is_filterable;
        this.display_order = display_order;
    }

    public Category_Attribute() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public int getAttribute_id() {
        return attribute_id;
    }

    public void setAttribute_id(int attribute_id) {
        this.attribute_id = attribute_id;
    }

    public int getIs_filterable() {
        return is_filterable;
    }

    public void setIs_filterable(int is_filterable) {
        this.is_filterable = is_filterable;
    }

    public int getDisplay_order() {
        return display_order;
    }

    public void setDisplay_order(int display_order) {
        this.display_order = display_order;
    }
}
