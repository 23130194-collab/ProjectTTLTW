package com.example.demo1.model;

import java.util.List;

public class OrderPage {
    private List<Order> orders;
    private int totalOrders;

    public OrderPage(List<Order> orders, int totalOrders) {
        this.orders = orders;
        this.totalOrders = totalOrders;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }
}
