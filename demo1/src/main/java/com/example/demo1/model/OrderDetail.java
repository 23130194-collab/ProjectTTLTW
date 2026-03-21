package com.example.demo1.model;

import java.util.List;

public class OrderDetail {
    private Order order;
    private User customer;
    private List<OrderItem> items;

    public OrderDetail() {
    }

    public OrderDetail(Order order, User customer, List<OrderItem> items) {
        this.order = order;
        this.customer = customer;
        this.items = items;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
}
