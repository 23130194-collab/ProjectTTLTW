package com.example.demo1.service;

import com.example.demo1.model.GhnCreateOrderResult;
import com.example.demo1.model.Order;
import com.example.demo1.model.OrderItem;
import com.example.demo1.model.Payment;
import com.example.demo1.model.RecipientInfo;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;

public class GhnShippingService {
    private static final String DEFAULT_BASE_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api";
    private static final int DEFAULT_PAYMENT_TYPE_ID = 1;
    private static final int DEFAULT_SERVICE_TYPE_ID = 2;
    private static final int DEFAULT_ITEM_WEIGHT = 500;
    private static final int DEFAULT_LENGTH = 20;
    private static final int DEFAULT_WIDTH = 15;
    private static final int DEFAULT_HEIGHT = 10;
    private static final int MAX_INSURANCE_VALUE = 5_000_000;
    private static final int MAX_COD_AMOUNT = 10_000_000;

    private final Gson gson = new Gson();

    public GhnCreateOrderResult createShippingOrder(Order order, RecipientInfo recipient, List<OrderItem> items, Payment payment)
            throws IOException {
        ensureConfigured();

        String provinceName = cleanAddressPart(recipient.getProvince());
        String districtName = cleanAddressPart(recipient.getDistrict());
        String wardName = cleanAddressPart(firstNonBlank(recipient.getWard(), extractWardFromAddress(recipient.getAddress())));
        Integer districtId = null;
        String wardCode = null;

        try {
            districtId = resolveDistrictId(provinceName, districtName);
            wardCode = resolveWardCode(districtId, wardName);
        } catch (IOException e) {
            System.err.println("Không map được mã địa chỉ GHN, gửi bằng tên địa chỉ: " + e.getMessage());
        }

        JsonObject payload = new JsonObject();
        payload.addProperty("payment_type_id", intConfig("ghn.paymentTypeId", "GHN_PAYMENT_TYPE_ID", DEFAULT_PAYMENT_TYPE_ID));
        payload.addProperty("required_note", config("ghn.requiredNote", "GHN_REQUIRED_NOTE", "KHONGCHOXEMHANG"));
        payload.addProperty("note", firstNonBlank(order.getNotes(), "Gọi khách trước khi giao hàng"));
        payload.addProperty("to_name", cleanAddressPart(recipient.getFullName()));
        payload.addProperty("to_phone", cleanAddressPart(recipient.getPhone()));
        payload.addProperty("to_address", buildRecipientAddress(recipient, wardName));
        payload.addProperty("to_ward_name", wardName);
        payload.addProperty("to_district_name", districtName);
        payload.addProperty("to_province_name", provinceName);
        if (wardCode != null) {
            payload.addProperty("to_ward_code", wardCode);
        }
        if (districtId != null) {
            payload.addProperty("to_district_id", districtId);
        }
        payload.addProperty("cod_amount", calculateCodAmount(order, payment));
        payload.addProperty("content", "Đơn hàng " + order.getOrderCode());
        payload.addProperty("weight", calculateWeight(items));
        payload.addProperty("length", intConfig("ghn.defaultLength", "GHN_DEFAULT_LENGTH", DEFAULT_LENGTH));
        payload.addProperty("width", intConfig("ghn.defaultWidth", "GHN_DEFAULT_WIDTH", DEFAULT_WIDTH));
        payload.addProperty("height", intConfig("ghn.defaultHeight", "GHN_DEFAULT_HEIGHT", DEFAULT_HEIGHT));
        payload.addProperty("service_type_id", intConfig("ghn.serviceTypeId", "GHN_SERVICE_TYPE_ID", DEFAULT_SERVICE_TYPE_ID));
        payload.addProperty("insurance_value", Math.min(toMoney(order.getTotalAmount()), MAX_INSURANCE_VALUE));
        payload.addProperty("client_order_code", order.getOrderCode());
        payload.add("items", buildItems(items));

        String responseText = post("/v2/shipping-order/create", payload, true);
        JsonObject response = gson.fromJson(responseText, JsonObject.class);
        int code = getInt(response, "code", 0);
        if (code != 200) {
            return new GhnCreateOrderResult(false, firstNonBlank(
                    getString(response, "message_display"),
                    getString(response, "message"),
                    "GHN không tạo được vận đơn"
            ));
        }

        JsonObject data = getObject(response, "data");
        GhnCreateOrderResult result = new GhnCreateOrderResult(true, "Đã tạo vận đơn GHN thành công.");
        result.setRawResponse(responseText);
        if (data != null) {
            result.setOrderCode(getString(data, "order_code"));
            result.setTotalFee(getNullableInt(data, "total_fee"));
            result.setExpectedDeliveryTime(getString(data, "expected_delivery_time"));
        }
        return result;
    }

    private JsonArray buildItems(List<OrderItem> items) {
        JsonArray itemArray = new JsonArray();
        if (items == null || items.isEmpty()) {
            return itemArray;
        }

        for (OrderItem item : items) {
            JsonObject itemJson = new JsonObject();
            itemJson.addProperty("name", firstNonBlank(item.getProductName(), "Sản phẩm"));
            itemJson.addProperty("code", String.valueOf(item.getProductId()));
            itemJson.addProperty("quantity", item.getQuantity());
            itemJson.addProperty("price", toMoney(item.getUnitPrice()));
            itemJson.addProperty("length", intConfig("ghn.defaultLength", "GHN_DEFAULT_LENGTH", DEFAULT_LENGTH));
            itemJson.addProperty("width", intConfig("ghn.defaultWidth", "GHN_DEFAULT_WIDTH", DEFAULT_WIDTH));
            itemJson.addProperty("height", intConfig("ghn.defaultHeight", "GHN_DEFAULT_HEIGHT", DEFAULT_HEIGHT));
            itemJson.addProperty("weight", intConfig("ghn.itemWeight", "GHN_ITEM_WEIGHT", DEFAULT_ITEM_WEIGHT));
            itemArray.add(itemJson);
        }

        return itemArray;
    }

    private int resolveDistrictId(String provinceName, String districtName) throws IOException {
        provinceName = cleanAddressPart(provinceName);
        districtName = cleanAddressPart(districtName);
        if (isBlank(districtName)) {
            throw new IOException("Thiếu Quận/Huyện nhận hàng để tạo vận đơn GHN.");
        }

        String responseText = get("/master-data/district");
        JsonArray districts = getDataArray(responseText);
        for (JsonElement element : districts) {
            JsonObject district = element.getAsJsonObject();
            if (matchesName(district, "DistrictName", districtName)
                    && (isBlank(provinceName) || matchesName(district, "ProvinceName", provinceName))) {
                return getInt(district, "DistrictID", 0);
            }
        }

        for (JsonElement element : districts) {
            JsonObject district = element.getAsJsonObject();
            if (matchesName(district, "DistrictName", districtName)) {
                return getInt(district, "DistrictID", 0);
            }
        }

        throw new IOException("Không tìm thấy mã Quận/Huyện GHN cho: " + districtName + ".");
    }

    private String resolveWardCode(int districtId, String wardName) throws IOException {
        wardName = cleanAddressPart(wardName);
        if (districtId <= 0) {
            throw new IOException("Mã Quận/Huyện GHN không hợp lệ.");
        }
        if (isBlank(wardName)) {
            throw new IOException("Thiếu Phường/Xã nhận hàng để tạo vận đơn GHN.");
        }

        JsonObject payload = new JsonObject();
        payload.addProperty("district_id", districtId);
        String responseText = post("/master-data/ward?district_id", payload, false);
        JsonArray wards = getDataArray(responseText);
        for (JsonElement element : wards) {
            JsonObject ward = element.getAsJsonObject();
            if (matchesName(ward, "WardName", wardName)) {
                return getString(ward, "WardCode");
            }
        }

        throw new IOException("Không tìm thấy mã Phường/Xã GHN cho: " + wardName + ".");
    }

    private String get(String path) throws IOException {
        return execute(Request.Get(apiUrl(path))
                .addHeader("Token", token())
                .addHeader("Accept", "application/json"));
    }

    private String post(String path, JsonObject payload, boolean includeShopId) throws IOException {
        Request request = Request.Post(apiUrl(path))
                .addHeader("Token", token())
                .addHeader("Accept", "application/json")
                .bodyString(gson.toJson(payload), ContentType.APPLICATION_JSON);

        if (includeShopId) {
            request.addHeader("ShopId", String.valueOf(shopId()));
        }

        return execute(request);
    }

    private String execute(Request request) throws IOException {
        HttpResponse response = request.execute().returnResponse();
        int statusCode = response.getStatusLine().getStatusCode();
        String responseText = response.getEntity() == null
                ? ""
                : EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);

        if (statusCode < 200 || statusCode >= 300) {
            throw new IOException(buildHttpErrorMessage(statusCode, responseText));
        }

        return responseText;
    }

    private String buildHttpErrorMessage(int statusCode, String responseText) {
        String ghnMessage = extractGhnMessage(responseText);
        if (!isBlank(ghnMessage)) {
            return "GHN báo lỗi " + statusCode + ": " + ghnMessage;
        }
        return "GHN báo lỗi " + statusCode + ". Vui lòng kiểm tra lại địa chỉ nhận hàng và cấu hình shop.";
    }

    private String extractGhnMessage(String responseText) {
        if (isBlank(responseText)) {
            return null;
        }

        try {
            JsonObject response = gson.fromJson(responseText, JsonObject.class);
            return firstNonBlank(
                    getString(response, "code_message_value"),
                    getString(response, "message_display"),
                    getString(response, "message")
            );
        } catch (Exception e) {
            return responseText;
        }
    }

    private String apiUrl(String path) {
        String baseUrl = config("ghn.baseUrl", "GHN_API_BASE_URL", DEFAULT_BASE_URL);
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        return baseUrl + path;
    }

    private void ensureConfigured() {
        if (isBlank(token())) {
            throw new IllegalStateException("Thiếu cấu hình GHN_TOKEN hoặc system property ghn.token.");
        }
        if (shopId() <= 0) {
            throw new IllegalStateException("Thiếu cấu hình GHN_SHOP_ID hoặc system property ghn.shopId.");
        }
    }

    private String token() {
        return config("ghn.token", "GHN_TOKEN", "");
    }

    private int shopId() {
        return intConfig("ghn.shopId", "GHN_SHOP_ID", 0);
    }

    private int calculateCodAmount(Order order, Payment payment) {
        if (payment == null || !isCodPayment(payment.getPaymentMethod())) {
            return 0;
        }
        return Math.min(toMoney(order.getTotalAmount()), MAX_COD_AMOUNT);
    }

    private boolean isCodPayment(String paymentMethod) {
        String normalizedPayment = normalize(paymentMethod);
        return normalizedPayment.contains("cod")
                || normalizedPayment.contains("nhan hang")
                || normalizedPayment.contains("tien mat");
    }

    private int calculateWeight(List<OrderItem> items) {
        int totalQuantity = 0;
        if (items != null) {
            for (OrderItem item : items) {
                totalQuantity += Math.max(item.getQuantity(), 0);
            }
        }
        return Math.max(DEFAULT_ITEM_WEIGHT, totalQuantity * intConfig("ghn.itemWeight", "GHN_ITEM_WEIGHT", DEFAULT_ITEM_WEIGHT));
    }

    private String buildRecipientAddress(RecipientInfo recipient, String wardName) {
        return joinAddress(
                recipient.getAddress(),
                wardName,
                recipient.getDistrict(),
                recipient.getProvince()
        );
    }

    private String joinAddress(String... parts) {
        StringBuilder builder = new StringBuilder();
        for (String part : parts) {
            String cleanedPart = cleanAddressPart(part);
            if (isBlank(cleanedPart)) {
                continue;
            }
            if (builder.length() > 0) {
                builder.append(", ");
            }
            builder.append(cleanedPart);
        }
        return builder.toString();
    }

    private JsonArray getDataArray(String responseText) throws IOException {
        JsonObject response = gson.fromJson(responseText, JsonObject.class);
        JsonElement data = response == null ? null : response.get("data");
        if (data == null || data.isJsonNull()) {
            throw new IOException("GHN trả về dữ liệu không hợp lệ.");
        }
        if (data.isJsonArray()) {
            return data.getAsJsonArray();
        }
        JsonArray array = new JsonArray();
        array.add(data);
        return array;
    }

    private boolean matchesName(JsonObject object, String fieldName, String targetName) {
        String normalizedTarget = normalize(targetName);
        if (normalizedTarget.isEmpty()) {
            return false;
        }

        String name = normalize(getString(object, fieldName));
        if (!name.isEmpty()
                && (name.equals(normalizedTarget) || name.contains(normalizedTarget) || normalizedTarget.contains(name))) {
            return true;
        }

        JsonElement extensions = object.get("NameExtension");
        if (extensions != null && extensions.isJsonArray()) {
            for (JsonElement extension : extensions.getAsJsonArray()) {
                String extensionName = normalize(extension.getAsString());
                if (!extensionName.isEmpty()
                        && (extensionName.equals(normalizedTarget)
                        || extensionName.contains(normalizedTarget)
                        || normalizedTarget.contains(extensionName))) {
                    return true;
                }
            }
        }

        return false;
    }

    private String extractWardFromAddress(String address) {
        address = cleanAddressPart(address);
        if (isBlank(address)) {
            return null;
        }

        String[] parts = address.split(",");
        for (String part : parts) {
            String normalizedPart = normalize(part);
            if (normalizedPart.contains("phuong")
                    || normalizedPart.contains("xa ")
                    || normalizedPart.startsWith("xa")
                    || normalizedPart.contains("thi tran")) {
                return part.trim();
            }
        }
        return null;
    }

    private String config(String propertyName, String envName, String defaultValue) {
        String propertyValue = System.getProperty(propertyName);
        if (!isBlank(propertyValue)) {
            return propertyValue.trim();
        }
        String envValue = System.getenv(envName);
        if (!isBlank(envValue)) {
            return envValue.trim();
        }
        return defaultValue;
    }

    private int intConfig(String propertyName, String envName, int defaultValue) {
        String value = config(propertyName, envName, "");
        if (isBlank(value)) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int toMoney(double value) {
        return Math.max(0, (int) Math.round(value));
    }

    private String getString(JsonObject object, String fieldName) {
        JsonElement element = object == null ? null : object.get(fieldName);
        return element == null || element.isJsonNull() ? null : element.getAsString();
    }

    private JsonObject getObject(JsonObject object, String fieldName) {
        JsonElement element = object == null ? null : object.get(fieldName);
        return element == null || element.isJsonNull() || !element.isJsonObject() ? null : element.getAsJsonObject();
    }

    private int getInt(JsonObject object, String fieldName, int defaultValue) {
        Integer value = getNullableInt(object, fieldName);
        return value == null ? defaultValue : value;
    }

    private Integer getNullableInt(JsonObject object, String fieldName) {
        JsonElement element = object == null ? null : object.get(fieldName);
        if (element == null || element.isJsonNull()) {
            return null;
        }
        try {
            return element.getAsInt();
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (!isBlank(value)) {
                return value.trim();
            }
        }
        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String cleanAddressPart(String value) {
        if (value == null) {
            return null;
        }

        return value
                .replace('\u00A0', ' ')
                .replaceAll("\\s+", " ")
                .replaceAll("\\s+,\\s*", ", ")
                .replaceAll(",\\s*,+", ", ")
                .replaceAll("^,\\s*", "")
                .replaceAll(",\\s*$", "")
                .trim();
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        String cleanedValue = cleanAddressPart(value);
        return Normalizer.normalize(cleanedValue.toLowerCase(Locale.ROOT), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd')
                .trim();
    }
}
