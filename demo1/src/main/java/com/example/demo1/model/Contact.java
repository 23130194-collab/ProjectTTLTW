package com.example.demo1.model;

import java.sql.Timestamp;

public class Contact {
    private int id;
    private String name;
    private String email;
    private String content;
    private Timestamp createdAt;

    public Contact() {
    }

    public Contact(String name, String email, String content) {
        this.name = name;
        this.email = email;
        this.content = content;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
