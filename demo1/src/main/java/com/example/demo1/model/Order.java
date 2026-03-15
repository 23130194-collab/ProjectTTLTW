package com.example.demo1.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private Integer recipientInfoId;
    private String orderCode;
    private String orderStatus;
    private double subprice;
    private double discountAmount;
    private double shippingFee;
    private double totalAmount;
    private String notes;
    private Timestamp createdAt;
    private LocalDateTime updatedAt;
    private List<OrderItem> items;
    private RecipientInfo recipientInfo;

    public Order() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getRecipientInfoId() {
        return recipientInfoId;
    }

    public void setRecipientInfoId(Integer recipientInfoId) {
        this.recipientInfoId = recipientInfoId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public double getSubprice() {
        return subprice;
    }

    public void setSubprice(double subprice) {
        this.subprice = subprice;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public RecipientInfo getRecipientInfo() {
        return recipientInfo;
    }

    public void setRecipientInfo(RecipientInfo recipientInfo) {
        this.recipientInfo = recipientInfo;
    }
}
