package com.example.demo1.service;

import com.example.demo1.dao.VoucherDao;
import com.example.demo1.model.Voucher;

import java.util.List;

public class VoucherService {
    private final VoucherDao voucherDao = new VoucherDao();

    public List<Voucher> getVouchers(String keyword, String filterStatus, int page, int pageSize) {
        return voucherDao.getVouchers(keyword, filterStatus, pageSize, (page - 1) * pageSize);
    }

    public int countVouchers(String keyword, String filterStatus) {
        return voucherDao.countVouchers(keyword, filterStatus);
    }

    public Voucher getVoucherById(int id) {
        return voucherDao.getVoucherById(id);
    }

    public void saveVoucher(Voucher voucher) {
        voucherDao.saveVoucher(voucher);
    }

    public void deleteVoucher(int id) {
        voucherDao.deleteVoucher(id);
    }

    public boolean isCodeExists(String code, Integer excludeId) {
        return voucherDao.isCodeExists(code, excludeId);
    }

    public List<Voucher> getActiveVouchersForUser(int userId) {
        return voucherDao.getActiveVouchersForUser(userId);
    }

    public List<Voucher> getSavedUsableVouchers(int userId) {
        return voucherDao.getSavedUsableVouchers(userId);
    }

    public boolean saveVoucherForUser(int userId, int voucherId) {
        Voucher voucher = voucherDao.getVoucherById(voucherId);
        if (voucher == null || !"ACTIVE".equals(voucher.getStatus())) {
            return false;
        }
        return voucherDao.saveVoucherForUser(userId, voucherId);
    }

    public Voucher getUsableSavedVoucher(int userId, int voucherId) {
        return voucherDao.getUsableSavedVoucher(userId, voucherId);
    }

    public double calculateDiscount(Voucher voucher, double orderAmount) {
        if (voucher == null || orderAmount <= 0 || orderAmount < voucher.getMinOrderValue()) {
            return 0;
        }
        return Math.min(voucher.getDiscountValue(), orderAmount);
    }

    public void markVoucherUsed(int userId, int voucherId, int orderId) {
        voucherDao.markVoucherUsed(userId, voucherId, orderId);
    }
}
