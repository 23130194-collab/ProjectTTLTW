package com.example.demo1.controller;

import com.example.demo1.model.CartItem;
import com.example.demo1.model.Order;
import com.example.demo1.model.RecipientInfo;
import com.example.demo1.model.ShippingActionResult;
import com.example.demo1.model.User;
import com.example.demo1.model.UserAddress;
import com.example.demo1.service.CartService;
import com.example.demo1.service.GhnShippingService;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.UserAddressService;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ShippingApiServlet", urlPatterns = {"/api/shipping/fee", "/api/shipping/scan", "/api/shipping/ghn/webhook"})
public class ShippingApiServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final CartService cartService = new CartService();
    private final UserAddressService userAddressService = new UserAddressService();
    private final GhnShippingService ghnShippingService = new GhnShippingService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("/api/shipping/fee".equals(request.getServletPath())) {
            handleFee(request, response);
            return;
        }

        if (!isAuthorized(request)) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, ShippingActionResult.failure("Không có quyền gọi API giao vận."));
            return;
        }

        String path = request.getServletPath();
        if ("/api/shipping/ghn/webhook".equals(path)) {
            handleGhnWebhook(request, response);
        } else {
            handleScan(request, response);
        }
    }

    private void handleScan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject body = readJsonBody(request);
        String orderCode = firstNonBlank(
                request.getParameter("orderCode"),
                request.getParameter("order_code"),
                getString(body, "orderCode"),
                getString(body, "order_code")
        );
        if (orderCode == null) {
            orderCode = findOrderCodeById(firstNonBlank(
                    request.getParameter("orderId"),
                    request.getParameter("order_id"),
                    getString(body, "orderId"),
                    getString(body, "order_id")
            ));
        }
        String event = firstNonBlank(
                request.getParameter("event"),
                request.getParameter("status"),
                getString(body, "event"),
                getString(body, "status")
        );
        String note = firstNonBlank(
                request.getParameter("note"),
                getString(body, "note"),
                "API quét mã vận chuyển"
        );

        ShippingActionResult result;
        if (orderCode == null) {
            result = ShippingActionResult.failure("Thiếu mã đơn hàng để cập nhật giao vận.");
        } else if ("pickup".equalsIgnoreCase(event) || "picked".equalsIgnoreCase(event)) {
            result = orderService.markCarrierPickedUp(orderCode, note);
        } else if ("delivered".equalsIgnoreCase(event) || "delivery".equalsIgnoreCase(event)) {
            result = orderService.markCarrierDelivered(orderCode, note);
        } else {
            result = ShippingActionResult.failure("Sự kiện quét mã không hợp lệ. Dùng pickup hoặc delivered.");
        }

        writeJson(response, result.isSuccess() ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST, result);
    }

    private void handleFee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            writeFeeJson(response, HttpServletResponse.SC_UNAUTHORIZED, false, 0, 0, "Vui lòng đăng nhập lại.");
            return;
        }

        UserAddress address = userAddressService.getAddressById(user.getId(), parsePositiveInt(request.getParameter("addressId")));
        if (address == null) {
            writeFeeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, 0, 0, "Địa chỉ nhận hàng không hợp lệ.");
            return;
        }

        List<CartItem> cartItems = filterSelectedCartItems(
                cartService.getCartItems(user.getId()),
                request.getParameterValues("productIds")
        );
        if (cartItems == null || cartItems.isEmpty()) {
            writeFeeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, 0, 0, "Giỏ hàng thanh toán không hợp lệ.");
            return;
        }

        double merchandiseTotal = calculateMerchandiseTotal(cartItems);
        try {
            int shippingFee = ghnShippingService.calculateShippingFee(buildRecipientFromAddress(address), cartItems, merchandiseTotal);
            writeFeeJson(response, HttpServletResponse.SC_OK, true, shippingFee, merchandiseTotal + shippingFee, null);
        } catch (Exception e) {
            writeFeeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, 0, merchandiseTotal, "Không tính được phí vận chuyển GHN: " + e.getMessage());
        }
    }

    private String findOrderCodeById(String orderIdValue) {
        if (orderIdValue == null) {
            return null;
        }
        try {
            Order order = orderService.getOrderById(Integer.parseInt(orderIdValue));
            return order == null ? null : order.getOrderCode();
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<CartItem> filterSelectedCartItems(List<CartItem> cartItems, String[] productIds) {
        if (cartItems == null || productIds == null || productIds.length == 0) {
            return cartItems;
        }

        Set<Integer> selectedIds = new HashSet<>();
        for (String id : productIds) {
            int productId = parsePositiveInt(id);
            if (productId > 0) {
                selectedIds.add(productId);
            }
        }

        List<CartItem> filteredItems = new ArrayList<>();
        for (CartItem item : cartItems) {
            if (selectedIds.contains(item.getProduct().getId())) {
                filteredItems.add(item);
            }
        }
        return filteredItems;
    }

    private double calculateMerchandiseTotal(List<CartItem> cartItems) {
        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }
        return total;
    }

    private RecipientInfo buildRecipientFromAddress(UserAddress address) {
        RecipientInfo recipient = new RecipientInfo();
        recipient.setFullName(address.getFullName());
        recipient.setPhone(address.getPhone());
        recipient.setProvince(address.getProvince());
        recipient.setDistrict(address.getDistrict());
        recipient.setWard(address.getWard());
        recipient.setAddress(address.getAddressDetail());
        return recipient;
    }

    private int parsePositiveInt(String value) {
        try {
            int parsedValue = Integer.parseInt(value == null ? "" : value.trim());
            return parsedValue > 0 ? parsedValue : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void handleGhnWebhook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject body = readJsonBody(request);
        String clientOrderCode = firstNonBlank(
                getString(body, "ClientOrderCode"),
                getString(body, "client_order_code"),
                getString(body, "clientOrderCode")
        );
        String ghnOrderCode = firstNonBlank(
                getString(body, "OrderCode"),
                getString(body, "order_code"),
                getString(body, "orderCode")
        );
        String status = firstNonBlank(
                getString(body, "Status"),
                getString(body, "status")
        );
        String description = firstNonBlank(
                getString(body, "Description"),
                getString(body, "description")
        );

        ShippingActionResult result = orderService.applyGhnShippingStatus(clientOrderCode, ghnOrderCode, status, description);
        writeJson(response, result.isSuccess() ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST, result);
    }

    private boolean isAuthorized(HttpServletRequest request) {
        String expectedSecret = firstNonBlank(System.getProperty("ghn.webhookSecret"), System.getenv("GHN_WEBHOOK_SECRET"));
        if (expectedSecret == null) {
            return true;
        }

        String providedSecret = firstNonBlank(
                request.getHeader("X-GHN-Webhook-Secret"),
                request.getHeader("X-Shipping-Secret"),
                request.getParameter("secret")
        );
        return expectedSecret.equals(providedSecret);
    }

    private JsonObject readJsonBody(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        if (contentType == null || !contentType.toLowerCase().contains("application/json")) {
            return new JsonObject();
        }

        StringBuilder builder = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            builder.append(line);
        }

        if (builder.length() == 0) {
            return new JsonObject();
        }

        JsonElement element = JsonParser.parseString(builder.toString());
        return element != null && element.isJsonObject() ? element.getAsJsonObject() : new JsonObject();
    }

    private void writeJson(HttpServletResponse response, int status, ShippingActionResult result) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();
        json.addProperty("success", result.isSuccess());
        json.addProperty("message", result.getMessage());
        if (result.getCarrierOrderCode() != null) {
            json.addProperty("carrierOrderCode", result.getCarrierOrderCode());
        }
        response.getWriter().write(gson.toJson(json));
    }

    private void writeFeeJson(HttpServletResponse response, int status, boolean success, double shippingFee, double totalAmount, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();
        json.addProperty("success", success);
        json.addProperty("shippingFee", shippingFee);
        json.addProperty("totalAmount", totalAmount);
        if (message != null) {
            json.addProperty("message", message);
        }
        response.getWriter().write(gson.toJson(json));
    }

    private String getString(JsonObject object, String fieldName) {
        JsonElement element = object == null ? null : object.get(fieldName);
        return element == null || element.isJsonNull() ? null : element.getAsString();
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }
}
