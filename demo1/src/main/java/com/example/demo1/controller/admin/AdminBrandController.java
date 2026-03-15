package com.example.demo1.controller.admin;

import com.example.demo1.model.Brand;
import com.example.demo1.model.BrandPage;
import com.example.demo1.service.BrandService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminBrandController", value = "/admin/brands")
public class AdminBrandController extends HttpServlet {
    private static final String SERVLET_PATH = "/admin/brands";
    private static final String JSP_PATH = "/admin/adminBrands.jsp";
    private final BrandService brandService = new BrandService();
    private static final int BRANDS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBrand(request, response);
                break;
            default:
                listBrands(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        saveBrand(request, response);
    }

    private void listBrands(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

        BrandPage brandPage = brandService.getPagedBrands(keyword, currentPage, BRANDS_PER_PAGE);
        int totalPages = (int) Math.ceil((double) brandPage.getTotalBrands() / BRANDS_PER_PAGE);

        request.setAttribute("brands", brandPage.getBrands());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Brand brandToEdit = brandService.getBrandById(id);
            if (brandToEdit == null) {
                request.getSession().setAttribute("errorMessage", "Thương hiệu không tồn tại.");
                response.sendRedirect(request.getContextPath() + SERVLET_PATH);
                return;
            }
            request.setAttribute("brandToEdit", brandToEdit);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID thương hiệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
            return;
        }
        listBrands(request, response);
    }

    private void saveBrand(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String displayOrderStr = request.getParameter("displayOrder");
        String logoUrl = request.getParameter("logo");
        
        Integer id = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : null;
        boolean isNew = (id == null);

        if (name == null || name.trim().isEmpty() || displayOrderStr == null || displayOrderStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ tên và thứ tự hiển thị.");
            forwardWithData(request, response);
            return;
        }

        if (brandService.isBrandNameExists(name, id)) {
            request.setAttribute("errorMessage", "Tên thương hiệu '" + name + "' đã tồn tại. Vui lòng chọn tên khác.");
            forwardWithData(request, response);
            return;
        }
        
        Brand brand;
        if (!isNew) {
            brand = brandService.getBrandById(id);
        } else {
            brand = new Brand();
        }

        brand.setName(name);
        brand.setStatus(request.getParameter("status"));
        brand.setDisplayOrder(Integer.parseInt(displayOrderStr));

        if (logoUrl != null && !logoUrl.trim().isEmpty()) {
            brand.setLogo(logoUrl);
        } else if (isNew) {
            request.setAttribute("errorMessage", "Vui lòng cung cấp hình ảnh cho thương hiệu mới.");
            forwardWithData(request, response);
            return;
        }

        brandService.saveBrand(brand);
        request.getSession().setAttribute("successMessage", isNew ? "Thêm thương hiệu thành công!" : "Cập nhật thương hiệu thành công!");
        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (brandService.deleteBrand(id)) {
                request.getSession().setAttribute("successMessage", "Xóa thương hiệu thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể xóa thương hiệu này vì vẫn còn sản phẩm liên quan.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID thương hiệu không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void forwardWithData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        Brand brand = new Brand();
        if (idParam != null && !idParam.isEmpty()) {
            brand.setId(Integer.parseInt(idParam));
        }
        brand.setName(request.getParameter("name"));
        brand.setStatus(request.getParameter("status"));
        brand.setLogo(request.getParameter("logo"));
        try {
            brand.setDisplayOrder(Integer.parseInt(request.getParameter("displayOrder")));
        } catch (NumberFormatException e) {
        }
        request.setAttribute("brandToEdit", brand);
        listBrands(request, response);
    }
}
