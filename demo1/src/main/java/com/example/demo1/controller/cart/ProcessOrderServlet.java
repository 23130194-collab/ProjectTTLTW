package com.example.demo1.controller.cart;

import com.example.demo1.model.*;
import com.example.demo1.service.CartService;
import com.example.demo1.service.GhnShippingService;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.ProductService;
import com.example.demo1.service.NotificationService;
import com.example.demo1.service.UserAddressService;
import com.example.demo1.service.VoucherService;
import com.example.demo1.exception.OutOfStockException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import com.example.demo1.config.VnPayConfig;

@WebServlet(name = "ProcessOrderServlet", value = "/ProcessOrderServlet")
public class ProcessOrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ProductService productService = new ProductService();
    private final CartService cartService = new CartService();
    private final GhnShippingService ghnShippingService = new GhnShippingService();
    private final VoucherService voucherService = new VoucherService();
    private final UserAddressService userAddressService = new UserAddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("thanhToan.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getId());

        String[] productIds = request.getParameterValues("productIds");
        String idsParam = "";
        if (productIds != null) {
            idsParam = String.join(",", productIds);
        }

        if (productIds != null && cartItems != null && !cartItems.isEmpty()) {
            Set<Integer> selectedIds = new HashSet<>();
            for (String idStr : productIds) {
                selectedIds.add(Integer.parseInt(idStr));
            }

            List<CartItem> filteredItems = new ArrayList<>();
            for (CartItem item : cartItems) {
                if (selectedIds.contains(item.getProduct().getId())) {
                    filteredItems.add(item);
                }
            }
            cartItems = filteredItems;
        }

        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("cartError", "Giỏ hàng thanh toán không hợp lệ hoặc đã trống.");
            response.sendRedirect("AddCart?action=view");
            return;
        }

        String fullName = cleanInput(request.getParameter("fullname"));
        String phone = cleanPhone(request.getParameter("phone"));
        String email = cleanInput(request.getParameter("email"));
        int addressId = parseInt(request.getParameter("addressId"), 0);
        UserAddress selectedAddress = addressId > 0 ? userAddressService.getAddressById(user.getId(), addressId) : null;

        String province = cleanInput(selectedAddress != null ? selectedAddress.getProvince() : request.getParameter("province"));
        String district = cleanInput(selectedAddress != null ? selectedAddress.getDistrict() : request.getParameter("district"));
        if (district == null) {
            district = "";
        }
        String ward = cleanInput(selectedAddress != null ? selectedAddress.getWard() : request.getParameter("ward"));
        String addressDetail = cleanInput(selectedAddress != null ? selectedAddress.getAddressDetail() : request.getParameter("address"));

        String phoneRegex = "^(03|05|07|08|09)[0-9]{8}$";
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";

        if (phone == null || !phone.matches(phoneRegex) || email == null || !email.matches(emailRegex)) {
            response.sendRedirect("AddCart?action=checkout&ids=" + idsParam + "&error=invalid_format");
            return;
        }

        for (CartItem item : cartItems) {
            Product dbProduct = productService.getProduct(item.getProduct().getId());

            if (dbProduct == null) {
                session.setAttribute("cartError", "Một số sản phẩm trong giỏ hàng không còn khả dụng.");
                response.sendRedirect("AddCart?action=view");
                return;
            }

            if (item.getQuantity() > dbProduct.getStock()) {
                session.setAttribute("cartError", "Sản phẩm " + dbProduct.getName() + " chỉ còn " + dbProduct.getStock() + " cái.");
                response.sendRedirect("AddCart?action=view");
                return;
            }
        }

        Order order = new Order();
        double total = 0;
        double subprice = 0;

        for (CartItem item : cartItems) {
            double price = item.getProduct().getPrice();
            double oldPrice = item.getProduct().getOldPrice();

            if (oldPrice == 0) {
                oldPrice = price;
            }

            total += price * item.getQuantity();
            subprice += oldPrice * item.getQuantity();
        }

        RecipientInfo recipient = new RecipientInfo();
        recipient.setFullName(fullName);
        recipient.setPhone(phone);
        recipient.setEmail(email);
        recipient.setProvince(province);
        recipient.setDistrict(district);
        recipient.setWard(ward);
        recipient.setAddress(addressDetail);

        double discountAmount = subprice - total;
        int voucherId = parseInt(request.getParameter("voucherId"), 0);
        Voucher appliedVoucher = voucherId > 0 ? voucherService.getUsableSavedVoucher(user.getId(), voucherId) : null;
        double voucherDiscountAmount = voucherService.calculateDiscount(appliedVoucher, total);
        double shippingFee;
        try {
            shippingFee = ghnShippingService.calculateShippingFee(recipient, cartItems, total);
        } catch (Exception e) {
            session.setAttribute("checkoutError", "Không tính được phí vận chuyển GHN: " + e.getMessage());
            response.sendRedirect("AddCart?action=checkout&ids=" + idsParam + "&error=shipping");
            return;
        }
        double payableTotal = Math.max(total - voucherDiscountAmount, 0) + shippingFee;

        String paymentMethod = cleanInput(request.getParameter("payment_method"));
        if (paymentMethod == null) paymentMethod = "Thanh toán khi nhận hàng (COD)";
        
        boolean isVnPay = "VNPAY".equalsIgnoreCase(paymentMethod) || "Chuyển khoản".equalsIgnoreCase(paymentMethod);
        
        Payment payment = new Payment(0, paymentMethod, isVnPay ? "Chờ thanh toán" : "Thành công", payableTotal);

        order.setUserId(user.getId());
        order.setOrderCode("TN-" + System.currentTimeMillis());
        order.setOrderStatus(isVnPay ? "Chờ thanh toán" : "Chờ xác nhận");
        order.setSubprice(subprice);
        order.setDiscountAmount(discountAmount + voucherDiscountAmount);
        order.setVoucherId(appliedVoucher == null ? null : appliedVoucher.getId());
        order.setVoucherDiscountAmount(voucherDiscountAmount);
        order.setShippingFee(shippingFee);
        order.setTotalAmount(payableTotal);

        boolean success = false;
        try {
            success = orderService.createOrder(order, recipient, cartItems, payment);
        } catch (OutOfStockException e) {
            session.setAttribute("cartError", e.getMessage());
            response.sendRedirect("AddCart?action=view");
            return;
        }

        if (success) {
            if (appliedVoucher != null) {
                voucherService.markVoucherUsed(user.getId(), appliedVoucher.getId(), order.getId());
            }
            try {
                NotificationService notiService = new NotificationService();

                String content = "Đơn hàng " + order.getOrderCode() + " đặt thành công. Cảm ơn bạn!";
                String link = "order-detail?id=" + order.getId();
                Notification userNoti = new Notification(user.getId(), content, link, 0);
                notiService.insert(userNoti);

            } catch (Exception e) {
                e.printStackTrace();
            }

            if (productIds != null) {
                for (String idStr : productIds) {
                    cartService.removeItem(user.getId(), Integer.parseInt(idStr));
                }
            } else {
                cartService.clearCart(user.getId());
            }

            if (isVnPay) {
                String vnpayUrl = generateVnPayUrl(request, order.getOrderCode(), payableTotal);
                response.sendRedirect(vnpayUrl);
            } else {
                response.sendRedirect("thankyouNotification.jsp");
            }
        } else {
            response.sendRedirect("AddCart?action=checkout&ids=" + idsParam + "&error=db");
        }
    }

    private String generateVnPayUrl(HttpServletRequest request, String orderCode, double amount) {
        String vnp_Version = VnPayConfig.vnp_Version;
        String vnp_Command = VnPayConfig.vnp_Command;
        String vnp_OrderInfo = "Thanh toan don hang " + orderCode;
        String orderType = "other";
        String vnp_TxnRef = orderCode;
        String vnp_IpAddr = VnPayConfig.getIpAddress(request);
        String vnp_TmnCode = VnPayConfig.vnp_TmnCode;
        
        int amountInVnd = (int) (amount);

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amountInVnd * 100));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_BankCode", ""); 
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.vnp_Returnurl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        java.util.Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        java.util.Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                try {
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                } catch (java.io.UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = VnPayConfig.hmacSHA512(VnPayConfig.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        return VnPayConfig.vnp_PayUrl + "?" + queryUrl;
    }

    private String cleanInput(String value) {
        if (value == null) {
            return null;
        }

        return value
                .replace('\u00A0', ' ')
                .replaceAll("\\s+", " ")
                .replaceAll("\\s+,\\s*", ", ")
                .trim();
    }

    private String cleanPhone(String value) {
        String cleanedValue = cleanInput(value);
        return cleanedValue == null ? null : cleanedValue.replaceAll("\\s+", "");
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.trim().isEmpty() ? defaultValue : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

}
