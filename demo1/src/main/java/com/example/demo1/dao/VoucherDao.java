package com.example.demo1.dao;

import com.example.demo1.model.Voucher;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class VoucherDao {
    private final Jdbi jdbi = DatabaseDao.get();

    public List<Voucher> getVouchers(String keyword, String filterStatus, int limit, int offset) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT * FROM vouchers WHERE 1 = 1 ";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "AND code LIKE :keyword ";
            }
            if ("active".equals(filterStatus)) {
                sql += "AND status = 'ACTIVE' AND used_count < quantity AND end_date >= NOW() ";
            } else if ("inactive".equals(filterStatus)) {
                sql += "AND status = 'INACTIVE' ";
            } else if ("exhausted".equals(filterStatus)) {
                sql += "AND used_count >= quantity ";
            } else if ("expired".equals(filterStatus)) {
                sql += "AND end_date < NOW() ";
            }
            sql += "ORDER BY created_at DESC, id DESC LIMIT :limit OFFSET :offset";

            Query query = handle.createQuery(sql)
                    .bind("limit", limit)
                    .bind("offset", offset);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            return query.mapToBean(Voucher.class).list();
        });
    }

    public int countVouchers(String keyword, String filterStatus) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM vouchers WHERE 1 = 1 ";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "AND code LIKE :keyword ";
            }
            if ("active".equals(filterStatus)) {
                sql += "AND status = 'ACTIVE' AND used_count < quantity AND end_date >= NOW() ";
            } else if ("inactive".equals(filterStatus)) {
                sql += "AND status = 'INACTIVE' ";
            } else if ("exhausted".equals(filterStatus)) {
                sql += "AND used_count >= quantity ";
            } else if ("expired".equals(filterStatus)) {
                sql += "AND end_date < NOW() ";
            }
            Query query = handle.createQuery(sql);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            return query.mapTo(Integer.class).one();
        });
    }

    public Voucher getVoucherById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM vouchers WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Voucher.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean isCodeExists(String code, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM vouchers WHERE code = :code";
        if (excludeId != null) {
            sql += " AND id <> :id";
        }
        final String finalSql = sql;
        return jdbi.withHandle(handle -> {
            Query query = handle.createQuery(finalSql).bind("code", code);
            if (excludeId != null) {
                query.bind("id", excludeId);
            }
            return query.mapTo(Integer.class).one() > 0;
        });
    }

    public void saveVoucher(Voucher voucher) {
        if (voucher.getId() == 0) {
            jdbi.useHandle(handle ->
                    handle.createUpdate("INSERT INTO vouchers (code, discount_value, start_date, end_date, status, quantity, min_order_value, description) " +
                                    "VALUES (:code, :discountValue, :startDate, :endDate, :status, :quantity, :minOrderValue, :description)")
                            .bindBean(voucher)
                            .execute()
            );
            return;
        }

        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE vouchers SET code = :code, discount_value = :discountValue, " +
                                "start_date = :startDate, end_date = :endDate, status = :status, " +
                                "quantity = :quantity, min_order_value = :minOrderValue, description = :description WHERE id = :id")
                        .bindBean(voucher)
                        .execute()
        );
    }

    public void deleteVoucher(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM vouchers WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public List<Voucher> getActiveVouchersForUser(int userId) {
        String sql = "SELECT v.*, uv.id IS NOT NULL AS saved, COALESCE(uv.is_used, 0) AS used " +
                "FROM vouchers v " +
                "LEFT JOIN user_vouchers uv ON uv.voucher_id = v.id AND uv.user_id = :userId " +
                "WHERE v.status = 'ACTIVE' AND NOW() BETWEEN v.start_date AND v.end_date AND v.used_count < v.quantity " +
                "ORDER BY v.end_date ASC, v.discount_value DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public List<Voucher> getSavedUsableVouchers(int userId) {
        String sql = "SELECT v.*, TRUE AS saved, uv.is_used AS used " +
                "FROM user_vouchers uv " +
                "JOIN vouchers v ON v.id = uv.voucher_id " +
                "WHERE uv.user_id = :userId AND uv.is_used = FALSE " +
                "AND v.status = 'ACTIVE' AND NOW() BETWEEN v.start_date AND v.end_date AND v.used_count < v.quantity " +
                "ORDER BY v.end_date ASC, v.discount_value DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public boolean saveVoucherForUser(int userId, int voucherId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("INSERT IGNORE INTO user_vouchers (user_id, voucher_id) VALUES (:userId, :voucherId)")
                        .bind("userId", userId)
                        .bind("voucherId", voucherId)
                        .execute() > 0
        );
    }

    public Voucher getUsableSavedVoucher(int userId, int voucherId) {
        String sql = "SELECT v.*, TRUE AS saved, uv.is_used AS used " +
                "FROM user_vouchers uv " +
                "JOIN vouchers v ON v.id = uv.voucher_id " +
                "WHERE uv.user_id = :userId AND uv.voucher_id = :voucherId AND uv.is_used = FALSE " +
                "AND v.status = 'ACTIVE' AND NOW() BETWEEN v.start_date AND v.end_date AND v.used_count < v.quantity";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("voucherId", voucherId)
                        .mapToBean(Voucher.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void markVoucherUsed(int userId, int voucherId, int orderId) {
        jdbi.useTransaction(handle -> {
            int updated = handle.createUpdate("UPDATE user_vouchers SET is_used = TRUE, used_at = NOW(), order_id = :orderId " +
                            "WHERE user_id = :userId AND voucher_id = :voucherId AND is_used = FALSE")
                    .bind("userId", userId)
                    .bind("voucherId", voucherId)
                    .bind("orderId", orderId)
                    .execute();
            
            if (updated > 0) {
                handle.createUpdate("UPDATE vouchers SET used_count = used_count + 1 WHERE id = :voucherId")
                        .bind("voucherId", voucherId)
                        .execute();
            }
        });
    }
}
