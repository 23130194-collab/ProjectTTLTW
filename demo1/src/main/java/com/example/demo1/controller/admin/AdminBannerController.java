package com.example.demo1.controller.admin;

import com.example.demo1.dao.CategoryDao;
import com.example.demo1.model.Banner;
import com.example.demo1.model.Category;
import com.example.demo1.service.BannerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "AdminBannerController", value = "/admin/banners")
public class AdminBannerController extends HttpServlet {

    private final BannerService bannerService = new BannerService();
    private final CategoryDao categoryDao = new CategoryDao();

    private void loadPageData(HttpServletRequest request) {
        List<Category> categories = categoryDao.getAll();
        request.setAttribute("categories", categories);

        String keyword = request.getParameter("keyword");
        String filterPosition = request.getParameter("filterPosition");

        if (filterPosition != null && filterPosition.trim().isEmpty()) {
            filterPosition = null;
        }

        int page = 1;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        int limit = 10;
        int offset = (page - 1) * limit;

        List<Banner> banners = bannerService.getBanners(keyword, filterPosition, limit, offset);
        int totalBanners = bannerService.countBanners(keyword, filterPosition);
        int totalPages = (int) Math.ceil((double) totalBanners / limit);

        for (Banner banner : banners) {
            try {
                int categoryId = Integer.parseInt(banner.getPosition());
                Category category = categoryDao.getById(categoryId);
                if (category != null) {
                    banner.setPosition(category.getName());
                }
            } catch (NumberFormatException e) {
            }
        }

        request.setAttribute("banners", banners);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("keyword", keyword);
        request.setAttribute("filterPosition", filterPosition);
    }

    private void keepFormData(HttpServletRequest request, int id, String name, String sTime, String eTime, String pos, int order, String img) {
        Banner b = new Banner();
        b.setId(id);
        b.setName(name);
        b.setStart_time(sTime);
        b.setEnd_time(eTime);
        b.setPosition(pos);
        b.setDisplay_order(order);
        b.setImage(img);
        request.setAttribute("bannerToEdit", b);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("bannerToEdit", bannerService.getBannerById(id));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        loadPageData(request);
        request.getRequestDispatcher("/admin/adminBanners.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        String idStr = request.getParameter("id");
        int id = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;
        String name = request.getParameter("name");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String position = request.getParameter("position");
        String imageLink = request.getParameter("image");
        int displayOrder = 1;
        try {
            displayOrder = Integer.parseInt(request.getParameter("display_order"));
        } catch (Exception e) {
        }

        try {
            LocalDate startDate = LocalDate.parse(startTime);
            LocalDate endDate = LocalDate.parse(endTime);

            if (endDate.isBefore(startDate)) {
                request.setAttribute("errorMessage", "Thời gian kết thúc phải sau thời gian bắt đầu.");
                keepFormData(request, id, name, startTime, endTime, position, displayOrder, imageLink);
                loadPageData(request);
                request.getRequestDispatcher("/admin/adminBanners.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Định dạng thời gian không hợp lệ.");
            keepFormData(request, id, name, startTime, endTime, position, displayOrder, imageLink);
            loadPageData(request);
            request.getRequestDispatcher("/admin/adminBanners.jsp").forward(request, response);
            return;
        }

        boolean force = "true".equals(request.getParameter("force"));

        if (bannerService.isNameExists(name, position, id)) {
            request.setAttribute("errorMessage", "Banner '" + name + "' đã tồn tại trong hệ thống!");
            keepFormData(request, id, name, startTime, endTime, position, displayOrder, imageLink);
            loadPageData(request);
            request.getRequestDispatcher("/admin/adminBanners.jsp").forward(request, response);
            return;
        }

        if (!force && bannerService.isDisplayOrderExists(position, displayOrder, id)) {
            request.setAttribute("confirmReplaceOrder", true);

            String posName = "Trang chủ";
            if (!"Trang chủ".equals(position)) {
                try {
                    int categoryId = Integer.parseInt(position);
                    Category category = categoryDao.getById(categoryId);
                    if (category != null) {
                        posName = category.getName();
                    } else {
                        posName = "Danh mục ID: " + position;
                    }
                } catch (NumberFormatException e) {
                    posName = position;
                }
            }

            request.setAttribute("conflictMessage", "Thứ tự hiển thị " + displayOrder + " tại '" + posName + "' đã tồn tại. Bạn có muốn chèn vào và đẩy các banner cũ xuống không?");

            keepFormData(request, id, name, startTime, endTime, position, displayOrder, imageLink);
            loadPageData(request);
            request.getRequestDispatcher("/admin/adminBanners.jsp").forward(request, response);
            return;
        }

        if (force) {
            bannerService.shiftDisplayOrders(position, displayOrder);
        }

        boolean success = false;
        if ("create".equals(action)) {
            success = bannerService.createBanner(name, startTime, endTime, position, displayOrder, imageLink);
            if (success) request.getSession().setAttribute("message", "Thêm banner thành công!");
        } else if ("update".equals(action)) {
            success = bannerService.updateBanner(id, name, startTime, endTime, position, displayOrder, imageLink);
            if (success) request.getSession().setAttribute("message", "Cập nhật banner thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            bannerService.deleteBanner(id);
            request.getSession().setAttribute("message", "Đã xóa banner thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Có lỗi khi thực hiện xóa banner!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }
}