package com.example.demo1.dao;

import com.example.demo1.model.*;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public class OrderDao {
    private Jdbi jdbi = DatabaseDao.get();

    public List<Order> getAllOrders(int page, int pageSize) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders ORDER BY order_code DESC LIMIT :limit OFFSET :offset")
                        .bind("limit", pageSize)
                        .bind("offset", (page - 1) * pageSize)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public int getTotalOrderCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public OrderDetail getOrderDetailById(int orderId) {
        Order order = getOrderById(orderId);
        if (order == null) {
            return null;
        }
        User customer = jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE id = :userId")
                        .bind("userId", order.getUserId())
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
        List<OrderItem> items = getOrderItemsByOrderId(orderId);
        return new OrderDetail(order, customer, items);
    }

    public Order getOrderById(int orderId) {
        Order order = jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE id = :orderId")
                        .bind("orderId", orderId)
                        .mapToBean(Order.class)
                        .findOne()
                        .orElse(null)
        );

        if (order != null) {
            RecipientInfo recipientInfo = getRecipientInfoByOrderId(orderId);
            order.setRecipientInfo(recipientInfo);
        }

        return order;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        String query = "SELECT od.id, od.order_id, od.product_id, od.quantity, " +
                "od.original_price, od.unit_price, p.name as productName, p.image as productImage " +
                "FROM order_details od JOIN products p ON od.product_id = p.id " +
                "WHERE od.order_id = :orderId";

        return jdbi.withHandle(handle -> {
            handle.registerRowMapper(BeanMapper.factory(OrderItem.class));
            return handle.createQuery(query)
                    .bind("orderId", orderId)
                    .mapTo(OrderItem.class)
                    .list();
        });
    }

    public boolean updateOrderStatus(int orderId, String status) {
        int updatedRows = jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE orders SET order_status = :status WHERE id = :orderId")
                        .bind("status", status)
                        .bind("orderId", orderId)
                        .execute()
        );
        return updatedRows > 0;
    }

    public void updateOrderTotals(int orderId, double subprice, double discountAmount, double totalAmount) {
        jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE orders SET subprice = :subprice, discount_amount = :discountAmount, total_amount = :totalAmount WHERE id = :orderId")
                        .bind("orderId", orderId)
                        .bind("subprice", subprice)
                        .bind("discountAmount", discountAmount)
                        .bind("totalAmount", totalAmount)
                        .execute()
        );
    }

    public List<Order> searchOrders(String keyword, int page, int pageSize) {
        String searchKeyword = "%" + keyword + "%";
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE order_code LIKE :keyword ORDER BY order_code DESC LIMIT :limit OFFSET :offset")
                        .bind("keyword", searchKeyword)
                        .bind("limit", pageSize)
                        .bind("offset", (page - 1) * pageSize)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public int getSearchOrderCount(String keyword) {
        String searchKeyword = "%" + keyword + "%";
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_code LIKE :keyword")
                        .bind("keyword", searchKeyword)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Order> getOrdersByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY created_at DESC";

        return jdbi.withHandle(h -> {
            List<Order> orders = h.createQuery(sql)
                    .bind("userId", userId)
                    .mapToBean(Order.class)
                    .list();

            for (Order order : orders) {
                order.setItems(getOrderItemsByOrderId(order.getId()));
                order.setRecipientInfo(getRecipientInfoByOrderId(order.getId()));
            }
            return orders;
        });
    }

    public int countOrdersByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Order> getOrdersByUserIdPaging(int userId, int limit, int offset) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY created_at DESC LIMIT :limit OFFSET :offset";

        return jdbi.withHandle(h -> {
            List<Order> orders = h.createQuery(sql)
                    .bind("userId", userId)
                    .bind("limit", limit)
                    .bind("offset", offset)
                    .mapToBean(Order.class)
                    .list();

            for (Order order : orders) {
                order.setItems(getOrderItemsByOrderId(order.getId()));
                order.setRecipientInfo(getRecipientInfoByOrderId(order.getId()));
            }
            return orders;
        });
    }

    public boolean createOrder(Order order, RecipientInfo recipient, Map<Integer, CartItem> cart, Payment payment) {
        return jdbi.inTransaction(handle -> {
            try {
                int orderId = handle.createUpdate("INSERT INTO orders (user_id, order_code, order_status, subprice, discount_amount, shipping_fee, total_amount) " +
                                "VALUES (:userId, :orderCode, :status, :subprice, :discountAmount, :shippingFee, :total)")
                        .bind("userId", order.getUserId())
                        .bind("orderCode", order.getOrderCode())
                        .bind("status", order.getOrderStatus())
                        .bind("subprice", order.getSubprice())
                        .bind("discountAmount", order.getDiscountAmount())
                        .bind("shippingFee", order.getShippingFee())
                        .bind("total", order.getTotalAmount())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class).one();
                order.setId(orderId);

                handle.createUpdate("INSERT INTO payment (order_id, payment_method, payment_status, amount, paid_at, created_at) " +
                                "VALUES (:orderId, :method, :status, :amount, NOW(), NOW())")
                        .bind("orderId", orderId)
                        .bind("method", payment.getPaymentMethod())
                        .bind("status", "Thành công")
                        .bind("amount", payment.getAmount())
                        .execute();

                handle.createUpdate("INSERT INTO recipient_info (order_id, full_name, phone, email, province, district, address_detail) " +
                                "VALUES (:orderId, :fullName, :phone, :email, :province, :district, :addressDetail)")
                        .bind("orderId", orderId)
                        .bind("fullName", recipient.getFullName())
                        .bind("phone", recipient.getPhone())
                        .bind("email", recipient.getEmail())
                        .bind("province", recipient.getProvince())
                        .bind("district", recipient.getDistrict())
                        .bind("addressDetail", recipient.getAddress())
                        .execute();

                for (CartItem item : cart.values()) {
                    double originalPrice = item.getProduct().getOldPrice();
                    if (originalPrice == 0) {
                        originalPrice = item.getProduct().getPrice();
                    }

                    handle.createUpdate("INSERT INTO order_details (order_id, product_id, quantity, unit_price, original_price) " +
                                    "VALUES (:orderId, :productId, :quantity, :price, :originalPrice)")
                            .bind("orderId", orderId)
                            .bind("productId", item.getProduct().getId())
                            .bind("quantity", item.getQuantity())
                            .bind("price", item.getProduct().getPrice())
                            .bind("originalPrice", originalPrice)
                            .execute();

                    String updateStockSql = "UPDATE products SET stock = stock - :quantity WHERE id = :productId";
                    handle.createUpdate(updateStockSql)
                            .bind("quantity", item.getQuantity())
                            .bind("productId", item.getProduct().getId())
                            .execute();

                    handle.createUpdate("UPDATE products SET status = 'inactive' WHERE id = :productId AND stock <= 0")
                            .bind("productId", item.getProduct().getId())
                            .execute();
                }

                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        });
    }

    public int countTotalOrdersByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND order_status = 'Đã giao'";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
    }

    public double calculateTotalSpentByUserId(int userId) {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE user_id = :userId AND order_status = 'Đã giao'";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Double.class)
                        .findOne()
                        .orElse(0.0)
        );
    }

    public boolean cancelOrder(int orderId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE orders SET order_status = 'Đã hủy' WHERE id = :orderId")
                        .bind("orderId", orderId)
                        .execute() > 0
        );
    }

    public RecipientInfo getRecipientInfoByOrderId(int orderId) {
        String sql = "SELECT * FROM recipient_info WHERE order_id = :orderId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", orderId)
                        .mapToBean(RecipientInfo.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Order> getOrdersByUserIdAndStatus(int userId, String status) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId AND order_status = :status ORDER BY created_at DESC";

        return jdbi.withHandle(h -> {
            List<Order> orders = h.createQuery(sql)
                    .bind("userId", userId)
                    .bind("status", status)
                    .mapToBean(Order.class)
                    .list();

            for (Order order : orders) {
                order.setItems(getOrderItemsByOrderId(order.getId()));
                order.setRecipientInfo(getRecipientInfoByOrderId(order.getId()));
            }
            return orders;
        });
    }

    public double getTotalRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT SUM(total_amount) FROM orders WHERE order_status = 'Đã giao'")
                        .mapTo(Double.class)
                        .findOne()
                        .orElse(0.0)
        );
    }

    public int getTotalOrdersCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public Map<String, Double> getDailyRevenueForLast7Days() {
        String sql = "SELECT DATE(created_at) as order_date, SUM(total_amount) as daily_revenue " +
                "FROM orders " +
                "WHERE order_status = 'Đã giao' AND created_at >= CURDATE() - INTERVAL 7 DAY " +
                "GROUP BY DATE(created_at) " +
                "ORDER BY order_date ASC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("order_date").toString(),
                                        m -> {
                                            Object revenue = m.get("daily_revenue");
                                            return (revenue instanceof Number) ? ((Number) revenue).doubleValue() : 0.0;
                                        }
                                )
                        )
        );
    }
}
