<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Banner</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminBanners.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminForm.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>
    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span
            class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a></div>
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
                <h1 class="page-title">Quản Lý Banner</h1>
                <div class="breadcrumb">
                    <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
                    <span>/</span>
                    <span class="breadcrumb-current">Banner</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success" id="successAlert">
                <span>${sessionScope.message}</span>
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <span>${errorMessage}</span>
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            </div>
        </c:if>

        <form id="bannerForm" action="${contextPath}/admin/banners" method="post" class="admin-form-card">
            <input type="hidden" name="force" value="false">
            <input type="hidden" name="action"
                   value="${(not empty bannerToEdit && bannerToEdit.id > 0) ? 'update' : 'create'}">
            <c:if test="${not empty bannerToEdit && bannerToEdit.id > 0}">
                <input type="hidden" name="id" value="${bannerToEdit.id}">
            </c:if>

            <div class="admin-form-header">
                <div class="admin-form-header-icon">
                    <i class="fa-solid ${(not empty bannerToEdit && bannerToEdit.id > 0) ? 'fa-pen' : 'fa-plus'}"></i>
                </div>
                <h2 class="admin-form-title-text">
                    <c:choose>
                        <c:when test="${not empty bannerToEdit && bannerToEdit.id > 0}">Chỉnh sửa banner</c:when>
                        <c:otherwise>Thêm banner mới</c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <div class="admin-form-grid">
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Tên banner <span class="required">*</span></label>
                    <input type="text" name="name" class="form-input"
                           placeholder="Nhập tên banner" value="${bannerToEdit.name}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Thời gian bắt đầu <span class="required">*</span></label>
                    <c:set var="startDate" value="${bannerToEdit.start_time}"/>
                    <c:if test="${not empty startDate && startDate.length() > 10}">
                        <c:set var="startDate" value="${startDate.substring(0, 10)}"/>
                    </c:if>
                    <input type="date" id="banner-start-time" name="start_time" class="form-input"
                           value="${startDate}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Thời gian kết thúc <span class="required">*</span></label>
                    <c:set var="endDate" value="${bannerToEdit.end_time}"/>
                    <c:if test="${not empty endDate && endDate.length() > 10}">
                        <c:set var="endDate" value="${endDate.substring(0, 10)}"/>
                    </c:if>
                    <input type="date" id="banner-end-time" name="end_time" class="form-input"
                           value="${endDate}" required>
                </div>
                <div class="form-field form-span-2">
                    <label class="admin-form-label">Vị trí hiển thị <span class="required">*</span></label>
                    <select name="position" class="form-select" required>
                        <option value="">Chọn vị trí</option>
                        <option value="Trang chủ" ${bannerToEdit.position == 'Trang chủ' ? 'selected' : ''}>Trang chủ</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}"
                                ${String.valueOf(category.id) == bannerToEdit.position ? 'selected' : ''}>
                                    ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Thứ tự hiển thị <span class="required">*</span></label>
                    <input type="number" name="display_order" class="form-input"
                           placeholder="VD: 1"
                           value="${not empty bannerToEdit ? bannerToEdit.display_order : ''}"
                           min="1" required>
                </div>
                <div class="form-field form-span-3">
                    <label class="admin-form-label">Đường dẫn hình ảnh</label>
                    <c:set var="imgVal" value=""/>
                    <c:if test="${not empty bannerToEdit.image and bannerToEdit.image.startsWith('http')}">
                        <c:set var="imgVal" value="${bannerToEdit.image}"/>
                    </c:if>
                    <input type="text" name="image" class="form-input"
                           placeholder="https://example.com/image.png" value="${imgVal}">
                </div>
                <div class="form-actions">
                    <a href="#confirm-save-modal" class="admin-btn-primary open-modal-btn">
                        <i class="fa-solid ${(not empty bannerToEdit && bannerToEdit.id > 0) ? 'fa-floppy-disk' : 'fa-plus'}"></i>
                        <c:choose>
                            <c:when test="${not empty bannerToEdit && bannerToEdit.id > 0}">Cập nhật</c:when>
                            <c:otherwise>Thêm mới</c:otherwise>
                        </c:choose>
                    </a>
                    <c:if test="${not empty bannerToEdit && bannerToEdit.id > 0}">
                        <a href="${contextPath}/admin/banners" class="admin-btn-cancel">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                    </c:if>
                </div>
            </div>
        </form>

        <form action="${contextPath}/admin/banners" method="get">
            <div class="form-search-row">
                <select name="filterPosition" onchange="this.form.submit()" class="form-select filter-select">
                    <option value="">Tất cả vị trí</option>
                    <option value="Trang chủ" ${filterPosition == 'Trang chủ' ? 'selected' : ''}>Trang chủ</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${String.valueOf(cat.id) == filterPosition ? 'selected' : ''}>
                                ${cat.name}
                        </option>
                    </c:forEach>
                </select>
                <div class="search-wrapper">
                    <input type="text" name="keyword" class="search-input-banner"
                           placeholder="Tìm kiếm banner..." value="${param.keyword}">
                    <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </div>
        </form>

        <div class="banner-table-container">
            <table class="banner-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Hình ảnh</th>
                    <th style="text-align: left;">Tên banner</th>
                    <th>Vị trí</th>
                    <th>Thứ tự</th>
                    <th>Thời gian</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty banners and not empty param.keyword}">
                        <tr>
                            <td colspan="7" class="no-results-cell">
                                <i class="fa-solid fa-magnifying-glass no-results-icon"></i>
                                Không tìm thấy kết quả phù hợp với từ khóa '<span class="no-results-keyword">${param.keyword}</span>'
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${banners}" varStatus="status">
                            <tr>
                                <td>${(currentPage - 1) * 10 + status.count}</td>
                                <td>
                                    <img src="${b.image}" class="banner-img-preview" alt="Banner"
                                         onerror="this.src='https://via.placeholder.com/100x60?text=No+Image'">
                                </td>
                                <td style="text-align: left; font-weight: 600;">${b.name}</td>
                                <td><span class="status status-active" style="background:#f1f5f9;color:#334155;">${b.position}</span></td>
                                <td>${b.display_order}</td>
                                <td>
                                    <div class="time-range">
                                        <i class="fa-regular fa-calendar"></i> ${b.start_time}<br>
                                        <i class="fa-solid fa-arrow-down-long" style="font-size:10px;margin:2px 0;"></i><br>
                                        <i class="fa-regular fa-calendar-check"></i> ${b.end_time}
                                    </div>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${contextPath}/admin/banners?action=edit&id=${b.id}" class="action-btn edit"><i
                                                class="fa-solid fa-pen"></i></a>
                                        <a href="#confirm-delete-modal-${b.id}" class="action-btn delete open-modal-btn"><i
                                                class="fa-solid fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <c:if test="${currentPage > 1}">
                    <a href="${contextPath}/admin/banners?page=${currentPage - 1}&keyword=${keyword}&filterPosition=${filterPosition}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${contextPath}/admin/banners?page=${i}&keyword=${keyword}&filterPosition=${filterPosition}"
                       class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${contextPath}/admin/banners?page=${currentPage + 1}&keyword=${keyword}&filterPosition=${filterPosition}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</main>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="bannerForm" class="modal-btn modal-confirm">Lưu</button>
        </div>
    </div>
</div>

<c:forEach var="b" items="${banners}">
    <div id="confirm-delete-modal-${b.id}" class="modal-overlay">
        <div class="modal-content">
            <h3>Xác nhận xóa</h3>
            <p>Bạn có chắc chắn muốn xóa banner "${b.name}" không?</p>
            <div class="modal-buttons">
                <a href="#" class="modal-btn modal-cancel">Hủy</a>
                <a href="${contextPath}/admin/banners?action=delete&id=${b.id}" class="modal-btn modal-confirm">Xóa</a>
            </div>
        </div>
    </div>
</c:forEach>

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
        var alertBox = document.getElementById('successAlert');
        if (alertBox) {
            setTimeout(function () {
                alertBox.style.transition = 'opacity 0.5s ease';
                alertBox.style.opacity = '0';
                setTimeout(() => alertBox.remove(), 500);
            }, 5000);
        }

        const confirmReplace = '<c:out value="${confirmReplaceOrder}" />';
        if (confirmReplace === 'true') {
            const message = '<c:out value="${conflictMessage}" />';
            if (confirm(message)) {
                const form = document.getElementById('bannerForm');
                if (form) {
                    form.querySelector('input[name="force"]').value = 'true';
                    form.submit();
                }
            }
        }

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
                if (event.target === this) { this.classList.remove('show'); }
            });
        });

        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
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
                if (e.target === logoutConfirmModal) { logoutConfirmModal.classList.remove('show'); }
            });
        }

        const today = new Date();
        const pad = n => String(n).padStart(2, '0');
        const todayStr = today.getFullYear() + '-' + pad(today.getMonth() + 1) + '-' + pad(today.getDate());
        const startInput = document.getElementById('banner-start-time');
        const endInput = document.getElementById('banner-end-time');
        if (startInput) {
            startInput.setAttribute('min', todayStr);
            startInput.addEventListener('change', function () {
                if (endInput) {
                    endInput.setAttribute('min', this.value || todayStr);
                    if (endInput.value && endInput.value < this.value) {
                        endInput.value = this.value;
                    }
                }
            });
        }
        if (endInput) {
            const startVal = startInput && startInput.value ? startInput.value : todayStr;
            endInput.setAttribute('min', startVal);
        }
    });
</script>
</body>
</html>
