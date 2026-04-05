package com.example.demo1.controller.admin;

import com.example.demo1.dao.CategoryDao;
import com.example.demo1.model.Attribute;
import com.example.demo1.model.Category;
import com.example.demo1.service.AttributeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAttributeServlet", value = "/admin/attributes")
public class AdminAttributeServlet extends HttpServlet {
    private static final String SERVLET_PATH = "/admin/attributes";
    private static final String JSP_PATH = "/admin/adminAttributes.jsp";
    private AttributeService attributeService;
    private CategoryDao categoryDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.attributeService = new AttributeService();
        this.categoryDao = new CategoryDao();
    }

    private void loadPageData(HttpServletRequest request) {
        List<Category> categories = categoryDao.getAll();
        request.setAttribute("categories", categories);

        String keyword = request.getParameter("keyword");

        int filterCategoryId = 0;
        String filterParam = request.getParameter("filterCategoryId");

        if (filterParam != null && !filterParam.isEmpty()) {
            try {
                filterCategoryId = Integer.parseInt(filterParam);
            } catch (NumberFormatException e) {
                filterCategoryId = 0;
            }
        }

        int page = 1;
        if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        List<Attribute> attributes = attributeService.getAttributes(keyword, filterCategoryId, limit, offset);

        int totalAttributes = attributeService.countAttributes(keyword, filterCategoryId);

        int totalPages = (int) Math.ceil((double) totalAttributes / limit);

        request.setAttribute("attributes", attributes);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("keyword", keyword);

        request.setAttribute("filterCategoryId", filterCategoryId);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Attribute attributeToEdit = attributeService.getAttributeById(id);
                request.setAttribute("attributeToEdit", attributeToEdit);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?error=invalid_id");
                return;
            }
        }
        loadPageData(request);
        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
            return;
        }

        try {
            switch (action) {
                case "add":
                    addAttributeForCategory(request, response);
                    break;
                case "update":
                    updateAttribute(request, response);
                    break;
                case "delete":
                    deleteAttribute(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + SERVLET_PATH);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?error=true");
        }
    }

    private void addAttributeForCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String status = request.getParameter("status");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        int displayOrder = Integer.parseInt(request.getParameter("display_order"));
        int isFilterable = (request.getParameter("is_filterable") != null) ? 1 : 0;
        boolean force = "true".equals(request.getParameter("force"));

        if (attributeService.isAttributeExists(name, categoryId)) {
            request.setAttribute("errorMessage", "Thuộc tính '" + name + "' đã tồn tại trong danh mục này!");
            request.setAttribute("oldName", name);
            request.setAttribute("oldStatus", status);
            request.setAttribute("oldCategoryId", categoryId);
            request.setAttribute("oldDisplayOrder", displayOrder);
            request.setAttribute("oldIsFilterable", isFilterable);
            loadPageData(request);
            request.getRequestDispatcher(JSP_PATH).forward(request, response);
            return;
        }

        if (!force && attributeService.isDisplayOrderExists(categoryId, displayOrder, 0)) {
            request.setAttribute("confirmReplaceOrder", true);

            request.setAttribute("conflictMessage", "Thứ tự hiển thị " + displayOrder + " đã tồn tại. Bạn có muốn chèn vào và đẩy các mục cũ xuống không?");

            request.setAttribute("oldName", name);
            request.setAttribute("oldStatus", status);
            request.setAttribute("oldCategoryId", categoryId);
            request.setAttribute("oldDisplayOrder", displayOrder);
            request.setAttribute("oldIsFilterable", isFilterable);
            loadPageData(request);
            request.getRequestDispatcher(JSP_PATH).forward(request, response);
            return;
        }

        if (force) {
            attributeService.shiftDisplayOrders(categoryId, displayOrder);
        }

        if (name != null && !name.trim().isEmpty()) {
            attributeService.createAttributeForCategory(name, status, categoryId, displayOrder, isFilterable);
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?success=add");
        } else {
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?error=name_required");
        }
    }

    private void updateAttribute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String status = request.getParameter("status");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        int displayOrder = Integer.parseInt(request.getParameter("display_order"));
        int isFilterable = (request.getParameter("is_filterable") != null) ? 1 : 0;
        boolean force = "true".equals(request.getParameter("force"));

        if (!force && attributeService.isDisplayOrderExists(categoryId, displayOrder, id)) {
            request.setAttribute("confirmReplaceOrder", true);
            request.setAttribute("conflictMessage", "Thứ tự hiển thị " + displayOrder + " đã tồn tại. Bạn có muốn chèn vào và đẩy các mục cũ xuống không?");

            Attribute tempAttr = new Attribute();
            tempAttr.setId(id);
            tempAttr.setName(name);
            tempAttr.setStatus(status);
            tempAttr.setCategoryId(categoryId);
            tempAttr.setDisplayOrder(displayOrder);
            tempAttr.setIsFilterable(isFilterable);
            request.setAttribute("attributeToEdit", tempAttr);

            loadPageData(request);
            request.getRequestDispatcher(JSP_PATH).forward(request, response);
            return;
        }

        if (force) {
            attributeService.shiftDisplayOrders(categoryId, displayOrder);
        }

        if (name != null && !name.trim().isEmpty()) {
            attributeService.updateAttributeAndCategoryLink(id, name, status, categoryId, displayOrder, isFilterable);
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?success=update");
        } else {
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?action=edit&id=" + id + "&error=name_required");
        }
    }

    private void deleteAttribute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            attributeService.deleteAttribute(id);
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?success=delete");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?error=invalid_id");
        }
    }
}