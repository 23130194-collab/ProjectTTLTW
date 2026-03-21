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
    <title>TechNova Admin - Quản lý Đánh giá</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminReview.css?v=2.5">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>

<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
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
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link active"><span class="nav-icon"><i
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
                <h1 class="page-title">Quản lý Đánh giá</h1>
                <div class="breadcrumb">
                    <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
                    <span>/</span>
                    <span class="breadcrumb-current">Đánh giá</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty reviewToEdit}">
            <form id="reviewForm" action="${contextPath}/admin/reviews" method="post" class="review-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="reviewId" value="${reviewToEdit.id}">
                <input type="hidden" name="page" value="${currentPage}">
                <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                <input type="hidden" name="statusFilter" value="${selectedStatus}">
                <div class="form-columns">
                    <div class="form-column-left">
                        <div class="form-group"><label class="form-label">Sản phẩm</label><input type="text"
                                                                                                 class="form-control"
                                                                                                 value="${reviewToEdit.productName}"
                                                                                                 readonly></div>
                        <div class="form-group"><label class="form-label">Nội dung</label><textarea
                                class="form-control content-area" rows="6" readonly>${reviewToEdit.content}</textarea>
                        </div>
                    </div>
                    <div class="form-column-right">
                        <div class="form-group"><label class="form-label">Người dùng</label><input type="text"
                                                                                                   class="form-control"
                                                                                                   value="${reviewToEdit.userName}"
                                                                                                   readonly></div>
                        <div class="form-group"><label class="form-label">Điểm</label><input type="number"
                                                                                             class="form-control"
                                                                                             value="${reviewToEdit.rating}"
                                                                                             readonly></div>
                        <div class="form-group"><label class="form-label">Thời gian</label><input type="text"
                                                                                                  class="form-control"
                                                                                                  value="<fmt:formatDate value='${reviewToEdit.createdAt}' pattern='HH:mm dd/MM/yyyy'/>"
                                                                                                  readonly></div>
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="active" ${reviewToEdit.status.trim().equalsIgnoreCase('active') ? 'selected' : ''}>
                                    Hoạt động
                                </option>
                                <option value="hidden" ${reviewToEdit.status.trim().equalsIgnoreCase('hidden') ? 'selected' : ''}>
                                    Ẩn
                                </option>
                            </select>
                        </div>
                        <div class="form-buttons">
                            <a href="#" id="save-button" class="btn btn-primary">Cập nhật</a>
                            <a href="${contextPath}/admin/reviews?page=${currentPage}&status=${selectedStatus}&searchKeyword=${searchKeyword}"
                               class="btn btn-secondary">Hủy</a>
                        </div>
                    </div>
                </div>
            </form>
        </c:if>

        <div class="filter-bar">
            <div class="filter-tabs">
                <a href="${contextPath}/admin/reviews?status=all&searchKeyword=${searchKeyword}"
                   class="tab ${empty selectedStatus or selectedStatus == 'all' ? 'active' : ''}">Tất cả</a>
                <a href="${contextPath}/admin/reviews?status=active&searchKeyword=${searchKeyword}"
                   class="tab ${selectedStatus == 'active' ? 'active' : ''}">Hoạt động</a>
                <a href="${contextPath}/admin/reviews?status=hidden&searchKeyword=${searchKeyword}"
                   class="tab ${selectedStatus == 'hidden' ? 'active' : ''}">Ẩn</a>
            </div>
            <form action="${contextPath}/admin/reviews" method="get" class="search-form">
                <div class="search-wrapper">
                    <input type="text" name="searchKeyword" id="searchInput" class="search-input-review"
                           placeholder="Tìm theo tên sản phẩm, người dùng..." value="${searchKeyword}">
                    <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                    <input type="hidden" name="status" value="${selectedStatus}">
                </div>
            </form>
        </div>

        <div class="table-container">
            <table class="review-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Sản phẩm</th>
                    <th>Người dùng</th>
                    <th>Đánh giá</th>
                    <th class="col-content">Nội dung</th>
                    <th>Ngày</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="review" items="${reviewList}" varStatus="loop">
                    <tr>
                        <td>${(currentPage - 1) * 10 + loop.count}</td>
                        <td class="col-product">
                            <span class="truncate-text" title="${review.productName}">${review.productName}</span>
                        </td>
                        <td>${review.userName}</td>
                        <td><span class="rating-star">${review.rating} <i class="fa-solid fa-star"></i></span></td>
                        <td class="col-content text-left">
                            <span class="truncate-text" title="${review.content}">${review.content}</span>
                        </td>
                        <td><fmt:formatDate value="${review.createdAt}" pattern="HH:mm dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${review.status.trim().equalsIgnoreCase('active')}">
                                    <span class="status status-active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status status-hidden">Ẩn</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="col-actions">
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/reviews?action=edit&id=${review.id}&page=${currentPage}&status=${selectedStatus}&searchKeyword=${searchKeyword}"
                                   class="action-btn edit" title="Sửa trạng thái"><i class="fa-solid fa-pen"></i></a>
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
                    <a href="${contextPath}/admin/reviews?page=${currentPage - 1}&status=${selectedStatus}&searchKeyword=${searchKeyword}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${contextPath}/admin/reviews?page=${i}&status=${selectedStatus}&searchKeyword=${searchKeyword}"
                       class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${contextPath}/admin/reviews?page=${currentPage + 1}&status=${selectedStatus}&searchKeyword=${searchKeyword}"
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
            <a href="#" class="modal-btn modal-cancel" id="cancel-save">Hủy</a>
            <button type="submit" form="reviewForm" class="modal-btn modal-confirm">Lưu</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const saveBtn = document.getElementById('save-button');
        const confirmSaveModal = document.getElementById('confirm-save-modal');
        const cancelSaveBtn = document.getElementById('cancel-save');

        if (saveBtn && confirmSaveModal && cancelSaveBtn) {
            saveBtn.addEventListener('click', function (e) {
                e.preventDefault();
                confirmSaveModal.classList.add('show');
            });

            cancelSaveBtn.addEventListener('click', function (e) {
                e.preventDefault();
                confirmSaveModal.classList.remove('show');
            });

            confirmSaveModal.addEventListener('click', function (e) {
                if (e.target === confirmSaveModal) {
                    confirmSaveModal.classList.remove('show');
                }
            });
        }

        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            setTimeout(function () {
                alert.style.display = 'none';
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