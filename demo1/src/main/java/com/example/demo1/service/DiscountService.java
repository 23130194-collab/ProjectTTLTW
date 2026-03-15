package com.example.demo1.service;

import com.example.demo1.dao.DiscountDao;
import com.example.demo1.model.Discount;

import java.sql.Timestamp;

public class DiscountService {
    private final DiscountDao discountDao = new DiscountDao();

    public int createDiscount(Discount discount) {
        return discountDao.addDiscountAndReturnId(discount);
    }

    public void updateDiscount(int discountId, Double discountValue, Timestamp startTime, Timestamp endTime) {
        Discount discount = discountDao.getDiscountById(discountId);
        if (discount != null) {
            discount.setDiscountValue(discountValue);
            discount.setStartTime(startTime);
            discount.setEndTime(endTime);
            discountDao.updateDiscount(discount);
        }
    }

    public void deleteDiscount(int discountId) {
        discountDao.deleteDiscount(discountId);
    }
}
