package com.example.demo1.controller.admin;

import com.example.demo1.model.*;
import com.example.demo1.service.OrderService;
import com.example.demo1.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "OrderAdminServlet", value = "/admin/orders")
public class OrderAdminServlet extends HttpServlet {
    private static final String SERVLET_PATH = "/admin/orders";
    private static final String JSP_LIST_PATH = "/admin/adminOrders.jsp";
    private static final String JSP_DETAIL_PATH = "/admin/adminOrderDetails.jsp";
    private static final List<String> ORDER_STATUSES = Arrays.asList(
            "Chờ xác nhận",
            "Đang xử lý",
            "Đang giao",
            "Đã giao",
            "Đã hủy"
    );

    private final OrderService orderService = new OrderService();
    private static final int ORDERS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        orderService.autoAdvanceTimedOrders();

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewOrder(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            updateOrderStatus(request, response);
        } else if ("handoverToCarrier".equals(action)) {
            handoverToCarrier(request, response);
        } else {
            listOrders(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String statusFilter = getValidStatusFilter(request.getParameter("status"));
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

        OrderPage orderPage = orderService.getPagedOrders(keyword, statusFilter, currentPage, ORDERS_PER_PAGE);
        int totalPages = (int) Math.ceil((double) orderPage.getTotalOrders() / ORDERS_PER_PAGE);

        request.setAttribute("orders", orderPage.getOrders());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("orderStatuses", ORDER_STATUSES);

        request.getRequestDispatcher(JSP_LIST_PATH).forward(request, response);
    }

    private String getValidStatusFilter(String status) {
        if (status == null || status.trim().isEmpty()) {
            return null;
        }

        String trimmedStatus = status.trim();
        return ORDER_STATUSES.contains(trimmedStatus) ? trimmedStatus : null;
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            OrderDetail orderDetail = orderService.getOrderDetailById(id);
            if (orderDetail == null) {
                request.getSession().setAttribute("errorMessage", "Đơn hàng không tồn tại.");
                response.sendRedirect(request.getContextPath() + SERVLET_PATH);
                return;
            }
            request.setAttribute("orderDetail", orderDetail);
            request.getRequestDispatcher(JSP_DETAIL_PATH).forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("orderStatus");
            boolean success = false;

            if ("Đã hủy".equals(status)) {
                success = orderService.cancelOrder(orderId, "Bị hủy bởi quản trị viên");
            } else {
                success = orderService.updateOrderStatus(orderId, status, "Quản trị viên cập nhật trạng thái đơn hàng");

                if (success && "Đã giao".equals(status)) {
                    Order order = orderService.getOrderById(orderId);
                    if (order != null) {
                        ProductService productService = new ProductService();
                        List<OrderItem> items = orderService.getOrderItemsByOrderId(orderId);
                    }
                }
            }

            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật trạng thái thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Cập nhật trạng thái thất bại.");
            }

            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?action=view&id=" + orderId);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
        }
    }

    private void handoverToCarrier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            ShippingActionResult result = orderService.handoverToCarrier(orderId);

            if (result.isSuccess()) {
                request.getSession().setAttribute("successMessage", result.getMessage());
            } else {
                request.getSession().setAttribute("errorMessage", result.getMessage());
            }

            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?action=view&id=" + orderId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
        }
    }
}
