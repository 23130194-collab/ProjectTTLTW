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
    <title>TechNova Admin - Mục sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminCategories.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span class="nav-icon"><i
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
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink">
            <span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>
            Đăng xuất
        </a>
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
        <div class="page-title">Mục sản phẩm</div>
        <div class="breadcrumb">
            <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Danh mục</span>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.successMessage}" escapeXml="false"/>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.errorMessage}" escapeXml="false"/>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${requestScope.errorMessage}" escapeXml="false"/>
            </div>
        </c:if>

        <form action="${contextPath}/admin/categories" method="post" class="category-form" id="categoryForm">
            <c:if test="${not empty categoryToEdit}">
                <input type="hidden" name="categoryId" value="${categoryToEdit.id}">
            </c:if>
            <div class="form-row">
                <div class="input-group flex-2">
                    <label class="input-label">Tên mục sản phẩm</label>
                    <input type="text" name="categoryName" class="input-field" placeholder="Tên mục sản phẩm"
                           value="${categoryToEdit.name}" required>
                </div>
                <div class="input-group flex-1">
                    <label class="input-label">Thứ tự hiển thị</label>
                    <input type="number" name="displayOrder" id="displayOrderInput" class="input-field"
                           placeholder="Thứ tự" value="${categoryToEdit.display_order}" required>
                </div>
                <div class="input-group flex-1">
                    <label class="input-label">Trạng thái</label>
                    <select name="status" class="input-field">
                        <option value="active" ${categoryToEdit.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="hidden" ${categoryToEdit.status == 'hidden' ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>
            </div>
            <div class="form-row" style="align-items: flex-end;">
                <div class="input-group" style="flex: 1;">
                    <label class="input-label">Đường dẫn hình ảnh</label>
                    <input type="text" name="imageUrl" class="input-field"
                           placeholder="Dán đường dẫn hình ảnh mới tại đây" value="">
                </div>
                <div class="button-group" style="margin-left: 15px; width: auto;">
                    <a href="#confirm-save-modal" class="add-category-btn open-modal-btn">
                        <c:choose>
                            <c:when test="${not empty categoryToEdit}">Cập nhật</c:when>
                            <c:otherwise><i class="fa-solid fa-plus"
                                            style="margin-right: 8px;"></i> Thêm danh mục</c:otherwise>
                        </c:choose>
                    </a>
                    <c:if test="${not empty categoryToEdit}">
                        <a href="${contextPath}/admin/categories" class="cancel-btn">Hủy</a>
                    </c:if>
                </div>
            </div>
            <c:if test="${not empty categoryToEdit.image}">
                <div class="current-image-preview" style="margin-top: 10px; display: flex; align-items: center;">
                    <span style="font-size: 14px; color: #64748b; margin-right: 10px;">Ảnh hiện tại:</span>
                    <c:choose>
                        <c:when test="${categoryToEdit.image.startsWith('http')}">
                            <img src="${categoryToEdit.image}" alt="Preview"
                                 style="height: 40px; border-radius: 4px; border: 1px solid #e2e8f0;">
                        </c:when>
                        <c:otherwise>
                            <img src="${contextPath}/${categoryToEdit.image}" alt="Preview"
                                 style="height: 40px; border-radius: 4px; border: 1px solid #e2e8f0;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </form>

        <form action="${contextPath}/admin/categories" method="get" class="form-search-row">
            <div class="search-wrapper">
                <input type="text" name="searchKeyword" class="search-input-category"
                       placeholder="Tìm kiếm mục sản phẩm..." value="${searchKeyword}">
                <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
        </form>

        <div class="category-table-container">
            <table class="category-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Hình ảnh</th>
                    <th>Tên mục sản phẩm</th>
                    <th>Thứ tự</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${categoryList}" var="cat" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <c:set var="imageSrc" value="${cat.image}"/>
                            <c:choose>
                                <c:when test="${imageSrc.startsWith('http')}">
                                    <img src="${imageSrc}" alt="${cat.name}" class="table-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${contextPath}/${imageSrc}" alt="${cat.name}" class="table-image">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${cat.name}</td>
                        <td>${cat.display_order}</td>
                        <td>
                            <c:choose>
                                <c:when test="${cat.status.trim().equalsIgnoreCase('active')}">
                                    <span class="status status-active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status status-hidden">Ẩn</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/categories?action=edit&id=${cat.id}"
                                   class="action-btn edit" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                                <a href="#confirm-delete-modal-${cat.id}" class="action-btn delete open-modal-btn"
                                   title="Xóa"><i
                                        class="fa-solid fa-trash-can"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<c:forEach var="cat" items="${categoryList}">
    <div id="confirm-delete-modal-${cat.id}" class="modal-overlay">
        <div class="modal-content">
            <h3>Xác nhận xóa</h3>
            <p>Bạn có chắc chắn muốn xóa danh mục "${cat.name}" không?</p>
            <div class="modal-buttons">
                <a href="#" class="modal-btn modal-cancel">Hủy</a>
                <a href="${contextPath}/admin/categories?action=delete&id=${cat.id}"
                   class="modal-btn modal-confirm">Xóa</a>
            </div>
        </div>
    </div>
</c:forEach>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi cho danh mục này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="categoryForm" class="modal-btn modal-confirm">Lưu</button>
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

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.alert').forEach(function (alert) {
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });

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
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>