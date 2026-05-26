package com.example.demo1.controller.payment;

import com.example.demo1.config.VnPayConfig;
import com.example.demo1.dao.OrderDao;
import com.example.demo1.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VnPayReturnServlet", value = "/vnpay-return")
public class VnPayReturnServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()),
                           URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        String signValue = VnPayConfig.hashAllFields(fields);
        
        String orderCode = request.getParameter("vnp_TxnRef");
        
        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                Order order = orderDao.getOrderByCode(orderCode);
                if (order != null && "Chờ thanh toán".equals(order.getOrderStatus())) {
                    orderDao.updateOrderStatus(order.getId(), "Đang xử lý");
                }
                
                request.setAttribute("message", "Thanh toán thành công! Mã đơn hàng: " + orderCode);
                request.setAttribute("status", "success");
            } else {
                Order order = orderDao.getOrderByCode(orderCode);
                if (order != null && "Chờ thanh toán".equals(order.getOrderStatus())) {
                    orderDao.updateOrderStatus(order.getId(), "Thanh toán thất bại");
                }
                
                request.setAttribute("message", "Thanh toán thất bại hoặc bị hủy. Mã đơn: " + orderCode);
                request.setAttribute("status", "failed");
            }
        } else {
            request.setAttribute("message", "Chữ ký bảo mật không hợp lệ!");
            request.setAttribute("status", "error");
        }
        
        request.getRequestDispatcher("/vnpayReturn.jsp").forward(request, response);
    }
}
