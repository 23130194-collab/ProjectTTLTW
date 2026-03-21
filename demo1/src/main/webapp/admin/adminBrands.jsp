<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Thương hiệu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminBrands.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>

    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i
                class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
    </div>
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
        <div class="page-header">
            <div>
                <h1 class="page-title">Thương hiệu</h1>
                <div class="breadcrumb">
                    <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
                    <span>/</span>
                    <span class="breadcrumb-current">Thương hiệu</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                    ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                    ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                    ${requestScope.errorMessage}
            </div>
        </c:if>

        <form action="${contextPath}/admin/brands" method="post" id="brandForm">
            <input type="hidden" name="id" value="${brandToEdit.id}">

            <div class="brand-form">
                <div class="form-group">
                    <label class="form-label">Tên thương hiệu</label>
                    <input type="text" name="name" placeholder="Nhập tên thương hiệu" value="${brandToEdit.name}"
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label">Thứ tự hiển thị</label>
                    <input type="number" name="displayOrder" placeholder="Nhập thứ tự"
                           value="${brandToEdit != null ? brandToEdit.displayOrder : ''}" required min="1">
                </div>
                <div class="form-group">
                    <label class="form-label">Trạng thái hoạt động</label>
                    <div class="custom-select-wrapper">
                        <select name="status">
                            <option value="Hoạt động" ${brandToEdit.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động
                            </option>
                            <option value="Ẩn" ${brandToEdit.status == 'Ẩn' ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="image-section">
                <label class="form-label">Hình ảnh thương hiệu</label>
                <div class="image-input-group">
                    <div class="url-input-group">
                        <input type="text" id="image-url" name="logo" class="image-input-box"
                               placeholder="https://example.com/image.png" value="${brandToEdit.logo}">
                        <a href="#confirm-save-modal" class="add-brand-submit">
                            <c:choose>
                                <c:when test="${not empty brandToEdit}">Cập nhật</c:when>
                                <c:otherwise>Thêm thương hiệu</c:otherwise>
                            </c:choose>
                        </a>
                        <c:if test="${not empty brandToEdit}">
                            <a href="${contextPath}/admin/brands" class="cancel-btn">Hủy</a>
                        </c:if>
                    </div>
                </div>
            </div>
            <c:set var="previewLogoUrl" value="${brandToEdit.logo}"/>
            <c:choose>
                <c:when test="${not empty previewLogoUrl and previewLogoUrl.startsWith('http')}">
                    <c:set var="finalPreviewUrl" value="${previewLogoUrl}"/>
                </c:when>
                <c:when test="${not empty previewLogoUrl}">
                    <c:set var="finalPreviewUrl" value="${contextPath}/${previewLogoUrl}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="finalPreviewUrl" value="#"/>
                </c:otherwise>
            </c:choose>
            <img id="image-preview" src="${finalPreviewUrl}" alt="Image Preview"
                 style="max-width: 200px; max-height: 200px; margin-top: 10px; display: ${not empty brandToEdit.logo ? 'block' : 'none'};"/>
        </form>

        <form action="${contextPath}/admin/brands" method="get" class="form-search-row">
            <div class="search-wrapper">
                <input type="text" name="keyword" class="search-input-brand" placeholder="Tìm kiếm thương hiệu..."
                       value="${keyword}">
                <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
        </form>

        <div class="brand-table-container">
            <table class="brand-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Hình ảnh</th>
                    <th>Tên thương hiệu</th>
                    <th>Thứ tự hiển thị</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="brand" items="${brands}" varStatus="loop">
                    <tr>
                        <td>${(currentPage - 1) * 10 + loop.count}</td>
                        <td>
                            <c:set var="logoUrl" value="${brand.logo}"/>
                            <c:choose>
                                <c:when test="${logoUrl.startsWith('http')}">
                                    <img src="${logoUrl}" width="55" alt="${brand.name}"
                                         onerror="this.style.display='none'">
                                </c:when>
                                <c:when test="${not empty logoUrl}">
                                    <img src="${contextPath}/${logoUrl}" width="55" alt="${brand.name}"
                                         onerror="this.style.display='none'">
                                </c:when>
                            </c:choose>
                        </td>
                        <td><c:out value="${brand.name}"/></td>
                        <td><c:out value="${brand.displayOrder}"/></td>
                        <td>
                            <span class="status ${brand.status == 'Hoạt động' ? 'status-active' : 'status-hidden'}">
                                <c:out value="${brand.status}"/>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/brands?action=edit&id=${brand.id}"
                                   class="action-btn edit"><i class="fa-solid fa-pen"></i></a>
                                <a href="#confirm-delete-modal-${brand.id}" class="action-btn delete"><i
                                        class="fa-solid fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <c:if test="${currentPage > 1}">
                    <a href="${contextPath}/admin/brands?page=${currentPage - 1}&keyword=${keyword}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${contextPath}/admin/brands?page=${i}&keyword=${keyword}"
                       class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${contextPath}/admin/brands?page=${currentPage + 1}&keyword=${keyword}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</main>

<c:forEach var="brand" items="${brands}">
    <div id="confirm-delete-modal-${brand.id}" class="modal-overlay">
        <div class="modal-content">
            <h3>Xác nhận xóa</h3>
            <p>Bạn có chắc chắn muốn xóa thương hiệu "${brand.name}" không?</p>
            <div class="modal-buttons">
                <a href="#" class="modal-btn modal-cancel">Hủy</a>
                <a href="${contextPath}/admin/brands?action=delete&id=${brand.id}"
                   class="modal-btn modal-confirm">Xóa</a>
            </div>
        </div>
    </div>
</c:forEach>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="brandForm" class="modal-btn modal-confirm">Lưu</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });
    });
</script>

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

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });

            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });

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