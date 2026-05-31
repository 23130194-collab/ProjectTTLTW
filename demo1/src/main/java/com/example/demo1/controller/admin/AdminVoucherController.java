package com.example.demo1.controller.admin;

import com.example.demo1.model.Voucher;
import com.example.demo1.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "AdminVoucherController", value = "/admin/vouchers")
public class AdminVoucherController extends HttpServlet {
    private static final String JSP_PATH = "/admin/adminVouchers.jsp";
    private static final int PAGE_SIZE = 10;
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            showEditForm(request, response);
            return;
        }
        if ("delete".equals(action)) {
            deleteVoucher(request, response);
            return;
        }
        listVouchers(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        saveVoucher(request, response);
    }

    private void listVouchers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        int currentPage = parseInt(request.getParameter("page"), 1);
        int total = voucherService.countVouchers(keyword);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("vouchers", voucherService.getVouchers(keyword, currentPage, PAGE_SIZE));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Voucher voucher = voucherService.getVoucherById(id);
        if (voucher == null) {
            request.getSession().setAttribute("errorMessage", "Voucher không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            return;
        }
        request.setAttribute("voucherToEdit", voucher);
        listVouchers(request, response);
    }

    private void saveVoucher(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                ? null
                : parseInt(request.getParameter("id"), 0);
        String code = cleanCode(request.getParameter("code"));
        double discountValue = parseDouble(request.getParameter("discountValue"), 0);
        Timestamp startDate = parseDateTime(request.getParameter("startDate"));
        Timestamp endDate = parseDateTime(request.getParameter("endDate"));
        int quantity = parseInt(request.getParameter("quantity"), 0);
        double minOrderValue = parseDouble(request.getParameter("minOrderValue"), 0);
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        if (code == null || discountValue <= 0 || startDate == null || endDate == null || !startDate.before(endDate) || quantity <= 0 || minOrderValue < 0) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mã voucher, giá trị giảm, số lượng (>0), đơn tối thiểu (>=0) và thời gian hợp lệ.");
            forwardWithData(request, response);
            return;
        }
        if (voucherService.isCodeExists(code, id)) {
            request.setAttribute("errorMessage", "Mã voucher đã tồn tại.");
            forwardWithData(request, response);
            return;
        }

        Voucher voucher = new Voucher();
        if (id != null) {
            voucher.setId(id);
        }
        voucher.setCode(code);
        voucher.setDiscountValue(discountValue);
        voucher.setStartDate(startDate);
        voucher.setEndDate(endDate);
        voucher.setQuantity(quantity);
        voucher.setMinOrderValue(minOrderValue);
        voucher.setDescription(description);
        voucher.setStatus("INACTIVE".equals(status) ? "INACTIVE" : "ACTIVE");

        voucherService.saveVoucher(voucher);
        request.getSession().setAttribute("successMessage", id == null ? "Thêm voucher thành công." : "Cập nhật voucher thành công.");
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id > 0) {
            voucherService.deleteVoucher(id);
            request.getSession().setAttribute("successMessage", "Xóa voucher thành công.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    private void forwardWithData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Voucher voucher = new Voucher();
        voucher.setId(parseInt(request.getParameter("id"), 0));
        voucher.setCode(cleanCode(request.getParameter("code")));
        voucher.setDiscountValue(parseDouble(request.getParameter("discountValue"), 0));
        voucher.setStartDate(parseDateTime(request.getParameter("startDate")));
        voucher.setEndDate(parseDateTime(request.getParameter("endDate")));
        voucher.setQuantity(parseInt(request.getParameter("quantity"), 0));
        voucher.setMinOrderValue(parseDouble(request.getParameter("minOrderValue"), 0));
        voucher.setDescription(request.getParameter("description"));
        voucher.setStatus(request.getParameter("status"));
        request.setAttribute("voucherToEdit", voucher);
        listVouchers(request, response);
    }

    private String cleanCode(String value) {
        if (value == null) {
            return null;
        }
        String cleaned = value.trim().toUpperCase().replaceAll("\\s+", "");
        return cleaned.isEmpty() ? null : cleaned;
    }

    private Timestamp parseDateTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return Timestamp.valueOf(LocalDateTime.parse(value));
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value == null ? defaultValue : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return value == null ? defaultValue : Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
