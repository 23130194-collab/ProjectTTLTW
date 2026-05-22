package com.example.demo1.controller;

import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.Order;
import com.example.demo1.model.OrderItem;
import com.example.demo1.model.User;
import com.example.demo1.model.UserAddress;
import com.example.demo1.model.VietnamAddressUnit;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.UserAddressService;
import com.example.demo1.service.VietnamAddressService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.Normalizer;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "OrderController", urlPatterns = {"/my-orders", "/order-detail", "/account", "/confirm-received"})
public class OrderController extends HttpServlet {
    private final VietnamAddressService vietnamAddressService = new VietnamAddressService();
    private final UserAddressService userAddressService = new UserAddressService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        orderService.autoAdvanceTimedOrders();

        OrderDao orderDao = new OrderDao();

        int totalOrders = orderDao.countTotalOrdersByUserId(user.getId());
        double totalSpent = orderDao.calculateTotalSpentByUserId(user.getId());

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalSpent", totalSpent);

        String path = request.getServletPath();

        if (path.equals("/my-orders") || path.equals("/user")) {
            handleListOrders(request, response, user, orderDao);
        } else if (path.equals("/order-detail")) {
            handleOrderDetail(request, response, user, orderDao);
        } else if (path.equals("/account")) {
            handleAccount(request, user);
            request.getRequestDispatcher("/thongTinTaiKhoan.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/order-detail")) {
            handleCancelOrder(request, response);
        } else if (path.equals("/confirm-received")) {
            handleConfirmReceived(request, response);
        } else if (path.equals("/account")) {
            handleAccountReload(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    private void handleAccountReload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDao orderDao = new OrderDao();
        request.setAttribute("totalOrders", orderDao.countTotalOrdersByUserId(user.getId()));
        request.setAttribute("totalSpent", orderDao.calculateTotalSpentByUserId(user.getId()));

        handleAccount(request, user);
        request.getRequestDispatcher("/thongTinTaiKhoan.jsp").forward(request, response);
    }

    private void handleListOrders(HttpServletRequest request, HttpServletResponse response, User user, OrderDao orderDao)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Order> orderList;

        if (status != null && !status.isEmpty()) {
            orderList = orderDao.getOrdersByUserIdAndStatus(user.getId(), status);
        } else {
            orderList = orderDao.getOrdersByUserId(user.getId());
        }

        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("/user.jsp").forward(request, response);
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, User user, OrderDao orderDao)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDao.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("timelineSteps", orderService.getOrderTimelineSteps(order));
            request.getRequestDispatcher("/chiTietDonHang.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("id");
        String reason = request.getParameter("cancellationReason");

        if ("cancel".equals(action) && orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                OrderDao orderDao = new OrderDao();
                Order order = orderDao.getOrderById(orderId);

                if (order != null && order.getUserId() == user.getId()) {
                    if ("Chờ xác nhận".equals(order.getOrderStatus())) {
                        orderService.cancelOrder(orderId, reason);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/my-orders");
    }

    private void handleConfirmReceived(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("id");
        if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                orderService.confirmReceived(orderId, user.getId());
                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/my-orders");
    }

    private void handleAccount(HttpServletRequest request, User user) {
        userAddressService.ensureDefaultAddressForUser(user);

        List<UserAddress> userAddresses = userAddressService.getAddressesByUserId(user.getId());
        UserAddress defaultAddress = null;
        for (UserAddress address : userAddresses) {
            if (address.isDefaultAddress()) {
                defaultAddress = address;
                break;
            }
        }

        if (defaultAddress == null && !userAddresses.isEmpty()) {
            userAddressService.setDefaultAddress(user.getId(), userAddresses.get(0).getId());
            userAddresses = userAddressService.getAddressesByUserId(user.getId());
            defaultAddress = userAddressService.getDefaultAddressByUserId(user.getId());
        }

        if (defaultAddress != null) {
            user.setAddress(defaultAddress.getFullAddress());
        }

        request.setAttribute("userAddresses", userAddresses);
        request.setAttribute("defaultAddress", defaultAddress);
        prepareAddressForm(request, user);
    }

    private void prepareAddressForm(HttpServletRequest request, User user) {
        String addressMode = request.getParameter("addressMode");
        if (!"add".equals(addressMode) && !"edit".equals(addressMode)) {
            return;
        }

        UserAddress editingAddress = null;
        if ("edit".equals(addressMode)) {
            try {
                int addressId = Integer.parseInt(valueOrEmpty(request.getParameter("addressId")));
                editingAddress = userAddressService.getAddressById(user.getId(), addressId);
                request.setAttribute("editingAddress", editingAddress);
                if (editingAddress == null) {
                    request.setAttribute("addressFormError", "Không tìm thấy địa chỉ cần sửa.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("addressFormError", "Địa chỉ cần sửa không hợp lệ.");
            }
        }

        try {
            List<VietnamAddressUnit> provinces = vietnamAddressService.getProvinces();
            request.setAttribute("addressFormProvinces", provinces);

            String selectedProvinceValue = request.getParameter("province");
            Integer selectedProvinceCode = VietnamAddressService.getCodeFromOptionValue(selectedProvinceValue);
            VietnamAddressUnit selectedProvince = selectedProvinceCode == null
                    ? findByName(provinces, editingAddress == null ? null : editingAddress.getProvince())
                    : findByCode(provinces, selectedProvinceCode);

            if (selectedProvince != null) {
                selectedProvinceValue = selectedProvince.getOptionValue();
                request.setAttribute("selectedAddressProvinceValue", selectedProvinceValue);

                List<VietnamAddressUnit> wards = vietnamAddressService.getWardsByProvinceCode(selectedProvince.getCode());
                request.setAttribute("addressFormWards", wards);

                String selectedWardValue = request.getParameter("ward");
                Integer selectedWardCode = VietnamAddressService.getCodeFromOptionValue(selectedWardValue);
                VietnamAddressUnit selectedWard = selectedWardCode == null
                        ? findByName(wards, editingAddress == null ? null : editingAddress.getWard())
                        : findByCode(wards, selectedWardCode);

                if (selectedWard != null) {
                    request.setAttribute("selectedAddressWardValue", selectedWard.getOptionValue());
                }
            } else {
                request.setAttribute("addressFormWards", Collections.emptyList());
            }
        } catch (IOException e) {
            request.setAttribute("addressFormLoadError", "Không tải được dữ liệu Tỉnh/Thành phố, Phường/Xã. Vui lòng thử lại sau.");
            request.setAttribute("addressFormProvinces", Collections.emptyList());
            request.setAttribute("addressFormWards", Collections.emptyList());
        }
    }

    private VietnamAddressUnit findByCode(List<VietnamAddressUnit> units, Integer code) {
        if (units == null || code == null) {
            return null;
        }

        for (VietnamAddressUnit unit : units) {
            if (unit.getCode() == code) {
                return unit;
            }
        }

        return null;
    }

    private VietnamAddressUnit findByName(List<VietnamAddressUnit> units, String name) {
        String normalizedName = normalize(name);
        if (units == null || normalizedName.isEmpty()) {
            return null;
        }

        for (VietnamAddressUnit unit : units) {
            if (normalizedName.equals(normalize(unit.getName()))) {
                return unit;
            }
        }

        return null;
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }

        return Normalizer.normalize(value.toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd')
                .trim();
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }
}
