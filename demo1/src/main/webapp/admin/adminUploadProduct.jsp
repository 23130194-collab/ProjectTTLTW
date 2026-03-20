<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - ${not empty product ? 'Chỉnh sửa' : 'Thêm'} sản phẩm</title>
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminUploadProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>
<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${contextPath}/admin/dashboard">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
        </a>
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;">
            <span class="logo-text">TechNova</span>
        </a>
    </div>
    <ul class="nav-menu">
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span
            class="nav-icon"><i
            class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a></div>
</aside>

<header class="header">
    <div class="header-actions">
        <button class="notification-btn" id="notificationBtn">
            <i class="fa-solid fa-bell"></i>
        </button>

        <div class="user-profile">
            <img src="https://www.shutterstock.com/image-vector/admin-icon-strategy-collection-thin-600nw-2307398667.jpg"
                 alt="User Profile">
        </div>
    </div>
</header>

<main class="main-content">
    <div class="content-area">
        <h1 class="page-title">${not empty product ? 'Chỉnh sửa' : 'Thêm'} sản phẩm</h1>
        <div class="breadcrumb">
            <a href="${contextPath}/admin/dashboard">Trang chủ</a> / <a
                href="${contextPath}/admin/products">Danh sách sản phẩm</a> /
            <span>${not empty product ? 'Chỉnh sửa' : 'Thêm'} sản phẩm</span>
        </div>

        <c:if test="${not empty errorMessage}">
            <div style="background-color: #ffebee; color: #c62828; padding: 15px; margin: 20px 0; border: 1px solid #ef9a9a; border-radius: 4px;">
                    ${errorMessage}
            </div>
        </c:if>

        <form action="${contextPath}/admin/upload-product" method="post" class="upload-product-container"
              id="productForm">
            <c:if test="${not empty product}">
            <input type="hidden" name="productId" value="${product.id}">
            </c:if>

            <div class="form-section">
                <div class="form-group">
                    <h3>Tên sản phẩm</h3>
                    <input type="text" name="name" placeholder="Nhập tên sản phẩm" class="form-input"
                           value="${product.name}" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <h3>Danh mục</h3>
                        <select class="form-select" name="categoryId" id="category-select" required>
                            <option value="" disabled ${empty product ? 'selected' : ''}>Chọn danh mục</option>
                            <c:forEach var="category" items="${categoryList}">
                                <option value="${category.id}" ${product.categoryId == category.id ? 'selected' : ''}>${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <h3>Thương hiệu</h3>
                        <select class="form-select" name="brandId" required>
                            <option value="" disabled ${empty product ? 'selected' : ''}>Chọn thương hiệu</option>
                            <c:forEach var="brand" items="${brandList}">
                                <option value="${brand.id}" ${product.brandId == brand.id ? 'selected' : ''}>${brand.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3>Giới thiệu sản phẩm:</h3>
                <div class="form-group">
                    <textarea id="product-description" name="description" rows="15"><c:out
                            value="${product.description}" escapeXml="false"/></textarea>
                </div>
            </div>

            <div class="form-section">
                <div class="attribute-header"
                     style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h3>Thông số kỹ thuật</h3>
                    <select id="attribute-select" class="form-select attribute-select" style="width: 200px;">
                        <option value="">Chọn thuộc tính</option>
                    </select>
                </div>

                <div id="attributes-container">
                    <c:forEach var="spec" items="${specs}">
                        <div class="attribute-item active">
                            <div class="attr-top">
                                <span class="attr-name">${spec.attributeName}</span>
                                <div class="attr-controls">
                                    <span class="attr-delete" title="Xóa thuộc tính này">Xóa</span>
                                    <i class="fa-solid fa-chevron-down attr-toggle-icon"></i>
                                </div>
                            </div>
                            <div class="attr-body">
                                <input type="hidden" name="specIds" value="${spec.attributeId}">
                                <div class="attr-row">
                                    <span class="attr-label">Tên:</span>
                                    <span class="attr-static-val">${spec.attributeName}</span>
                                </div>
                                <div class="attr-row">
                                    <span class="attr-label">Giá trị:</span>
                                    <input type="text" name="specValues" class="form-input" value="${spec.specValue}"
                                           placeholder="Nhập giá trị...">
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="form-section">
                <h3>Giá sản phẩm:</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label>Giá gốc (VND)</label>
                        <input type="text" name="oldPrice" placeholder="Nhập giá sản phẩm" class="form-input"
                               value="${product.oldPrice}">
                    </div>
                    <div class="form-group">
                        <label>Giảm giá (%)</label>
                        <input type="number" name="discountValue"
                               placeholder="Nhập giá trị giảm giá"
                               class="form-input"
                               value="${product.discountValue}"
                               min="0" max="100" step="1.0"></div>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Ngày bắt đầu giảm giá</label>
                    <c:if test="${not empty product.discountStart}">
                        <c:set var="formattedStart" value="${fn:substring(product.discountStart, 0, 16)}"/>
                    </c:if>
                    <input type="datetime-local" name="discountStart" class="form-input"
                           value="${formattedStart}">
                </div>
                <div class="form-group">
                    <label>Ngày kết thúc giảm giá</label>
                    <c:if test="${not empty product.discountEnd}">
                        <c:set var="formattedEnd" value="${fn:substring(product.discountEnd, 0, 16)}"/>
                    </c:if>
                    <input type="datetime-local" name="discountEnd" class="form-input"
                           value="${formattedEnd}">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số lượng tồn kho</label>
                    <input type="text" name="stock" placeholder="Nhập số lượng sản phẩm" class="form-input"
                           value="${product.stock}">
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="active" ${product.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="inactive" ${product.status == 'inactive' ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>
            </div>

            <div class="form-section">
                <h3>Ảnh đại diện</h3>
                <div class="form-group">
                    <label for="main-image-input">URL ảnh đại diện</label>
                    <input type="text" id="main-image-input" name="mainImage"
                           placeholder="Dán URL ảnh đại diện ở đây..." class="form-input" value="${product.image}">
                    <c:if test="${not empty product.image}">
                        <div style="margin-top: 10px;">
                            <c:set var="imageUrl" value="${product.image}"/>
                            <c:choose>
                                <c:when test="${fn:startsWith(imageUrl, 'http')}">
                                    <img src="${imageUrl}" alt="Ảnh đại diện"
                                         style="max-width: 150px; max-height: 150px; border-radius: 4px; border: 1px solid #e2e8f0;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${contextPath}/${imageUrl}" alt="Ảnh đại diện"
                                         style="max-width: 150px; max-height: 150px; border-radius: 4px; border: 1px solid #e2e8f0;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="form-section">
                <h3>Hình ảnh chi tiết sản phẩm</h3>
                <div class="image-uploader">
                    <div class="image-adder-group">
                        <div class="form-group" style="flex: 1;">
                            <label for="image-url-input">Hình ảnh chi tiết</label>
                            <div style="display: flex; gap: 10px;">
                                <input type="text" id="image-url-input" placeholder="https://example.com/image.png"
                                       class="form-input" style="flex: 1;">
                            </div>
                        </div>
                        <div class="form-group" style="width: 100px;">
                            <label for="image-order-input">Thứ tự</label>
                            <input type="number" id="image-order-input" placeholder="1" class="form-input">
                        </div>
                        <button type="button" id="btn-add-image" class="btn-add-img" style="height: 38px;">Thêm</button>
                    </div>
                    <div id="image-data-container" style="display: none;">
                        <c:forEach var="image" items="${images}">
                            <input type="hidden" name="imageUrls" value="${image.image}">
                            <input type="hidden" name="imageOrders" value="${image.displayOrder}">
                        </c:forEach>
                    </div>
                    <div class="image-thumbnails" id="image-preview-container">
                    </div>
                </div>
            </div>
    </div>

    <div class="form-actions-footer">
        <a href="${contextPath}/admin/products" class="btn-cancel">Hủy</a>
        <a href="#confirm-save-modal" class="btn-complete open-modal-btn">Hoàn thành</a>
    </div>
    </form>
    </div>
</main>
<div id="delete-spec-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận xóa</h3>
        <p>Bạn có chắc chắn muốn xóa thuộc tính <strong id="modal-spec-name"></strong> không?</p>
        <div class="modal-buttons">
            <button type="button" class="modal-btn modal-cancel" id="btn-cancel-delete">Hủy</button>
            <button type="button" class="modal-btn modal-confirm" id="btn-confirm-delete">Xóa</button>
        </div>
    </div>
</div>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="productForm" class="modal-btn modal-confirm">Lưu</button>
        </div>
    </div>
</div>

<div id="logoutConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLogout">Hủy</a>
            <a href="${contextPath}/logout" class="modal-btn modal-confirm">Đăng xuất</a>
        </div>
    </div>
</div>

<script src="https://cdn.tiny.cloud/1/3ed7uep3wrojhgtffcu69d19t08h1k9sikr7x4myygwkmrju/tinymce/6/tinymce.min.js"
        referrerpolicy="origin" defer></script>

<script>
    const globalContextPath = "${pageContext.request.contextPath}";
</script>
<script src="${contextPath}/admin/adminjs/adminUploadProduct.js" defer></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll('.open-modal-btn').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                const modalId = this.getAttribute('href');
                document.querySelector(modalId).classList.add('show');
            });
        });

        document.querySelectorAll('.modal-cancel').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                this.closest('.modal-overlay').classList.remove('show');
            });
        });

        document.querySelectorAll('.modal-overlay').forEach(overlay => {
            overlay.addEventListener('click', function (event) {
                if (event.target === this) {
                    this.classList.remove('show');
                }
            });
        });

        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');
        if (logoutLink) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });
        }
        if (cancelLogoutBtn) {
            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });
        }
        if (logoutConfirmModal) {
            logoutConfirmModal.addEventListener('click', function (e) {
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>