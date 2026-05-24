package com.example.demo1.model;

public class ShippingActionResult {
    private final boolean success;
    private final String message;
    private final String carrierOrderCode;

    private ShippingActionResult(boolean success, String message, String carrierOrderCode) {
        this.success = success;
        this.message = message;
        this.carrierOrderCode = carrierOrderCode;
    }

    public static ShippingActionResult success(String message) {
        return new ShippingActionResult(true, message, null);
    }

    public static ShippingActionResult success(String message, String carrierOrderCode) {
        return new ShippingActionResult(true, message, carrierOrderCode);
    }

    public static ShippingActionResult failure(String message) {
        return new ShippingActionResult(false, message, null);
    }

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }

    public String getCarrierOrderCode() {
        return carrierOrderCode;
    }
}
