package com.example.demo1.dao;

import com.example.demo1.model.Discount;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.StatementContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;

public class DiscountDao {
    private final Jdbi jdbi = DatabaseDao.get();

    public static class DiscountMapper implements RowMapper<Discount> {
        @Override
        public Discount map(ResultSet rs, StatementContext ctx) throws SQLException {
            Discount discount = new Discount();
            discount.setId(rs.getInt("id"));
            discount.setDiscountValue(rs.getDouble("discount_value"));
            discount.setStartTime(rs.getTimestamp("start_time"));
            discount.setEndTime(rs.getTimestamp("end_time"));
            return discount;
        }
    }

    public int addDiscountAndReturnId(Discount discount) {
        return jdbi.withHandle(handle -> {
            String sql = "INSERT INTO discounts (discount_value, start_time, end_time) VALUES (:discountValue, :startTime, :endTime)";
            return handle.createUpdate(sql)
                    .bindBean(discount)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public Discount getDiscountById(int discountId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM discounts WHERE id = :id")
                        .bind("id", discountId)
                        .map(new DiscountMapper())
                        .findOne()
                        .orElse(null)
        );
    }

    public void updateDiscount(Discount discount) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE discounts SET discount_value = :discountValue, start_time = :startTime, end_time = :endTime WHERE id = :id")
                        .bindBean(discount)
                        .execute()
        );
    }

    public void deleteDiscount(int discountId) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM discounts WHERE id = :id")
                        .bind("id", discountId)
                        .execute()
        );
    }
}
