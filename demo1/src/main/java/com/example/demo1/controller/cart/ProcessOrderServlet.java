package com.example.demo1.controller.cart;

import com.example.demo1.model.*;
import com.example.demo1.service.CartService;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.ProductService;
import com.example.demo1.service.NotificationService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "ProcessOrderServlet", value = "/ProcessOrderServlet")
public class ProcessOrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ProductService productService = new ProductService();
    private final CartService cartService = new CartService();

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

        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String addressDetail = request.getParameter("address");

        String phoneRegex = "^(03|05|07|08|09)[0-9]{8}$";
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";

        if (phone == null || !phone.matches(phoneRegex) || email == null || !email.matches(emailRegex)) {
            response.sendRedirect("thanhToan.jsp?error=invalid_format");
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

        double discountAmount = subprice - total;
        double shippingFee = 0;

        String paymentMethod = request.getParameter("payment_method");
        if (paymentMethod == null) paymentMethod = "Thanh toán khi nhận hàng (COD)";
        Payment payment = new Payment(0, paymentMethod, "Thành công", total);

        order.setUserId(user.getId());
        order.setOrderCode("TN-" + System.currentTimeMillis());
        order.setOrderStatus("Chờ xác nhận");
        order.setSubprice(subprice);
        order.setDiscountAmount(discountAmount);
        order.setShippingFee(shippingFee);
        order.setTotalAmount(total);

        RecipientInfo recipient = new RecipientInfo();
        recipient.setFullName(fullName);
        recipient.setPhone(phone);
        recipient.setEmail(email);
        recipient.setProvince(province);
        recipient.setDistrict(district);
        recipient.setAddress(addressDetail);

        boolean success = orderService.createOrder(order, recipient, cartItems, payment);

        if (success) {
            try {
                NotificationService notiService = new NotificationService();

                String content = "Đơn hàng " + order.getOrderCode() + " đặt thành công. Cảm ơn bạn!";
                String link = "order-detail?id=" + order.getId();
                Notification userNoti = new Notification(user.getId(), content, link, 0);
                notiService.insert(userNoti);

                String adminContent = "Đơn hàng mới " + order.getOrderCode() + " từ khách hàng " + fullName;
                String adminLink = "admin/orders?action=view&id=" + order.getId();

                Notification adminNoti = new Notification(null, adminContent, adminLink, 1);
                new com.example.demo1.dao.NotificationDao().insert(adminNoti);

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

            response.sendRedirect("thankyouNotification.jsp");
        } else {
            response.sendRedirect("thanhToan.jsp?error=db");
        }
    }
}