package com.example.demo1.model;

public class ProductSuggestion {
    private int id;
    private String name;

    public ProductSuggestion(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public String getName() { return name; }
}
