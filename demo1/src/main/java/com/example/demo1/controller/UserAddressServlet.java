package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.model.UserAddress;
import com.example.demo1.service.UserAddressService;
import com.example.demo1.service.VietnamAddressService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UserAddressServlet", value = "/account-address")
public class UserAddressServlet extends HttpServlet {
    private final UserAddressService userAddressService = new UserAddressService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = trim(request.getParameter("action"));
        String redirectUrl = request.getContextPath() + "/account";

        try {
            if ("add".equals(action)) {
                UserAddress address = buildAddressFromRequest(request, currentUser);
                address.setUserId(currentUser.getId());
                userAddressService.createAddress(address);
                refreshDefaultAddressInSession(session, currentUser);
                session.setAttribute("addressSuccess", "Đã thêm địa chỉ nhận hàng.");
            } else if ("update".equals(action)) {
                int addressId = parseAddressId(request.getParameter("addressId"));
                redirectUrl += "?addressMode=edit&addressId=" + addressId;

                UserAddress address = buildAddressFromRequest(request, currentUser);
                address.setId(addressId);
                address.setUserId(currentUser.getId());

                if (userAddressService.updateAddress(address)) {
                    refreshDefaultAddressInSession(session, currentUser);
                    session.setAttribute("addressSuccess", "Đã cập nhật địa chỉ nhận hàng.");
                    redirectUrl = request.getContextPath() + "/account";
                } else {
                    session.setAttribute("addressError", "Không tìm thấy địa chỉ cần cập nhật.");
                }
            } else if ("delete".equals(action)) {
                int addressId = parseAddressId(request.getParameter("addressId"));

                if (userAddressService.deleteAddress(currentUser.getId(), addressId)) {
                    refreshDefaultAddressInSession(session, currentUser);
                    session.setAttribute("addressSuccess", "Đã xóa địa chỉ nhận hàng.");
                } else {
                    session.setAttribute("addressError", "Không tìm thấy địa chỉ cần xóa.");
                }
            } else if ("set-default".equals(action)) {
                int addressId = parseAddressId(request.getParameter("addressId"));

                if (userAddressService.setDefaultAddress(currentUser.getId(), addressId)) {
                    refreshDefaultAddressInSession(session, currentUser);
                    session.setAttribute("addressSuccess", "Đã đặt làm địa chỉ mặc định.");
                } else {
                    session.setAttribute("addressError", "Không tìm thấy địa chỉ cần đặt mặc định.");
                }
            } else {
                session.setAttribute("addressError", "Thao tác địa chỉ không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("addressError", e.getMessage());
            if ("add".equals(action)) {
                redirectUrl = request.getContextPath() + "/account?addressMode=add";
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("addressError", "Đã xảy ra lỗi khi xử lý địa chỉ. Vui lòng thử lại.");
        }

        response.sendRedirect(redirectUrl);
    }

    private UserAddress buildAddressFromRequest(HttpServletRequest request, User currentUser) {
        String label = trim(request.getParameter("label"));
        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phone"));
        String addressDetail = trim(request.getParameter("addressDetail"));
        String provinceOption = trim(request.getParameter("province"));
        String wardOption = trim(request.getParameter("ward"));

        if (fullName.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập họ tên người nhận.");
        }
        if (phone.isEmpty() || !phone.matches("^(03|05|07|08|09)[0-9]{8}$")) {
            throw new IllegalArgumentException("Số điện thoại phải có 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09.");
        }
        if (addressDetail.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập số nhà, tên đường.");
        }
        if (provinceOption.isEmpty() || wardOption.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ Tỉnh/Thành phố và Phường/Xã.");
        }

        String provinceName = VietnamAddressService.getNameFromOptionValue(provinceOption);
        String wardName = VietnamAddressService.getNameFromOptionValue(wardOption);
        String fullAddress = buildFullAddress(addressDetail, wardName, provinceName);

        UserAddress address = new UserAddress();
        address.setLabel(label.isEmpty() ? "Địa chỉ" : label);
        address.setFullName(fullName);
        address.setPhone(phone);
        address.setAddressDetail(addressDetail);
        address.setWard(wardName);
        address.setProvince(provinceName);
        address.setFullAddress(fullAddress);
        address.setDefaultAddress("true".equals(request.getParameter("defaultAddress"))
                || "on".equals(request.getParameter("defaultAddress"))
                || trim(currentUser.getAddress()).isEmpty());

        return address;
    }

    private String buildFullAddress(String addressDetail, String wardName, String provinceName) {
        StringBuilder fullAddress = new StringBuilder();
        appendAddressPart(fullAddress, addressDetail);
        appendAddressPart(fullAddress, wardName);
        appendAddressPart(fullAddress, provinceName);
        return fullAddress.toString();
    }

    private void appendAddressPart(StringBuilder address, String part) {
        String trimmed = trim(part);
        if (trimmed.isEmpty()) {
            return;
        }

        if (address.length() > 0) {
            address.append(", ");
        }
        address.append(trimmed);
    }

    private int parseAddressId(String value) {
        try {
            int addressId = Integer.parseInt(trim(value));
            if (addressId <= 0) {
                throw new NumberFormatException("Address id must be positive");
            }
            return addressId;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Địa chỉ không hợp lệ.");
        }
    }

    private void refreshDefaultAddressInSession(HttpSession session, User currentUser) {
        UserAddress defaultAddress = userAddressService.getDefaultAddressByUserId(currentUser.getId());
        currentUser.setAddress(defaultAddress == null ? null : defaultAddress.getFullAddress());
        session.setAttribute("user", currentUser);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
