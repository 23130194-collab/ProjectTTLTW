package com.example.demo1.controller.admin;

import com.example.demo1.model.Contact;
import com.example.demo1.service.ContactService;
import com.example.demo1.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "AdminContactServlet", value = "/admin/contacts")
public class AdminContactServlet extends HttpServlet {
    private static final String JSP_PATH = "/admin/adminContacts.jsp";
    private static final String SERVLET_PATH = "/admin/contacts";
    private static final int CONTACTS_PER_PAGE = 10;
    private final ContactService contactService = new ContactService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            handleDetail(request);
        }

        showContactList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("reply".equals(action)) {
            handleReply(request, response);
            return;
        }

        if ("markProcessed".equals(action)) {
            handleMarkProcessed(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void showContactList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        String status = normalizeStatus(request.getParameter("status"));
        int currentPage = parsePage(request.getParameter("page"));

        int totalContacts = contactService.getTotalContactCount(keyword, status);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalContacts / CONTACTS_PER_PAGE));

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        List<Contact> contactList = contactService.getContactsByPage(currentPage, CONTACTS_PER_PAGE, keyword, status);

        request.setAttribute("contactList", contactList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    private void handleDetail(HttpServletRequest request) {
        try {
            int contactId = Integer.parseInt(request.getParameter("id"));
            Contact selectedContact = contactService.getContactById(contactId);

            if (selectedContact == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy liên hệ cần xem chi tiết.");
                return;
            }

            request.setAttribute("selectedContact", selectedContact);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID liên hệ không hợp lệ.");
        }
    }

    private void handleReply(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = normalize(request.getParameter("searchKeyword"));
        String status = normalizeStatus(request.getParameter("statusFilter"));
        int page = parsePage(request.getParameter("page"));

        try {
            int contactId = Integer.parseInt(request.getParameter("contactId"));
            String responseContent = normalize(request.getParameter("responseContent"));

            if (responseContent.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Vui lòng nhập nội dung phản hồi.");
                response.sendRedirect(buildRedirectUrl(request, page, status, keyword, contactId));
                return;
            }

            Contact contact = contactService.getContactById(contactId);
            if (contact == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy liên hệ để phản hồi.");
                response.sendRedirect(buildRedirectUrl(request, page, status, keyword, null));
                return;
            }

            EmailService.sendContactResponseEmail(contact.getEmail(), contact.getName(), contact.getContent(), responseContent);
            contactService.saveResponse(contactId, responseContent);
            request.getSession().setAttribute("successMessage", "Đã gửi email phản hồi và cập nhật trạng thái liên hệ.");
            response.sendRedirect(buildRedirectUrl(request, page, status, keyword, contactId));
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID liên hệ không hợp lệ.");
            response.sendRedirect(buildRedirectUrl(request, page, status, keyword, null));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Không thể gửi email phản hồi. Vui lòng kiểm tra cấu hình email.");
            response.sendRedirect(buildRedirectUrl(request, page, status, keyword, parseOptionalInt(request.getParameter("contactId"))));
        }
    }

    private void handleMarkProcessed(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = normalize(request.getParameter("searchKeyword"));
        String status = normalizeStatus(request.getParameter("statusFilter"));
        int page = parsePage(request.getParameter("page"));

        try {
            int contactId = Integer.parseInt(request.getParameter("contactId"));
            Contact contact = contactService.getContactById(contactId);

            if (contact == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy liên hệ để cập nhật.");
                response.sendRedirect(buildRedirectUrl(request, page, status, keyword, null));
                return;
            }

            contactService.markAsProcessed(contactId);
            request.getSession().setAttribute("successMessage", "Đã đánh dấu liên hệ là đã xử lý.");
            response.sendRedirect(buildRedirectUrl(request, page, status, keyword, contactId));
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID liên hệ không hợp lệ.");
            response.sendRedirect(buildRedirectUrl(request, page, status, keyword, null));
        }
    }

    private int parsePage(String pageStr) {
        try {
            return pageStr == null ? 1 : Math.max(1, Integer.parseInt(pageStr));
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "all";
        }
        return status.trim();
    }

    private Integer parseOptionalInt(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String buildRedirectUrl(HttpServletRequest request, int page, String status, String keyword, Integer detailId) {
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append(SERVLET_PATH)
                .append("?page=").append(page)
                .append("&status=").append(encode(status))
                .append("&keyword=").append(encode(keyword));

        if (detailId != null) {
            url.append("&action=detail&id=").append(detailId);
        }

        return url.toString();
    }

    private String encode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
