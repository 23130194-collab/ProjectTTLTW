package com.example.demo1.controller.admin;

import com.example.demo1.model.Category;
import com.example.demo1.service.CategoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", value = "/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private static final String SERVLET_PATH = "/admin/categories";
    private static final String JSP_PATH = "/admin/adminCategories.jsp";
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "edit":
                    handleEditAction(request, response);
                    return;
                case "delete":
                    handleDeleteAction(request, response);
                    return;
            }
        }

        showCategoryList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String categoryIdStr = request.getParameter("categoryId");

        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            handleUpdatePost(request, response);
        } else {
            handleInsertPost(request, response);
        }
    }

    private void showCategoryList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchKeyword = request.getParameter("searchKeyword");
        List<Category> categoryList;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            categoryList = categoryService.searchCategories(searchKeyword);
            request.setAttribute("searchKeyword", searchKeyword);
        } else {
            categoryList = categoryService.getAllCategories();
        }

        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    private void handleEditAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category categoryToEdit = categoryService.getCategoryById(id);
            if (categoryToEdit != null) {
                request.setAttribute("categoryToEdit", categoryToEdit);
            }
        } catch (NumberFormatException e) {
        }
        showCategoryList(request, response);
    }

    private void handleDeleteAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean deleted = categoryService.deleteCategory(id);
            if (deleted) {
                request.getSession().setAttribute("successMessage", "Xóa danh mục thành công!");
                refreshApplicationScopeCategories();
            } else {
                String categoryName = "<strong>" + categoryService.getCategoryById(id).getName() + "</strong>";
                request.getSession().setAttribute("errorMessage", "Không thể xóa danh mục " + categoryName + " vì vẫn còn sản phẩm tồn tại.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID danh mục không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void handleInsertPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("categoryName");
        String displayOrderStr = request.getParameter("displayOrder");
        String status = request.getParameter("status");
        String imageUrl = request.getParameter("imageUrl");

        if (name == null || name.trim().isEmpty() || displayOrderStr == null || displayOrderStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên danh mục và thứ tự không được để trống!");
            forwardWithData(request, response);
            return;
        }

        if (categoryService.isCategoryNameExists(name, null)) {
            request.setAttribute("errorMessage", "Tên danh mục '" + name + "' đã tồn tại.");
            forwardWithData(request, response);
            return;
        }

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng cung cấp đường dẫn hình ảnh cho danh mục!");
            forwardWithData(request, response);
            return;
        }

        int displayOrder = Integer.parseInt(displayOrderStr);
        categoryService.addCategory(name, displayOrder, imageUrl, status);
        request.getSession().setAttribute("successMessage", "Thêm danh mục mới thành công!");
        refreshApplicationScopeCategories();
        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void handleUpdatePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("categoryName");
        String displayOrderStr = request.getParameter("displayOrder");
        String status = request.getParameter("status");
        String imageUrl = request.getParameter("imageUrl");

        if (name == null || name.trim().isEmpty() || displayOrderStr == null || displayOrderStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên danh mục và thứ tự không được để trống!");
            forwardWithData(request, response);
            return;
        }

        if (categoryService.isCategoryNameExists(name, categoryId)) {
            request.setAttribute("errorMessage", "Tên danh mục '" + name + "' đã tồn tại.");
            forwardWithData(request, response);
            return;
        }

        Category oldCategory = categoryService.getCategoryById(categoryId);
        String imagePath = imageUrl;
        if (imagePath == null || imagePath.trim().isEmpty()) {
            imagePath = oldCategory.getImage();
        }

        int displayOrder = Integer.parseInt(displayOrderStr);
        Category updatedCategory = new Category(categoryId, imagePath, name, displayOrder, status);
        categoryService.updateCategory(updatedCategory);
        request.getSession().setAttribute("successMessage", "Cập nhật danh mục thành công!");
        refreshApplicationScopeCategories();
        response.sendRedirect(request.getContextPath() + SERVLET_PATH);
    }

    private void refreshApplicationScopeCategories() {
        List<Category> activeCategoryList = categoryService.getActiveCategories();
        getServletContext().setAttribute("categoryList", activeCategoryList);
    }

    private void forwardWithData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryIdStr = request.getParameter("categoryId");
        Category category = new Category();
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            category.setId(Integer.parseInt(categoryIdStr));
        }
        category.setName(request.getParameter("categoryName"));
        try {
            category.setDisplay_order(Integer.parseInt(request.getParameter("displayOrder")));
        } catch (NumberFormatException e) {
        }
        category.setStatus(request.getParameter("status"));
        category.setImage(request.getParameter("imageUrl"));

        request.setAttribute("categoryToEdit", category);
        showCategoryList(request, response);
    }
}
