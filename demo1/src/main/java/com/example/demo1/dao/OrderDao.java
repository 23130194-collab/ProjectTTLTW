package com.example.demo1.dao;

import com.example.demo1.model.*;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;
import org.jdbi.v3.core.statement.Query;

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
        return searchOrders(keyword, null, page, pageSize);
    }

    public int getSearchOrderCount(String keyword) {
        return getSearchOrderCount(keyword, null);
    }

    public List<Order> searchOrders(String keyword, String status, int page, int pageSize) {
        String sql = buildOrderFilterSql("SELECT * FROM orders", keyword, status)
                + " ORDER BY order_code DESC LIMIT :limit OFFSET :offset";

        return jdbi.withHandle(handle -> {
            Query query = handle.createQuery(sql)
                    .bind("limit", pageSize)
                    .bind("offset", (page - 1) * pageSize);
            bindOrderFilters(query, keyword, status);
            return query.mapToBean(Order.class).list();
        });
    }

    public int getSearchOrderCount(String keyword, String status) {
        String sql = buildOrderFilterSql("SELECT COUNT(*) FROM orders", keyword, status);

        return jdbi.withHandle(handle -> {
            Query query = handle.createQuery(sql);
            bindOrderFilters(query, keyword, status);
            return query.mapTo(Integer.class).one();
        });
    }

    private String buildOrderFilterSql(String baseSql, String keyword, String status) {
        StringBuilder sql = new StringBuilder(baseSql).append(" WHERE 1 = 1");
        if (keyword != null) {
            sql.append(" AND order_code LIKE :keyword");
        }
        if (status != null) {
            sql.append(" AND order_status = :status");
        }
        return sql.toString();
    }

    private void bindOrderFilters(Query query, String keyword, String status) {
        if (keyword != null) {
            query.bind("keyword", "%" + keyword + "%");
        }
        if (status != null) {
            query.bind("status", status);
        }
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

    public boolean cancelOrder(int orderId, String reason) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE orders SET order_status = 'Đã hủy', cancellation_reason = :reason WHERE id = :orderId")
                        .bind("orderId", orderId)
                        .bind("reason", reason)
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
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status != 'Đã hủy'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public double getMonthlyRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT IFNULL(SUM(total_amount), 0) FROM orders WHERE order_status = 'Đã giao' AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())")
                        .mapTo(Double.class)
                        .one()
        );
    }

    public int getPendingOrdersCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status = 'Chờ xác nhận'")
                        .mapTo(Integer.class)
                        .one()
        );
    }


    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM orders o " +
                "JOIN order_details od ON o.id = od.order_id " +
                "WHERE o.user_id = :userId AND od.product_id = :productId AND o.order_status = 'Đã giao'";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one() > 0
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

    public double getCancelRate() {
        int total = jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders").mapTo(Integer.class).one()
        );
        if (total == 0) return 0.0;
        int cancelled = jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status = 'Đã hủy'").mapTo(Integer.class).one()
        );
        return Math.round(((double) cancelled / total) * 100.0 * 10) / 10.0;
    }

    public double getAverageOrderValue() {
        int deliveredOrders = jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status = 'Đã giao'").mapTo(Integer.class).one()
        );
        if (deliveredOrders == 0) return 0.0;
        double totalRevenue = getTotalRevenue();
        return Math.round(totalRevenue / deliveredOrders);
    }

    public int getTotalProductsSold() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT IFNULL(SUM(od.quantity), 0) FROM order_details od JOIN orders o ON od.order_id = o.id WHERE o.order_status = 'Đã giao'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int getProductsSoldThisMonth() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT IFNULL(SUM(od.quantity), 0) FROM order_details od JOIN orders o ON od.order_id = o.id WHERE o.order_status = 'Đã giao' AND MONTH(o.created_at) = MONTH(CURDATE()) AND YEAR(o.created_at) = YEAR(CURDATE())")
                        .mapTo(Integer.class).one()
        );
    }

    public double getTodaysRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT IFNULL(SUM(total_amount), 0) FROM orders WHERE order_status = 'Đã giao' AND DATE(created_at) = CURDATE()")
                        .mapTo(Double.class)
                        .one()
        );
    }

    public int getProcessingOrdersCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status = 'Đang giao'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int getDeliveredOrdersCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE order_status = 'Đã giao'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public Map<String, Double> getRevenueByTimeRange(int days) {
        String sql = "SELECT DATE_FORMAT(created_at, '%d/%m/%Y') as order_date, SUM(total_amount) as daily_revenue " +
                "FROM orders " +
                "WHERE order_status = 'Đã giao' AND created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY DATE(created_at) " +
                "ORDER BY DATE(created_at) ASC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("order_date").toString(),
                                        m -> {
                                            Object revenue = m.get("daily_revenue");
                                            return (revenue instanceof Number) ? ((Number) revenue).doubleValue() : 0.0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Double> getRevenueByCategory(int days) {
        String sql = "SELECT c.name as category_name, SUM(od.quantity * od.unit_price) as category_revenue " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "JOIN products p ON od.product_id = p.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "WHERE o.order_status = 'Đã giao' AND o.created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY c.id, c.name " +
                "ORDER BY category_revenue DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("category_name").toString(),
                                        m -> {
                                            Object revenue = m.get("category_revenue");
                                            return (revenue instanceof Number) ? ((Number) revenue).doubleValue() : 0.0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Integer> getOrdersCountByTimeRange(int days) {
         String sql = "SELECT DATE_FORMAT(created_at, '%d/%m/%Y') as order_date, COUNT(*) as daily_orders " +
                "FROM orders " +
                "WHERE created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY DATE(created_at) " +
                "ORDER BY DATE(created_at) ASC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("order_date").toString(),
                                        m -> {
                                            Object count = m.get("daily_orders");
                                            return (count instanceof Number) ? ((Number) count).intValue() : 0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Integer> getOrderStatusRatio(int days) {
         String sql = "SELECT order_status, COUNT(*) as status_count " +
                "FROM orders " +
                "WHERE created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY order_status";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("order_status").toString(),
                                        m -> {
                                            Object count = m.get("status_count");
                                            return (count instanceof Number) ? ((Number) count).intValue() : 0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Integer> getOrderSuccessVsFailRatio(int days) {
         String sql = "SELECT " +
                "CASE WHEN order_status = 'Đã giao' THEN 'Thành công' " +
                "     WHEN order_status = 'Đã hủy' THEN 'Thất bại' " +
                "     ELSE 'Khác' END as final_status, " +
                "COUNT(*) as status_count " +
                "FROM orders " +
                "WHERE order_status IN ('Đã giao', 'Đã hủy') AND created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY final_status";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("final_status").toString(),
                                        m -> {
                                            Object count = m.get("status_count");
                                            return (count instanceof Number) ? ((Number) count).intValue() : 0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }
    public Map<String, Integer> getTopSellingProducts(int days, int limit) {
        String sql = "SELECT p.name as product_name, SUM(od.quantity) as total_sold " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "JOIN products p ON od.product_id = p.id " +
                "WHERE o.order_status = 'Đã giao' AND o.created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY p.id, p.name " +
                "ORDER BY total_sold DESC " +
                "LIMIT :limit";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .bind("limit", limit)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("product_name").toString(),
                                        m -> {
                                            Object count = m.get("total_sold");
                                            return (count instanceof Number) ? ((Number) count).intValue() : 0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Integer> getPaymentMethodRatio(int days) {
        String sql = "SELECT p.payment_method, COUNT(*) as method_count " +
                "FROM payment p " +
                "JOIN orders o ON p.order_id = o.id " +
                "WHERE o.created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY p.payment_method";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("payment_method").toString(),
                                        m -> {
                                            Object count = m.get("method_count");
                                            return (count instanceof Number) ? ((Number) count).intValue() : 0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }

    public Map<String, Double> getRevenueByPaymentMethod(int days) {
        String sql = "SELECT p.payment_method, SUM(o.total_amount) as method_revenue " +
                "FROM payment p " +
                "JOIN orders o ON p.order_id = o.id " +
                "WHERE o.order_status = 'Đã giao' AND o.created_at >= CURDATE() - INTERVAL :days DAY " +
                "GROUP BY p.payment_method";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("days", days)
                        .mapToMap()
                        .list()
                        .stream()
                        .collect(
                                java.util.stream.Collectors.toMap(
                                        m -> m.get("payment_method").toString(),
                                        m -> {
                                            Object revenue = m.get("method_revenue");
                                            return (revenue instanceof Number) ? ((Number) revenue).doubleValue() : 0.0;
                                        },
                                        (e1, e2) -> e1,
                                        java.util.LinkedHashMap::new
                                )
                        )
        );
    }
}
