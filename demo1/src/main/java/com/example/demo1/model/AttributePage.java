package com.example.demo1.model;

import java.util.List;

public class AttributePage {
    private List<Attribute> attributes;
    private int totalAttributes;

    public AttributePage() {
    }

    public AttributePage(List<Attribute> attributes, int totalAttributes) {
        this.attributes = attributes;
        this.totalAttributes = totalAttributes;
    }

    public List<Attribute> getAttributes() {
        return attributes;
    }

    public int getTotalAttributes() {
        return totalAttributes;
    }

    public void setAttributes(List<Attribute> attributes) {
        this.attributes = attributes;
    }

    public void setTotalAttributes(int totalAttributes) {
        this.totalAttributes = totalAttributes;
    }
}
