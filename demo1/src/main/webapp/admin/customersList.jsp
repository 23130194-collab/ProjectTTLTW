<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Danh sách khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/customersList.css?v=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/adminModal.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link active"><span class="nav-icon"><i
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
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i
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
        <div class="page-header">
            <h1 class="page-title">Danh sách khách hàng</h1>
        </div>

        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" class="breadcrumb-link">Trang chủ</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Danh sách khách hàng</span>
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

        <div class="filter-section">
            <form action="${contextPath}/admin/customers" method="get" class="filter-form">

                <select name="status" id="statusSelect" onchange="this.form.submit()" class="filter-select">
                    <option value="all" ${param.status == 'all' || empty param.status ? 'selected' : ''}>
                        Tất cả trạng thái
                    </option>
                    <option value="active" ${param.status == 'active' ? 'selected' : ''}>
                        Đang hoạt động
                    </option>
                    <option value="locked" ${param.status == 'locked' ? 'selected' : ''}>
                        Đã khóa
                    </option>
                </select>

                <div class="search-wrapper">
                    <input type="text" name="keyword" class="search-input-customer" placeholder="Tìm kiếm khách hàng..."
                           value="${keyword}">
                    <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </form>
        </div>

        <div class="customer-list">
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Đơn hàng</th>
                        <th>Tham gia</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>

                <tbody id="customerTableBody">
                <c:if test="${empty customerList}">
                    <tr>
                        <td colspan="6" style="text-align: center;">Không có dữ liệu khách hàng nào trong Database.</td>
                    </tr>
                </c:if>

                <c:forEach var="u" items="${customerList}" varStatus="status">
                    <tr>
                        <td style="text-align: center;">${(currentPage - 1) * 5 + status.index + 1}</td>

                        <td>
                            <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${u.id}"
                               class="customer-link">
                                <div class="reviewer-avatar">
                                        ${u.name != null ? u.name.substring(0, 1).toUpperCase() : "?"}
                                </div>
                                    ${u.name}
                            </a>
                        </td>

                        <td>${u.email}</td>

                        <td style="text-align: center;">${u.orderCount}</td>

                        <td>
                            <fmt:formatDate value="${u.created_at}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/customer-detail?id=${u.id}" class="action-btn edit"
                                   title="Xem">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <a href="#"
                                   class="action-btn delete"
                                   style="background-color: ${u.status == 'Locked' ? '#fee2e2' : '#e0f2fe'};
                                           color: ${u.status == 'Locked' ? '#b91c1c' : '#0284c7'};"
                                   title="${u.status == 'Locked' ? 'Mở khóa' : 'Khóa tài khoản'}"

                                   onclick="openLockModal(event, '${contextPath}/admin/lock-customer?id=${u.id}', '${u.status}')">

                                    <c:choose>
                                        <c:when test="${u.status == 'Locked'}">
                                            <i class="fa-solid fa-lock"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-lock-open"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="pagination-container">

                    <c:if test="${currentPage > 1}">
                        <a href="${contextPath}/admin/customers?page=${currentPage - 1}&keyword=${keyword}&status=${param.status}"
                           class="pagination-btn">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${contextPath}/admin/customers?page=${i}&keyword=${keyword}&status=${param.status}"
                           class="page-number ${currentPage == i ? 'active' : ''}">
                                ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${contextPath}/admin/customers?page=${currentPage + 1}&keyword=${keyword}&status=${param.status}"
                           class="pagination-btn">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </c:if>

                </div>
            </c:if>
        </div>
    </div>
</main>

<div id="lockConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="lockModalTitle">Xác nhận</h3>
        <p id="lockModalMessage">Nội dung xác nhận...</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLockBtn">Hủy</a>
            <a href="#" class="modal-btn modal-confirm" id="confirmLockBtn">Đồng ý</a>
        </div>
    </div>
</div>

<script>
    function openLockModal(event, actionUrl, currentStatus) {
        event.preventDefault();

        const lockModal = document.getElementById('lockConfirmModal');
        const confirmLockBtn = document.getElementById('confirmLockBtn');
        const lockModalTitle = document.getElementById('lockModalTitle');
        const lockModalMessage = document.getElementById('lockModalMessage');

        confirmLockBtn.href = actionUrl;

        if (currentStatus === 'Locked') {
            lockModalTitle.innerText = "Xác nhận mở khóa";
            lockModalMessage.innerText = "Bạn có chắc chắn muốn mở khóa tài khoản này? Họ sẽ có thể đăng nhập lại.";
            confirmLockBtn.style.backgroundColor = "#0284c7";
            confirmLockBtn.innerText = "Mở khóa";
        } else {
            lockModalTitle.innerText = "Xác nhận khóa tài khoản";
            lockModalMessage.innerText = "Bạn có chắc chắn muốn khóa tài khoản này? Họ sẽ không thể đăng nhập hệ thống.";
            confirmLockBtn.style.backgroundColor = "#ef4444";
            confirmLockBtn.innerText = "Khóa ngay";
        }

        lockModal.classList.add('show');
    }

    document.addEventListener("DOMContentLoaded", function () {

        const lockModal = document.getElementById('lockConfirmModal');
        const cancelLockBtn = document.getElementById('cancelLockBtn');

        if (cancelLockBtn) {
            cancelLockBtn.addEventListener('click', function (e) {
                e.preventDefault();
                lockModal.classList.remove('show');
            });
        }

        if (lockModal) {
            lockModal.addEventListener('click', function (e) {
                if (e.target === lockModal) {
                    lockModal.classList.remove('show');
                }
            });
        }
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
    document.addEventListener('DOMContentLoaded', function() {
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function(e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });

            cancelLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });

            logoutConfirmModal.addEventListener('click', function(e) {
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>