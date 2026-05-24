package com.example.demo1.service;

import com.example.demo1.dao.OrderDao;
import com.example.demo1.dao.ProductDao;
import com.example.demo1.model.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderService {
    private static final int AUTO_ADVANCE_SECONDS = 60;
    public static final String STATUS_ORDER_PLACED = "Đặt hàng";
    public static final String STATUS_PENDING = "Chờ xác nhận";
    public static final String STATUS_PROCESSING = "Đang xử lý";
    public static final String STATUS_SHIPPING = "Đang giao";
    public static final String STATUS_SENT_TO_CARRIER = "Đã giao cho đơn vị vận chuyển";
    public static final String STATUS_DELIVERED = "Đã giao";
    public static final String STATUS_CANCELLED = "Đã hủy";

    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();
    private final GhnShippingService ghnShippingService = new GhnShippingService();

    public OrderPage getPagedOrders(String keyword, int currentPage, int ordersPerPage) {
        return getPagedOrders(keyword, null, currentPage, ordersPerPage);
    }

    public OrderPage getPagedOrders(String keyword, String status, int currentPage, int ordersPerPage) {
        List<Order> orders;
        int totalOrders;
        String normalizedKeyword = normalizeFilter(keyword);
        String normalizedStatus = normalizeFilter(status);

        if (normalizedKeyword != null || normalizedStatus != null) {
            orders = orderDao.searchOrders(normalizedKeyword, normalizedStatus, currentPage, ordersPerPage);
            totalOrders = orderDao.getSearchOrderCount(normalizedKeyword, normalizedStatus);
        } else {
            orders = orderDao.getAllOrders(currentPage, ordersPerPage);
            totalOrders = orderDao.getTotalOrderCount();
        }
        return new OrderPage(orders, totalOrders);
    }

    private String normalizeFilter(String value) {
        if (value == null) {
            return null;
        }

        String trimmedValue = value.trim();
        return trimmedValue.isEmpty() ? null : trimmedValue;
    }

    public OrderDetail getOrderDetailById(int orderId) {
        return orderDao.getOrderDetailById(orderId);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        return updateOrderStatus(orderId, status, "Cập nhật trạng thái đơn hàng");
    }

    public boolean updateOrderStatus(int orderId, String status, String note) {
        String normalizedStatus = normalizeFilter(status);
        if (normalizedStatus == null) {
            return false;
        }

        Order order = orderDao.getOrderById(orderId);
        if (order == null) {
            return false;
        }

        String currentStatus = order.getOrderStatus();
        if (normalizedStatus.equals(currentStatus)) {
            orderDao.ensureStatusHistoryExists(orderId, normalizedStatus, defaultStatusNote(note, normalizedStatus));
            return true;
        }

        boolean success = orderDao.updateOrderStatus(
                orderId,
                currentStatus,
                normalizedStatus,
                defaultStatusNote(note, normalizedStatus)
        );
        if (success) {
            recalculateAndSyncOrderTotals(orderId);

            if (!STATUS_DELIVERED.equals(currentStatus) && STATUS_DELIVERED.equals(normalizedStatus)) {
                List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
                for (OrderItem item : items) {
                    productDao.incrementSoldQuantity(item.getProductId(), item.getQuantity());
                }
            } else if (!STATUS_CANCELLED.equals(currentStatus) && STATUS_CANCELLED.equals(normalizedStatus)) {
                List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
                for (OrderItem item : items) {
                    productDao.incrementStock(item.getProductId(), item.getQuantity());
                }
            }
        }
        return success;
    }

    private String defaultStatusNote(String note, String status) {
        String normalizedNote = normalizeFilter(note);
        return normalizedNote == null ? "Cập nhật trạng thái: " + status : normalizedNote;
    }

    public void recalculateAndSyncOrderTotals(int orderId) {
        List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
        Order order = orderDao.getOrderById(orderId);

        if (order == null || items == null) {
            return;
        }

        double subprice = 0;
        double discountAmount = 0;

        for (OrderItem item : items) {
            subprice += item.getOriginalPrice() * item.getQuantity();
            discountAmount += (item.getOriginalPrice() - item.getUnitPrice()) * item.getQuantity();
        }

        double totalAmount = subprice - discountAmount + order.getShippingFee();

        orderDao.updateOrderTotals(orderId, subprice, discountAmount, totalAmount);
    }

    public Order getOrderById(int orderId) {
        return orderDao.getOrderById(orderId);
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        return orderDao.getOrderItemsByOrderId(orderId);
    }

    public List<Order> getAllOrders(int page, int pageSize) {
        return orderDao.getAllOrders(page, pageSize);
    }

    public int getTotalOrderCount() {
        return orderDao.getTotalOrderCount();
    }

    public List<Order> searchOrders(String keyword, int page, int pageSize) {
        return orderDao.searchOrders(keyword, page, pageSize);
    }

    public int getSearchOrderCount(String keyword) {
        return orderDao.getSearchOrderCount(keyword);
    }

    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }

    public int countOrdersByUserId(int userId) {
        return orderDao.countOrdersByUserId(userId);
    }

    public List<Order> getOrdersByUserIdPaging(int userId, int limit, int offset) {
        return orderDao.getOrdersByUserIdPaging(userId, limit, offset);
    }

    public int countTotalOrdersByUserId(int userId) {
        return orderDao.countTotalOrdersByUserId(userId);
    }

    public double calculateTotalSpentByUserId(int userId) {
        return orderDao.calculateTotalSpentByUserId(userId);
    }

    public List<Order> getOrdersByUserIdAndStatus(int userId, String status) {
        return orderDao.getOrdersByUserIdAndStatus(userId, status);
    }

    public boolean createOrder(Order order, RecipientInfo recipient, List<CartItem> cartItems, Payment payment) {
        return orderDao.createOrder(order, recipient, cartItems, payment);
    }

    public boolean cancelOrder(int orderId, String reason) {
        Order order = orderDao.getOrderById(orderId);
        if (order == null) {
            return false;
        }

        if (STATUS_CANCELLED.equals(order.getOrderStatus())) {
            orderDao.ensureStatusHistoryExists(orderId, STATUS_CANCELLED, defaultStatusNote(reason, STATUS_CANCELLED));
            return true;
        }

        boolean success = orderDao.cancelOrder(orderId, reason);
        if (success) {
            List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
            for (OrderItem item : items) {
                productDao.incrementStock(item.getProductId(), item.getQuantity());
            }
        }
        return success;
    }

    public boolean confirmReceived(int orderId, int userId) {
        Order order = orderDao.getOrderById(orderId);
        if (order == null || order.getUserId() != userId) {
            return false;
        }

        if (!STATUS_SHIPPING.equals(order.getOrderStatus())) {
            return false;
        }

        return updateOrderStatus(orderId, STATUS_DELIVERED, "Khách hàng xác nhận đã nhận hàng");
    }

    public ShippingActionResult handoverToCarrier(int orderId) {
        Order order = orderDao.getOrderById(orderId);
        if (order == null) {
            return ShippingActionResult.failure("Đơn hàng không tồn tại.");
        }
        if (!isProcessingStatus(order.getOrderStatus())) {
            return ShippingActionResult.failure("Chỉ có thể giao đơn đang xử lý cho đơn vị vận chuyển.");
        }
        if (order.isSentToCarrier()) {
            return ShippingActionResult.success("Đơn hàng đã được gửi sang đơn vị vận chuyển trước đó.");
        }
        if (order.getRecipientInfo() == null) {
            return ShippingActionResult.failure("Đơn hàng thiếu thông tin người nhận.");
        }

        try {
            List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);
            Payment payment = orderDao.getPaymentByOrderId(orderId);
            GhnCreateOrderResult result = ghnShippingService.createShippingOrder(order, order.getRecipientInfo(), items, payment);
            if (!result.isSuccess()) {
                return ShippingActionResult.failure(result.getMessage());
            }

            String note = "Đã tạo vận đơn GHN";
            if (result.getOrderCode() != null && !result.getOrderCode().trim().isEmpty()) {
                note += ": " + result.getOrderCode();
            }
            orderDao.ensureStatusHistoryExists(orderId, STATUS_SENT_TO_CARRIER, note);
            return ShippingActionResult.success(note, result.getOrderCode());
        } catch (IllegalStateException | IOException e) {
            return ShippingActionResult.failure(e.getMessage());
        }
    }

    public ShippingActionResult markCarrierPickedUp(String orderCode, String note) {
        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            return ShippingActionResult.failure("Không tìm thấy đơn hàng " + orderCode + ".");
        }
        if (STATUS_CANCELLED.equals(order.getOrderStatus()) || STATUS_DELIVERED.equals(order.getOrderStatus())) {
            return ShippingActionResult.failure("Đơn hàng đã ở trạng thái cuối, không thể chuyển sang đang giao.");
        }
        if (STATUS_SHIPPING.equals(order.getOrderStatus())) {
            return ShippingActionResult.success("Đơn hàng đang ở trạng thái Đang giao.");
        }

        boolean success = updateOrderStatus(
                order.getId(),
                STATUS_SHIPPING,
                defaultStatusNote(note, STATUS_SHIPPING)
        );
        return success
                ? ShippingActionResult.success("Đơn hàng đã chuyển sang Đang giao.")
                : ShippingActionResult.failure("Không thể chuyển đơn hàng sang Đang giao.");
    }

    public ShippingActionResult markCarrierDelivered(String orderCode, String note) {
        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            return ShippingActionResult.failure("Không tìm thấy đơn hàng " + orderCode + ".");
        }
        if (STATUS_CANCELLED.equals(order.getOrderStatus()) || STATUS_DELIVERED.equals(order.getOrderStatus())) {
            return ShippingActionResult.failure("Đơn hàng đã ở trạng thái cuối.");
        }

        boolean success = updateOrderStatus(
                order.getId(),
                STATUS_DELIVERED,
                defaultStatusNote(note, STATUS_DELIVERED)
        );
        return success
                ? ShippingActionResult.success("Đơn hàng đã được đánh dấu là đã giao.")
                : ShippingActionResult.failure("Không thể đánh dấu đơn hàng là đã giao.");
    }

    public ShippingActionResult applyGhnShippingStatus(String clientOrderCode, String ghnOrderCode, String ghnStatus, String description) {
        String orderCode = normalizeFilter(clientOrderCode);
        if (orderCode == null) {
            return ShippingActionResult.failure("Webhook GHN thiếu client_order_code.");
        }

        String normalizedStatus = normalizeFilter(ghnStatus);
        if (normalizedStatus == null) {
            return ShippingActionResult.failure("Webhook GHN thiếu trạng thái vận đơn.");
        }

        String note = buildCarrierNote("GHN cập nhật " + normalizedStatus, ghnOrderCode, description);
        String lowerStatus = normalizedStatus.toLowerCase();
        if ("delivered".equals(lowerStatus)) {
            return markCarrierDelivered(orderCode, note);
        }
        if (isGhnInTransitStatus(lowerStatus)) {
            return markCarrierPickedUp(orderCode, note);
        }
        if (isGhnCancelledStatus(lowerStatus)) {
            Order order = orderDao.getOrderByCode(orderCode);
            if (order == null) {
                return ShippingActionResult.failure("Không tìm thấy đơn hàng " + orderCode + ".");
            }
            boolean success = cancelOrder(order.getId(), note);
            return success
                    ? ShippingActionResult.success("Đơn hàng đã được hủy theo trạng thái GHN.")
                    : ShippingActionResult.failure("Không thể hủy đơn hàng theo trạng thái GHN.");
        }

        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            return ShippingActionResult.failure("Không tìm thấy đơn hàng " + orderCode + ".");
        }
        orderDao.ensureStatusHistoryExists(order.getId(), "GHN: " + normalizedStatus, note);
        return ShippingActionResult.success("Đã ghi nhận trạng thái GHN: " + normalizedStatus + ".");
    }

    private String buildCarrierNote(String prefix, String carrierOrderCode, String description) {
        StringBuilder note = new StringBuilder(prefix == null ? "" : prefix);
        if (carrierOrderCode != null && !carrierOrderCode.trim().isEmpty()) {
            note.append(" - mã vận đơn ").append(carrierOrderCode.trim());
        }
        if (description != null && !description.trim().isEmpty()) {
            note.append(" - ").append(description.trim());
        }
        return note.toString();
    }

    private boolean isGhnInTransitStatus(String status) {
        return "picked".equals(status)
                || "storing".equals(status)
                || "transporting".equals(status)
                || "sorting".equals(status)
                || "delivering".equals(status)
                || "money_collect_delivering".equals(status)
                || "delivery_fail".equals(status);
    }

    private boolean isGhnCancelledStatus(String status) {
        return "cancel".equals(status)
                || "cancelled".equals(status)
                || "damage".equals(status)
                || "lost".equals(status);
    }

    private boolean isProcessingStatus(String status) {
        return STATUS_PROCESSING.equals(status) || "Đang xử lí".equals(status);
    }

    public int autoAdvanceTimedOrders() {
        int updatedCount = 0;
        updatedCount += autoAdvanceOrders(
                STATUS_PENDING,
                STATUS_PROCESSING,
                "Tự động chuyển sang Đang xử lý sau 1 phút"
        );
        return updatedCount;
    }

    private int autoAdvanceOrders(String fromStatus, String toStatus, String note) {
        List<Integer> orderIds = orderDao.getOrderIdsReadyForAutoTransition(fromStatus, AUTO_ADVANCE_SECONDS);
        int updatedCount = 0;
        for (Integer orderId : orderIds) {
            if (orderId != null && updateOrderStatus(orderId, toStatus, note)) {
                updatedCount++;
            }
        }
        return updatedCount;
    }

    public List<OrderTimelineStep> getOrderTimelineSteps(Order order) {
        List<OrderTimelineStep> timelineSteps = new ArrayList<>();
        if (order == null) {
            return timelineSteps;
        }

        List<OrderStatusHistory> histories = orderDao.getOrderStatusHistoryByOrderId(order.getId());
        Map<String, Timestamp> statusTimes = new LinkedHashMap<>();
        boolean hasCancelledHistory = false;

        for (OrderStatusHistory history : histories) {
            if (history.getStatus() == null) {
                continue;
            }
            statusTimes.putIfAbsent(history.getStatus(), history.getCreatedAt());
            if (STATUS_CANCELLED.equals(history.getStatus())) {
                hasCancelledHistory = true;
            }
        }

        if (order.getCreatedAt() != null) {
            statusTimes.putIfAbsent(STATUS_ORDER_PLACED, order.getCreatedAt());
        }

        List<String> timelineStatuses = new ArrayList<>(Arrays.asList(
                STATUS_ORDER_PLACED,
                STATUS_PENDING,
                STATUS_PROCESSING,
                STATUS_SHIPPING
        ));

        if (STATUS_CANCELLED.equals(order.getOrderStatus()) || hasCancelledHistory) {
            timelineStatuses.add(STATUS_CANCELLED);
        } else {
            timelineStatuses.add(STATUS_DELIVERED);
        }

        for (String status : timelineStatuses) {
            Timestamp occurredAt = statusTimes.get(status);
            boolean current = status.equals(order.getOrderStatus());
            boolean completed = occurredAt != null;
            boolean cancelled = STATUS_CANCELLED.equals(status);
            timelineSteps.add(new OrderTimelineStep(status, occurredAt, completed, current, cancelled));
        }

        return timelineSteps;
    }

    public RecipientInfo getRecipientInfoByOrderId(int orderId) {
        return orderDao.getRecipientInfoByOrderId(orderId);
    }

    public boolean hasUserPurchasedProduct(int userId, int productId) {
        return orderDao.hasUserPurchasedProduct(userId, productId);
    }

    public double getTotalRevenue() {
        return orderDao.getTotalRevenue();
    }

    public double getMonthlyRevenue() {
        return orderDao.getMonthlyRevenue();
    }

    public int getPendingOrdersCount() {
        return orderDao.getPendingOrdersCount();
    }

    public double getCancelRate() {
        return orderDao.getCancelRate();
    }

    public double getTodaysRevenue() {
        return orderDao.getTodaysRevenue();
    }

    public int getTotalProductsSold() {
        return orderDao.getTotalProductsSold();
    }

    public int getProductsSoldThisMonth() {
        return orderDao.getProductsSoldThisMonth();
    }

    public int getProcessingOrdersCount() {
        return orderDao.getProcessingOrdersCount();
    }

    public int getDeliveredOrdersCount() {
        return orderDao.getDeliveredOrdersCount();
    }

    public Map<String, Double> getDailyRevenueForLast7Days() {
        return orderDao.getDailyRevenueForLast7Days();
    }

    public Map<String, Double> getRevenueByTimeRange(int days) {
        return orderDao.getRevenueByTimeRange(days);
    }

    public Map<String, Double> getRevenueByCategory(int days) {
        return orderDao.getRevenueByCategory(days);
    }

    public Map<String, Integer> getOrdersCountByTimeRange(int days) {
        return orderDao.getOrdersCountByTimeRange(days);
    }

    public Map<String, Integer> getOrderStatusRatio(int days) {
        return orderDao.getOrderStatusRatio(days);
    }

    public Map<String, Integer> getOrderSuccessVsFailRatio(int days) {
        return orderDao.getOrderSuccessVsFailRatio(days);
    }

    public Map<String, Integer> getTopSellingProducts(int days, int limit) {
        return orderDao.getTopSellingProducts(days, limit);
    }

    public Map<String, Integer> getPaymentMethodRatio(int days) {
        return orderDao.getPaymentMethodRatio(days);
    }

    public Map<String, Double> getRevenueByPaymentMethod(int days) {
        return orderDao.getRevenueByPaymentMethod(days);
    }

    public Map<String, Double> getOrderCancellationRate(int days) {
        return orderDao.getOrderCancellationRate(days);
    }
}
