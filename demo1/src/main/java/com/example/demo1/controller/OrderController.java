package com.example.demo1.controller;

import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.Order;
import com.example.demo1.model.OrderItem;
import com.example.demo1.model.User;
import com.example.demo1.model.VietnamAddressUnit;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.VietnamAddressService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "OrderController", urlPatterns = {"/my-orders", "/order-detail", "/account"})
public class OrderController extends HttpServlet {
    private final VietnamAddressService vietnamAddressService = new VietnamAddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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
                OrderService orderService = new OrderService();

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

    private void handleAccount(HttpServletRequest request, User user) {
        if (!"edit".equals(request.getParameter("mode"))) {
            return;
        }

        try {
            List<VietnamAddressUnit> provinces = vietnamAddressService.getProvinces();
            request.setAttribute("addressProvinces", provinces);

            String currentAddress = user.getAddress();
            String selectedProvinceValue = request.getParameter("province");
            Integer selectedProvinceCode = VietnamAddressService.getCodeFromOptionValue(selectedProvinceValue);

            VietnamAddressUnit selectedProvince = selectedProvinceCode == null
                    ? findByAddress(provinces, currentAddress)
                    : findByCode(provinces, selectedProvinceCode);

            if (selectedProvince != null) {
                selectedProvinceValue = selectedProvince.getOptionValue();
                request.setAttribute("selectedProvinceValue", selectedProvinceValue);

                List<VietnamAddressUnit> wards = vietnamAddressService.getWardsByProvinceCode(selectedProvince.getCode());
                request.setAttribute("addressWards", wards);

                String selectedWardValue = request.getParameter("ward");
                Integer selectedWardCode = VietnamAddressService.getCodeFromOptionValue(selectedWardValue);

                VietnamAddressUnit selectedWard = selectedWardCode == null
                        ? findByAddress(wards, currentAddress)
                        : findByCode(wards, selectedWardCode);

                if (selectedWard != null) {
                    selectedWardValue = selectedWard.getOptionValue();
                    request.setAttribute("selectedWardValue", selectedWardValue);
                }

                String addressDetail = request.getParameter("addressDetail");
                if (addressDetail == null) {
                    addressDetail = selectedWard == null
                            ? ""
                            : extractAddressDetail(currentAddress, selectedProvince.getName(), selectedWard.getName());
                }
                request.setAttribute("addressDetail", addressDetail);
            } else {
                request.setAttribute("addressWards", Collections.emptyList());
                request.setAttribute("addressDetail", valueOrEmpty(request.getParameter("addressDetail")));
            }
        } catch (IOException e) {
            request.setAttribute("addressLoadError", "Không tải được dữ liệu Tỉnh/Thành phố, Phường/Xã. Vui lòng thử lại sau.");
            request.setAttribute("addressProvinces", Collections.emptyList());
            request.setAttribute("addressWards", Collections.emptyList());
            request.setAttribute("addressDetail", valueOrEmpty(request.getParameter("addressDetail")));
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

    private VietnamAddressUnit findByAddress(List<VietnamAddressUnit> units, String address) {
        String normalizedAddress = normalize(address);
        if (units == null || normalizedAddress.isEmpty()) {
            return null;
        }

        for (VietnamAddressUnit unit : units) {
            if (!normalize(unit.getName()).isEmpty() && normalizedAddress.contains(normalize(unit.getName()))) {
                return unit;
            }
        }

        return null;
    }

    private String extractAddressDetail(String address, String provinceName, String wardName) {
        if (address == null || address.trim().isEmpty()) {
            return "";
        }

        List<String> selectedParts = new ArrayList<>();
        selectedParts.add(normalize(provinceName));
        selectedParts.add(normalize(wardName));
        selectedParts.add("viet nam");

        List<String> detailParts = new ArrayList<>();
        String[] parts = address.split(",");
        for (String part : parts) {
            String trimmed = part.trim();
            String normalizedPart = normalize(trimmed);
            if (!trimmed.isEmpty() && !selectedParts.contains(normalizedPart)) {
                detailParts.add(trimmed);
            }
        }

        return String.join(", ", detailParts);
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
