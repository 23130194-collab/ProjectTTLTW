package com.example.demo1.controller.admin;

import com.example.demo1.dao.Product_SpecDao;
import com.example.demo1.model.Brand;
import com.example.demo1.model.Category;
import com.example.demo1.model.Product;
import com.example.demo1.model.Product_Spec;
import com.example.demo1.model.Product_Image;
import com.example.demo1.service.BrandService;
import com.example.demo1.service.CategoryService;
import com.example.demo1.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@WebServlet(name = "AdminUploadProductServlet", value = "/admin/upload-product")
public class AdminUploadProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            CategoryService categoryService = new CategoryService();
            BrandService brandService = new BrandService();
            ProductService productService = new ProductService();

            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.setAttribute("brandList", brandService.getAllBrands());

            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int productId = Integer.parseInt(idStr);
                    Product product = productService.getProduct(productId);

                    if (product != null) {
                        request.setAttribute("product", product);

                        List<Product_Image> detailImages = productService.getProductImages(productId);
                        if (detailImages == null) detailImages = new ArrayList<>();
                        detailImages.sort(Comparator.comparingInt(Product_Image::getDisplayOrder));
                        request.setAttribute("images", detailImages);

                        List<Product_Spec> specs = productService.getProductSpecs(productId);
                        if (specs == null) specs = new ArrayList<>();
                        request.setAttribute("specs", specs);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi khi lấy Id sản phẩm: " + e.getMessage());
                }
            }
            request.getRequestDispatcher("/admin/adminUploadProduct.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Xảy ra lỗi ở doGet trong file AdminUploadProductServlet: " + e.getMessage());
            response.setStatus(500);
            response.getWriter().write("Lỗi server: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String productIdStr = request.getParameter("productId");
        int productId = parseIntSafe(productIdStr);
        boolean isNew = (productId <= 0);

        ProductService productService = new ProductService();

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int categoryId = parseIntSafe(request.getParameter("categoryId"));
        int brandId = parseIntSafe(request.getParameter("brandId"));
        int stock = parseIntSafe(request.getParameter("stock"));
        double oldPrice = parseDoubleSafe(request.getParameter("oldPrice"));
        String status = request.getParameter("status");

        if (status == null || status.trim().isEmpty()) status = "active";

        if (stock == 0) status = "inactive";

        List<String> missingFields = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) missingFields.add("Tên sản phẩm");
        if (categoryId == 0) missingFields.add("Danh mục");
        if (brandId == 0) missingFields.add("Thương hiệu");
        if (oldPrice <= 0) missingFields.add("Giá gốc sản phẩm");

        String mainImage = request.getParameter("mainImage");
        if (isNew && (mainImage == null || mainImage.trim().isEmpty())) {
            missingFields.add("Ảnh đại diện");
        }

        if (!missingFields.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ các trường: " + String.join(", ", missingFields) + ".");
            forwardWithData(request, response);
            return;
        }

        if (productService.isProductNameExistsInCategory(name, categoryId, productId)) {
            request.setAttribute("errorMessage", "Tên sản phẩm '" + name + "' đã tồn tại trong danh mục này.");
            forwardWithData(request, response);
            return;
        }

        List<Product_Image> detailImages = getImagesFromRequest(request);
        Double discountValue = getDiscountValue(request);
        Timestamp discountStart = parseTimestamp(request.getParameter("discountStart"));
        Timestamp discountEnd = parseTimestamp(request.getParameter("discountEnd"));

        try {
            if (isNew) {
                Product newProduct = new Product();
                newProduct.setName(name);
                newProduct.setCategoryId(categoryId);
                newProduct.setBrandId(brandId);
                newProduct.setDescription(description);
                newProduct.setOldPrice(oldPrice);
                newProduct.setStock(stock);
                newProduct.setStatus(status);

                int currentProductId = productService.createProduct(newProduct, mainImage, detailImages, discountValue, discountStart, discountEnd);
                updateProductSpecs(request, currentProductId);
            } else {
                Product productToUpdate = productService.getProduct(productId);

                if (productToUpdate == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    return;
                }

                if (name != null && !name.trim().isEmpty()) productToUpdate.setName(name);
                if (description != null && !description.trim().isEmpty()) productToUpdate.setDescription(description);
                productToUpdate.setStatus(status);

                if (categoryId > 0) productToUpdate.setCategoryId(categoryId);
                if (brandId > 0) productToUpdate.setBrandId(brandId);
                if (stock >= 0) productToUpdate.setStock(stock);
                if (oldPrice > 0) productToUpdate.setOldPrice(oldPrice);

                productService.updateProduct(productToUpdate, mainImage, detailImages, discountValue, discountStart, discountEnd);
                updateProductSpecs(request, productId);
            }

            request.getSession().setAttribute("successMessage", isNew ? "Thêm sản phẩm thành công!" : "Cập nhật sản phẩm thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            System.err.println("Lỗi khi lưu sản phẩm: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi khi lưu sản phẩm: " + e.getMessage());
            forwardWithData(request, response);
        }
    }

    private List<Product_Image> getImagesFromRequest(HttpServletRequest request) {
        String[] imageUrls = request.getParameterValues("imageUrls");
        String[] imageOrders = request.getParameterValues("imageOrders");
        String contextPath = request.getContextPath();
        List<Product_Image> images = new ArrayList<>();

        if (imageUrls != null && imageOrders != null) {
            for (int i = 0; i < imageUrls.length; i++) {
                if (imageUrls[i] != null && !imageUrls[i].trim().isEmpty()) {
                    String imageUrl = imageUrls[i].trim();
                    if (imageUrl.startsWith(contextPath + "/")) {
                        imageUrl = imageUrl.substring(contextPath.length() + 1);
                    }
                    Product_Image img = new Product_Image();
                    img.setImage(imageUrl);
                    img.setDisplayOrder(parseIntSafe(imageOrders[i]));
                    images.add(img);
                }
            }
        }
        images.sort(Comparator.comparingInt(Product_Image::getDisplayOrder));
        return images;
    }

    private Double getDiscountValue(HttpServletRequest request) {
        String discountValueStr = request.getParameter("discountValue");
        if (discountValueStr != null && !discountValueStr.trim().isEmpty()) {
            try {
                double value = Double.parseDouble(discountValueStr);
                return (value >= 0 && value <= 100) ? value : null;
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    private void updateProductSpecs(HttpServletRequest request, int productId) {
        String[] specIds = request.getParameterValues("specIds");
        String[] specValues = request.getParameterValues("specValues");

        if (productId > 0 && specIds != null && specValues != null && specIds.length == specValues.length) {
            Product_SpecDao specDao = new Product_SpecDao();
            specDao.deleteByProductId(productId);

            for (int i = 0; i < specIds.length; i++) {
                String val = specValues[i];
                if (val != null && !val.trim().isEmpty()) {
                    try {
                        int attrId = Integer.parseInt(specIds[i]);
                        specDao.insertProductSpec(productId, attrId, val.trim());
                    } catch (NumberFormatException ex) {
                        System.err.println("Lỗi parse attribute ID trong updateProductSpecs: " + ex.getMessage());
                    }
                }
            }
        }
    }

    private void forwardWithData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryService categoryService = new CategoryService();
        BrandService brandService = new BrandService();
        request.setAttribute("categoryList", categoryService.getAllCategories());
        request.setAttribute("brandList", brandService.getAllBrands());

        Product productData = new Product();
        productData.setId(parseIntSafe(request.getParameter("productId")));
        productData.setName(request.getParameter("name"));
        productData.setCategoryId(parseIntSafe(request.getParameter("categoryId")));
        productData.setBrandId(parseIntSafe(request.getParameter("brandId")));
        productData.setDescription(request.getParameter("description"));
        productData.setOldPrice(parseDoubleSafe(request.getParameter("oldPrice")));
        productData.setStock(parseIntSafe(request.getParameter("stock")));
        productData.setStatus(request.getParameter("status"));

        String discountValueStr = request.getParameter("discountValue");
        if (discountValueStr != null && !discountValueStr.isEmpty()) {
            productData.setDiscountValue(parseDoubleSafe(discountValueStr));
        }

        productData.setImage(request.getParameter("mainImage"));
        request.setAttribute("product", productData);

        List<Product_Image> images = getImagesFromRequest(request);
        request.setAttribute("images", images);

        request.getRequestDispatcher("/admin/adminUploadProduct.jsp").forward(request, response);
    }

    private Timestamp parseTimestamp(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.util.Date parsedDate = dateFormat.parse(dateStr);
            return new Timestamp(parsedDate.getTime());
        } catch (ParseException e) {
            System.err.println("Lỗi parse timestamp: " + e.getMessage());
            return null;
        }
    }

    private int parseIntSafe(String s) {
        try {
            return (s != null && !s.isEmpty()) ? Integer.parseInt(s.trim()) : 0;
        } catch (NumberFormatException e) { return 0; }
    }

    private double parseDoubleSafe(String s) {
        try {
            return (s != null && !s.isEmpty()) ? Double.parseDouble(s.trim()) : 0.0;
        } catch (NumberFormatException e) { return 0.0; }
    }
}
