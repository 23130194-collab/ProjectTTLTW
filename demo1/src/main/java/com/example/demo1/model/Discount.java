package com.example.demo1.model;

import java.sql.Timestamp;

public class Discount {
    private int id;
    private double discountValue;
    private Timestamp startTime;
    private Timestamp endTime;

    public Discount(int id, double discountValue, Timestamp startTime, Timestamp endTime) {
        this.id = id;
        this.discountValue = discountValue;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public Discount() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }
}
