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

        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (currentUser == null) {
            if (isAjax) {
                sendJson(response, HttpServletResponse.SC_UNAUTHORIZED,
                        "{\"success\":false,\"error\":\"Vui lòng đăng nhập lại.\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
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

                if (isAjax) {
                    UserAddress saved = userAddressService.getDefaultAddressByUserId(currentUser.getId());
                    java.util.List<UserAddress> all = userAddressService.getAddressesByUserId(currentUser.getId());
                    UserAddress newest = all.isEmpty() ? address : all.get(all.size() - 1);
                    sendJson(response, HttpServletResponse.SC_OK, buildAddressJson(newest, true));
                    return;
                }
                session.setAttribute("addressSuccess", "Đã thêm địa chỉ nhận hàng.");

            } else if ("update".equals(action)) {
                int addressId = parseAddressId(request.getParameter("addressId"));
                UserAddress address = buildAddressFromRequest(request, currentUser);
                address.setId(addressId);
                address.setUserId(currentUser.getId());

                if (userAddressService.updateAddress(address)) {
                    refreshDefaultAddressInSession(session, currentUser);
                    if (isAjax) {
                        sendJson(response, HttpServletResponse.SC_OK, buildAddressJson(address, false));
                        return;
                    }
                    session.setAttribute("addressSuccess", "Đã cập nhật địa chỉ nhận hàng.");
                } else {
                    if (isAjax) {
                        sendJson(response, HttpServletResponse.SC_NOT_FOUND,
                                "{\"success\":false,\"error\":\"Không tìm thấy địa chỉ cần cập nhật.\"}");
                        return;
                    }
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
                if (isAjax) {
                    sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                            "{\"success\":false,\"error\":\"Thao tác không hợp lệ.\"}");
                    return;
                }
                session.setAttribute("addressError", "Thao tác địa chỉ không hợp lệ.");
            }

        } catch (IllegalArgumentException e) {
            if (isAjax) {
                sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
                return;
            }
            session.setAttribute("addressError", e.getMessage());
            if ("add".equals(action)) redirectUrl += "?addressMode=add";

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "{\"success\":false,\"error\":\"Đã xảy ra lỗi. Vui lòng thử lại.\"}");
                return;
            }
            session.setAttribute("addressError", "Đã xảy ra lỗi khi xử lý địa chỉ. Vui lòng thử lại.");
        }

        response.sendRedirect(redirectUrl);
    }

    private void sendJson(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(json);
    }

    private String buildAddressJson(UserAddress a, boolean selectAfterSave) {
        return "{"
                + "\"success\":true,"
                + "\"selectAfterSave\":" + selectAfterSave + ","
                + "\"id\":"           + a.getId()                              + ","
                + "\"label\":\""      + escapeJson(a.getLabel())               + "\","
                + "\"fullName\":\""   + escapeJson(a.getFullName())            + "\","
                + "\"phone\":\""      + escapeJson(a.getPhone())               + "\","
                + "\"province\":\""   + escapeJson(a.getProvince())            + "\","
                + "\"ward\":\""       + escapeJson(a.getWard())                + "\","
                + "\"fullAddress\":\"" + escapeJson(a.getFullAddress())        + "\","
                + "\"isDefault\":"    + a.isDefaultAddress()
                + "}";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private UserAddress buildAddressFromRequest(HttpServletRequest request, User currentUser) {
        String label         = trim(request.getParameter("label"));
        String fullName      = trim(request.getParameter("fullName"));
        String phone         = trim(request.getParameter("phone"));
        String addressDetail = trim(request.getParameter("addressDetail"));
        String provinceOption = trim(request.getParameter("province"));
        String wardOption     = trim(request.getParameter("ward"));

        if (fullName.isEmpty())
            throw new IllegalArgumentException("Vui lòng nhập họ tên người nhận.");
        if (phone.isEmpty() || !phone.matches("^(03|05|07|08|09)[0-9]{8}$"))
            throw new IllegalArgumentException("Số điện thoại phải có 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09.");
        if (addressDetail.isEmpty())
            throw new IllegalArgumentException("Vui lòng nhập số nhà, tên đường.");
        if (provinceOption.isEmpty() || wardOption.isEmpty())
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ Tỉnh/Thành phố và Phường/Xã.");

        String provinceName = VietnamAddressService.getNameFromOptionValue(provinceOption);
        String wardName     = VietnamAddressService.getNameFromOptionValue(wardOption);
        String fullAddress  = buildFullAddress(addressDetail, wardName, provinceName);

        UserAddress address = new UserAddress();
        address.setLabel(label.isEmpty() ? "Địa chỉ" : label);
        address.setFullName(fullName);
        address.setPhone(phone);
        address.setAddressDetail(addressDetail);
        address.setWard(wardName);
        address.setProvince(provinceName);
        address.setFullAddress(fullAddress);
        address.setDefaultAddress(
                "true".equals(request.getParameter("defaultAddress"))
                        || "on".equals(request.getParameter("defaultAddress"))
                        || trim(currentUser.getAddress()).isEmpty());
        return address;
    }

    private String buildFullAddress(String addressDetail, String wardName, String provinceName) {
        StringBuilder sb = new StringBuilder();
        appendAddressPart(sb, addressDetail);
        appendAddressPart(sb, wardName);
        appendAddressPart(sb, provinceName);
        return sb.toString();
    }

    private void appendAddressPart(StringBuilder sb, String part) {
        String t = trim(part);
        if (t.isEmpty()) return;
        if (sb.length() > 0) sb.append(", ");
        sb.append(t);
    }

    private int parseAddressId(String value) {
        try {
            int id = Integer.parseInt(trim(value));
            if (id <= 0) throw new NumberFormatException();
            return id;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Địa chỉ không hợp lệ.");
        }
    }

    private void refreshDefaultAddressInSession(HttpSession session, User currentUser) {
        UserAddress def = userAddressService.getDefaultAddressByUserId(currentUser.getId());
        currentUser.setAddress(def == null ? null : def.getFullAddress());
        session.setAttribute("user", currentUser);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
